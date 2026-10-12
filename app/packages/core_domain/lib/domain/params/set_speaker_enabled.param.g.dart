// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_speaker_enabled.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SetSpeakerEnabledParam _$SetSpeakerEnabledParamFromJson(
  Map<String, dynamic> json,
) => _SetSpeakerEnabledParam(
  callId: json['callId'] as String,
  isEnabled: json['isEnabled'] as bool,
);

Map<String, dynamic> _$SetSpeakerEnabledParamToJson(
  _SetSpeakerEnabledParam instance,
) => <String, dynamic>{
  'callId': instance.callId,
  'isEnabled': instance.isEnabled,
};
