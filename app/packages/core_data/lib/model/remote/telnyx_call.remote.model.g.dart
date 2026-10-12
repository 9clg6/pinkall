// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telnyx_call.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TelnyxCallRemoteModel _$TelnyxCallRemoteModelFromJson(
  Map<String, dynamic> json,
) => _TelnyxCallRemoteModel(
  callId: json['callId'] as String,
  direction: json['direction'] as String,
  status: json['status'] as String,
  remoteName: json['remoteName'] as String?,
  remoteNumber: json['remoteNumber'] as String?,
  isMuted: json['isMuted'] as bool? ?? false,
  isSpeakerEnabled: json['isSpeakerEnabled'] as bool? ?? false,
  failureReason: json['failureReason'] as String?,
);

Map<String, dynamic> _$TelnyxCallRemoteModelToJson(
  _TelnyxCallRemoteModel instance,
) => <String, dynamic>{
  'callId': instance.callId,
  'direction': instance.direction,
  'status': instance.status,
  'remoteName': instance.remoteName,
  'remoteNumber': instance.remoteNumber,
  'isMuted': instance.isMuted,
  'isSpeakerEnabled': instance.isSpeakerEnabled,
  'failureReason': instance.failureReason,
};
