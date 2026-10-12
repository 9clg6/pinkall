import 'package:core_domain/domain/entities/workspace_sales_context.entity.dart';
import 'package:core_domain/domain/repositories/workspace_sales_context.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Retrieves the durable sales context for the authenticated workspace.
final class GetWorkspaceSalesContextUseCase
    extends FutureUseCase<WorkspaceSalesContextEntity?> {
  /// Creates the use case with its [workspaceSalesContextRepository].
  GetWorkspaceSalesContextUseCase({
    required WorkspaceSalesContextRepository workspaceSalesContextRepository,
  }) : _repository = workspaceSalesContextRepository;

  final WorkspaceSalesContextRepository _repository;

  @override
  Future<WorkspaceSalesContextEntity?> invoke() => _repository.getContext();
}
