import 'dart:io';

import 'package:api_agent_vocal/src/infrastructure/store/postgres_snapshot_store.dart';
import 'package:postgres/postgres.dart';
import 'package:test/test.dart';

void main() {
  final String? databaseUrl = Platform.environment['DATABASE_URL'];
  final String? rootCertificate =
      Platform.environment['DATABASE_SSL_ROOT_CERT'];
  final Object skipReason = databaseUrl == null || databaseUrl.isEmpty
      ? 'Set DATABASE_URL to run the live PostgreSQL integration tests.'
      : false;

  group('live PostgreSQL', () {
    test(
      'connects with certificate verification and reads the migrated table',
      () async {
        final Connection connection = await Connection.openFromUrl(
          _connectionUrl(databaseUrl!, rootCertificate),
        );
        try {
          final Result result = await connection.execute(
            "SELECT to_regclass('public.pinkall_poc_snapshots')::text AS table_name",
            queryMode: QueryMode.simple,
          );
          expect(
            result.single.toColumnMap()['table_name'],
            'pinkall_poc_snapshots',
          );
        } finally {
          await connection.close();
        }
      },
      skip: skipReason,
    );

    test(
      'initializes and loads through the production snapshot repository',
      () async {
        final PostgresPocSnapshotRepository repository =
            PostgresPocSnapshotRepository(
              databaseUrl!,
              sslRootCertificatePath: rootCertificate,
            );
        try {
          await repository.initialize();
          await repository.load('pinkall-live-integration-test');
        } finally {
          await repository.close();
        }
      },
      skip: skipReason,
    );
  });
}

String _connectionUrl(String databaseUrl, String? rootCertificate) {
  final Uri uri = Uri.parse(databaseUrl);
  final Map<String, String> query = <String, String>{...uri.queryParameters};
  query['sslmode'] = rootCertificate == null ? 'require' : 'verify-full';
  if (rootCertificate != null) {
    query['sslrootcert'] = rootCertificate;
  }
  query['connect_timeout'] = '10';
  query['query_timeout'] = '15';
  query['application_name'] = 'pinkall-live-test';
  return uri.replace(queryParameters: query).toString();
}
