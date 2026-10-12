// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coaching_progress.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoachingProgressMetricRemoteModel _$CoachingProgressMetricRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CoachingProgressMetricRemoteModel(
  current: (json['current'] as num?)?.toDouble(),
  previous: (json['previous'] as num?)?.toDouble(),
  delta: (json['delta'] as num?)?.toDouble(),
  sampleCount: (json['sample_count'] as num).toInt(),
);

Map<String, dynamic> _$CoachingProgressMetricRemoteModelToJson(
  _CoachingProgressMetricRemoteModel instance,
) => <String, dynamic>{
  'current': instance.current,
  'previous': instance.previous,
  'delta': instance.delta,
  'sample_count': instance.sampleCount,
};

_CallObservedMetricsRemoteModel _$CallObservedMetricsRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CallObservedMetricsRemoteModel(
  sellerTalkRatio: (json['seller_talk_ratio'] as num).toDouble(),
  questionCount: (json['question_count'] as num).toInt(),
  averageSellerTurnSeconds: (json['average_seller_turn_seconds'] as num)
      .toDouble(),
  longestSellerTurnSeconds: (json['longest_seller_turn_seconds'] as num)
      .toDouble(),
  hesitationCount: (json['hesitation_count'] as num).toInt(),
  questionsPerMinute: (json['questions_per_minute'] as num).toDouble(),
  hesitationsPerMinute: (json['hesitations_per_minute'] as num).toDouble(),
);

Map<String, dynamic> _$CallObservedMetricsRemoteModelToJson(
  _CallObservedMetricsRemoteModel instance,
) => <String, dynamic>{
  'seller_talk_ratio': instance.sellerTalkRatio,
  'question_count': instance.questionCount,
  'average_seller_turn_seconds': instance.averageSellerTurnSeconds,
  'longest_seller_turn_seconds': instance.longestSellerTurnSeconds,
  'hesitation_count': instance.hesitationCount,
  'questions_per_minute': instance.questionsPerMinute,
  'hesitations_per_minute': instance.hesitationsPerMinute,
};

