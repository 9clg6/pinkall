// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_contact.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateContactParam _$CreateContactParamFromJson(Map<String, dynamic> json) =>
    _CreateContactParam(
      phoneNumber: json['phone_number'] as String,
      market:
          $enumDecodeNullable(_$ContactMarketEnumMap, json['market']) ??
          ContactMarket.unknown,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      company: json['company'] as String?,
      jobTitle: json['job_title'] as String?,
      email: json['email'] as String?,
      hasPriorConsent: json['has_prior_consent'] as bool?,
      hasOptedOut: json['has_opted_out'] as bool?,
      professionalRelevanceConfirmed:
          json['professional_relevance_confirmed'] as bool?,
      customFields:
          (json['custom_fields'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$CreateContactParamToJson(
  _CreateContactParam instance,
) => <String, dynamic>{
  'phone_number': instance.phoneNumber,
  'market': _$ContactMarketEnumMap[instance.market]!,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'company': instance.company,
  'job_title': instance.jobTitle,
  'email': instance.email,
  'has_prior_consent': instance.hasPriorConsent,
  'has_opted_out': instance.hasOptedOut,
  'professional_relevance_confirmed': instance.professionalRelevanceConfirmed,
  'custom_fields': instance.customFields,
};

const _$ContactMarketEnumMap = {
  ContactMarket.b2b: 'b2b',
  ContactMarket.b2c: 'b2c',
  ContactMarket.unknown: 'unknown',
};
