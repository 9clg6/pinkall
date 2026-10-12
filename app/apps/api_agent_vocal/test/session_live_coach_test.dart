import 'dart:async';
import 'dart:convert';

import 'package:api_agent_vocal/src/application/session_service.dart';
import 'package:api_agent_vocal/src/config/app_config.dart';
import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/stt_contracts.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/telnyx_media.dart';
import 'package:test/test.dart';

void main() {
  test(
    'commits a provider-confirmed turn without the silence fallback',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'COACH_MIN_INTERVAL_MS': '0',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final _TrackSttProvider stt = _TrackSttProvider();
      final _RecordingCoachGateway coachGateway = _RecordingCoachGateway();
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: coachGateway,
        coachCatalog: const _SourceBackedCatalog(),
        turnIdleFallback: const Duration(seconds: 30),
      );
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });

      final CallSessionSnapshot session = service.createSession(
        callId: 'call-provider-turn-end',
        destinationNumber: '+33102030405',
        contactId: null,
        preparationMarkdown: null,
        coachMode: CoachMode.live,
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
          streamId: 'stream-provider-turn-end',
          sequenceNumber: 1,
          callControlId: 'control-provider-turn-end',
          callSessionId: 'session-provider-turn-end',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );
      await service.ingestAudio(
        session.id,
        _audioFrame(track: MediaTrack.inbound, sequenceNumber: 2),
      );

      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: 'Le prix est trop élevé pour nous.',
              startSeconds: 0,
              endSeconds: 1.2,
              isTurnEnd: true,
            ),
          );

      await _waitUntil(() => coachGateway.calls == 1);
      expect(
        store
            .transcript(session.id)
            .where((TranscriptSegment segment) => segment.isFinal),
        hasLength(1),
      );
    },
  );

  test(
    'starts speculative coaching on eager EOT and publishes only after final',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'COACH_MIN_INTERVAL_MS': '0',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final _TrackSttProvider stt = _TrackSttProvider(
        providesSemanticTurnBoundaries: true,
      );
      final _RecordingCoachGateway coachGateway = _RecordingCoachGateway();
      final List<String> diagnostics = <String>[];
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: coachGateway,
        coachCatalog: const _SourceBackedCatalog(),
        diagnosticSink: diagnostics.add,
      );
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });

      final CallSessionSnapshot session = service.createSession(
        callId: 'call-speculative-coach',
        destinationNumber: '+33102030405',
        contactId: null,
        preparationMarkdown: null,
        coachMode: CoachMode.live,
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
          streamId: 'stream-speculative-coach',
          sequenceNumber: 1,
          callControlId: 'control-speculative-coach',
          callSessionId: 'session-speculative-coach',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );
      await service.ingestAudio(
        session.id,
        _audioFrame(track: MediaTrack.inbound, sequenceNumber: 2),
      );

      final Future<ClientEvent> suggestion = store
          .events(session.id)
          .firstWhere(
            (ClientEvent event) => event.type == 'coaching_suggestion',
          );
      const String objection = 'Le prix est trop élevé pour nous.';
      stt.session(MediaTrack.inbound)
        ..emit(const SttTextDelta(objection))
        ..emit(
          const SttEagerTurnEnd(
            text: objection,
            startSeconds: 0,
            endSeconds: 1.2,
            providerTurnId: '4',
          ),
        );

      await _waitUntil(() => coachGateway.calls == 1);
      await Future<void>.delayed(Duration.zero);
      expect(coachGateway.lastTriggeringSegment?.isFinal, isFalse);
      expect(store.metrics().exposures, 0);

      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: objection,
              startSeconds: 0,
              endSeconds: 1.2,
              isTurnEnd: true,
              providerTurnId: '4',
            ),
          );

      await suggestion.timeout(const Duration(seconds: 1));
      expect(coachGateway.calls, 1);
      expect(store.metrics().exposures, 1);
      final Map<String, Object?> metrics = service.liveCoachLatencyMetrics();
      expect(metrics['evaluations'], 1);
      expect(metrics['delivered'], 1);
      final Map<String, Object?> speculative =
          metrics['speculative']! as Map<String, Object?>;
      expect(speculative['started'], 1);
      expect(speculative['cancelled'], 0);
      expect(
        diagnostics.join('\n'),
        allOf(
          contains('speculative_confirmed'),
          contains('"trigger":"eager_eot"'),
        ),
      );
    },
  );

  test('discards eager advice when the prospect resumes speaking', () async {
    final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
      'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
      'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
      'COACH_MIN_INTERVAL_MS': '0',
    });
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    final _TrackSttProvider stt = _TrackSttProvider(
      providesSemanticTurnBoundaries: true,
    );
    final _RecordingCoachGateway coachGateway = _RecordingCoachGateway();
    final SessionService service = SessionService(
      config: config,
      store: store,
      sttProvider: stt,
      coachGateway: coachGateway,
      coachCatalog: const _SourceBackedCatalog(),
    );
    addTearDown(() async {
      await service.dispose();
      await store.dispose();
    });

    final CallSessionSnapshot session = service.createSession(
      callId: 'call-resumed-speculation',
      destinationNumber: '+33102030405',
      contactId: null,
      preparationMarkdown: null,
      coachMode: CoachMode.live,
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
        streamId: 'stream-resumed-speculation',
        sequenceNumber: 1,
        callControlId: 'control-resumed-speculation',
        callSessionId: 'session-resumed-speculation',
        encoding: 'PCMU',
        sampleRate: 8000,
        channels: 1,
      ),
    );
    await service.ingestAudio(
      session.id,
      _audioFrame(track: MediaTrack.inbound, sequenceNumber: 2),
    );

    final Future<ClientEvent> suggestion = store
        .events(session.id)
        .firstWhere((ClientEvent event) => event.type == 'coaching_suggestion');
    const String eagerText = 'Le prix semble élevé.';
    stt.session(MediaTrack.inbound)
      ..emit(const SttTextDelta(eagerText))
      ..emit(
        const SttEagerTurnEnd(
          text: eagerText,
          startSeconds: 0,
          endSeconds: 0.8,
          providerTurnId: '8',
        ),
      );
    await _waitUntil(() => coachGateway.calls == 1);
    stt
        .session(MediaTrack.inbound)
        .emit(const SttTurnResumed(providerTurnId: '8'));
    await _waitUntil(
      () => (service.liveCoachLatencyMetrics()['evaluations']! as int) == 1,
    );
    expect(store.metrics().exposures, 0);

    const String finalText =
        'Le prix semble élevé, mais nous pouvons avancer ce mois-ci.';
    stt
        .session(MediaTrack.inbound)
        .emit(
          const SttSegment(
            text: finalText,
            startSeconds: 0,
            endSeconds: 1.8,
            isTurnEnd: true,
            providerTurnId: '8',
          ),
        );

    await suggestion.timeout(const Duration(seconds: 1));
    expect(coachGateway.calls, 2);
    expect(store.metrics().exposures, 1);
    final Map<String, Object?> speculative =
        service.liveCoachLatencyMetrics()['speculative']!
            as Map<String, Object?>;
    expect(speculative['cancelled'], 1);
  });

  test('only the newest eager generation may publish', () async {
    final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
      'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
      'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
      'COACH_MIN_INTERVAL_MS': '0',
    });
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    final _TrackSttProvider stt = _TrackSttProvider(
      providesSemanticTurnBoundaries: true,
    );
    final _NoneThenSelectionCoachGateway coachGateway =
        _NoneThenSelectionCoachGateway();
    final SessionService service = SessionService(
      config: config,
      store: store,
      sttProvider: stt,
      coachGateway: coachGateway,
      coachCatalog: const _SourceBackedCatalog(),
    );
    addTearDown(() async {
      await service.dispose();
      await store.dispose();
    });

    final CallSessionSnapshot session = service.createSession(
      callId: 'call-newest-speculation',
      destinationNumber: '+33102030405',
      contactId: null,
      preparationMarkdown: null,
      coachMode: CoachMode.live,
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
        streamId: 'stream-newest-speculation',
        sequenceNumber: 1,
        callControlId: 'control-newest-speculation',
        callSessionId: 'session-newest-speculation',
        encoding: 'PCMU',
        sampleRate: 8000,
        channels: 1,
      ),
    );
    await service.ingestAudio(
      session.id,
      _audioFrame(track: MediaTrack.inbound, sequenceNumber: 2),
    );

    final Future<ClientEvent> suggestion = store
        .events(session.id)
        .firstWhere((ClientEvent event) => event.type == 'coaching_suggestion');
    const String firstText = 'Le prix semble élevé.';
    stt.session(MediaTrack.inbound)
      ..emit(const SttTextDelta(firstText))
      ..emit(
        const SttEagerTurnEnd(
          text: firstText,
          startSeconds: 0,
          endSeconds: 0.8,
          providerTurnId: '12',
        ),
      );
    await _waitUntil(() => coachGateway.calls == 1);
    stt
        .session(MediaTrack.inbound)
        .emit(const SttTurnResumed(providerTurnId: '12'));

    const String finalText =
        'Le prix semble élevé, mais la décision doit être prise aujourd’hui.';
    stt.session(MediaTrack.inbound)
      ..emit(
        const SttEagerTurnEnd(
          text: finalText,
          startSeconds: 0,
          endSeconds: 1.8,
          providerTurnId: '12',
        ),
      )
      ..emit(
        const SttSegment(
          text: finalText,
          startSeconds: 0,
          endSeconds: 1.8,
          isTurnEnd: true,
          providerTurnId: '12',
        ),
      );
    expect(coachGateway.calls, 1, reason: 'the first request is still active');
    coachGateway.completeFirstWithNone();

    await suggestion.timeout(const Duration(seconds: 1));
    expect(coachGateway.calls, 2);
    expect(store.metrics().exposures, 1);
    final Map<String, int> outcomes =
        service.liveCoachLatencyMetrics()['outcomes']! as Map<String, int>;
    expect(outcomes['turn_resumed'], 1);
    expect(outcomes['suggestion'], 1);
  });

  test('turn-aware provider ignores idle fallback until EndOfTurn', () async {
    final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
      'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
      'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
      'COACH_MIN_INTERVAL_MS': '0',
    });
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    final _TrackSttProvider stt = _TrackSttProvider(
      providesSemanticTurnBoundaries: true,
    );
    final _RecordingCoachGateway coachGateway = _RecordingCoachGateway();
    final List<String> diagnostics = <String>[];
    final SessionService service = SessionService(
      config: config,
      store: store,
      sttProvider: stt,
      coachGateway: coachGateway,
      coachCatalog: const _SourceBackedCatalog(),
      turnIdleFallback: const Duration(milliseconds: 20),
      turnAwareWatchdog: const Duration(milliseconds: 250),
      diagnosticSink: diagnostics.add,
    );
    addTearDown(() async {
      await service.dispose();
      await store.dispose();
    });

    final CallSessionSnapshot session = service.createSession(
      callId: 'call-turn-aware-race',
      destinationNumber: '+33102030405',
      contactId: null,
      preparationMarkdown: null,
      coachMode: CoachMode.live,
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
        streamId: 'stream-turn-aware-race',
        sequenceNumber: 1,
        callControlId: 'control-turn-aware-race',
        callSessionId: 'session-turn-aware-race',
        encoding: 'PCMU',
        sampleRate: 8000,
        channels: 1,
      ),
    );
    await service.ingestAudio(
      session.id,
      _audioFrame(track: MediaTrack.inbound, sequenceNumber: 2),
    );

    stt
        .session(MediaTrack.inbound)
        .emit(
          const SttTurnTelemetry(
            event: 'Update',
            turnIndex: 4,
            sequenceId: 12,
            audioWindowStart: 0.4,
            audioWindowEnd: 1.2,
            endOfTurnConfidence: 0.42,
          ),
        );
    stt
        .session(MediaTrack.inbound)
        .emit(
          const SttTurnTelemetry(
            event: 'StartOfTurn',
            turnIndex: 4,
            sequenceId: 13,
            audioWindowStart: 0.4,
            audioWindowEnd: 1.3,
            endOfTurnConfidence: 0.51,
          ),
        );
    stt
        .session(MediaTrack.inbound)
        .emit(const SttTextDelta('Le prix est trop élevé pour nous.'));
    await Future<void>.delayed(const Duration(milliseconds: 80));

    final List<TranscriptSegment> interim = store.transcript(session.id);
    expect(interim, hasLength(1));
    expect(interim.single.isFinal, isFalse);
    expect(coachGateway.calls, 0);
    expect(
      diagnostics.join('\n'),
      contains(
        'track=inbound event=StartOfTurn turn_index=4 sequence_id=13 '
        'audio_window_start=0.4 audio_window_end=1.3 '
        'eot_confidence=0.51',
      ),
    );
    expect(diagnostics.join('\n'), isNot(contains('event=Update')));
    expect(diagnostics.join('\n'), isNot(contains('Le prix')));

    stt
        .session(MediaTrack.inbound)
        .emit(
          const SttSegment(
            text: 'Le prix est trop élevé pour nous.',
            startSeconds: 0,
            endSeconds: 1.2,
            isTurnEnd: true,
          ),
        );

    await _waitUntil(() => coachGateway.calls == 1);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final List<TranscriptSegment> finalSegments = store
        .transcript(session.id)
        .where((TranscriptSegment segment) => segment.isFinal)
        .toList(growable: false);
    expect(finalSegments, hasLength(1));
    expect(finalSegments.single.text, 'Le prix est trop élevé pour nous.');
    expect(coachGateway.calls, 1);
  });

  test('turn-aware watchdog finalizes a stranded interim turn', () async {
    final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
      'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
      'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
      'COACH_MIN_INTERVAL_MS': '0',
    });
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    final _TrackSttProvider stt = _TrackSttProvider(
      providesSemanticTurnBoundaries: true,
    );
    final _RecordingCoachGateway coachGateway = _RecordingCoachGateway();
    final List<String> diagnostics = <String>[];
    final SessionService service = SessionService(
      config: config,
      store: store,
      sttProvider: stt,
      coachGateway: coachGateway,
      coachCatalog: const _SourceBackedCatalog(),
      turnIdleFallback: const Duration(milliseconds: 5),
      turnAwareWatchdog: const Duration(milliseconds: 60),
      diagnosticSink: diagnostics.add,
    );
    addTearDown(() async {
      await service.dispose();
      await store.dispose();
    });

    final CallSessionSnapshot session = service.createSession(
      callId: 'call-turn-aware-watchdog',
      destinationNumber: '+33102030405',
      contactId: null,
      preparationMarkdown: null,
      coachMode: CoachMode.live,
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
        streamId: 'stream-turn-aware-watchdog',
        sequenceNumber: 1,
        callControlId: 'control-turn-aware-watchdog',
        callSessionId: 'session-turn-aware-watchdog',
        encoding: 'PCMU',
        sampleRate: 8000,
        channels: 1,
      ),
    );
    await service.ingestAudio(
      session.id,
      _audioFrame(track: MediaTrack.inbound, sequenceNumber: 2),
    );

    stt
        .session(MediaTrack.inbound)
        .emit(const SttTextDelta('Je dois encore vérifier le budget.'));
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(
      store
          .transcript(session.id)
          .where((TranscriptSegment segment) => segment.isFinal),
      isEmpty,
    );
    expect(coachGateway.calls, 0);

    await _waitUntil(() => coachGateway.calls == 1);
    final List<TranscriptSegment> finalSegments = store
        .transcript(session.id)
        .where((TranscriptSegment segment) => segment.isFinal)
        .toList(growable: false);
    expect(finalSegments, hasLength(1));
    expect(finalSegments.single.text, 'Je dois encore vérifier le budget.');
    expect(diagnostics.join('\n'), contains('turn_watchdog_fired'));
  });

  test(
    'starts coaching after live activation and a debounced prospect turn',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'COACH_MIN_INTERVAL_MS': '0',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final WorkspaceSalesContext workspaceContext = store
          .upsertWorkspaceSalesContext(
            companyName: 'Pinkall Studio',
            productName: 'Pinkall Coach',
            pitchMarkdown:
                '# Pitch V1\nTransformer chaque appel en apprentissage.',
            expectedRevision: null,
          );
      final _TrackSttProvider stt = _TrackSttProvider();
      final _RecordingCoachGateway coachGateway = _RecordingCoachGateway();
      final List<String> diagnostics = <String>[];
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: coachGateway,
        coachCatalog: const _SourceBackedCatalog(),
        turnIdleFallback: const Duration(milliseconds: 20),
        diagnosticSink: diagnostics.add,
      );
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });

      final CallSessionSnapshot session = service.createSession(
        callId: 'call-live-coach',
        destinationNumber: '+33102030405',
        contactId: null,
        preparationMarkdown: '# Priorité\nComprendre le processus de décision.',
        coachMode: CoachMode.off,
        sellerTrack: MediaTrack.outbound,
      );
      store.upsertWorkspaceSalesContext(
        companyName: 'Pinkall Studio V2',
        productName: 'Pinkall Coach V2',
        pitchMarkdown: '# Pitch V2\nRéservé aux futurs appels.',
        expectedRevision: workspaceContext.revision,
      );
      service.acknowledgeTranscriptionConsent(
        sessionId: session.id,
        method: 'verbal_notice',
        acknowledgedAt: DateTime.now().toUtc(),
      );
      await service.beginMedia(
        session.id,
        const TelnyxStartFrame(
          streamId: 'stream-live-coach',
          sequenceNumber: 1,
          callControlId: 'call-control-live-coach',
          callSessionId: 'call-session-live-coach',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );
      await Future.wait(<Future<void>>[
        service.ingestAudio(
          session.id,
          _audioFrame(track: MediaTrack.outbound, sequenceNumber: 2),
        ),
        service.ingestAudio(
          session.id,
          _audioFrame(track: MediaTrack.inbound, sequenceNumber: 3),
        ),
      ]);

      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: 'Le budget doit encore être validé.',
              startSeconds: 0,
              endSeconds: 1,
            ),
          );
      await _waitUntil(
        () =>
            store
                .transcript(session.id)
                .where((TranscriptSegment segment) => segment.isFinal)
                .length ==
            1,
      );
      expect(coachGateway.calls, 0, reason: 'coach off must be inert');

      final CallSessionSnapshot liveSession = service.setCoachMode(
        session.id,
        CoachMode.live,
      );
      expect(liveSession.coachMode, CoachMode.live);

      stt
          .session(MediaTrack.outbound)
          .emit(
            const SttSegment(
              text: 'Quel budget aviez-vous prévu ?',
              startSeconds: 1,
              endSeconds: 2,
            ),
          );
      await _waitUntil(
        () =>
            store
                .transcript(session.id)
                .where((TranscriptSegment segment) => segment.isFinal)
                .length ==
            2,
      );
      expect(coachGateway.calls, 0, reason: 'seller speech must be ignored');

      final Future<ClientEvent> suggestionEvent = store
          .events(session.id)
          .firstWhere(
            (ClientEvent event) => event.type == 'coaching_suggestion',
          )
          .timeout(const Duration(seconds: 1));
      stt
          .session(MediaTrack.inbound)
          .emit(const SttTextDelta('Je dois en parler à mon associé'));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(coachGateway.calls, 0, reason: 'the debounce must not fire early');
      stt
          .session(MediaTrack.inbound)
          .emit(const SttTextDelta(' avant de décider.'));

      final ClientEvent event = await suggestionEvent;
      expect(coachGateway.calls, 1);
      expect(coachGateway.lastTranscript.last.speaker, SpeakerRole.prospect);
      expect(coachGateway.lastTranscript.last.isFinal, isTrue);
      expect(
        coachGateway.lastTriggeringSegment?.id,
        coachGateway.lastTranscript.last.id,
      );
      final String coachingContext = coachGateway.lastPreparationMarkdown!;
      expect(
        coachingContext,
        contains('[PINKALL_BEGIN_UNTRUSTED_USER_CONTEXT]'),
      );
      expect(coachingContext, contains('company_name: Pinkall Studio'));
      expect(coachingContext, contains('product_name: Pinkall Coach'));
      expect(coachingContext, contains('# Pitch V1'));
      expect(
        coachingContext,
        contains('# Priorité\nComprendre le processus de décision.'),
      );
      expect(coachingContext, isNot(contains('Pitch V2')));
      expect(coachingContext, isNot(contains('Studio V2')));
      expect(event.data['recommendation_id'], _recommendation.id);
      expect(event.data['source_ids'], _recommendation.sourceIds);
      expect(event.data['evidence_segment_ids'], coachGateway.evidenceIds);
      final List<Object?> sources = event.data['sources']! as List<Object?>;
      expect(sources, hasLength(1));
      expect((sources.single! as Map<String, Object?>)['id'], 'source-1');
      expect(store.metrics().exposures, 1);
      await _waitUntil(
        () => diagnostics.any(
          (String item) => item.contains('pinkall.coach decision'),
        ),
      );
      final String diagnostic = diagnostics.firstWhere(
        (String item) => item.contains('pinkall.coach decision'),
      );
      expect(diagnostic, contains('"outcome":"suggestion"'));
      expect(diagnostic, contains('"candidate_count":1'));
      expect(diagnostic, contains('"latency_ms":'));
      expect(diagnostic, contains('"recommendation_id":"recommendation-1"'));
      expect(diagnostic, contains('"minimum_confidence":'));
      expect(diagnostic, contains('"minimum_context_match":'));
      expect(diagnostic, isNot(contains('reason_code')));
      expect(diagnostic, isNot(contains('trigger_signal')));
      expect(diagnostic, isNot(contains('Comprendre le processus')));
      expect(diagnostic, isNot(contains('Je dois en parler')));
      expect(diagnostic, isNot(contains('private model rationale')));
    },
  );

  test(
    'merges provider segments into one turn before coaching after silence',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'COACH_MIN_INTERVAL_MS': '0',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final _TrackSttProvider stt = _TrackSttProvider();
      final _RecordingCoachGateway coachGateway = _RecordingCoachGateway();
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: coachGateway,
        coachCatalog: const _SourceBackedCatalog(),
        turnSilenceBoundary: const Duration(milliseconds: 1800),
        turnIdleFallback: const Duration(milliseconds: 40),
      );
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });

      final CallSessionSnapshot session = service.createSession(
        callId: 'call-merged-turn',
        destinationNumber: '+33102030408',
        contactId: null,
        coachMode: CoachMode.live,
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
          streamId: 'stream-merged-turn',
          sequenceNumber: 1,
          callControlId: 'control-merged-turn',
          callSessionId: 'telnyx-merged-turn',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );
      await service.ingestAudio(
        session.id,
        _audioFrame(track: MediaTrack.inbound, sequenceNumber: 2),
      );

      final Future<ClientEvent> suggestion = store
          .events(session.id)
          .firstWhere(
            (ClientEvent event) => event.type == 'coaching_suggestion',
          );
      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: 'Le prix me paraît élevé',
              startSeconds: 0,
              endSeconds: 1,
            ),
          );
      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: 'pour les chantiers obtenus.',
              startSeconds: 1.8,
              endSeconds: 2.8,
            ),
          );

      await Future<void>.delayed(const Duration(milliseconds: 15));
      expect(coachGateway.calls, 0);
      final List<TranscriptSegment> provisional = store.transcript(session.id);
      expect(provisional, hasLength(1));
      expect(provisional.single.isFinal, isFalse);
      expect(
        provisional.single.text,
        'Le prix me paraît élevé pour les chantiers obtenus.',
      );

      await suggestion.timeout(const Duration(seconds: 1));
      expect(coachGateway.calls, 1);
      expect(coachGateway.lastTranscript, hasLength(1));
      expect(coachGateway.lastTranscript.single.isFinal, isTrue);
      expect(
        coachGateway.lastTranscript.single.text,
        'Le prix me paraît élevé pour les chantiers obtenus.',
      );
    },
  );

  test(
    'retries an enriched pending turn after a none without cooldown',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'COACH_MIN_INTERVAL_MS': '0',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final _TrackSttProvider stt = _TrackSttProvider();
      final _NoneThenSelectionCoachGateway coachGateway =
          _NoneThenSelectionCoachGateway();
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: coachGateway,
        coachCatalog: const _SourceBackedCatalog(),
        turnIdleFallback: const Duration(milliseconds: 20),
      );
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });

      final CallSessionSnapshot session = service.createSession(
        callId: 'call-enriched-turn',
        destinationNumber: '+33102030409',
        contactId: null,
        coachMode: CoachMode.live,
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
          streamId: 'stream-enriched-turn',
          sequenceNumber: 1,
          callControlId: 'control-enriched-turn',
          callSessionId: 'telnyx-enriched-turn',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );
      await service.ingestAudio(
        session.id,
        _audioFrame(track: MediaTrack.inbound, sequenceNumber: 2),
      );

      final List<ClientEvent> coachStatuses = <ClientEvent>[];
      final StreamSubscription<ClientEvent> statusSubscription = store
          .events(session.id)
          .where((ClientEvent event) => event.type == 'coach_status')
          .listen(coachStatuses.add);
      addTearDown(statusSubscription.cancel);
      final Future<ClientEvent> suggestion = store
          .events(session.id)
          .firstWhere(
            (ClientEvent event) => event.type == 'coaching_suggestion',
          );

      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: "J'ai installé l'application.",
              startSeconds: 0,
              endSeconds: 1,
            ),
          );
      await _waitUntil(() => coachGateway.calls == 1);

      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: 'Mais le prix est trop élevé pour les chantiers obtenus.',
              startSeconds: 4,
              endSeconds: 6,
            ),
          );
      await _waitUntil(
        () =>
            store
                .transcript(session.id)
                .where((TranscriptSegment item) => item.isFinal)
                .length ==
            2,
      );
      expect(coachGateway.calls, 1, reason: 'the first request is in flight');

      coachGateway.completeFirstWithNone();
      final ClientEvent event = await suggestion.timeout(
        const Duration(seconds: 1),
      );
      expect(coachGateway.calls, 2);
      expect(event.data['recommendation_id'], _recommendation.id);
      expect(store.metrics().exposures, 1);
      expect(
        coachGateway.transcripts.last.last.text,
        'Mais le prix est trop élevé pour les chantiers obtenus.',
      );
      await _waitUntil(() => coachStatuses.length >= 4);
      expect(
        coachStatuses
            .map((ClientEvent item) => item.data['status'])
            .whereType<String>(),
        containsAllInOrder(<String>[
          'analyzing',
          'listening',
          'analyzing',
          'listening',
        ]),
      );
    },
  );

  test(
    'two null decisions do not consume the per-minute suggestion quota',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'COACH_MIN_INTERVAL_MS': '0',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final _TrackSttProvider stt = _TrackSttProvider();
      final _TwoNoneThenSelectionCoachGateway coachGateway =
          _TwoNoneThenSelectionCoachGateway();
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: coachGateway,
        coachCatalog: const _SourceBackedCatalog(),
        turnIdleFallback: const Duration(milliseconds: 10),
      );
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });

      final CallSessionSnapshot session = service.createSession(
        callId: 'call-two-null-then-objection',
        destinationNumber: '+33102030410',
        contactId: null,
        coachMode: CoachMode.live,
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
          streamId: 'stream-two-null-then-objection',
          sequenceNumber: 1,
          callControlId: 'control-two-null-then-objection',
          callSessionId: 'telnyx-two-null-then-objection',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );
      await service.ingestAudio(
        session.id,
        _audioFrame(track: MediaTrack.inbound, sequenceNumber: 2),
      );
      final Future<ClientEvent> suggestion = store
          .events(session.id)
          .firstWhere(
            (ClientEvent event) => event.type == 'coaching_suggestion',
          );

      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: 'Bonjour.',
              startSeconds: 0,
              endSeconds: 1,
              isTurnEnd: true,
            ),
          );
      await _waitUntil(() => coachGateway.calls == 1);
      await Future<void>.delayed(Duration.zero);

      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: 'Oui.',
              startSeconds: 3,
              endSeconds: 4,
              isTurnEnd: true,
            ),
          );
      await _waitUntil(() => coachGateway.calls == 2);
      await Future<void>.delayed(Duration.zero);

      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: 'Mais le prix est vraiment trop élevé.',
              startSeconds: 6,
              endSeconds: 8,
              isTurnEnd: true,
            ),
          );

      final ClientEvent event = await suggestion.timeout(
        const Duration(seconds: 1),
      );
      expect(coachGateway.calls, 3);
      expect(event.data['recommendation_id'], _recommendation.id);
      expect(store.metrics().exposures, 1);
    },
  );

  test(
    'keeps coach failures fail-soft and emits redacted diagnostics',
    () async {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'test-token-with-more-than-24-characters',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'COACH_MIN_INTERVAL_MS': '0',
      });
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      final _TrackSttProvider stt = _TrackSttProvider();
      final List<String> diagnostics = <String>[];
      final SessionService service = SessionService(
        config: config,
        store: store,
        sttProvider: stt,
        coachGateway: const _ThrowingCoachGateway(),
        coachCatalog: const _SourceBackedCatalog(),
        turnIdleFallback: const Duration(milliseconds: 20),
        diagnosticSink: diagnostics.add,
      );
      addTearDown(() async {
        await service.dispose();
        await store.dispose();
      });

      final CallSessionSnapshot session = service.createSession(
        callId: 'call-coach-failure',
        destinationNumber: '+33102030407',
        contactId: null,
        coachMode: CoachMode.live,
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
          streamId: 'stream-coach-failure',
          sequenceNumber: 1,
          callControlId: 'control-coach-failure',
          callSessionId: 'telnyx-coach-failure',
          encoding: 'PCMU',
          sampleRate: 8000,
          channels: 1,
        ),
      );
      await service.ingestAudio(
        session.id,
        _audioFrame(track: MediaTrack.inbound, sequenceNumber: 2),
      );
      stt
          .session(MediaTrack.inbound)
          .emit(
            const SttSegment(
              text: 'Nous devons encore valider le budget.',
              startSeconds: 0,
              endSeconds: 1,
            ),
          );

      await _waitUntil(
        () => diagnostics.any(
          (String item) => item.contains('pinkall.coach failed'),
        ),
      );
      expect(store.session(session.id)!.status, SessionStatus.streaming);
      expect(store.transcript(session.id).single.isFinal, isTrue);
      expect(store.metrics().exposures, 0);
      expect(diagnostics.join('\n'), contains('error=StateError'));
      expect(diagnostics.join('\n'), contains('candidate_count=1'));
      expect(diagnostics.join('\n'), contains('latency_ms='));
      expect(diagnostics.join('\n'), isNot(contains('super-secret-token')));
    },
  );
}

