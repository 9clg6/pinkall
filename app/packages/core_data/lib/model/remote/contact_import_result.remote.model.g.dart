// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_import_result.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactImportResultRemoteModel _$ContactImportResultRemoteModelFromJson(
  Map<String, dynamic> json,
) => _ContactImportResultRemoteModel(
  importId: json['import_id'] as String,
  importedCount: (json['imported_count'] as num).toInt(),
  skippedCount: (json['skipped_count'] as num).toInt(),
  errors:
      (json['errors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$ContactImportResultRemoteModelToJson(
  _ContactImportResultRemoteModel instance,
) => <String, dynamic>{
  'import_id': instance.importId,
  'imported_count': instance.importedCount,
  'skipped_count': instance.skippedCount,
  'errors': instance.errors,
};
