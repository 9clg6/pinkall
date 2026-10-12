import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/transcript_metrics.dart';

/// One metric compared between the current and previous call windows.
final class CoachingProgressMetric {
  const CoachingProgressMetric({
    required this.current,
    required this.previous,
    required this.delta,
    required this.sampleCount,
  });

  final double? current;
  final double? previous;
  final double? delta;
  final int sampleCount;

  Map<String, Object?> toJson() => <String, Object?>{
    'current': current,
    'previous': previous,
    'delta': delta,
    'sample_count': sampleCount,
  };
}

/// Aggregated performance for one stable radar axis.
final class CoachingProgressAxis {
  const CoachingProgressAxis({
    required this.axis,
    required this.currentScore,
    required this.previousScore,
    required this.delta,
    required this.signal,
    required this.observation,
    required this.sampleCount,
  });

  final PostCallPerformanceAxisName axis;
  final int currentScore;
  final int? previousScore;
  final int? delta;
  final PostCallPerformanceSignal signal;
  final String observation;
  final int sampleCount;

  Map<String, Object?> toJson() => <String, Object?>{
    'axis': axis.name,
    'current_score': currentScore,
    'previous_score': previousScore,
    'delta': delta,
    'signal': signal.wireName,
    'observation': observation,
    'sample_count': sampleCount,
  };
}

/// One analyzed call used by the historical trend visualization.
final class CoachingProgressCall {
  const CoachingProgressCall({
    required this.sessionId,
    required this.callId,
    required this.occurredAt,
    required this.destinationNumber,
    required this.outcome,
    required this.performanceAxes,
    required this.observedMetrics,
  });

  final String sessionId;
  final String callId;
  final DateTime occurredAt;
  final String destinationNumber;
  final String? outcome;
  final List<PostCallPerformanceAxis> performanceAxes;
  final TranscriptMetrics? observedMetrics;

  Map<String, Object?> toJson() => <String, Object?>{
    'session_id': sessionId,
    'call_id': callId,
    'occurred_at': occurredAt.toUtc().toIso8601String(),
    'destination_number': destinationNumber,
    'outcome': outcome,
    'performance_axes': performanceAxes
        .map((PostCallPerformanceAxis axis) => axis.toJson())
        .toList(growable: false),
    'observed_metrics': observedMetrics?.toJson(),
  };
}

/// Longitudinal coaching profile for the authenticated Pinkall workspace.
final class CoachingProgressSnapshot {
  const CoachingProgressSnapshot({
    required this.generatedAt,
    required this.sessionCount,
    required this.analyzedCallCount,
    required this.currentWindowSize,
    required this.previousWindowSize,
    required this.axes,
    required this.observedMetrics,
    required this.recentCalls,
    required this.focus,
    required this.strength,
  });

  final DateTime generatedAt;
  final int sessionCount;
  final int analyzedCallCount;
  final int currentWindowSize;
  final int previousWindowSize;
  final List<CoachingProgressAxis> axes;
  final Map<String, CoachingProgressMetric> observedMetrics;
  final List<CoachingProgressCall> recentCalls;
  final CoachingProgressAxis? focus;
  final CoachingProgressAxis? strength;

  Map<String, Object?> toJson() => <String, Object?>{
    'generated_at': generatedAt.toUtc().toIso8601String(),
    'session_count': sessionCount,
    'analyzed_call_count': analyzedCallCount,
    'current_window_size': currentWindowSize,
    'previous_window_size': previousWindowSize,
    'has_comparison': previousWindowSize > 0,
    'axes': axes
        .map((CoachingProgressAxis axis) => axis.toJson())
        .toList(growable: false),
    'observed_metrics': observedMetrics.map(
      (String key, CoachingProgressMetric value) =>
          MapEntry<String, Object?>(key, value.toJson()),
    ),
    'recent_calls': recentCalls
        .map((CoachingProgressCall call) => call.toJson())
        .toList(growable: false),
    'focus': focus?.toJson(),
    'strength': strength?.toJson(),
    'version': 1,
  };
}
