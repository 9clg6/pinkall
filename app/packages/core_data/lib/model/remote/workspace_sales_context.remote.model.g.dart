// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_sales_context.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkspaceSalesContextRemoteModel _$WorkspaceSalesContextRemoteModelFromJson(
  Map<String, dynamic> json,
) => _WorkspaceSalesContextRemoteModel(
  companyName: json['company_name'] as String,
  productName: json['product_name'] as String,
  pitchMarkdown: json['pitch_markdown'] as String,
  revision: (json['revision'] as num).toInt(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$WorkspaceSalesContextRemoteModelToJson(
  _WorkspaceSalesContextRemoteModel instance,
) => <String, dynamic>{
  'company_name': instance.companyName,
  'product_name': instance.productName,
  'pitch_markdown': instance.pitchMarkdown,
  'revision': instance.revision,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
