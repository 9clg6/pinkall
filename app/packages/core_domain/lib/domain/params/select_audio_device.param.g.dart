// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_audio_device.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SelectAudioDeviceParam _$SelectAudioDeviceParamFromJson(
  Map<String, dynamic> json,
) => _SelectAudioDeviceParam(
  deviceId: json['deviceId'] as String,
  kind: $enumDecode(_$AudioDeviceKindEnumMap, json['kind']),
);

Map<String, dynamic> _$SelectAudioDeviceParamToJson(
  _SelectAudioDeviceParam instance,
) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'kind': _$AudioDeviceKindEnumMap[instance.kind]!,
};

const _$AudioDeviceKindEnumMap = {
  AudioDeviceKind.input: 'input',
  AudioDeviceKind.output: 'output',
};
