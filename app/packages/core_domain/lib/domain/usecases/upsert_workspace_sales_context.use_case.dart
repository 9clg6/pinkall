import 'package:core_domain/domain/entities/workspace_sales_context.entity.dart';
import 'package:core_domain/domain/params/upsert_workspace_sales_context.param.dart';
import 'package:core_domain/domain/repositories/workspace_sales_context.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Creates or updates the durable sales context for the workspace.
final class UpsertWorkspaceSalesContextUseCase
    extends
        FutureUseCaseWithParams<
          WorkspaceSalesContextEntity,
          UpsertWorkspaceSalesContextParam
        > {
  /// Creates the use case with its [workspaceSalesContextRepository].
  UpsertWorkspaceSalesContextUseCase({
    required WorkspaceSalesContextRepository workspaceSalesContextRepository,
  }) : _repository = workspaceSalesContextRepository;

  final WorkspaceSalesContextRepository _repository;

  @override
  Future<WorkspaceSalesContextEntity> invoke(
    UpsertWorkspaceSalesContextParam params,
  ) => _repository.upsertContext(params);
}
