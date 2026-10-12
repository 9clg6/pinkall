import 'package:core_data/model/remote/workspace_sales_context.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Domain mapping for the durable workspace sales context.
extension WorkspaceSalesContextRemoteModelX
    on WorkspaceSalesContextRemoteModel {
  /// Converts this API model to its immutable domain representation.
  WorkspaceSalesContextEntity toEntity() => WorkspaceSalesContextEntity(
    companyName: companyName,
    productName: productName,
    pitchMarkdown: pitchMarkdown,
    revision: revision,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
