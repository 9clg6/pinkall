import 'dart:async';

import 'package:core_domain/core_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:pinkall/core/providers/data/endpoint/audio_device.client.provider.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/calls/presentation/screens/active_call/active_call.state.dart';
import 'package:pinkall/features/calls/presentation/screens/active_call/active_call.view_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('companion refresh loads both final transcript and debrief', () async {
    final _FakeConversationSessionRepository repository =
        _FakeConversationSessionRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        conversationSessionRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    final ActiveCallViewModelProvider provider = activeCallViewModelProvider(
      'call-1',
      'session-1',
      '+33123456789',
      false,
      true,
    );
    final ProviderSubscription<AsyncValue<ActiveCallState>> subscription =
        container.listen(
          provider,
          (
            AsyncValue<ActiveCallState>? previous,
            AsyncValue<ActiveCallState> next,
          ) {},
        );
    addTearDown(subscription.close);

    await container.read(provider.future);
    await container.read(provider.notifier).finalizeDebrief();

    final ActiveCallState state = container.read(provider).requireValue;
    expect(state.finalTranscript, repository.transcript);
    expect(state.debrief, repository.debrief);
    expect(state.finalizationMessage, 'Débrief final disponible.');
    expect(repository.finalTranscriptRequestCount, 1);
    expect(repository.debriefRequestCount, 1);
  });

  test('applies coach status events and ignores future event types', () async {
    final _RealtimeConversationSessionRepository repository =
        _RealtimeConversationSessionRepository();
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        conversationSessionRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await repository.dispose();
    });
    final ActiveCallViewModelProvider provider = activeCallViewModelProvider(
      'call-live',
      'session-live',
      '+33123456789',
      false,
      true,
    );
    final ProviderSubscription<AsyncValue<ActiveCallState>> subscription =
        container.listen(
          provider,
          (
            AsyncValue<ActiveCallState>? previous,
            AsyncValue<ActiveCallState> next,
          ) {},
        );
    addTearDown(subscription.close);

    await container.read(provider.future);
    await _waitUntil(() => repository.didOpenRealtimeStream);

    repository.add(
      const SessionRealtimeEventEntity.coachStatus(
        CoachStatusEntity(status: CoachAnalysisStatus.analyzing),
      ),
    );
    await _waitUntil(
      () =>
          container.read(provider).requireValue.coachAnalysisStatus ==
          CoachAnalysisStatus.analyzing,
    );

    repository
      ..add(
        const SessionRealtimeEventEntity.unknown(
          type: 'future_event',
          payload: <String, Object?>{'version': 2},
        ),
      )
      ..add(
        const SessionRealtimeEventEntity.coachStatus(
          CoachStatusEntity(
            status: CoachAnalysisStatus.listening,
            outcome: CoachAnalysisOutcome.none,
          ),
        ),
      );
    await _waitUntil(
      () =>
          container.read(provider).requireValue.coachAnalysisOutcome ==
          CoachAnalysisOutcome.none,
    );

    final ActiveCallState state = container.read(provider).requireValue;
    expect(state.coachAnalysisStatus, CoachAnalysisStatus.listening);
    expect(state.realtimeFailure, isNull);
  });

  test(
    'carrier rejection before connection cancels without finalizing',
    () async {
      final _CallStateRepository calls = _CallStateRepository();
      final _LifecycleConversationSessionRepository sessions =
          _LifecycleConversationSessionRepository(
            initialStatus: ConversationSessionStatus.created,
          );
      final ProviderContainer container = _nonCompanionContainer(
        calls: calls,
        sessions: sessions,
      );
      final ActiveCallViewModelProvider provider = activeCallViewModelProvider(
        'call-rejected',
        'session-lifecycle',
        '+33123456789',
        false,
        false,
      );
      final ProviderSubscription<AsyncValue<ActiveCallState>> subscription =
          container.listen(
            provider,
            (
              AsyncValue<ActiveCallState>? previous,
              AsyncValue<ActiveCallState> next,
            ) {},
          );
      addTearDown(() async {
        subscription.close();
        container.dispose();
        await calls.dispose();
      });

      await container.read(provider.future);
      await _waitUntil(() => calls.didWatchCall);
      calls.add(
        const CallStateEntity(
          callId: 'call-rejected',
          direction: CallDirection.outgoing,
          status: CallLifecycleStatus.ended,
          remoteNumber: '+33123456789',
          failureReason: 'SIP 603 call rejected D17',
        ),
      );
      await _waitUntil(() => sessions.cancelRequestCount == 1);

      final ActiveCallState state = container.read(provider).requireValue;
      expect(sessions.finalizeRequestCount, 0);
      expect(sessions.debriefRequestCount, 0);
      expect(state.finalizationMessage, contains('Aucun débrief'));
      expect(state.operationFailure, contains('bloqué par le fournisseur'));
      expect(state.operationFailure, contains('contacte son support'));
      expect(state.operationFailure, isNot(contains('SIP 603')));
    },
  );

  test(
    'media connection failure explains that audio did not connect',
    () async {
      final _CallStateRepository calls = _CallStateRepository();
      final _LifecycleConversationSessionRepository sessions =
          _LifecycleConversationSessionRepository(
            initialStatus: ConversationSessionStatus.created,
          );
      final ProviderContainer container = _nonCompanionContainer(
        calls: calls,
        sessions: sessions,
      );
      final ActiveCallViewModelProvider provider = activeCallViewModelProvider(
        'call-media-failed',
        'session-lifecycle',
        '+33123456789',
        false,
        false,
      );
      final ProviderSubscription<AsyncValue<ActiveCallState>> subscription =
          container.listen(
            provider,
            (
              AsyncValue<ActiveCallState>? previous,
              AsyncValue<ActiveCallState> next,
            ) {},
          );
      addTearDown(() async {
        subscription.close();
        container.dispose();
        await calls.dispose();
      });

      await container.read(provider.future);
      await _waitUntil(() => calls.didWatchCall);
      calls.add(
        const CallStateEntity(
          callId: 'call-media-failed',
          direction: CallDirection.outgoing,
          status: CallLifecycleStatus.error,
          remoteNumber: '+33123456789',
          failureReason: 'media_connection_failed',
        ),
      );
      await _waitUntil(
        () => container.read(provider).requireValue.operationFailure != null,
      );

      final ActiveCallState state = container.read(provider).requireValue;
      expect(state.operationFailure, contains('connexion audio'));
      expect(state.operationFailure, contains('Vérifie ton réseau'));
      expect(
        state.operationFailure,
        isNot(contains('media_connection_failed')),
      );
    },
  );

  test(
    'connected call still finalizes when its backend snapshot is created',
    () async {
      final _CallStateRepository calls = _CallStateRepository();
      final _LifecycleConversationSessionRepository sessions =
          _LifecycleConversationSessionRepository(
            initialStatus: ConversationSessionStatus.created,
          );
      final ProviderContainer container = _nonCompanionContainer(
        calls: calls,
        sessions: sessions,
      );
      final ActiveCallViewModelProvider provider = activeCallViewModelProvider(
        'call-connected',
        'session-lifecycle',
        '+33123456789',
        false,
        false,
      );
      final ProviderSubscription<AsyncValue<ActiveCallState>> subscription =
          container.listen(
            provider,
            (
              AsyncValue<ActiveCallState>? previous,
              AsyncValue<ActiveCallState> next,
            ) {},
          );
      addTearDown(() async {
        subscription.close();
        container.dispose();
        await calls.dispose();
      });

      await container.read(provider.future);
      await _waitUntil(() => calls.didWatchCall);
      calls
        ..add(
          const CallStateEntity(
            callId: 'call-connected',
            direction: CallDirection.outgoing,
            status: CallLifecycleStatus.active,
            remoteNumber: '+33123456789',
          ),
        )
        ..add(
          const CallStateEntity(
            callId: 'call-connected',
            direction: CallDirection.outgoing,
            status: CallLifecycleStatus.ended,
            remoteNumber: '+33123456789',
          ),
        );
      await _waitUntil(() => sessions.debriefRequestCount == 1);

      expect(sessions.cancelRequestCount, 0);
      expect(sessions.finalizeRequestCount, 1);
      expect(
        container.read(provider).requireValue.finalizationMessage,
        'Débrief final disponible.',
      );
    },
  );

  test('finalization completes safely after provider disposal', () async {
    final _CallStateRepository calls = _CallStateRepository();
    final _LifecycleConversationSessionRepository sessions =
        _LifecycleConversationSessionRepository(
          initialStatus: ConversationSessionStatus.active,
          delayFinalization: true,
        );
    final ProviderContainer container = _nonCompanionContainer(
      calls: calls,
      sessions: sessions,
    );
    final ActiveCallViewModelProvider provider = activeCallViewModelProvider(
      'call-disposed',
      'session-lifecycle',
      '+33123456789',
      false,
      false,
    );
    final ProviderSubscription<AsyncValue<ActiveCallState>> subscription =
        container.listen(
          provider,
          (
            AsyncValue<ActiveCallState>? previous,
            AsyncValue<ActiveCallState> next,
          ) {},
        );

    await container.read(provider.future);
    final Future<void> finalization = container
        .read(provider.notifier)
        .finalizeDebrief();
    await sessions.finalizationStarted.future;
    subscription.close();
    container.dispose();
    sessions.completeFinalization();

    await expectLater(finalization, completes);
    expect(sessions.finalTranscriptRequestCount, 0);
    expect(sessions.debriefRequestCount, 0);
    await calls.dispose();
  });
}

