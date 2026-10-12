// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_recording_import.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateRecordingImportParam _$CreateRecordingImportParamFromJson(
  Map<String, dynamic> json,
) => _CreateRecordingImportParam(
  source: json['source'] as String? ?? 'recording_import',
  fileName: json['file_name'] as String,
  mimeType: json['mime_type'] as String,
  sizeBytes: (json['size_bytes'] as num).toInt(),
  title: json['title'] as String?,
  locale: json['locale'] as String? ?? 'fr-FR',
  preparationMarkdown: json['preparation_markdown'] as String?,
);

Map<String, dynamic> _$CreateRecordingImportParamToJson(
  _CreateRecordingImportParam instance,
) => <String, dynamic>{
  'source': instance.source,
  'file_name': instance.fileName,
  'mime_type': instance.mimeType,
  'size_bytes': instance.sizeBytes,
  'title': instance.title,
  'locale': instance.locale,
  'preparation_markdown': instance.preparationMarkdown,
};