_CoachingProgressMetricsRemoteModel
_$CoachingProgressMetricsRemoteModelFromJson(Map<String, dynamic> json) =>
    _CoachingProgressMetricsRemoteModel(
      sellerTalkRatio: CoachingProgressMetricRemoteModel.fromJson(
        json['seller_talk_ratio'] as Map<String, dynamic>,
      ),
      questionCount: CoachingProgressMetricRemoteModel.fromJson(
        json['question_count'] as Map<String, dynamic>,
      ),
      averageSellerTurnSeconds: CoachingProgressMetricRemoteModel.fromJson(
        json['average_seller_turn_seconds'] as Map<String, dynamic>,
      ),
      longestSellerTurnSeconds: CoachingProgressMetricRemoteModel.fromJson(
        json['longest_seller_turn_seconds'] as Map<String, dynamic>,
      ),
      hesitationCount: CoachingProgressMetricRemoteModel.fromJson(
        json['hesitation_count'] as Map<String, dynamic>,
      ),
      questionsPerMinute: CoachingProgressMetricRemoteModel.fromJson(
        json['questions_per_minute'] as Map<String, dynamic>,
      ),
      hesitationsPerMinute: CoachingProgressMetricRemoteModel.fromJson(
        json['hesitations_per_minute'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CoachingProgressMetricsRemoteModelToJson(
  _CoachingProgressMetricsRemoteModel instance,
) => <String, dynamic>{
  'seller_talk_ratio': instance.sellerTalkRatio.toJson(),
  'question_count': instance.questionCount.toJson(),
  'average_seller_turn_seconds': instance.averageSellerTurnSeconds.toJson(),
  'longest_seller_turn_seconds': instance.longestSellerTurnSeconds.toJson(),
  'hesitation_count': instance.hesitationCount.toJson(),
  'questions_per_minute': instance.questionsPerMinute.toJson(),
  'hesitations_per_minute': instance.hesitationsPerMinute.toJson(),
};

_CoachingProgressAxisRemoteModel _$CoachingProgressAxisRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CoachingProgressAxisRemoteModel(
  axis: json['axis'] as String,
  currentScore: (json['current_score'] as num).toInt(),
  previousScore: (json['previous_score'] as num?)?.toInt(),
  delta: (json['delta'] as num?)?.toInt(),
  signal: json['signal'] as String,
  observation: json['observation'] as String,
  sampleCount: (json['sample_count'] as num).toInt(),
);

Map<String, dynamic> _$CoachingProgressAxisRemoteModelToJson(
  _CoachingProgressAxisRemoteModel instance,
) => <String, dynamic>{
  'axis': instance.axis,
  'current_score': instance.currentScore,
  'previous_score': instance.previousScore,
  'delta': instance.delta,
  'signal': instance.signal,
  'observation': instance.observation,
  'sample_count': instance.sampleCount,
};

_CoachingProgressCallRemoteModel _$CoachingProgressCallRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CoachingProgressCallRemoteModel(
  callId: json['call_id'] as String,
  sessionId: json['session_id'] as String,
  occurredAt: DateTime.parse(json['occurred_at'] as String),
  destinationNumber: json['destination_number'] as String,
  performanceAxes: (json['performance_axes'] as List<dynamic>)
      .map(
        (e) =>
            CallPerformanceAxisRemoteModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  outcome: json['outcome'] as String?,
  observedMetrics: json['observed_metrics'] == null
      ? null
      : CallObservedMetricsRemoteModel.fromJson(
          json['observed_metrics'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CoachingProgressCallRemoteModelToJson(
  _CoachingProgressCallRemoteModel instance,
) => <String, dynamic>{
  'call_id': instance.callId,
  'session_id': instance.sessionId,
  'occurred_at': instance.occurredAt.toIso8601String(),
  'destination_number': instance.destinationNumber,
  'performance_axes': instance.performanceAxes.map((e) => e.toJson()).toList(),
  'outcome': instance.outcome,
  'observed_metrics': instance.observedMetrics?.toJson(),
};

_CoachingProgressRemoteModel _$CoachingProgressRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CoachingProgressRemoteModel(
  generatedAt: DateTime.parse(json['generated_at'] as String),
  sessionCount: (json['session_count'] as num).toInt(),
  analyzedCallCount: (json['analyzed_call_count'] as num).toInt(),
  currentWindowSize: (json['current_window_size'] as num).toInt(),
  previousWindowSize: (json['previous_window_size'] as num).toInt(),
  hasComparison: json['has_comparison'] as bool,
  rubricVersion: json['rubric_version'] as String,
  axes: (json['axes'] as List<dynamic>)
      .map(
        (e) =>
            CoachingProgressAxisRemoteModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  observedMetrics: CoachingProgressMetricsRemoteModel.fromJson(
    json['observed_metrics'] as Map<String, dynamic>,
  ),
  recentCalls: (json['recent_calls'] as List<dynamic>)
      .map(
        (e) =>
            CoachingProgressCallRemoteModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  focus: json['focus'] == null
      ? null
      : CoachingProgressAxisRemoteModel.fromJson(
          json['focus'] as Map<String, dynamic>,
        ),
  strength: json['strength'] == null
      ? null
      : CoachingProgressAxisRemoteModel.fromJson(
          json['strength'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CoachingProgressRemoteModelToJson(
  _CoachingProgressRemoteModel instance,
) => <String, dynamic>{
  'generated_at': instance.generatedAt.toIso8601String(),
  'session_count': instance.sessionCount,
  'analyzed_call_count': instance.analyzedCallCount,
  'current_window_size': instance.currentWindowSize,
  'previous_window_size': instance.previousWindowSize,
  'has_comparison': instance.hasComparison,
  'rubric_version': instance.rubricVersion,
  'axes': instance.axes.map((e) => e.toJson()).toList(),
  'observed_metrics': instance.observedMetrics.toJson(),
  'recent_calls': instance.recentCalls.map((e) => e.toJson()).toList(),
  'focus': instance.focus?.toJson(),
  'strength': instance.strength?.toJson(),
};
