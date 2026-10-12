// ignore_for_file: invalid_annotation_target

import 'package:core_data/model/remote/coaching_source.remote.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_debrief.remote.model.freezed.dart';
part 'call_debrief.remote.model.g.dart';

/// JSON model for one transcript-grounded statement.
@freezed
abstract class GroundedCallTextRemoteModel with _$GroundedCallTextRemoteModel {
  /// Creates grounded call text from the API contract.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GroundedCallTextRemoteModel({
    required String text,
    required List<String> evidenceSegmentIds,
  }) = _GroundedCallTextRemoteModel;

  /// Parses grounded call text.
  factory GroundedCallTextRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$GroundedCallTextRemoteModelFromJson(json);
}

/// JSON model for an explicit commitment.
@freezed
abstract class CallCommitmentRemoteModel with _$CallCommitmentRemoteModel {
  /// Creates a remote commitment.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CallCommitmentRemoteModel({
    required String owner,
    required String text,
    required List<String> evidenceSegmentIds,
    DateTime? dueAt,
  }) = _CallCommitmentRemoteModel;

  /// Parses a commitment.
  factory CallCommitmentRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CallCommitmentRemoteModelFromJson(json);
}

/// JSON model for the generated follow-up draft.
@freezed
abstract class CallFollowUpRemoteModel with _$CallFollowUpRemoteModel {
  /// Creates a remote follow-up.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CallFollowUpRemoteModel({
    required String subject,
    required String body,
    required List<String> evidenceSegmentIds,
    String? nextAction,
    DateTime? dueAt,
  }) = _CallFollowUpRemoteModel;

  /// Parses a follow-up.
  factory CallFollowUpRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CallFollowUpRemoteModelFromJson(json);
}

/// JSON model for the single source-backed improvement.
@freezed
abstract class CallImprovementRemoteModel with _$CallImprovementRemoteModel {
  /// Creates a remote improvement.
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CallImprovementRemoteModel({
    required String recommendationId,
    required String text,
    required String rationale,
    required List<String> evidenceSegmentIds,
    required List<CoachingSourceRemoteModel> sources,
    required double confidence,
  }) = _CallImprovementRemoteModel;

  /// Parses an improvement.
  factory CallImprovementRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CallImprovementRemoteModelFromJson(json);
}

/// JSON model for one post-call radar competency.
@freezed
abstract class CallPerformanceAxisRemoteModel
    with _$CallPerformanceAxisRemoteModel {
  /// Creates a remote performance axis.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CallPerformanceAxisRemoteModel({
    required String axis,
    required int score,
    required String signal,
    required String observation,
    required List<String> evidenceSegmentIds,
  }) = _CallPerformanceAxisRemoteModel;

  /// Parses a performance axis.
  factory CallPerformanceAxisRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CallPerformanceAxisRemoteModelFromJson(json);
}

/// JSON model for one phrase-level rewrite.
@freezed
abstract class PhraseCoachingRemoteModel with _$PhraseCoachingRemoteModel {
  /// Creates remote phrase coaching.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory PhraseCoachingRemoteModel({
    required String focus,
    required String originalText,
    required String improvedText,
    required String rationale,
    required List<String> evidenceSegmentIds,
    @Default(<CoachingSourceRemoteModel>[])
    List<CoachingSourceRemoteModel> sources,
    @Default(0) double confidence,
    String? recommendationId,
  }) = _PhraseCoachingRemoteModel;

  /// Parses phrase coaching.
  factory PhraseCoachingRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$PhraseCoachingRemoteModelFromJson(json);
}

/// JSON model for one broader sales or go-to-market recommendation.
@freezed
abstract class StrategicCallAdviceRemoteModel
    with _$StrategicCallAdviceRemoteModel {
  /// Creates remote strategic advice.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StrategicCallAdviceRemoteModel({
    required String category,
    required String priority,
    required String title,
    required String advice,
    required String rationale,
    required List<String> evidenceSegmentIds,
    @Default(<CoachingSourceRemoteModel>[])
    List<CoachingSourceRemoteModel> sources,
    @Default(0) double confidence,
    String? recommendationId,
  }) = _StrategicCallAdviceRemoteModel;

  /// Parses strategic advice.
  factory StrategicCallAdviceRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$StrategicCallAdviceRemoteModelFromJson(json);
}

/// JSON model for Pinkall's final post-call debrief.
@freezed
abstract class CallDebriefRemoteModel with _$CallDebriefRemoteModel {
  /// Creates a remote debrief.
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory CallDebriefRemoteModel({
    required String sessionId,
    required GroundedCallTextRemoteModel summary,
    required List<GroundedCallTextRemoteModel> keyPoints,
    required List<CallCommitmentRemoteModel> commitments,
    required CallFollowUpRemoteModel followUp,
    required DateTime generatedAt,
    required String provider,
    required String model,
    @Default(<GroundedCallTextRemoteModel>[])
    List<GroundedCallTextRemoteModel> strengths,
    @Default(<CallPerformanceAxisRemoteModel>[])
    List<CallPerformanceAxisRemoteModel> performanceAxes,
    @Default(<PhraseCoachingRemoteModel>[])
    List<PhraseCoachingRemoteModel> phraseCoaching,
    @Default(<StrategicCallAdviceRemoteModel>[])
    List<StrategicCallAdviceRemoteModel> strategicAdvice,
    CallImprovementRemoteModel? improvement,
  }) = _CallDebriefRemoteModel;

  /// Parses a debrief.
  factory CallDebriefRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CallDebriefRemoteModelFromJson(json);
}
