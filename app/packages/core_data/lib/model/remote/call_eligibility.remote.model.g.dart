// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_eligibility.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CallEligibilityRemoteModel _$CallEligibilityRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CallEligibilityRemoteModel(
  status: json['status'] as String,
  reasons: (json['reasons'] as List<dynamic>).map((e) => e as String).toList(),
  checkedAt: DateTime.parse(json['checked_at'] as String),
  policyVersion: json['policy_version'] as String,
  contactId: json['contact_id'] as String?,
);

Map<String, dynamic> _$CallEligibilityRemoteModelToJson(
  _CallEligibilityRemoteModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'reasons': instance.reasons,
  'checked_at': instance.checkedAt.toIso8601String(),
  'policy_version': instance.policyVersion,
  'contact_id': instance.contactId,
};