ProviderContainer _nonCompanionContainer({
  required _CallStateRepository calls,
  required _LifecycleConversationSessionRepository sessions,
}) => ProviderContainer(
  overrides: <Override>[
    callRepositoryProvider.overrideWith((Ref ref) async => calls),
    supportsDesktopAudioDeviceSelectionProvider.overrideWithValue(false),
    conversationSessionRepositoryProvider.overrideWithValue(sessions),
  ],
);

Future<void> _waitUntil(bool Function() predicate) async {
  final DateTime deadline = DateTime.now().add(const Duration(seconds: 1));
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out while waiting for the realtime state update.');
    }
    await Future<void>.delayed(Duration.zero);
  }
}

final class _CallStateRepository implements CallRepository {
  final StreamController<CallStateEntity> _states =
      StreamController<CallStateEntity>.broadcast(sync: true);
  bool didWatchCall = false;

  void add(CallStateEntity call) => _states.add(call);

  @override
  Stream<CallStateEntity> watchCallState(String callId) {
    didWatchCall = true;
    return _states.stream;
  }

  @override
  Future<void> dispose() => _states.close();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _LifecycleConversationSessionRepository
    implements ConversationSessionRepository {
  _LifecycleConversationSessionRepository({
    required ConversationSessionStatus initialStatus,
    this.delayFinalization = false,
  }) : _session = ConversationSessionEntity(
         id: 'session-lifecycle',
         callId: 'call-lifecycle',
         status: initialStatus,
         coachMode: CoachMode.off,
         createdAt: DateTime.utc(2026, 7, 13),
         transcriptionConsentAcknowledged: false,
       );

  final ConversationSessionEntity _session;
  final bool delayFinalization;
  final Completer<void> finalizationStarted = Completer<void>();
  final Completer<ConversationSessionEntity> _finalization =
      Completer<ConversationSessionEntity>();
  int cancelRequestCount = 0;
  int finalizeRequestCount = 0;
  int finalTranscriptRequestCount = 0;
  int debriefRequestCount = 0;

  void completeFinalization() {
    if (!_finalization.isCompleted) {
      _finalization.complete(
        _session.copyWith(status: ConversationSessionStatus.completed),
      );
    }
  }

  @override
  Future<ConversationSessionEntity> getSession(String sessionId) async =>
      _session;

  @override
  Future<ConversationSessionEntity> cancelSession(String sessionId) async {
    cancelRequestCount++;
    return _session.copyWith(status: ConversationSessionStatus.failed);
  }

  @override
  Future<ConversationSessionEntity> finalizeSession(String sessionId) async {
    finalizeRequestCount++;
    if (!delayFinalization) {
      return _session.copyWith(status: ConversationSessionStatus.completed);
    }
    if (!finalizationStarted.isCompleted) {
      finalizationStarted.complete();
    }
    return _finalization.future;
  }

  @override
  Future<ConversationTranscriptEntity> getFinalTranscript(
    String sessionId,
  ) async {
    finalTranscriptRequestCount++;
    return ConversationTranscriptEntity(
      sessionId: sessionId,
      segments: const <TranscriptSegmentEntity>[],
      finalizedAt: DateTime.utc(2026, 7, 13),
    );
  }

  @override
  Future<CallDebriefEntity> getDebrief(String sessionId) async {
    debriefRequestCount++;
    return CallDebriefEntity(
      sessionId: sessionId,
      summary: const GroundedCallTextEntity(
        text: 'Résumé final.',
        evidenceSegmentIds: <String>[],
      ),
      keyPoints: const <GroundedCallTextEntity>[],
      commitments: const <CallCommitmentEntity>[],
      followUp: const CallFollowUpEntity(
        subject: 'Suivi',
        body: 'Merci pour votre échange.',
        evidenceSegmentIds: <String>[],
      ),
      generatedAt: DateTime.utc(2026, 7, 13),
      provider: 'test',
      model: 'test-model',
    );
  }

  @override
  Stream<SessionRealtimeEventEntity> watchSessionEvents(String sessionId) =>
      const Stream<SessionRealtimeEventEntity>.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _RealtimeConversationSessionRepository
    implements ConversationSessionRepository {
  final StreamController<SessionRealtimeEventEntity> _events =
      StreamController<SessionRealtimeEventEntity>.broadcast(sync: true);
  bool didOpenRealtimeStream = false;

  void add(SessionRealtimeEventEntity event) => _events.add(event);

  Future<void> dispose() => _events.close();

  @override
  Future<ConversationSessionEntity> getSession(String sessionId) async =>
      ConversationSessionEntity(
        id: sessionId,
        callId: 'call-live',
        status: ConversationSessionStatus.active,
        coachMode: CoachMode.live,
        createdAt: DateTime.utc(2026, 7, 13),
        transcriptionConsentAcknowledged: true,
      );

  @override
  Stream<SessionRealtimeEventEntity> watchSessionEvents(String sessionId) {
    didOpenRealtimeStream = true;
    return _events.stream;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeConversationSessionRepository
    implements ConversationSessionRepository {
  _FakeConversationSessionRepository()
    : transcript = ConversationTranscriptEntity(
        sessionId: 'session-1',
        segments: const <TranscriptSegmentEntity>[],
        finalizedAt: DateTime.utc(2026, 7, 13),
      ),
      debrief = CallDebriefEntity(
        sessionId: 'session-1',
        summary: const GroundedCallTextEntity(
          text: 'Résumé final.',
          evidenceSegmentIds: <String>[],
        ),
        keyPoints: const <GroundedCallTextEntity>[],
        commitments: const <CallCommitmentEntity>[],
        followUp: const CallFollowUpEntity(
          subject: 'Suivi',
          body: 'Merci pour votre échange.',
          evidenceSegmentIds: <String>[],
        ),
        generatedAt: DateTime.utc(2026, 7, 13),
        provider: 'test',
        model: 'test-model',
      );

  final ConversationTranscriptEntity transcript;
  final CallDebriefEntity debrief;
  int sessionRequestCount = 0;
  int finalTranscriptRequestCount = 0;
  int debriefRequestCount = 0;

  @override
  Future<ConversationSessionEntity> getSession(String sessionId) async {
    sessionRequestCount++;
    return ConversationSessionEntity(
      id: sessionId,
      callId: 'call-1',
      status: sessionRequestCount == 1
          ? ConversationSessionStatus.active
          : ConversationSessionStatus.completed,
      coachMode: CoachMode.off,
      createdAt: DateTime.utc(2026, 7, 13),
      transcriptionConsentAcknowledged: false,
    );
  }

  @override
  Future<ConversationTranscriptEntity> getFinalTranscript(
    String sessionId,
  ) async {
    finalTranscriptRequestCount++;
    return transcript;
  }

  @override
  Future<CallDebriefEntity> getDebrief(String sessionId) async {
    debriefRequestCount++;
    return debrief;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
