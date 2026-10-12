import 'package:core_domain/domain/enum/suggestion_feedback_value.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coaching_feedback.entity.freezed.dart';

/// Server-confirmed user feedback for a coaching suggestion.
@freezed
abstract class CoachingFeedbackEntity with _$CoachingFeedbackEntity {
  /// Creates coaching feedback.
  const factory CoachingFeedbackEntity({
    required String id,
    required String sessionId,
    required String suggestionId,
    required SuggestionFeedbackValue value,
    required bool applied,
    required DateTime submittedAt,
    String? note,
  }) = _CoachingFeedbackEntity;
}
