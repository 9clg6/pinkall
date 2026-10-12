import 'dart:async';
import 'dart:convert';

import 'package:api_agent_vocal/src/application/session_service.dart';
import 'package:api_agent_vocal/src/config/app_config.dart';
import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/stt_contracts.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/telnyx_media.dart';
import 'package:test/test.dart';

void main() {
  test(
    'drops all pre-consent media without opening STT or buffering',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final _RecordingSttProvider stt = _RecordingSttProvider();
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: const UnavailableCoachGateway('off'),
        coachCatalog: const _UnavailableCatalog(),
      );
      final CallSessionSnapshot session = service.createSession(
        callId: 'call-1',
        destinationNumber: '+33102030405',
        contactId: null,
        coachMode: CoachMode.off,
        sellerTrack: MediaTrack.outbound,
      );
      await service.beginMedia(
        session.id,
        const TelnyxStartFrame(
          streamId: 'stream',
          sequenceNumber: 1,
          callControlId: 'call-control',
          callSessionId: 'call-session',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );
      final TelnyxAudioFrame audio = TelnyxAudioFrame(
        streamId: 'stream',
        sequenceNumber: 2,
        track: MediaTrack.inbound,
        chunk: 1,
        timestamp: 20,
        payload: base64Encode(<int>[0xff, 0xff]),
      );

      await service.ingestAudio(session.id, audio);
      expect(stt.openCount, 0);
      expect(store.audio(session.id, MediaTrack.inbound), isEmpty);

      service.acknowledgeTranscriptionConsent(
        sessionId: session.id,
        method: 'verbal_notice',
        acknowledgedAt: DateTime.now().toUtc(),
      );
      await service.ingestAudio(session.id, audio);
      expect(stt.openCount, 1);
      expect(store.audio(session.id, MediaTrack.inbound), hasLength(4));
      expect(stt.session.audioBytes, 4);

      stt.session.controller
        ..add(const SttTextDelta('Rappelez-moi'))
        ..add(const SttTextDelta(' mardi.'))
        ..add(const SttDone('Rappelez-moi mardi.'));
      await Future<void>.delayed(Duration.zero);
      expect(store.transcript(session.id), hasLength(1));
      expect(store.transcript(session.id).single.text, 'Rappelez-moi mardi.');
      expect(store.transcript(session.id).single.isFinal, isTrue);

      await service.endMedia(session.id);
      await store.dispose();
    },
  );

  test('waits for Telnyx stop and finalizes idempotently', () async {
    final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
      'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
      'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
      'MISTRAL_API_KEY': 'test-only',
    });
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    final _RecordingSttProvider stt = _RecordingSttProvider();
    final SessionService service = SessionService(
      config: config,
      store: store,
      sttProvider: stt,
      coachGateway: const UnavailableCoachGateway('off'),
      coachCatalog: const _UnavailableCatalog(),
      mediaStopWait: const Duration(milliseconds: 5),
    );
    final CallSessionSnapshot session = service.createSession(
      callId: 'call-2',
      destinationNumber: '+33102030406',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    service.acknowledgeTranscriptionConsent(
      sessionId: session.id,
      method: 'verbal_notice',
      acknowledgedAt: DateTime.now().toUtc(),
    );
    await service.beginMedia(
      session.id,
      const TelnyxStartFrame(
        streamId: 'stream-2',
        sequenceNumber: 1,
        callControlId: 'control-2',
        callSessionId: 'telnyx-session-2',
        encoding: 'PCMU',
        sampleRate: 8000,
        channels: 1,
      ),
    );
    await service.ingestAudio(
      session.id,
      TelnyxAudioFrame(
        streamId: 'stream-2',
        sequenceNumber: 2,
        track: MediaTrack.inbound,
        chunk: 1,
        timestamp: 20,
        payload: base64Encode(<int>[0xff, 0xff]),
      ),
    );

    await expectLater(service.finalize(session.id), throwsA(isA<StateError>()));
    expect(stt.batchCount, 0);
    expect(store.session(session.id)!.status, SessionStatus.streaming);

    await service.endMedia(session.id);
    final List<List<TranscriptSegment>> results = await Future.wait(
      <Future<List<TranscriptSegment>>>[
        service.finalize(session.id),
        service.finalize(session.id),
      ],
    );
    expect(stt.batchCount, 1);
    expect(results.first.single.text, 'Transcript final réel.');
    expect(results.last.single.text, 'Transcript final réel.');

    await service.finalize(session.id);
    expect(stt.batchCount, 1);
    await store.dispose();
  });

  test(
    'buffers audio and batch-finalizes when realtime session opening fails',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final _RecordingSttProvider stt = _RecordingSttProvider()
        ..throwOnOpen = true;
      final List<String> diagnostics = <String>[];
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: const UnavailableCoachGateway('off'),
        coachCatalog: const _UnavailableCatalog(),
        diagnosticSink: diagnostics.add,
      );
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });
      final CallSessionSnapshot session = service.createSession(
        callId: 'call-realtime-open-failure',
        destinationNumber: '+33102030408',
        contactId: null,
        coachMode: CoachMode.off,
        sellerTrack: MediaTrack.outbound,
      );
      service.acknowledgeTranscriptionConsent(
        sessionId: session.id,
        method: 'verbal_notice',
        acknowledgedAt: DateTime.now().toUtc(),
      );
      await service.beginMedia(
        session.id,
        const TelnyxStartFrame(
          streamId: 'stream-open-failure',
          sequenceNumber: 1,
          callControlId: 'control-open-failure',
          callSessionId: 'telnyx-open-failure',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );
      await service.ingestAudio(
        session.id,
        TelnyxAudioFrame(
          streamId: 'stream-open-failure',
          sequenceNumber: 2,
          track: MediaTrack.inbound,
          chunk: 1,
          timestamp: 20,
          payload: base64Encode(<int>[0xff, 0xff]),
        ),
      );

      expect(store.audio(session.id, MediaTrack.inbound), hasLength(4));
      expect(stt.openCount, 1);
      expect(store.session(session.id)!.status, SessionStatus.streaming);
      expect(diagnostics.join('\n'), contains('reason=session_open_failed'));

      await service.endMedia(session.id);
      final List<TranscriptSegment> transcript = await service.finalize(
        session.id,
      );
      expect(transcript.single.text, 'Transcript final réel.');
      expect(stt.batchCount, 1);
      expect(store.session(session.id)!.status, SessionStatus.finalized);
    },
  );

  test(
    'realtime event and close failures never fail batch finalization',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final _RecordingSttProvider stt = _RecordingSttProvider();
      final List<String> diagnostics = <String>[];
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: const UnavailableCoachGateway('off'),
        coachCatalog: const _UnavailableCatalog(),
        diagnosticSink: diagnostics.add,
      );
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });
      final CallSessionSnapshot session = service.createSession(
        callId: 'call-realtime-close-failure',
        destinationNumber: '+33102030409',
        contactId: null,
        coachMode: CoachMode.off,
        sellerTrack: MediaTrack.outbound,
      );
      service.acknowledgeTranscriptionConsent(
        sessionId: session.id,
        method: 'verbal_notice',
        acknowledgedAt: DateTime.now().toUtc(),
      );
      await service.beginMedia(
        session.id,
        const TelnyxStartFrame(
          streamId: 'stream-close-failure',
          sequenceNumber: 1,
          callControlId: 'control-close-failure',
          callSessionId: 'telnyx-close-failure',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );
      await service.ingestAudio(
        session.id,
        TelnyxAudioFrame(
          streamId: 'stream-close-failure',
          sequenceNumber: 2,
          track: MediaTrack.inbound,
          chunk: 1,
          timestamp: 20,
          payload: base64Encode(<int>[0xff, 0xff]),
        ),
      );
      stt.session
        ..throwOnClose = true
        ..controller.add(
          const SttFailure(
            'Voxtral error: Timeout waiting for response from streaming transcription.',
          ),
        );
      await Future<void>.delayed(Duration.zero);

      expect(store.session(session.id)!.status, SessionStatus.streaming);
      expect(diagnostics.join('\n'), contains('reason=provider_event_failed'));
      await service.endMedia(session.id);
      expect(store.session(session.id)!.status, SessionStatus.stopped);

      final List<TranscriptSegment> transcript = await service.finalize(
        session.id,
      );
      expect(transcript.single.text, 'Transcript final réel.');
      expect(stt.batchCount, 1);
      expect(store.session(session.id)!.status, SessionStatus.finalized);
    },
  );

  test(
    'reopens realtime STT after bounded backoff while retaining batch audio',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final _RecordingSttProvider stt = _RecordingSttProvider();
      final List<String> diagnostics = <String>[];
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: const UnavailableCoachGateway('off'),
        coachCatalog: const _UnavailableCatalog(),
        realtimeRetryBaseDelay: const Duration(milliseconds: 20),
        realtimeCleanupTimeout: const Duration(milliseconds: 20),
        realtimeMaxConsecutiveFailures: 3,
        turnIdleFallback: const Duration(milliseconds: 100),
        diagnosticSink: diagnostics.add,
      );
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });
      final CallSessionSnapshot session = service.createSession(
        callId: 'call-realtime-recovery',
        destinationNumber: '+33102030410',
        contactId: null,
        coachMode: CoachMode.off,
        sellerTrack: MediaTrack.outbound,
      );
      service.acknowledgeTranscriptionConsent(
        sessionId: session.id,
        method: 'verbal_notice',
        acknowledgedAt: DateTime.now().toUtc(),
      );
      await service.beginMedia(
        session.id,
        const TelnyxStartFrame(
          streamId: 'stream-recovery',
          sequenceNumber: 1,
          callControlId: 'control-recovery',
          callSessionId: 'telnyx-recovery',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );

      TelnyxAudioFrame frame(int sequenceNumber) => TelnyxAudioFrame(
        streamId: 'stream-recovery',
        sequenceNumber: sequenceNumber,
        track: MediaTrack.inbound,
        chunk: sequenceNumber,
        timestamp: sequenceNumber * 20,
        payload: base64Encode(<int>[0xff, 0xff]),
      );

      await service.ingestAudio(session.id, frame(2));
      final _RecordingSttSession firstSession = stt.session;
      firstSession.controller
        ..add(const SttTextDelta('La transcription'))
        ..add(const SttFailure('temporary realtime connection failure'));
      await _waitUntil(
        () => diagnostics.any(
          (String item) => item.contains('realtime_retry_scheduled'),
        ),
      );

      await service.ingestAudio(session.id, frame(3));
      expect(stt.openCount, 1, reason: 'backoff must prevent a tight retry');

      await Future<void>.delayed(const Duration(milliseconds: 25));
      await service.ingestAudio(session.id, frame(4));
      expect(stt.openCount, 2);
      expect(stt.session, isNot(same(firstSession)));
      expect(stt.session.audioBytes, 4);

      stt.session.controller.add(
        const SttSegment(
          text: 'en direct a repris.',
          startSeconds: 0,
          endSeconds: 1,
        ),
      );
      await _waitUntil(
        () => store
            .transcript(session.id)
            .any(
              (TranscriptSegment segment) =>
                  segment.text == 'La transcription en direct a repris.',
            ),
      );

      expect(store.audio(session.id, MediaTrack.inbound), hasLength(12));
      expect(store.session(session.id)!.status, SessionStatus.streaming);
      expect(diagnostics.join('\n'), contains('realtime_reopened'));
      expect(diagnostics.join('\n'), contains('realtime_recovered'));

      await service.endMedia(session.id);
      final List<TranscriptSegment> transcript = await service.finalize(
        session.id,
      );
      expect(transcript.single.text, 'Transcript final réel.');
      expect(stt.batchCount, 1);
    },
  );

  test('batch finalization merges segments until a real pause', () async {
    final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
      'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
      'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
      'MISTRAL_API_KEY': 'test-only',
    });
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    final _RecordingSttProvider stt = _RecordingSttProvider()
      ..batchTranscript = const BatchTranscript(
        text: 'Allô ? Allô ? Bonjour. Pourquoi êtes-vous inscrit ?',
        language: 'fr',
        segments: <BatchTranscriptSegment>[
          BatchTranscriptSegment(
            text: 'Allô ?',
            startSeconds: 0,
            endSeconds: 0.5,
          ),
          BatchTranscriptSegment(
            text: 'Allô ?',
            startSeconds: 1.1,
            endSeconds: 1.5,
          ),
          BatchTranscriptSegment(
            text: 'Bonjour.',
            startSeconds: 5.6,
            endSeconds: 6.5,
          ),
          BatchTranscriptSegment(
            text: 'Pourquoi êtes-vous inscrit ?',
            startSeconds: 7.9,
            endSeconds: 9,
          ),
        ],
        provider: 'test_recording_stt',
      );
    final SessionService service = SessionService(
      config: config,
      store: store,
      sttProvider: stt,
      coachGateway: const UnavailableCoachGateway('off'),
      coachCatalog: const _UnavailableCatalog(),
      turnSilenceBoundary: const Duration(milliseconds: 1800),
    );
    addTearDown(() async {
      await service.dispose();
      await store.dispose();
    });
    final CallSessionSnapshot session = service.createSession(
      callId: 'call-batch-turns',
      destinationNumber: '+33102030411',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    service.acknowledgeTranscriptionConsent(
      sessionId: session.id,
      method: 'verbal_notice',
      acknowledgedAt: DateTime.now().toUtc(),
    );
    await service.beginMedia(
      session.id,
      const TelnyxStartFrame(
        streamId: 'stream-batch-turns',
        sequenceNumber: 1,
        callControlId: 'control-batch-turns',
        callSessionId: 'telnyx-batch-turns',
        encoding: 'PCMU',
        sampleRate: 8000,
        channels: 1,
      ),
    );
    await service.ingestAudio(
      session.id,
      TelnyxAudioFrame(
        streamId: 'stream-batch-turns',
        sequenceNumber: 2,
        track: MediaTrack.outbound,
        chunk: 1,
        timestamp: 20,
        payload: base64Encode(<int>[0xff, 0xff]),
      ),
    );
    await service.endMedia(session.id);

    final List<TranscriptSegment> transcript = await service.finalize(
      session.id,
    );
    expect(transcript, hasLength(2));
    expect(transcript.first.text, 'Allô ? Allô ?');
    expect(transcript.last.text, 'Bonjour. Pourquoi êtes-vous inscrit ?');
  });
}

