import 'package:json_annotation/json_annotation.dart';

/// Machine-readable reasons returned by the outbound-call policy engine.
@JsonEnum(fieldRename: FieldRename.snake)
enum CallEligibilityReason {
  /// The contact explicitly opted out of calls.
  optedOut,

  /// Prior consent required for the consumer call is missing.
  b2cConsentMissing,

  /// Relevance to the prospect's professional activity is not established.
  professionalRelevanceMissing,

  /// The B2B or B2C relationship is unknown.
  marketUnknown,

  /// The destination number cannot be called under the current policy.
  phoneNumberInvalid,

  /// The policy service could not reach a reliable determination.
  policyUnavailable,
}
