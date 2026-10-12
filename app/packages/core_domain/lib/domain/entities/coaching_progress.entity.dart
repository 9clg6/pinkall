import 'package:core_domain/domain/entities/call_debrief.entity.dart';
import 'package:core_domain/domain/enum/call_performance_axis.enum.dart';
import 'package:core_domain/domain/enum/call_performance_signal.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coaching_progress.entity.freezed.dart';

/// One factual metric compared between two call windows.
@freezed
abstract class CoachingProgressMetricEntity
    with _$CoachingProgressMetricEntity {
  /// Creates a metric comparison.
  const factory CoachingProgressMetricEntity({
    required double? current,
    required double? previous,
    required double? delta,
    required int sampleCount,
  }) = _CoachingProgressMetricEntity;
}

/// Deterministic measurements for one individual call.
@freezed
abstract class CallObservedMetricsEntity with _$CallObservedMetricsEntity {
  /// Creates factual transcript measurements.
  const factory CallObservedMetricsEntity({
    required double sellerTalkRatio,
    required int questionCount,
    required double averageSellerTurnSeconds,
    required double longestSellerTurnSeconds,
    required int hesitationCount,
    required double questionsPerMinute,
    required double hesitationsPerMinute,
  }) = _CallObservedMetricsEntity;
}

/// All factual metrics aggregated for the selected call window.
@freezed
abstract class CoachingProgressMetricsEntity
    with _$CoachingProgressMetricsEntity {
  /// Creates the complete metric comparison set.
  const factory CoachingProgressMetricsEntity({
    required CoachingProgressMetricEntity sellerTalkRatio,
    required CoachingProgressMetricEntity questionCount,
    required CoachingProgressMetricEntity averageSellerTurnSeconds,
    required CoachingProgressMetricEntity longestSellerTurnSeconds,
    required CoachingProgressMetricEntity hesitationCount,
    required CoachingProgressMetricEntity questionsPerMinute,
    required CoachingProgressMetricEntity hesitationsPerMinute,
  }) = _CoachingProgressMetricsEntity;
}

/// One radar dimension aggregated over the selected recent calls.
@freezed
abstract class CoachingProgressAxisEntity with _$CoachingProgressAxisEntity {
  /// Creates one longitudinal radar axis.
  const factory CoachingProgressAxisEntity({
    required CallPerformanceAxis axis,
    required int currentScore,
    required int? previousScore,
    required int? delta,
    required CallPerformanceSignal signal,
    required String observation,
    required int sampleCount,
  }) = _CoachingProgressAxisEntity;
}

/// One call point displayed in the historical progression timeline.
@freezed
abstract class CoachingProgressCallEntity with _$CoachingProgressCallEntity {
  /// Creates one historical analyzed call.
  const factory CoachingProgressCallEntity({
    required String callId,
    required String sessionId,
    required DateTime occurredAt,
    required String destinationNumber,
    required List<CallPerformanceAxisEntity> performanceAxes,
    String? outcome,
    CallObservedMetricsEntity? observedMetrics,
  }) = _CoachingProgressCallEntity;
}

/// Workspace-level coaching history without an artificial global score.
@freezed
abstract class CoachingProgressEntity with _$CoachingProgressEntity {
  /// Creates the complete historical coaching profile.
  const factory CoachingProgressEntity({
    required DateTime generatedAt,
    required int sessionCount,
    required int analyzedCallCount,
    required int currentWindowSize,
    required int previousWindowSize,
    required bool hasComparison,
    required String rubricVersion,
    required List<CoachingProgressAxisEntity> axes,
    required CoachingProgressMetricsEntity observedMetrics,
    required List<CoachingProgressCallEntity> recentCalls,
    CoachingProgressAxisEntity? focus,
    CoachingProgressAxisEntity? strength,
  }) = _CoachingProgressEntity;
}
