import 'package:core_data/mappers/call_debrief.mapper.dart';
import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/call_debrief.remote.model.dart';
import 'package:core_data/model/remote/coaching_progress.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Domain mapping for one deterministic metric comparison.
extension CoachingProgressMetricRemoteModelX
    on CoachingProgressMetricRemoteModel {
  /// Converts this API model to a domain entity.
  CoachingProgressMetricEntity toEntity() => CoachingProgressMetricEntity(
    current: current,
    previous: previous,
    delta: delta,
    sampleCount: sampleCount,
  );
}

/// Domain mapping for factual measurements from one call.
extension CallObservedMetricsRemoteModelX on CallObservedMetricsRemoteModel {
  /// Converts this API model to a domain entity.
  CallObservedMetricsEntity toEntity() => CallObservedMetricsEntity(
    sellerTalkRatio: sellerTalkRatio,
    questionCount: questionCount,
    averageSellerTurnSeconds: averageSellerTurnSeconds,
    longestSellerTurnSeconds: longestSellerTurnSeconds,
    hesitationCount: hesitationCount,
    questionsPerMinute: questionsPerMinute,
    hesitationsPerMinute: hesitationsPerMinute,
  );
}

/// Domain mapping for the aggregate factual metric set.
extension CoachingProgressMetricsRemoteModelX
    on CoachingProgressMetricsRemoteModel {
  /// Converts this API model to a domain entity.
  CoachingProgressMetricsEntity toEntity() => CoachingProgressMetricsEntity(
    sellerTalkRatio: sellerTalkRatio.toEntity(),
    questionCount: questionCount.toEntity(),
    averageSellerTurnSeconds: averageSellerTurnSeconds.toEntity(),
    longestSellerTurnSeconds: longestSellerTurnSeconds.toEntity(),
    hesitationCount: hesitationCount.toEntity(),
    questionsPerMinute: questionsPerMinute.toEntity(),
    hesitationsPerMinute: hesitationsPerMinute.toEntity(),
  );
}

/// Domain mapping for one aggregate radar dimension.
extension CoachingProgressAxisRemoteModelX on CoachingProgressAxisRemoteModel {
  /// Converts this API model to a domain entity.
  CoachingProgressAxisEntity toEntity() => CoachingProgressAxisEntity(
    axis: enumFromWireName<CallPerformanceAxis>(
      CallPerformanceAxis.values,
      axis,
    ),
    currentScore: currentScore,
    previousScore: previousScore,
    delta: delta,
    signal: enumFromWireName<CallPerformanceSignal>(
      CallPerformanceSignal.values,
      signal,
    ),
    observation: observation,
    sampleCount: sampleCount,
  );
}

/// Domain mapping for one historical call point.
extension CoachingProgressCallRemoteModelX on CoachingProgressCallRemoteModel {
  /// Converts this API model to a domain entity.
  CoachingProgressCallEntity toEntity() => CoachingProgressCallEntity(
    callId: callId,
    sessionId: sessionId,
    occurredAt: occurredAt,
    destinationNumber: destinationNumber,
    outcome: outcome,
    performanceAxes: performanceAxes
        .map((CallPerformanceAxisRemoteModel item) => item.toEntity())
        .toList(growable: false),
    observedMetrics: observedMetrics?.toEntity(),
  );
}

/// Domain mapping for the complete historical coaching profile.
extension CoachingProgressRemoteModelX on CoachingProgressRemoteModel {
  /// Converts this API model to a domain entity.
  CoachingProgressEntity toEntity() => CoachingProgressEntity(
    generatedAt: generatedAt,
    sessionCount: sessionCount,
    analyzedCallCount: analyzedCallCount,
    currentWindowSize: currentWindowSize,
    previousWindowSize: previousWindowSize,
    hasComparison: hasComparison,
    rubricVersion: rubricVersion,
    axes: axes
        .map((CoachingProgressAxisRemoteModel item) => item.toEntity())
        .toList(growable: false),
    observedMetrics: observedMetrics.toEntity(),
    recentCalls: recentCalls
        .map((CoachingProgressCallRemoteModel item) => item.toEntity())
        .toList(growable: false),
    focus: focus?.toEntity(),
    strength: strength?.toEntity(),
  );
}