TelnyxAudioFrame _audioFrame({
  required MediaTrack track,
  required int sequenceNumber,
}) {
  return TelnyxAudioFrame(
    streamId: 'stream-live-coach',
    sequenceNumber: sequenceNumber,
    track: track,
    chunk: sequenceNumber,
    timestamp: sequenceNumber * 20,
    payload: base64Encode(<int>[0xff]),
  );
}

Future<void> _waitUntil(bool Function() predicate) async {
  final DateTime deadline = DateTime.now().add(const Duration(seconds: 1));
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out while waiting for the STT event to be handled.');
    }
    await Future<void>.delayed(Duration.zero);
  }
}

final class _TrackSttProvider implements SttProvider {
  _TrackSttProvider({this.providesSemanticTurnBoundaries = false});

  @override
  final bool providesSemanticTurnBoundaries;

  final Map<MediaTrack, _TrackSttSession> _sessions =
      <MediaTrack, _TrackSttSession>{};

  @override
  bool get isConfigured => true;

  @override
  String get name => 'fake_stt';

  _TrackSttSession session(MediaTrack track) => _sessions[track]!;

  @override
  Future<RealtimeSttSession> openRealtimeSession({
    required MediaTrack track,
    required SttAudioFormat audioFormat,
  }) async {
    return _sessions.putIfAbsent(track, _TrackSttSession.new);
  }

