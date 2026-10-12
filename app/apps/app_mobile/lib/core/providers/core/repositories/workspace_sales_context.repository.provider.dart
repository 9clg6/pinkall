import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/data/datasource/workspace_sales_context.remote_data_source.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_sales_context.repository.provider.g.dart';

/// Provides the durable workspace sales-context repository.
@riverpod
Future<WorkspaceSalesContextRepository> workspaceSalesContextRepository(
  Ref ref,
) async {
  final WorkspaceSalesContextRemoteDataSource remoteDataSource = await ref
      .watch(workspaceSalesContextRemoteDataSourceProvider.future);
  return WorkspaceSalesContextRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );
}
