import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Coaching progression contract', () {
    test('parses snake-case history and maps metrics and radar enums', () {
      final CoachingProgressRemoteModel remote =
          CoachingProgressRemoteModel.fromJson(_progressPayload());

      expect(remote.recentCalls.single.callId, 'call-42');
      expect(remote.recentCalls.single.sessionId, 'session-42');
      expect(remote.observedMetrics.sellerTalkRatio.current, 0.42);

      final CoachingProgressEntity entity = remote.toEntity();
      expect(entity.rubricVersion, 'performance-v1');
      expect(entity.axes.single.axis, CallPerformanceAxis.discovery);
      expect(entity.axes.single.signal, CallPerformanceSignal.tooLow);
      expect(entity.axes.single.currentScore, 61);
      expect(entity.observedMetrics.questionsPerMinute.delta, 0.4);
      expect(entity.recentCalls.single.callId, 'call-42');
      expect(
        entity.recentCalls.single.performanceAxes.single.axis,
        CallPerformanceAxis.naturalness,
      );
      expect(
        entity.recentCalls.single.performanceAxes.single.signal,
        CallPerformanceSignal.tooHigh,
      );
      expect(entity.recentCalls.single.observedMetrics?.questionCount, 7);
      expect(entity.focus?.axis, CallPerformanceAxis.discovery);
      expect(entity.strength?.axis, CallPerformanceAxis.clarity);
    });

    test('requests the progress endpoint with window and limit', () async {
      final _ProgressHttpClient httpClient = _ProgressHttpClient();
      final ConversationSessionRepositoryImpl repository =
          ConversationSessionRepositoryImpl(
            remoteDataSource: ConversationSessionRemoteDataSourceImpl(
              httpClient: httpClient,
              realtimeClient: const _UnusedRealtimeClient(),
            ),
          );

      final CoachingProgressEntity progress = await repository
          .getCoachingProgress(
            const GetCoachingProgressParam(windowSize: 7, recentLimit: 30),
          );

      expect(httpClient.lastGetPath, '/v1/coaching/progress?window=7&limit=30');
      expect(progress.analyzedCallCount, 9);
      expect(progress.recentCalls.single.callId, 'call-42');
    });
  });
}

Map<String, dynamic> _progressPayload() => <String, dynamic>{
  'generated_at': '2026-07-14T09:30:00.000Z',
  'session_count': 12,
  'analyzed_call_count': 9,
  'current_window_size': 5,
  'previous_window_size': 4,
  'has_comparison': true,
  'rubric_version': 'performance-v1',
  'axes': <Map<String, dynamic>>[
    _aggregateAxis(
      axis: 'discovery',
      currentScore: 61,
      previousScore: 55,
      delta: 6,
      signal: 'too_low',
      observation: 'Les questions restent encore trop fermées.',
    ),
  ],
  'observed_metrics': <String, dynamic>{
    'seller_talk_ratio': _metric(current: 0.42, previous: 0.48, delta: -0.06),
    'question_count': _metric(current: 6, previous: 4, delta: 2),
    'average_seller_turn_seconds': _metric(
      current: 18.2,
      previous: 22.4,
      delta: -4.2,
    ),
    'longest_seller_turn_seconds': _metric(
      current: 41.0,
      previous: 58.5,
      delta: -17.5,
    ),
    'hesitation_count': _metric(current: 2, previous: 3, delta: -1),
    'questions_per_minute': _metric(current: 2.1, previous: 1.7, delta: 0.4),
    'hesitations_per_minute': _metric(current: 0.7, previous: 1.2, delta: -0.5),
  },
  'recent_calls': <Map<String, dynamic>>[
    <String, dynamic>{
      'call_id': 'call-42',
      'session_id': 'session-42',
      'occurred_at': '2026-07-14T09:00:00.000Z',
      'destination_number': '+33601020304',
      'outcome': 'meeting_booked',
      'performance_axes': <Map<String, dynamic>>[
        <String, dynamic>{
          'axis': 'naturalness',
          'score': 68,
          'signal': 'too_high',
          'observation': 'Le registre devient parfois trop familier.',
          'evidence_segment_ids': <String>['segment-7'],
        },
      ],
      'observed_metrics': <String, dynamic>{
        'seller_talk_ratio': 0.44,
        'question_count': 7,
        'average_seller_turn_seconds': 16.5,
        'longest_seller_turn_seconds': 38.0,
        'hesitation_count': 1,
        'questions_per_minute': 2.4,
        'hesitations_per_minute': 0.3,
      },
    },
  ],
  'focus': _aggregateAxis(
    axis: 'discovery',
    currentScore: 61,
    previousScore: 55,
    delta: 6,
    signal: 'too_low',
    observation: 'Les questions restent encore trop fermées.',
  ),
  'strength': _aggregateAxis(
    axis: 'clarity',
    currentScore: 82,
    previousScore: 75,
    delta: 7,
    signal: 'balanced',
    observation: 'Le message est structuré et facile à suivre.',
  ),
  'scope': 'single_poc_workspace_from_bearer',
  'storage': 'postgres_snapshot_poc',
  'version': 1,
};

Map<String, dynamic> _aggregateAxis({
  required String axis,
  required int currentScore,
  required int previousScore,
  required int delta,
  required String signal,
  required String observation,
}) => <String, dynamic>{
  'axis': axis,
  'current_score': currentScore,
  'previous_score': previousScore,
  'delta': delta,
  'signal': signal,
  'observation': observation,
  'sample_count': 5,
};

Map<String, dynamic> _metric({
  required num current,
  required num previous,
  required num delta,
}) => <String, dynamic>{
  'current': current,
  'previous': previous,
  'delta': delta,
  'sample_count': 5,
};

final class _ProgressHttpClient implements PinkallHttpClient {
  String? lastGetPath;

  @override
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    lastGetPath = path;
    return _progressPayload();
  }

  @override
  Future<Map<String, dynamic>> patchJson(
    String path, {
    Map<String, dynamic>? body,
  }) => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
  }) => throw UnimplementedError();
}

final class _UnusedRealtimeClient implements PinkallRealtimeClient {
  const _UnusedRealtimeClient();

  @override
  Stream<Map<String, dynamic>> watchJson(String path) =>
      const Stream<Map<String, dynamic>>.empty();
}
