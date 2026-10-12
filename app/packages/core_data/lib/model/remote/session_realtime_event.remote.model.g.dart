// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_realtime_event.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionRealtimeEventRemoteModel _$SessionRealtimeEventRemoteModelFromJson(
  Map<String, dynamic> json,
) => _SessionRealtimeEventRemoteModel(
  type: json['type'] as String,
  payload: json['payload'] as Map<String, dynamic>,
);

Map<String, dynamic> _$SessionRealtimeEventRemoteModelToJson(
  _SessionRealtimeEventRemoteModel instance,
) => <String, dynamic>{'type': instance.type, 'payload': instance.payload};
