import 'package:core_domain/domain/entities/workspace_sales_context.entity.dart';
import 'package:core_domain/domain/params/upsert_workspace_sales_context.param.dart';

/// Durable boundary for the authenticated workspace's product context.
abstract interface class WorkspaceSalesContextRepository {
  /// Returns null until the workspace has completed its initial setup.
  Future<WorkspaceSalesContextEntity?> getContext();

  /// Creates or updates the context using optimistic concurrency.
  Future<WorkspaceSalesContextEntity> upsertContext(
    UpsertWorkspaceSalesContextParam params,
  );
}
