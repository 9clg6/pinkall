import 'package:core_domain/domain/enum/call_eligibility_reason.enum.dart';
import 'package:core_domain/domain/enum/call_eligibility_status.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_eligibility.entity.freezed.dart';

/// Versioned outbound-call policy decision returned by the Pinkall backend.
@freezed
abstract class CallEligibilityEntity with _$CallEligibilityEntity {
  /// Creates an outbound-call eligibility decision.
  const factory CallEligibilityEntity({
    required CallEligibilityStatus status,
    required List<CallEligibilityReason> reasons,
    required DateTime checkedAt,
    required String policyVersion,
    String? contactId,
  }) = _CallEligibilityEntity;
}
