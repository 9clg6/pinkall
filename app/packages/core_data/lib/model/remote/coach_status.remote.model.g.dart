// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_status.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoachStatusRemoteModel _$CoachStatusRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CoachStatusRemoteModel(
  status: json['status'] as String,
  outcome: json['outcome'] as String?,
);

Map<String, dynamic> _$CoachStatusRemoteModelToJson(
  _CoachStatusRemoteModel instance,
) => <String, dynamic>{'status': instance.status, 'outcome': instance.outcome};
