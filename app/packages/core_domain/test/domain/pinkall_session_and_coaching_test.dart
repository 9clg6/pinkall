import 'package:core_domain/core_domain.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:test/test.dart';

void main() {
  group('Pinkall session contracts', () {
    test('session parameters use the backend snake-case contract', () {
      const CreateConversationSessionParam params =
          CreateConversationSessionParam(
            callId: 'call-42',
            destinationNumber: '+33102030405',
            coachModeOverride: CoachMode.live,
            preparationMarkdown:
                '# Objectif\nObtenir un rendez-vous de découverte.',
            context: <String, String>{'offer': 'Pinkall'},
          );

      expect(params.toJson(), <String, dynamic>{
        'call_id': 'call-42',
        'destination_number': '+33102030405',
        'contact_id': null,
        'coach_mode_override': 'live',
        'locale': null,
        'preparation_markdown':
            '# Objectif\nObtenir un rendez-vous de découverte.',
        'context': <String, String>{'offer': 'Pinkall'},
      });
    });

    test('contact imports serialize normalized nested rows', () {
      const ImportContactsParam params = ImportContactsParam(
        sourceName: 'prospects.csv',
        rows: <ContactImportRowParam>[
          ContactImportRowParam(
            phoneNumber: '+33601020304',
            market: ContactMarket.b2b,
            professionalRelevanceConfirmed: true,
          ),
        ],
      );

      final Map<String, dynamic> json = params.toJson();
      expect(json['source_name'], 'prospects.csv');
      expect(
        (json['rows'] as List<dynamic>).single,
        containsPair('market', 'b2b'),
      );
      expect(
        (json['rows'] as List<dynamic>).single,
        containsPair('professional_relevance_confirmed', true),
      );
    });

    test('coaching suggestions expire at their explicit deadline', () {
      final DateTime deadline = DateTime.utc(2026, 7, 11, 10);
      final CoachingSuggestionEntity suggestion = CoachingSuggestionEntity(
        id: 'suggestion-1',
        sessionId: 'session-1',
        kind: CoachingSuggestionKind.nextQuestion,
        text: 'Quel impact cela a-t-il aujourd’hui ?',
        rationale: 'Clarifies the cost of the current situation.',
        sources: const <CoachingSourceEntity>[],
        confidence: 0.92,
        createdAt: deadline.subtract(const Duration(seconds: 10)),
        expiresAt: deadline,
      );

      expect(
        suggestion.isExpiredAt(
          deadline.subtract(const Duration(microseconds: 1)),
        ),
        isFalse,
      );
      expect(suggestion.isExpiredAt(deadline), isTrue);
    });

    test(
      'consent use case delegates the explicit notice acknowledgement',
      () async {
        final _FakeConversationSessionRepository repository =
            _FakeConversationSessionRepository();
        final RecordTranscriptionConsentUseCase useCase =
            RecordTranscriptionConsentUseCase(
              conversationSessionRepository: repository,
            );
        final DateTime acknowledgedAt = DateTime.utc(2026, 7, 11, 10);
        final RecordTranscriptionConsentParam params =
            RecordTranscriptionConsentParam(
              sessionId: 'session-1',
              acknowledged: true,
              method: TranscriptionConsentMethod.automatedNotice,
              acknowledgedAt: acknowledgedAt,
            );

        final ResultState<TranscriptionConsentEntity> result = await useCase
            .execute(params);

        expect(result, isA<ResultSuccess<TranscriptionConsentEntity>>());
        expect(repository.recordedConsent, params);
        expect(
          (result as ResultSuccess<TranscriptionConsentEntity>)
              .data
              .acknowledged,
          isTrue,
        );
      },
    );

    test('active sessions expose calls started on another device', () async {
      final _FakeConversationSessionRepository repository =
          _FakeConversationSessionRepository();
      repository.activeSessions = <ConversationSessionEntity>[
        ConversationSessionEntity(
          id: 'session-mobile',
          callId: 'call-mobile',
          status: ConversationSessionStatus.active,
          coachMode: CoachMode.off,
          createdAt: DateTime.utc(2026, 7, 11, 10),
        ),
      ];

      final ResultState<List<ConversationSessionEntity>> result =
          await ListActiveConversationSessionsUseCase(
            conversationSessionRepository: repository,
          ).execute();

      expect(result, isA<ResultSuccess<List<ConversationSessionEntity>>>());
      expect(
        (result as ResultSuccess<List<ConversationSessionEntity>>)
            .data
            .single
            .id,
        'session-mobile',
      );
    });

    test('cancel use case delegates the session identifier', () async {
      final _FakeConversationSessionRepository repository =
          _FakeConversationSessionRepository();
      final ResultState<ConversationSessionEntity> result =
          await CancelConversationSessionUseCase(
            conversationSessionRepository: repository,
          ).execute(const SessionActionParam(sessionId: 'session-cancel'));

      expect(result, isA<ResultSuccess<ConversationSessionEntity>>());
      expect(repository.cancelledSessionId, 'session-cancel');
      expect(
        (result as ResultSuccess<ConversationSessionEntity>).data.status,
        ConversationSessionStatus.failed,
      );
    });

    test('progress parameters keep explicit window and history limits', () {
      const GetCoachingProgressParam params = GetCoachingProgressParam(
        windowSize: 7,
        recentLimit: 30,
      );

      expect(params.toJson(), <String, dynamic>{
        'window_size': 7,
        'recent_limit': 30,
      });
      expect(const GetCoachingProgressParam().windowSize, 5);
      expect(const GetCoachingProgressParam().recentLimit, 20);
    });

    test('progress use case delegates the complete request', () async {
      final _FakeConversationSessionRepository repository =
          _FakeConversationSessionRepository();
      const GetCoachingProgressParam params = GetCoachingProgressParam(
        windowSize: 4,
        recentLimit: 12,
      );

      final ResultState<CoachingProgressEntity> result =
          await GetCoachingProgressUseCase(
            conversationSessionRepository: repository,
          ).execute(params);

      expect(repository.requestedProgress, params);
      expect(result, isA<ResultSuccess<CoachingProgressEntity>>());
      expect(
        (result as ResultSuccess<CoachingProgressEntity>).data.rubricVersion,
        'performance-v1',
      );
    });
  });
}

