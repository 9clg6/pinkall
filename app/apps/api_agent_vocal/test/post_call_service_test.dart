import 'dart:async';

import 'package:api_agent_vocal/src/application/post_call_service.dart';
import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/objection_learning.dart';
import 'package:api_agent_vocal/src/domain/post_call_contracts.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:test/test.dart';

void main() {
  test('deduplicates concurrent generation and persists the result', () async {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    addTearDown(store.dispose);
    final CallSessionSnapshot session = store.createSession(
      callId: 'call-1',
      destinationNumber: '+33102030405',
      contactId: null,
      preparationMarkdown: '# Objectif\nObtenir le prochain rendez-vous.',
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    store.replaceFinalTranscript(session.id, <TranscriptSegment>[_segment()]);
    final _RecordingPostCallGateway gateway = _RecordingPostCallGateway();
    final _RecordingObjectionSink objectionSink = _RecordingObjectionSink();
    final PostCallService service = PostCallService(
      store: store,
      gateway: gateway,
      coachCatalog: const _Catalog(),
      objectionLearningSink: objectionSink,
    );

    final Future<PostCallDebrief> first = service.generate(session.id);
    final Future<PostCallDebrief> second = service.generate(session.id);
    expect(service.privacyBlockingSessionIds, contains(session.id));
    final List<PostCallDebrief> results = await Future.wait(
      <Future<PostCallDebrief>>[first, second],
    );

    expect(gateway.calls, 1);
    expect(
      gateway.lastPreparationMarkdown,
      '# Objectif\nObtenir le prochain rendez-vous.',
    );
    expect(identical(results.first, results.last), isTrue);
    expect(store.postCallDebrief(session.id), same(results.first));
    expect(service.privacyBlockingSessionIds, isEmpty);
    expect(objectionSink.calls, 1);
    expect(
      objectionSink.lastObjections.single.category,
      PostCallObjectionCategory.price,
    );

    final PostCallDebrief cached = await service.generate(session.id);
    expect(cached, same(results.first));
    expect(gateway.calls, 1);
  });

  test('does not fail a completed debrief when local learning fails', () async {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    addTearDown(store.dispose);
    final CallSessionSnapshot session = store.createSession(
      callId: 'call-learning-failure',
      destinationNumber: '+33102030415',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    store.replaceFinalTranscript(session.id, <TranscriptSegment>[_segment()]);
    final List<String> diagnostics = <String>[];
    final PostCallService service = PostCallService(
      store: store,
      gateway: _RecordingPostCallGateway(),
      coachCatalog: const _Catalog(),
      objectionLearningSink: _RecordingObjectionSink(throwOnLearn: true),
      diagnosticSink: diagnostics.add,
    );

    final PostCallDebrief debrief = await service.generate(session.id);

    expect(store.postCallDebrief(session.id), same(debrief));
    expect(diagnostics, contains('objection_learning_failed type=StateError'));
  });

  test('requires a final transcript', () async {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    addTearDown(store.dispose);
    final CallSessionSnapshot session = store.createSession(
      callId: 'call-2',
      destinationNumber: '+33102030406',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    final PostCallService service = PostCallService(
      store: store,
      gateway: _RecordingPostCallGateway(),
      coachCatalog: const _Catalog(),
    );

    await expectLater(service.generate(session.id), throwsA(isA<StateError>()));
    expect(
      store.postCallGeneration(session.id)?.failureCode,
      'missing_final_transcript',
    );
  });

  test('retries only an explicitly transient gateway failure', () async {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    addTearDown(store.dispose);
    final CallSessionSnapshot session = _sessionWithTranscript(store, 'retry');
    final _SequencedPostCallGateway gateway = _SequencedPostCallGateway(
      failures: const <Object>[
        PostCallGatewayException(code: 'provider_timeout', retryable: true),
      ],
    );
    DateTime now = DateTime.utc(2026, 7, 14, 10);
    final List<Duration> delays = <Duration>[];
    final PostCallService service = PostCallService(
      store: store,
      gateway: gateway,
      coachCatalog: const _Catalog(),
      maxAttempts: 3,
      retryBaseDelay: const Duration(milliseconds: 250),
      clock: () => now,
      delay: (Duration delay) async {
        delays.add(delay);
        now = now.add(delay);
      },
    );

    await service.generate(session.id);

    expect(gateway.calls, 2);
    expect(delays, <Duration>[const Duration(milliseconds: 250)]);
    final PostCallGenerationSnapshot status = service.status(session.id)!;
    expect(status.status, PostCallGenerationStatus.completed);
    expect(status.attemptCount, 2);
    expect(status.failureCode, isNull);
    expect(
      store.session(session.id)!.toJson()['debrief_generation'],
      status.toJson(),
    );
  });

  test('does not retry invalid provider output', () async {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    addTearDown(store.dispose);
    final CallSessionSnapshot session = _sessionWithTranscript(store, 'format');
    final _SequencedPostCallGateway gateway = _SequencedPostCallGateway(
      failures: const <Object>[FormatException('invalid structured output')],
    );
    final List<Duration> delays = <Duration>[];
    final PostCallService service = PostCallService(
      store: store,
      gateway: gateway,
      coachCatalog: const _Catalog(),
      maxAttempts: 3,
      delay: (Duration delay) async => delays.add(delay),
      clock: () => DateTime.utc(2026, 7, 14, 11),
    );

    await expectLater(
      service.generate(session.id),
      throwsA(isA<FormatException>()),
    );

    expect(gateway.calls, 1);
    expect(delays, isEmpty);
    final PostCallGenerationSnapshot status = service.status(session.id)!;
    expect(status.status, PostCallGenerationStatus.failed);
    expect(status.failureCode, 'invalid_provider_response');
    expect(status.retryable, isFalse);
    expect(status.nextRetryAt, isNull);
  });

  test(
    'resumes an interrupted durable job without duplicate provider calls',
    () async {
      final InMemoryPocStore first = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      addTearDown(first.dispose);
      final CallSessionSnapshot session = _sessionWithTranscript(
        first,
        'resume',
      );
      first.savePostCallGeneration(
        PostCallGenerationSnapshot(
          sessionId: session.id,
          status: PostCallGenerationStatus.running,
          attemptCount: 1,
          updatedAt: DateTime.utc(2026, 7, 14, 12),
          failureCode: null,
          retryable: null,
          nextRetryAt: null,
        ),
      );
      final InMemoryPocStore restored = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      addTearDown(restored.dispose);
      restored.restoreDurableSnapshot(first.exportDurableSnapshot());
      final _SequencedPostCallGateway gateway = _SequencedPostCallGateway();
      final PostCallService service = PostCallService(
        store: restored,
        gateway: gateway,
        coachCatalog: const _Catalog(),
        maxAttempts: 1,
      );

      expect(service.resumeInterruptedJobs(), 1);
      expect(service.resumeInterruptedJobs(), 1);
      await _waitFor(() => restored.postCallDebrief(session.id) != null);

      expect(gateway.calls, 1);
      expect(
        service.status(session.id)?.status,
        PostCallGenerationStatus.completed,
      );
      expect(service.status(session.id)?.attemptCount, 2);
      expect(service.resumeInterruptedJobs(), 0);
    },
  );

  test('injects the session workspace snapshot and call preparation', () async {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    addTearDown(store.dispose);
    final WorkspaceSalesContext firstContext = store
        .upsertWorkspaceSalesContext(
          companyName: 'Pinkall Studio',
          productName: 'Pinkall Coach',
          pitchMarkdown: '# Pitch V1\nAider les fondateurs à mieux vendre.',
          expectedRevision: null,
        );
    final CallSessionSnapshot session = store.createSession(
      callId: 'call-context',
      destinationNumber: '+33102030407',
      contactId: null,
      preparationMarkdown: '# Appel\nQualifier le besoin de coaching.',
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    store.upsertWorkspaceSalesContext(
      companyName: 'Pinkall Studio V2',
      productName: 'Pinkall Coach V2',
      pitchMarkdown:
          '# Pitch V2\nCe contexte ne concerne que les futurs appels.',
      expectedRevision: firstContext.revision,
    );
    store.replaceFinalTranscript(session.id, <TranscriptSegment>[_segment()]);
    final _RecordingPostCallGateway gateway = _RecordingPostCallGateway();
    final PostCallService service = PostCallService(
      store: store,
      gateway: gateway,
      coachCatalog: const _Catalog(),
    );

    await service.generate(session.id);

    final String context = gateway.lastPreparationMarkdown!;
    expect(context, contains('[PINKALL_BEGIN_UNTRUSTED_USER_CONTEXT]'));
    expect(context, contains('company_name: Pinkall Studio'));
    expect(context, contains('product_name: Pinkall Coach'));
    expect(context, contains('# Pitch V1'));
    expect(context, contains('# Appel'));
    expect(context, isNot(contains('Pitch V2')));
    expect(context, isNot(contains('Studio V2')));
    expect(
      session.toJson().values.join('\n'),
      isNot(contains('Aider les fondateurs')),
    );
  });
}

final class _RecordingPostCallGateway implements PostCallGateway {
  int calls = 0;
  String? lastPreparationMarkdown;

  @override
  bool get isConfigured => true;

  @override
  Future<PostCallDebrief> generate({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required List<CoachRecommendation> improvementCandidates,
    String? preparationMarkdown,
  }) async {
    calls += 1;
    lastPreparationMarkdown = preparationMarkdown;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final CoachRecommendation recommendation = improvementCandidates.single;
    return PostCallDebrief(
      sessionId: sessionId,
      summary: const PostCallGroundedText(
        text: 'Le prospect souhaite être rappelé.',
        evidenceSegmentIds: <String>['segment-1'],
      ),
      keyPoints: const <PostCallGroundedText>[],
      commitments: const <PostCallCommitment>[],
      followUp: const PostCallFollowUp(
        subject: 'Notre échange',
        body: 'Je vous rappelle mardi.',
        nextAction: 'Rappeler mardi',
        dueAt: null,
        evidenceSegmentIds: <String>['segment-1'],
      ),
      improvement: PostCallImprovement(
        recommendationId: recommendation.id,
        text: recommendation.message,
        rationale: 'Le créneau reste à confirmer.',
        evidenceSegmentIds: const <String>['segment-1'],
        sources: recommendation.sources,
        confidence: 0.9,
      ),
      generatedAt: DateTime.utc(2026, 7, 11),
      provider: 'test',
      model: 'test-model',
      objections: const <PostCallObjection>[
        PostCallObjection(
          category: PostCallObjectionCategory.price,
          text: 'Le prix est trop élevé.',
          responseAngle: 'Clarifier la perception de valeur.',
          suggestedResponse: 'Quel point rend cet investissement difficile ?',
          evidenceSegmentIds: <String>['segment-1'],
          confidence: 0.9,
        ),
      ],
    );
  }
}

final class _RecordingObjectionSink implements ObjectionLearningSink {
  _RecordingObjectionSink({this.throwOnLearn = false});

  final bool throwOnLearn;
  int calls = 0;
  List<PostCallObjection> lastObjections = const <PostCallObjection>[];

  @override
  Future<ObjectionLearningResult> learn({
    required String sessionId,
    required List<PostCallObjection> objections,
    required List<TranscriptSegment> transcript,
    required DateTime observedAt,
  }) async {
    calls += 1;
    lastObjections = objections;
    if (throwOnLearn) {
      throw StateError('local document unavailable');
    }
    return ObjectionLearningResult(
      detectedCount: objections.length,
      newCount: objections.length,
      updatedCount: 0,
    );
  }
}

final class _SequencedPostCallGateway implements PostCallGateway {
  _SequencedPostCallGateway({this.failures = const <Object>[]});

  final List<Object> failures;
  int calls = 0;

  @override
  bool get isConfigured => true;

  @override
  Future<PostCallDebrief> generate({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required List<CoachRecommendation> improvementCandidates,
    String? preparationMarkdown,
  }) async {
    final int callIndex = calls;
    calls += 1;
    if (callIndex < failures.length) {
      throw failures[callIndex];
    }
    final CoachRecommendation recommendation = improvementCandidates.single;
    return PostCallDebrief(
      sessionId: sessionId,
      summary: const PostCallGroundedText(
        text: 'Le prospect souhaite être rappelé.',
        evidenceSegmentIds: <String>['segment-1'],
      ),
      keyPoints: const <PostCallGroundedText>[],
      commitments: const <PostCallCommitment>[],
      followUp: const PostCallFollowUp(
        subject: 'Notre échange',
        body: 'Je vous rappelle mardi.',
        nextAction: 'Rappeler mardi',
        dueAt: null,
        evidenceSegmentIds: <String>['segment-1'],
      ),
      improvement: PostCallImprovement(
        recommendationId: recommendation.id,
        text: recommendation.message,
        rationale: 'Le créneau reste à confirmer.',
        evidenceSegmentIds: const <String>['segment-1'],
        sources: recommendation.sources,
        confidence: 0.9,
      ),
      generatedAt: DateTime.utc(2026, 7, 14),
      provider: 'test',
      model: 'test-model',
    );
  }
}

final class _Catalog implements CoachCatalog {
  const _Catalog();

  @override
  bool get allowsUnreviewedRecommendations => false;

  @override
  List<CoachRecommendation> candidatesFor({
    required CoachMode mode,
    required String latestText,
  }) => const <CoachRecommendation>[_recommendation];

  @override
  int get defaultExpirySeconds => 60;

  @override
  Duration get globalCooldown => Duration.zero;

  @override
  bool get isAvailable => true;

  @override
  int get maxSuggestionsPerMinute => 1;

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

TranscriptSegment _segment() => TranscriptSegment(
  id: 'segment-1',
  track: MediaTrack.inbound,
  speaker: SpeakerRole.prospect,
  text: 'Rappelez-moi mardi.',
  startSeconds: 0,
  endSeconds: 1,
  isFinal: true,
  provider: 'test',
  createdAt: DateTime.utc(2026, 7, 11),
);

CallSessionSnapshot _sessionWithTranscript(
  InMemoryPocStore store,
  String suffix,
) {
  final CallSessionSnapshot session = store.createSession(
    callId: 'call-$suffix',
    destinationNumber: '+33102030405',
    contactId: null,
    coachMode: CoachMode.off,
    sellerTrack: MediaTrack.outbound,
  );
  store.replaceFinalTranscript(session.id, <TranscriptSegment>[_segment()]);
  return session;
}

Future<void> _waitFor(bool Function() predicate) async {
  final Stopwatch timeout = Stopwatch()..start();
  while (!predicate()) {
    if (timeout.elapsed > const Duration(seconds: 2)) {
      fail('Timed out waiting for the background post-call job.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}

const CoachRecommendation _recommendation = CoachRecommendation(
  id: 'rec-1',
  status: 'live',
  message: 'Confirmer un créneau précis.',
  sourceIds: <String>['source-1'],
  sources: <CoachSource>[
    CoachSource(
      id: 'source-1',
      title: 'Study',
      evidenceLevel: 'experimental',
      author: null,
      url: null,
      locator: 'p. 1',
    ),
  ],
  triggers: <String>['next step'],
  raw: <String, Object?>{},
);
