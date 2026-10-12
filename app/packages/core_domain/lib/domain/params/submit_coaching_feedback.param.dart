// ignore_for_file: invalid_annotation_target

import 'package:core_domain/domain/enum/suggestion_feedback_value.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'submit_coaching_feedback.param.freezed.dart';
part 'submit_coaching_feedback.param.g.dart';

/// User feedback submitted for one coaching suggestion.
@freezed
abstract class SubmitCoachingFeedbackParam with _$SubmitCoachingFeedbackParam {
  /// Creates coaching feedback parameters.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SubmitCoachingFeedbackParam({
    required String sessionId,
    required String suggestionId,
    required SuggestionFeedbackValue value,
    @Default(false) bool applied,
    String? note,
  }) = _SubmitCoachingFeedbackParam;

  /// Creates coaching feedback parameters from JSON.
  factory SubmitCoachingFeedbackParam.fromJson(Map<String, dynamic> json) =>
      _$SubmitCoachingFeedbackParamFromJson(json);
}
