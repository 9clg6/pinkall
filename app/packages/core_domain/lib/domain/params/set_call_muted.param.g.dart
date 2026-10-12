// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_call_muted.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SetCallMutedParam _$SetCallMutedParamFromJson(Map<String, dynamic> json) =>
    _SetCallMutedParam(
      callId: json['callId'] as String,
      isMuted: json['isMuted'] as bool,
    );

Map<String, dynamic> _$SetCallMutedParamToJson(_SetCallMutedParam instance) =>
    <String, dynamic>{'callId': instance.callId, 'isMuted': instance.isMuted};
