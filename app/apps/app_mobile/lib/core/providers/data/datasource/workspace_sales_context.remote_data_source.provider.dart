import 'package:core_data/core_data.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'workspace_sales_context.remote_data_source.provider.g.dart';

/// Provides the authenticated workspace-context remote source.
@riverpod
Future<WorkspaceSalesContextRemoteDataSource>
workspaceSalesContextRemoteDataSource(Ref ref) async {
  return WorkspaceSalesContextRemoteDataSourceImpl(
    httpClient: ref.watch(pinkallHttpClientProvider),
  );
}
