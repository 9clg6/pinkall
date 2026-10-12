// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evaluate_call_eligibility.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EvaluateCallEligibilityParam _$EvaluateCallEligibilityParamFromJson(
  Map<String, dynamic> json,
) => _EvaluateCallEligibilityParam(
  phoneNumber: json['phone_number'] as String,
  market: $enumDecode(_$ContactMarketEnumMap, json['market']),
  contactId: json['contact_id'] as String?,
  hasPriorConsent: json['has_prior_consent'] as bool?,
  hasOptedOut: json['has_opted_out'] as bool?,
  professionalRelevanceConfirmed:
      json['professional_relevance_confirmed'] as bool?,
  countryCode: json['country_code'] as String?,
);

Map<String, dynamic> _$EvaluateCallEligibilityParamToJson(
  _EvaluateCallEligibilityParam instance,
) => <String, dynamic>{
  'phone_number': instance.phoneNumber,
  'market': _$ContactMarketEnumMap[instance.market]!,
  'contact_id': instance.contactId,
  'has_prior_consent': instance.hasPriorConsent,
  'has_opted_out': instance.hasOptedOut,
  'professional_relevance_confirmed': instance.professionalRelevanceConfirmed,
  'country_code': instance.countryCode,
};

const _$ContactMarketEnumMap = {
  ContactMarket.b2b: 'b2b',
  ContactMarket.b2c: 'b2c',
  ContactMarket.unknown: 'unknown',
};
