// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_transcription_consent.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecordTranscriptionConsentParam _$RecordTranscriptionConsentParamFromJson(
  Map<String, dynamic> json,
) => _RecordTranscriptionConsentParam(
  sessionId: json['session_id'] as String,
  acknowledged: json['acknowledged'] as bool,
  method: $enumDecode(_$TranscriptionConsentMethodEnumMap, json['method']),
  acknowledgedAt: DateTime.parse(json['acknowledged_at'] as String),
);

Map<String, dynamic> _$RecordTranscriptionConsentParamToJson(
  _RecordTranscriptionConsentParam instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'acknowledged': instance.acknowledged,
  'method': _$TranscriptionConsentMethodEnumMap[instance.method]!,
  'acknowledged_at': instance.acknowledgedAt.toIso8601String(),
};

const _$TranscriptionConsentMethodEnumMap = {
  TranscriptionConsentMethod.verbalNotice: 'verbal_notice',
  TranscriptionConsentMethod.automatedNotice: 'automated_notice',
  TranscriptionConsentMethod.contractual: 'contractual',
};
