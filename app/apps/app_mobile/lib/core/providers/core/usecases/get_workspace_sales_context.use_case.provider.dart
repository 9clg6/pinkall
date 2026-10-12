import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/workspace_sales_context.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_workspace_sales_context.use_case.provider.g.dart';

/// Provides the workspace sales-context read use case.
@riverpod
Future<GetWorkspaceSalesContextUseCase> getWorkspaceSalesContextUseCase(
  Ref ref,
) async {
  return GetWorkspaceSalesContextUseCase(
    workspaceSalesContextRepository: await ref.watch(
      workspaceSalesContextRepositoryProvider.future,
    ),
  );
}
