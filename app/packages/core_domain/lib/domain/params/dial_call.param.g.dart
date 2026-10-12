// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dial_call.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DialCallParam _$DialCallParamFromJson(Map<String, dynamic> json) =>
    _DialCallParam(
      destinationNumber: json['destinationNumber'] as String,
      clientState: json['clientState'] as String? ?? '',
      customHeaders:
          (json['customHeaders'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$DialCallParamToJson(_DialCallParam instance) =>
    <String, dynamic>{
      'destinationNumber': instance.destinationNumber,
      'clientState': instance.clientState,
      'customHeaders': instance.customHeaders,
    };
