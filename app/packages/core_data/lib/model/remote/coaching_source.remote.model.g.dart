// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coaching_source.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoachingSourceRemoteModel _$CoachingSourceRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CoachingSourceRemoteModel(
  id: json['id'] as String,
  title: json['title'] as String,
  evidenceLevel: json['evidence_level'] as String,
  author: json['author'] as String?,
  url: json['url'] as String?,
  locator: json['locator'] as String?,
);

Map<String, dynamic> _$CoachingSourceRemoteModelToJson(
  _CoachingSourceRemoteModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'evidence_level': instance.evidenceLevel,
  'author': instance.author,
  'url': instance.url,
  'locator': instance.locator,
};
