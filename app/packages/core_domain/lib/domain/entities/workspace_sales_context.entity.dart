import 'package:freezed_annotation/freezed_annotation.dart';

part 'workspace_sales_context.entity.freezed.dart';

/// Durable product and company context used by every Pinkall call.
@freezed
abstract class WorkspaceSalesContextEntity with _$WorkspaceSalesContextEntity {
  /// Creates the current workspace sales context.
  const factory WorkspaceSalesContextEntity({
    required String companyName,
    required String productName,
    required String pitchMarkdown,
    required int revision,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorkspaceSalesContextEntity;
}
