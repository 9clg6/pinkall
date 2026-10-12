import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/workspace_sales_context.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'upsert_workspace_sales_context.use_case.provider.g.dart';

/// Provides the workspace sales-context write use case.
@riverpod
Future<UpsertWorkspaceSalesContextUseCase> upsertWorkspaceSalesContextUseCase(
  Ref ref,
) async {
  return UpsertWorkspaceSalesContextUseCase(
    workspaceSalesContextRepository: await ref.watch(
      workspaceSalesContextRepositoryProvider.future,
    ),
  );
}