Future<void> _waitUntil(bool Function() predicate) async {
  final DateTime deadline = DateTime.now().add(const Duration(seconds: 1));
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out while waiting for asynchronous state.');
    }
    await Future<void>.delayed(Duration.zero);
  }
}

final class _RecordingSttProvider implements SttProvider {
  final List<_RecordingSttSession> sessions = <_RecordingSttSession>[];
  int openCount = 0;
  int batchCount = 0;
  bool throwOnOpen = false;
  BatchTranscript batchTranscript = const BatchTranscript(
    text: 'Transcript final réel.',
    language: 'fr',
    segments: <BatchTranscriptSegment>[
      BatchTranscriptSegment(
        text: 'Transcript final réel.',
        startSeconds: 0,
        endSeconds: 1,
      ),
    ],
    provider: 'test_recording_stt',
  );

  _RecordingSttSession get session => sessions.last;

  @override
  bool get isConfigured => true;

  @override
  bool get providesSemanticTurnBoundaries => false;

  @override
  String get name => 'test_recording_stt';

  @override
  Future<RealtimeSttSession> openRealtimeSession({
    required MediaTrack track,
    required SttAudioFormat audioFormat,
  }) async {
    openCount += 1;
    if (throwOnOpen) {
      throw StateError('realtime unavailable');
    }
    final _RecordingSttSession session = _RecordingSttSession();
    sessions.add(session);
    return session;
  }

