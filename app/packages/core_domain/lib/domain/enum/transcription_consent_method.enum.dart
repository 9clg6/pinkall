import 'package:json_annotation/json_annotation.dart';

/// Method used to inform participants that transcription is active.
@JsonEnum(fieldRename: FieldRename.snake)
enum TranscriptionConsentMethod {
  /// The caller delivered the notice verbally.
  verbalNotice,

  /// Pinkall played an automated notice before transcription started.
  automatedNotice,

  /// A prior contractual notice covers this conversation.
  contractual,
}
