import 'package:json_annotation/json_annotation.dart';

/// Result of the versioned backend outbound-call policy evaluation.
@JsonEnum(fieldRename: FieldRename.snake)
enum CallEligibilityStatus {
  /// The known facts satisfy the current policy.
  eligible,

  /// At least one blocking fact forbids the call.
  ineligible,

  /// Required facts are missing or need a human decision.
  reviewRequired,
}