final class _FakeConversationSessionRepository
    implements ConversationSessionRepository {
  RecordTranscriptionConsentParam? recordedConsent;
  List<ConversationSessionEntity> activeSessions =
      <ConversationSessionEntity>[];
  String? cancelledSessionId;
  GetCoachingProgressParam? requestedProgress;

  @override
  Future<ConversationSessionEntity> cancelSession(String sessionId) async {
    cancelledSessionId = sessionId;
    return ConversationSessionEntity(
      id: sessionId,
      callId: 'call-cancel',
      status: ConversationSessionStatus.failed,
      coachMode: CoachMode.off,
      createdAt: DateTime.utc(2026, 7, 11, 10),
      endedAt: DateTime.utc(2026, 7, 11, 10, 1),
    );
  }

  @override
  Future<ConversationSessionEntity> createSession(
    CreateConversationSessionParam params,
  ) => throw UnimplementedError();

  @override
  Future<ExternalConversationSessionEntity> createExternalSession(
    CreateExternalConversationSessionParam params,
  ) => throw UnimplementedError();

  @override
  Future<ConversationSessionEntity> finalizeSession(String sessionId) =>
      throw UnimplementedError();

  @override
  Future<ConversationTranscriptEntity> getFinalTranscript(String sessionId) =>
      throw UnimplementedError();

  @override
  Future<CallDebriefEntity> getDebrief(String sessionId) =>
      throw UnimplementedError();

  @override
  Future<CoachingProgressEntity> getCoachingProgress(
    GetCoachingProgressParam params,
  ) async {
    requestedProgress = params;
    return _emptyProgress();
  }

  @override
  Future<ConversationSessionEntity> getSession(String sessionId) =>
      throw UnimplementedError();

  @override
  Future<List<ConversationSessionEntity>> listActiveSessions() async =>
      activeSessions;

  @override
  Future<List<ConversationSessionEntity>> listSessions() async =>
      activeSessions;

  @override
  Future<TranscriptionConsentEntity> recordTranscriptionConsent(
    RecordTranscriptionConsentParam params,
  ) async {
    recordedConsent = params;
    return TranscriptionConsentEntity(
      sessionId: params.sessionId,
      acknowledged: params.acknowledged,
      method: params.method,
      acknowledgedAt: params.acknowledgedAt,
    );
  }

  @override
  Future<ConversationSessionEntity> updateCoachMode(
    UpdateSessionCoachModeParam params,
  ) => throw UnimplementedError();

  @override
  Stream<SessionRealtimeEventEntity> watchSessionEvents(String sessionId) =>
      throw UnimplementedError();
}

CoachingProgressEntity _emptyProgress() {
  const CoachingProgressMetricEntity metric = CoachingProgressMetricEntity(
    current: null,
    previous: null,
    delta: null,
    sampleCount: 0,
  );
  return CoachingProgressEntity(
    generatedAt: DateTime.utc(2026, 7, 14, 10),
    sessionCount: 0,
    analyzedCallCount: 0,
    currentWindowSize: 0,
    previousWindowSize: 0,
    hasComparison: false,
    rubricVersion: 'performance-v1',
    axes: const <CoachingProgressAxisEntity>[],
    observedMetrics: const CoachingProgressMetricsEntity(
      sellerTalkRatio: metric,
      questionCount: metric,
      averageSellerTurnSeconds: metric,
      longestSellerTurnSeconds: metric,
      hesitationCount: metric,
      questionsPerMinute: metric,
      hesitationsPerMinute: metric,
    ),
    recentCalls: const <CoachingProgressCallEntity>[],
  );
}
