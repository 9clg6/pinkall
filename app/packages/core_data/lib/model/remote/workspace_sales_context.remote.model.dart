// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_sales_context.remote.model.freezed.dart';
part 'workspace_sales_context.remote.model.g.dart';

/// JSON representation of the durable workspace sales context.
@freezed
abstract class WorkspaceSalesContextRemoteModel
    with _$WorkspaceSalesContextRemoteModel {
  /// Creates a remote workspace sales context.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory WorkspaceSalesContextRemoteModel({
    required String companyName,
    required String productName,
    required String pitchMarkdown,
    required int revision,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorkspaceSalesContextRemoteModel;

  /// Parses a workspace sales context.
  factory WorkspaceSalesContextRemoteModel.fromJson(
    Map<String, dynamic> json,
  ) => _$WorkspaceSalesContextRemoteModelFromJson(json);
}
