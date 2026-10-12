import 'package:core_data/clients/pinkall_http.client.dart';
import 'package:core_data/datasources/remote/workspace_sales_context.remote.data_source.dart';
import 'package:core_data/model/remote/workspace_sales_context.remote.model.dart';

/// HTTP implementation of [WorkspaceSalesContextRemoteDataSource].
final class WorkspaceSalesContextRemoteDataSourceImpl
    implements WorkspaceSalesContextRemoteDataSource {
  /// Creates the remote source with its authenticated [httpClient].
  const WorkspaceSalesContextRemoteDataSourceImpl({
    required PinkallHttpClient httpClient,
  }) : _httpClient = httpClient;

  final PinkallHttpClient _httpClient;

  @override
  Future<WorkspaceSalesContextRemoteModel?> getContext() async {
    final Map<String, dynamic> json = await _httpClient.getJson(
      '/v1/workspace/sales-context',
    );
    final Object? raw = json['data'];
    if (raw == null) {
      return null;
    }
    return WorkspaceSalesContextRemoteModel.fromJson(_objectMap(raw));
  }

  @override
  Future<WorkspaceSalesContextRemoteModel> upsertContext(
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.putJson(
      '/v1/workspace/sales-context',
      body: body,
    );
    return WorkspaceSalesContextRemoteModel.fromJson(
      _objectMap(json['data'] ?? json),
    );
  }

  static Map<String, dynamic> _objectMap(Object? raw) {
    if (raw is! Map<dynamic, dynamic>) {
      throw const FormatException(
        'Pinkall workspace sales context must be a JSON object.',
      );
    }
    return raw.map<String, dynamic>(
      (dynamic key, dynamic value) =>
          MapEntry<String, dynamic>(key.toString(), value),
    );
  }
}
