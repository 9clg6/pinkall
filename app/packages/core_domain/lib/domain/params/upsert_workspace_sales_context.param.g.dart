// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_workspace_sales_context.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpsertWorkspaceSalesContextParam _$UpsertWorkspaceSalesContextParamFromJson(
  Map<String, dynamic> json,
) => _UpsertWorkspaceSalesContextParam(
  companyName: json['company_name'] as String,
  productName: json['product_name'] as String,
  pitchMarkdown: json['pitch_markdown'] as String,
  expectedRevision: (json['expected_revision'] as num?)?.toInt(),
);

Map<String, dynamic> _$UpsertWorkspaceSalesContextParamToJson(
  _UpsertWorkspaceSalesContextParam instance,
) => <String, dynamic>{
  'company_name': instance.companyName,
  'product_name': instance.productName,
  'pitch_markdown': instance.pitchMarkdown,
  'expected_revision': instance.expectedRevision,
};
