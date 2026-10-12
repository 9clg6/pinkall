// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_custom_objection.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateCustomObjectionParam _$CreateCustomObjectionParamFromJson(
  Map<String, dynamic> json,
) => _CreateCustomObjectionParam(
  category: json['category'] as String,
  text: json['text'] as String,
  responseContent: json['response_content'] as String,
  responseSourceType: json['response_source_type'] as String? ?? 'text',
  responseSourceName: json['response_source_name'] as String?,
);

Map<String, dynamic> _$CreateCustomObjectionParamToJson(
  _CreateCustomObjectionParam instance,
) => <String, dynamic>{
  'category': instance.category,
  'text': instance.text,
  'response_content': instance.responseContent,
  'response_source_type': instance.responseSourceType,
  'response_source_name': instance.responseSourceName,
};
