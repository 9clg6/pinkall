// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'coaching_feedback.remote.model.freezed.dart';
part 'coaching_feedback.remote.model.g.dart';

/// JSON model for server-confirmed coaching feedback.
@freezed
abstract class CoachingFeedbackRemoteModel with _$CoachingFeedbackRemoteModel {
  /// Creates remote coaching feedback.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CoachingFeedbackRemoteModel({
    required String id,
    required String sessionId,
    required String suggestionId,
    required String value,
    required bool applied,
    required DateTime submittedAt,
    String? note,
  }) = _CoachingFeedbackRemoteModel;

  /// Creates remote coaching feedback from JSON.
  factory CoachingFeedbackRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$CoachingFeedbackRemoteModelFromJson(json);
}
