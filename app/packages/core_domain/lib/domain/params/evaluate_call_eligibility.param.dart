// ignore_for_file: invalid_annotation_target

import 'package:core_domain/domain/enum/contact_market.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'evaluate_call_eligibility.param.freezed.dart';
part 'evaluate_call_eligibility.param.g.dart';

/// Known facts submitted to the versioned outbound-call policy service.
@freezed
abstract class EvaluateCallEligibilityParam
    with _$EvaluateCallEligibilityParam {
  /// Creates call-eligibility evaluation parameters.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory EvaluateCallEligibilityParam({
    required String phoneNumber,
    required ContactMarket market,
    String? contactId,
    bool? hasPriorConsent,
    bool? hasOptedOut,
    bool? professionalRelevanceConfirmed,
    String? countryCode,
  }) = _EvaluateCallEligibilityParam;

  /// Creates call-eligibility evaluation parameters from JSON.
  factory EvaluateCallEligibilityParam.fromJson(Map<String, dynamic> json) =>
      _$EvaluateCallEligibilityParamFromJson(json);
}
