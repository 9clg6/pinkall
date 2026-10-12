import 'package:core_data/datasources/remote/workspace_sales_context.remote.data_source.dart';
import 'package:core_data/mappers/workspace_sales_context.mapper.dart';
import 'package:core_data/model/remote/workspace_sales_context.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Pinkall-backend implementation of [WorkspaceSalesContextRepository].
final class WorkspaceSalesContextRepositoryImpl
    implements WorkspaceSalesContextRepository {
  /// Creates the repository with its [remoteDataSource].
  const WorkspaceSalesContextRepositoryImpl({
    required WorkspaceSalesContextRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final WorkspaceSalesContextRemoteDataSource _remoteDataSource;

  @override
  Future<WorkspaceSalesContextEntity?> getContext() async {
    final WorkspaceSalesContextRemoteModel? model = await _remoteDataSource
        .getContext();
    return model?.toEntity();
  }

  @override
  Future<WorkspaceSalesContextEntity> upsertContext(
    UpsertWorkspaceSalesContextParam params,
  ) async {
    return (await _remoteDataSource.upsertContext(params.toJson())).toEntity();
  }
}