  @override
  Future<BatchTranscript> transcribeFinal({
    required List<int> pcmBytes,
    required SttAudioFormat audioFormat,
    required String fileName,
  }) {
    throw UnsupportedError('Batch STT is outside this live-coach test.');
  }
}

final class _TrackSttSession implements RealtimeSttSession {
  final StreamController<SttEvent> _events = StreamController<SttEvent>();

  @override
  Stream<SttEvent> get events => _events.stream;

  void emit(SttEvent event) => _events.add(event);

  @override
  Future<void> addAudio(List<int> pcmBytes) async {}

  @override
  Future<void> close() => _events.close();
}

final class _RecordingCoachGateway implements CoachGateway {
  int calls = 0;
  List<TranscriptSegment> lastTranscript = const <TranscriptSegment>[];
  TranscriptSegment? lastTriggeringSegment;
  List<String> evidenceIds = const <String>[];
  String? lastPreparationMarkdown;

  @override
  bool get isConfigured => true;

  @override
  Future<CoachSelection> select({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required TranscriptSegment triggeringSegment,
    required List<CoachRecommendation> candidates,
    String? preparationMarkdown,
  }) async {
    calls += 1;
    lastPreparationMarkdown = preparationMarkdown;
    lastTranscript = List<TranscriptSegment>.unmodifiable(transcript);
    lastTriggeringSegment = triggeringSegment;
    evidenceIds = <String>[triggeringSegment.id];
    return CoachSelection(
      recommendationId: candidates.single.id,
      rationale: 'private model rationale',
      confidence: 0.95,
      contextMatch: 0.95,
      evidenceSegmentIds: evidenceIds,
      reasonCode: 'prospect_objection',
      triggerSignal: 'decision_process',
    );
  }
}

