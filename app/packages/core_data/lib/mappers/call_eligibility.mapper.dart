import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/call_eligibility.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Mapping extensions for [CallEligibilityRemoteModel].
extension CallEligibilityRemoteModelX on CallEligibilityRemoteModel {
  /// Converts the remote policy decision to a domain entity.
  CallEligibilityEntity toEntity() => CallEligibilityEntity(
    contactId: contactId,
    status: enumFromWireName<CallEligibilityStatus>(
      CallEligibilityStatus.values,
      status,
    ),
    reasons: reasons
        .map(
          (String reason) => enumFromWireName<CallEligibilityReason>(
            CallEligibilityReason.values,
            reason,
          ),
        )
        .toList(growable: false),
    checkedAt: checkedAt,
    policyVersion: policyVersion,
  );
}
