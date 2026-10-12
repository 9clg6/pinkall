import 'package:core_data/model/remote/workspace_sales_context.remote.model.dart';

/// Remote source for the authenticated workspace sales context.
abstract interface class WorkspaceSalesContextRemoteDataSource {
  /// Returns null until the workspace has completed setup.
  Future<WorkspaceSalesContextRemoteModel?> getContext();

  /// Creates or updates the workspace sales context.
  Future<WorkspaceSalesContextRemoteModel> upsertContext(
    Map<String, dynamic> body,
  );
}
