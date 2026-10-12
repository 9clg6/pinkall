import 'package:json_annotation/json_annotation.dart';

/// Explicit user assessment of a coaching suggestion.
@JsonEnum(fieldRename: FieldRename.snake)
enum SuggestionFeedbackValue {
  /// The suggestion helped the conversation.
  useful,

  /// The suggestion did not add value.
  notUseful,

  /// The suggestion was factually or contextually incorrect.
  incorrect,

  /// The suggestion arrived at a distracting moment.
  distracting,
}
