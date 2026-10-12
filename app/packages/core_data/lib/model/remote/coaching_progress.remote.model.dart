// ignore_for_file: invalid_annotation_target

import 'package:core_data/model/remote/call_debrief.remote.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coaching_progress.remote.model.freezed.dart';
part 'coaching_progress.remote.model.g.dart';

/// Remote comparison for one deterministic metric.
@freezed
abstract class CoachingProgressMetricRemoteModel
    with _$CoachingProgressMetricRemoteModel {
  /// Creates a remote metric comparison.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CoachingProgressMetricRemoteModel({
    required double? current,
    required double? previous,
    required double? delta,
    required int sampleCount,
  }) = _CoachingProgressMetricRemoteModel;

  /// Parses a metric comparison.
  factory CoachingProgressMetricRemoteModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CoachingProgressMetricRemoteModelFromJson(json);
}

/// Remote factual measurements for one call.
@freezed
abstract class CallObservedMetricsRemoteModel
    with _$CallObservedMetricsRemoteModel {
  /// Creates remote factual call metrics.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CallObservedMetricsRemoteModel({
    required double sellerTalkRatio,
    required int questionCount,
    required double averageSellerTurnSeconds,
    required double longestSellerTurnSeconds,
    required int hesitationCount,
    required double questionsPerMinute,
    required double hesitationsPerMinute,
  }) = _CallObservedMetricsRemoteModel;

  /// Parses factual call metrics.
  factory CallObservedMetricsRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CallObservedMetricsRemoteModelFromJson(json);
}

/// Remote collection of all aggregate factual metrics.
@freezed
abstract class CoachingProgressMetricsRemoteModel
    with _$CoachingProgressMetricsRemoteModel {
  /// Creates the aggregate metric set.
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CoachingProgressMetricsRemoteModel({
    required CoachingProgressMetricRemoteModel sellerTalkRatio,
    required CoachingProgressMetricRemoteModel questionCount,
    required CoachingProgressMetricRemoteModel averageSellerTurnSeconds,
    required CoachingProgressMetricRemoteModel longestSellerTurnSeconds,
    required CoachingProgressMetricRemoteModel hesitationCount,
    required CoachingProgressMetricRemoteModel questionsPerMinute,
    required CoachingProgressMetricRemoteModel hesitationsPerMinute,
  }) = _CoachingProgressMetricsRemoteModel;

  /// Parses the aggregate metric set.
  factory CoachingProgressMetricsRemoteModel.fromJson(
    Map<String, dynamic> json,
  ) => _$CoachingProgressMetricsRemoteModelFromJson(json);
}

/// Remote aggregate for one radar axis.
@freezed
abstract class CoachingProgressAxisRemoteModel
    with _$CoachingProgressAxisRemoteModel {
  /// Creates a remote axis aggregate.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CoachingProgressAxisRemoteModel({
    required String axis,
    required int currentScore,
    required int? previousScore,
    required int? delta,
    required String signal,
    required String observation,
    required int sampleCount,
  }) = _CoachingProgressAxisRemoteModel;

  /// Parses an axis aggregate.
  factory CoachingProgressAxisRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CoachingProgressAxisRemoteModelFromJson(json);
}

/// Remote point for one analyzed historical call.
@freezed
abstract class CoachingProgressCallRemoteModel
    with _$CoachingProgressCallRemoteModel {
  /// Creates a remote historical call point.
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CoachingProgressCallRemoteModel({
    required String callId,
    required String sessionId,
    required DateTime occurredAt,
    required String destinationNumber,
    required List<CallPerformanceAxisRemoteModel> performanceAxes,
    String? outcome,
    CallObservedMetricsRemoteModel? observedMetrics,
  }) = _CoachingProgressCallRemoteModel;

  /// Parses a historical call point.
  factory CoachingProgressCallRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CoachingProgressCallRemoteModelFromJson(json);
}

/// Remote workspace-level historical coaching profile.
@freezed
abstract class CoachingProgressRemoteModel with _$CoachingProgressRemoteModel {
  /// Creates a remote coaching profile.
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CoachingProgressRemoteModel({
    required DateTime generatedAt,
    required int sessionCount,
    required int analyzedCallCount,
    required int currentWindowSize,
    required int previousWindowSize,
    required bool hasComparison,
    required String rubricVersion,
    required List<CoachingProgressAxisRemoteModel> axes,
    required CoachingProgressMetricsRemoteModel observedMetrics,
    required List<CoachingProgressCallRemoteModel> recentCalls,
    CoachingProgressAxisRemoteModel? focus,
    CoachingProgressAxisRemoteModel? strength,
  }) = _CoachingProgressRemoteModel;

  /// Parses a complete coaching profile.
  factory CoachingProgressRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CoachingProgressRemoteModelFromJson(json);
}