  @override
  Future<BatchTranscript> transcribeFinal({
    required List<int> pcmBytes,
    required SttAudioFormat audioFormat,
    required String fileName,
  }) async {
    batchCount += 1;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    return batchTranscript;
  }
}

final class _RecordingSttSession implements RealtimeSttSession {
  final StreamController<SttEvent> controller = StreamController<SttEvent>();
  int audioBytes = 0;
  bool throwOnClose = false;

  @override
  Stream<SttEvent> get events => controller.stream;

  @override
  Future<void> addAudio(List<int> pcmBytes) async {
    audioBytes += pcmBytes.length;
  }

  @override
  Future<void> close() async {
    await controller.close();
    if (throwOnClose) {
      throw StateError('provider close failed');
    }
  }
}

final class _UnavailableCatalog implements CoachCatalog {
  const _UnavailableCatalog();

  @override
  int get defaultExpirySeconds => 0;

  @override
  bool get allowsUnreviewedRecommendations => false;

  @override
  Duration get globalCooldown => Duration.zero;

  @override
  bool get isAvailable => false;

  @override
  int get maxSuggestionsPerMinute => 0;

  @override
  int get maxEvaluationsPerMinute => 0;

  @override
  double get minimumContextMatch => 1;

  @override
  double get minimumLiveConfidence => 1;

  @override
  CoachReleaseChannel get releaseChannel => CoachReleaseChannel.strict;

  @override
  String? get unavailableReason => 'not configured';

  @override
  List<CoachRecommendation> candidatesFor({
    required CoachMode mode,
    required String latestText,
  }) => const <CoachRecommendation>[];

  @override
  List<CoachRecommendation> postCallCandidates() =>
      const <CoachRecommendation>[];
}