final class _NoneThenSelectionCoachGateway implements CoachGateway {
  final Completer<CoachSelection> _first = Completer<CoachSelection>();
  final List<List<TranscriptSegment>> transcripts = <List<TranscriptSegment>>[];
  int calls = 0;

  @override
  bool get isConfigured => true;

  void completeFirstWithNone() {
    _first.complete(
      const CoachSelection(
        recommendationId: null,
        rationale: 'No grounded recommendation for this first turn.',
        confidence: 0,
        contextMatch: 0,
        evidenceSegmentIds: <String>[],
        reasonCode: 'none',
        triggerSignal: 'none',
      ),
    );
  }

  @override
  Future<CoachSelection> select({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required TranscriptSegment triggeringSegment,
    required List<CoachRecommendation> candidates,
    String? preparationMarkdown,
  }) {
    calls += 1;
    transcripts.add(List<TranscriptSegment>.unmodifiable(transcript));
    if (calls == 1) {
      return _first.future;
    }
    return Future<CoachSelection>.value(
      CoachSelection(
        recommendationId: candidates.single.id,
        rationale: 'The enriched price objection matches the curated card.',
        confidence: 0.95,
        contextMatch: 0.95,
        evidenceSegmentIds: <String>[triggeringSegment.id],
        reasonCode: 'price_objection',
        triggerSignal: 'explicit_too_expensive',
      ),
    );
  }
}

