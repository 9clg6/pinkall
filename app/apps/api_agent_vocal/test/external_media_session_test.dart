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
    'external tracks are consent gated and reuse final transcription',
    () async {
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024 * 1024,
      );
      final _RecordingSttProvider stt = _RecordingSttProvider();
      final SessionService service = _service(store: store, stt: stt);
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });
      final CallSessionSnapshot session = service.createExternalSession(
        title: 'Discovery Acme',
        preparationMarkdown: '# Objectif\r\nQualifier le besoin.',
        coachMode: CoachMode.off,
      );

      expect(service.isExternalSession(session.id), isTrue);
      expect(session.destinationNumber, 'Discovery Acme');
      expect(session.preparationMarkdown, '# Objectif\nQualifier le besoin.');

      await service.beginExternalMediaTrack(session.id, MediaTrack.outbound);
      await service.beginExternalMediaTrack(session.id, MediaTrack.inbound);
      await service.ingestExternalPcm16(session.id, MediaTrack.outbound, <int>[
        1,
        2,
        3,
        4,
      ]);
      await service.ingestExternalPcm16(session.id, MediaTrack.inbound, <int>[
        5,
        6,
        7,
        8,
      ]);

      expect(stt.openedTracks, isEmpty);
      expect(store.audio(session.id, MediaTrack.outbound), isEmpty);
      expect(store.audio(session.id, MediaTrack.inbound), isEmpty);

      service.acknowledgeTranscriptionConsent(
        sessionId: session.id,
        method: 'verbal_notice',
        acknowledgedAt: DateTime.now().toUtc(),
      );
      await service.ingestExternalPcm16(session.id, MediaTrack.outbound, <int>[
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
      ]);
      await service.ingestExternalPcm16(session.id, MediaTrack.inbound, <int>[
        9,
        10,
        11,
        12,
      ]);

      expect(stt.openedTracks.toSet(), MediaTrack.values.toSet());
      expect(
        stt.realtimeFormats.every(
          (SttAudioFormat format) =>
              format.encoding == 'pcm_s16le' && format.sampleRate == 16000,
        ),
        isTrue,
      );
      expect(store.audio(session.id, MediaTrack.outbound), hasLength(8));
      expect(store.audio(session.id, MediaTrack.inbound), hasLength(4));
      expect(
        jsonEncode(store.exportDurableSnapshot()),
        isNot(contains(base64Encode(<int>[1, 2, 3, 4, 5, 6, 7, 8]))),
      );

      await service.endExternalMediaTrack(session.id, MediaTrack.outbound);
      expect(store.session(session.id)!.status, SessionStatus.streaming);
      await service.endExternalMediaTrack(session.id, MediaTrack.inbound);
      expect(store.session(session.id)!.status, SessionStatus.stopped);

      final List<TranscriptSegment> transcript = await service.finalize(
        session.id,
      );
      expect(stt.batchFormats, hasLength(2));
      expect(
        stt.batchFormats.every(
          (SttAudioFormat format) => format.sampleRate == 16000,
        ),
        isTrue,
      );
      expect(
        transcript.map((TranscriptSegment item) => item.speaker).toSet(),
        <SpeakerRole>{SpeakerRole.seller, SpeakerRole.prospect},
      );
      expect(store.session(session.id)!.status, SessionStatus.finalized);
    },
  );

  test('rejects duplicate external track connections', () async {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    final SessionService service = _service(
      store: store,
      stt: _RecordingSttProvider(),
    );
    addTearDown(() async {
      await service.dispose();
      await store.dispose();
    });
    final CallSessionSnapshot session = service.createExternalSession(
      title: null,
      coachMode: CoachMode.off,
    );

    await service.beginExternalMediaTrack(session.id, MediaTrack.outbound);
    await expectLater(
      service.beginExternalMediaTrack(session.id, MediaTrack.outbound),
      throwsA(
        isA<StateError>().having(
          (StateError error) => error.message,
          'message',
          contains('already connected'),
        ),
      ),
    );
    await service.endExternalMediaTrack(session.id, MediaTrack.outbound);
  });

  test('normal sessions keep the Telnyx media path only', () async {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    final SessionService service = _service(
      store: store,
      stt: _RecordingSttProvider(),
    );
    addTearDown(() async {
      await service.dispose();
      await store.dispose();
    });
    final CallSessionSnapshot session = service.createSession(
      callId: 'telnyx-call',
      destinationNumber: '+33102030405',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );

    await expectLater(
      service.beginExternalMediaTrack(session.id, MediaTrack.outbound),
      throwsA(isA<StateError>()),
    );
    await service.beginMedia(
      session.id,
      const TelnyxStartFrame(
        streamId: 'stream',
        sequenceNumber: 1,
        callControlId: 'control',
        callSessionId: 'call-session',
        encoding: 'PCMU',
        sampleRate: 8000,
        channels: 1,
      ),
    );
    expect(store.session(session.id)!.mediaSampleRate, 8000);
    await service.endMedia(session.id);
  });
}

SessionService _service({
  required InMemoryPocStore store,
  required _RecordingSttProvider stt,
}) {
  final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
    'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
    'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
    'MISTRAL_API_KEY': 'test-only',
  });
  return SessionService(
    config: config,
    store: store,
    sttProvider: stt,
    coachGateway: const UnavailableCoachGateway('off'),
    coachCatalog: const _UnavailableCatalog(),
  );
}

final class _RecordingSttProvider implements SttProvider {
  final List<MediaTrack> openedTracks = <MediaTrack>[];
  final List<SttAudioFormat> realtimeFormats = <SttAudioFormat>[];
  final List<SttAudioFormat> batchFormats = <SttAudioFormat>[];

  @override
  bool get isConfigured => true;

  @override
  bool get providesSemanticTurnBoundaries => false;

  @override
  String get name => 'recording';

  @override
  Future<RealtimeSttSession> openRealtimeSession({
    required MediaTrack track,
    required SttAudioFormat audioFormat,
  }) async {
    openedTracks.add(track);
    realtimeFormats.add(audioFormat);
    return _RecordingSttSession();
  }

  @override
  Future<BatchTranscript> transcribeFinal({
    required List<int> pcmBytes,
    required SttAudioFormat audioFormat,
    required String fileName,
  }) async {
    batchFormats.add(audioFormat);
    final bool seller = fileName.contains(MediaTrack.outbound.name);
    return BatchTranscript(
      text: seller ? 'Présentation vendeur.' : 'Réponse prospect.',
      language: 'fr',
      segments: <BatchTranscriptSegment>[
        BatchTranscriptSegment(
          text: seller ? 'Présentation vendeur.' : 'Réponse prospect.',
          startSeconds: 0,
          endSeconds: pcmBytes.length / (audioFormat.sampleRate * 2),
        ),
      ],
      provider: 'recording',
    );
  }
}

final class _RecordingSttSession implements RealtimeSttSession {
  final StreamController<SttEvent> _events = StreamController<SttEvent>();

  @override
  Stream<SttEvent> get events => _events.stream;

  @override
  Future<void> addAudio(List<int> pcmBytes) async {}

  @override
  Future<void> close() => _events.close();
}

final class _UnavailableCatalog implements CoachCatalog {
  const _UnavailableCatalog();

  @override
  bool get allowsUnreviewedRecommendations => false;

  @override
  int get defaultExpirySeconds => 0;

  @override
  Duration get globalCooldown => Duration.zero;

  @override
  bool get isAvailable => false;

  @override
  int get maxEvaluationsPerMinute => 0;

  @override
  int get maxSuggestionsPerMinute => 0;

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
