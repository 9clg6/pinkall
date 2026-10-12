// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_outcome.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CallOutcomeRemoteModel _$CallOutcomeRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CallOutcomeRemoteModel(
  sessionId: json['session_id'] as String,
  type: json['type'] as String,
  recordedAt: DateTime.parse(json['recorded_at'] as String),
  note: json['note'] as String?,
);

Map<String, dynamic> _$CallOutcomeRemoteModelToJson(
  _CallOutcomeRemoteModel instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'type': instance.type,
  'recorded_at': instance.recordedAt.toIso8601String(),
  'note': instance.note,
};