final class _ThrowingCoachGateway implements CoachGateway {
  const _ThrowingCoachGateway();

  @override
  bool get isConfigured => true;

  @override
  Future<CoachSelection> select({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required TranscriptSegment triggeringSegment,
    required List<CoachRecommendation> candidates,
    String? preparationMarkdown,
  }) {
    throw StateError('Authorization: Bearer super-secret-token');
  }
}

final class _TwoNoneThenSelectionCoachGateway implements CoachGateway {
  int calls = 0;

  @override
  bool get isConfigured => true;

  @override
  Future<CoachSelection> select({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required TranscriptSegment triggeringSegment,
    required List<CoachRecommendation> candidates,
    String? preparationMarkdown,
  }) async {
    calls += 1;
    if (calls <= 2) {
      return const CoachSelection(
        recommendationId: null,
        rationale: 'No safe action yet.',
        confidence: 0,
        contextMatch: 0,
        reasonCode: 'low_context',
      );
    }
    return CoachSelection(
      recommendationId: candidates.single.id,
      rationale: 'The explicit objection matches the curated card.',
      confidence: 0.95,
      contextMatch: 0.95,
      evidenceSegmentIds: <String>[triggeringSegment.id],
      reasonCode: 'price_objection',
      triggerSignal: 'explicit_too_expensive',
    );
  }
}

