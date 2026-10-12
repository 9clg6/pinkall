// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcription_consent.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TranscriptionConsentRemoteModel _$TranscriptionConsentRemoteModelFromJson(
  Map<String, dynamic> json,
) => _TranscriptionConsentRemoteModel(
  sessionId: json['session_id'] as String,
  acknowledged: json['acknowledged'] as bool,
  method: json['method'] as String,
  acknowledgedAt: DateTime.parse(json['acknowledged_at'] as String),
);

Map<String, dynamic> _$TranscriptionConsentRemoteModelToJson(
  _TranscriptionConsentRemoteModel instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'acknowledged': instance.acknowledged,
  'method': instance.method,
  'acknowledged_at': instance.acknowledgedAt.toIso8601String(),
};
