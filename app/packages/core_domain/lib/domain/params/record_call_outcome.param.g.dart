// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_call_outcome.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecordCallOutcomeParam _$RecordCallOutcomeParamFromJson(
  Map<String, dynamic> json,
) => _RecordCallOutcomeParam(
  sessionId: json['session_id'] as String,
  type: $enumDecode(_$CallOutcomeTypeEnumMap, json['type']),
  note: json['note'] as String?,
);

Map<String, dynamic> _$RecordCallOutcomeParamToJson(
  _RecordCallOutcomeParam instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'type': _$CallOutcomeTypeEnumMap[instance.type]!,
  'note': instance.note,
};

const _$CallOutcomeTypeEnumMap = {
  CallOutcomeType.unknown: 'unknown',
  CallOutcomeType.noAnswer: 'no_answer',
  CallOutcomeType.voicemail: 'voicemail',
  CallOutcomeType.followUp: 'follow_up',
  CallOutcomeType.meetingBooked: 'meeting_booked',
  CallOutcomeType.notInterested: 'not_interested',
  CallOutcomeType.disqualified: 'disqualified',
  CallOutcomeType.won: 'won',
  CallOutcomeType.lost: 'lost',
};
