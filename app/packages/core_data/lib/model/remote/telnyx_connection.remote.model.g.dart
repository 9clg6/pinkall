// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telnyx_connection.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TelnyxConnectionRemoteModel _$TelnyxConnectionRemoteModelFromJson(
  Map<String, dynamic> json,
) => _TelnyxConnectionRemoteModel(
  status: json['status'] as String,
  failureReason: json['failureReason'] as String?,
);

Map<String, dynamic> _$TelnyxConnectionRemoteModelToJson(
  _TelnyxConnectionRemoteModel instance,
) => <String, dynamic>{
  'status': instance.status,
  'failureReason': instance.failureReason,
};
