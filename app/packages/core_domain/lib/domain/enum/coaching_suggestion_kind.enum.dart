import 'package:json_annotation/json_annotation.dart';

/// Commercial situation addressed by a live coaching suggestion.
@JsonEnum(fieldRename: FieldRename.snake)
enum CoachingSuggestionKind {
  /// A concise next question to ask.
  nextQuestion,

  /// A response to an objection detected in the conversation.
  objectionHandling,

  /// A request to clarify an ambiguous need or statement.
  clarification,

  /// A prompt to confirm a concrete next step.
  nextStep,

  /// A signal that the seller should listen rather than add a prompt.
  listen,
}
