import 'package:json_annotation/json_annotation.dart';

/// Lifecycle of a provider-independent Pinkall conversation session.
@JsonEnum(fieldRename: FieldRename.snake)
enum ConversationSessionStatus {
  /// The backend session exists but media processing has not started.
  created,

  /// Live transcript and optional coaching are active.
  active,

  /// The backend is reconciling the final transcript and post-call analysis.
  finalizing,

  /// All final artifacts are available.
  completed,

  /// The session could not be processed.
  failed,
}
