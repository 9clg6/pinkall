import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkspaceSalesContextRepositoryImpl', () {
    test('returns null while workspace onboarding is incomplete', () async {
      final _WorkspaceContextHttpClient client = _WorkspaceContextHttpClient(
        getResponse: <String, dynamic>{'data': null},
      );
      final WorkspaceSalesContextRepository repository =
          WorkspaceSalesContextRepositoryImpl(
            remoteDataSource: WorkspaceSalesContextRemoteDataSourceImpl(
              httpClient: client,
            ),
          );

      expect(await repository.getContext(), isNull);
    });

    test('maps a durable context and sends optimistic updates', () async {
      final DateTime createdAt = DateTime.utc(2026, 7, 13, 8);
      final DateTime updatedAt = DateTime.utc(2026, 7, 13, 9);
      final Map<String, dynamic> contextJson = <String, dynamic>{
        'company_name': 'Pinkall SAS',
        'product_name': 'Pinkall',
        'pitch_markdown': '# ICP\nFondateurs B2B',
        'revision': 3,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
      final _WorkspaceContextHttpClient client = _WorkspaceContextHttpClient(
        getResponse: <String, dynamic>{'data': contextJson},
        putResponse: <String, dynamic>{'data': contextJson},
      );
      final WorkspaceSalesContextRepository repository =
          WorkspaceSalesContextRepositoryImpl(
            remoteDataSource: WorkspaceSalesContextRemoteDataSourceImpl(
              httpClient: client,
            ),
          );

      final WorkspaceSalesContextEntity? loaded = await repository.getContext();
      final WorkspaceSalesContextEntity saved = await repository.upsertContext(
        const UpsertWorkspaceSalesContextParam(
          companyName: 'Pinkall SAS',
          productName: 'Pinkall',
          pitchMarkdown: '# ICP\nFondateurs B2B',
          expectedRevision: 2,
        ),
      );

      expect(loaded?.revision, 3);
      expect(saved.pitchMarkdown, contains('Fondateurs'));
      expect(client.lastPutPath, '/v1/workspace/sales-context');
      expect(client.lastPutBody?['expected_revision'], 2);
      expect(client.lastPutBody?['company_name'], 'Pinkall SAS');
    });
  });
}

final class _WorkspaceContextHttpClient implements PinkallHttpClient {
  _WorkspaceContextHttpClient({
    required this.getResponse,
    this.putResponse = const <String, dynamic>{},
  });

  final Map<String, dynamic> getResponse;
  final Map<String, dynamic> putResponse;
  String? lastPutPath;
  Map<String, dynamic>? lastPutBody;

  @override
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async => getResponse;

  @override
  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
  }) async {
    lastPutPath = path;
    lastPutBody = body;
    return putResponse;
  }

  @override
  Future<Map<String, dynamic>> patchJson(
    String path, {
    Map<String, dynamic>? body,
  }) => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  }) => throw UnimplementedError();
}
