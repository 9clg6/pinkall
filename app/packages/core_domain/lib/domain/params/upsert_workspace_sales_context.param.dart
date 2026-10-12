// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'upsert_workspace_sales_context.param.freezed.dart';
part 'upsert_workspace_sales_context.param.g.dart';

/// Parameters used to create or update the workspace sales context.
@freezed
abstract class UpsertWorkspaceSalesContextParam
    with _$UpsertWorkspaceSalesContextParam {
  /// Creates an optimistic workspace-context update.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UpsertWorkspaceSalesContextParam({
    required String companyName,
    required String productName,
    required String pitchMarkdown,
    int? expectedRevision,
  }) = _UpsertWorkspaceSalesContextParam;

  /// Parses workspace-context parameters from JSON.
  factory UpsertWorkspaceSalesContextParam.fromJson(
    Map<String, dynamic> json,
  ) => _$UpsertWorkspaceSalesContextParamFromJson(json);
}
