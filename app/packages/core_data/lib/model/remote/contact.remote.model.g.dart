// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactRemoteModel _$ContactRemoteModelFromJson(Map<String, dynamic> json) =>
    _ContactRemoteModel(
      id: json['id'] as String,
      phoneNumber: json['phone_number'] as String,
      market: json['market'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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

Map<String, dynamic> _$ContactRemoteModelToJson(
  _ContactRemoteModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'phone_number': instance.phoneNumber,
  'market': instance.market,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
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