final class _SourceBackedCatalog implements CoachCatalog {
  const _SourceBackedCatalog();

  @override
  bool get allowsUnreviewedRecommendations => false;

  @override
  List<CoachRecommendation> candidatesFor({
    required CoachMode mode,
    required String latestText,
  }) {
    return mode == CoachMode.off
        ? const <CoachRecommendation>[]
        : const <CoachRecommendation>[_recommendation];
  }

  @override
  int get defaultExpirySeconds => 45;

  @override
  Duration get globalCooldown => Duration.zero;

  @override
  bool get isAvailable => true;

  @override
  int get maxSuggestionsPerMinute => 2;

  @override
  int get maxEvaluationsPerMinute => 12;

  @override
  double get minimumContextMatch => 0.7;

  @override
  double get minimumLiveConfidence => 0.7;

  @override
  List<CoachRecommendation> postCallCandidates() => const <CoachRecommendation>[
    _recommendation,
  ];

  @override
  CoachReleaseChannel get releaseChannel => CoachReleaseChannel.strict;

  @override
  String? get unavailableReason => null;
}

const CoachRecommendation _recommendation = CoachRecommendation(
  id: 'recommendation-1',
  status: 'live',
  message: 'Clarifie qui participe à la décision et la prochaine étape.',
  sourceIds: <String>['source-1'],
  sources: <CoachSource>[
    CoachSource(
      id: 'source-1',
      title: 'Entrepreneurial Sales',
      evidenceLevel: 'expert_playbook',
      author: 'MIT OpenCourseWare',
      url:
          'https://ocw.mit.edu/courses/15-387-entrepreneurial-sales-spring-2015/',
      locator: 'Decision process',
    ),
  ],
  triggers: <String>['decision'],
  raw: <String, Object?>{
    'action': <String, Object?>{'type': 'clarification'},
    'confidence': <String, Object?>{
      'live_minimum': 0.8,
      'context_minimum': 0.8,
    },
  },
);
