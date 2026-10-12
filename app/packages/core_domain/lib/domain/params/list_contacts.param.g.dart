// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_contacts.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListContactsParam _$ListContactsParamFromJson(Map<String, dynamic> json) =>
    _ListContactsParam(
      query: json['query'] as String?,
      cursor: json['cursor'] as String?,
      limit: (json['limit'] as num?)?.toInt() ?? 50,
    );

Map<String, dynamic> _$ListContactsParamToJson(_ListContactsParam instance) =>
    <String, dynamic>{
      'query': instance.query,
      'cursor': instance.cursor,
      'limit': instance.limit,
    };
