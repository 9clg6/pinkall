import 'dart:convert';

import 'package:api_agent_vocal/api_agent_vocal.dart';
import 'package:api_agent_vocal/src/application/workspace_privacy_service.dart';
import 'package:api_agent_vocal/src/presentation/request_telemetry.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  const String token = 'privacy-test-token-with-more-than-24-characters';
  const String ownerUserId = '00000000-0000-4000-8000-000000000010';
  const String ownerWorkspaceId = '00000000-0000-4000-8000-000000000020';
  late PinkallBackend backend;
  late Handler handler;

  setUp(() async {
    backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': token,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only-not-used',
      }),
      requestAuthenticator: const _StaticRequestAuthenticator(
        AuthPrincipal(
          userId: ownerUserId,
          workspaceId: ownerWorkspaceId,
          mode: AuthMode.supabaseJwt,
          membershipRole: WorkspaceMembershipRole.owner,
        ),
      ),
    );
    await backend.initialize();
    handler = ApiRouter(backend: backend, retentionDays: 90).handler;
  });

  tearDown(() => backend.dispose());

  Request authenticated(
    String method,
    String path, {
    Map<String, Object?>? body,
    String? requestId,
  }) {
    return Request(
      method,
      Uri.parse('http://localhost$path'),
      headers: <String, String>{
        'authorization': 'Bearer $token',
        'content-type': 'application/json',
        if (requestId != null) RequestTelemetry.requestIdHeader: requestId,
      },
      body: body == null ? null : jsonEncode(body),
    );
  }

  test('exports workspace data without media credentials', () async {
    final CallSessionSnapshot session = backend.store.createSession(
      callId: 'privacy-call',
      destinationNumber: '+33600000000',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    backend.store.failSession(session.id, 'test_complete');

    final Response response = await handler(
      authenticated(
        'GET',
        '/v1/privacy/export',
        requestId: 'privacy-request-123',
      ),
    );
    final String raw = await response.readAsString();
    final Map<String, Object?> body = jsonDecode(raw) as Map<String, Object?>;

    expect(response.statusCode, 200);
    expect(body['workspace_id'], ownerWorkspaceId);
    expect(body['raw_audio_included'], isFalse);
    expect(raw, isNot(contains(session.mediaToken)));
    expect(response.headers['content-disposition'], contains('.json'));
    expect(response.headers['cache-control'], contains('private'));
    expect(response.headers['cache-control'], contains('no-store'));
    expect(response.headers['pragma'], 'no-cache');
    expect(response.headers['expires'], '0');
    expect(response.headers['vary'], contains('Authorization'));
    expect(
      response.headers[RequestTelemetry.requestIdHeader],
      'privacy-request-123',
    );
  });

  test(
    'retention apply requires the exact active-policy confirmation',
    () async {
      final Response preview = await handler(
        authenticated('GET', '/v1/privacy/retention'),
      );
      final Map<String, Object?> previewBody =
          jsonDecode(await preview.readAsString()) as Map<String, Object?>;
      expect(preview.statusCode, 200);
      expect(previewBody['retention_days'], 90);
      expect(previewBody['destructive_operation_allowed'], isTrue);
      expect(preview.headers['cache-control'], 'private, no-store');

      final Response rejected = await handler(
        authenticated(
          'POST',
          '/v1/privacy/retention/apply',
          body: const <String, Object?>{'confirmation': 'yes'},
        ),
      );
      expect(rejected.statusCode, 400);

      final Response accepted = await handler(
        authenticated(
          'POST',
          '/v1/privacy/retention/apply',
          body: const <String, Object?>{
            'confirmation': 'APPLY 90 DAY RETENTION',
          },
        ),
      );
      expect(accepted.statusCode, 200);
    },
  );

  test(
    'workspace deletion blocks active calls then clears durable data',
    () async {
      final CallSessionSnapshot session = backend.store.createSession(
        callId: 'privacy-active-call',
        destinationNumber: '+33600000001',
        contactId: null,
        coachMode: CoachMode.off,
        sellerTrack: MediaTrack.outbound,
      );
      backend.store.addContact(phoneNumber: '+33600000001');

      Future<Response> deleteWorkspace() async {
        return await handler(
          authenticated(
            'DELETE',
            '/v1/privacy/workspace-data',
            body: const <String, Object?>{
              'confirmation': WorkspacePrivacyService.deletionConfirmation,
            },
          ),
        );
      }

      final Response conflict = await deleteWorkspace();
      expect(conflict.statusCode, 409);
      expect(await conflict.readAsString(), contains('privacy_active_call'));

      backend.store.failSession(session.id, 'test_complete');
      final Response deleted = await deleteWorkspace();
      final Map<String, Object?> body =
          jsonDecode(await deleted.readAsString()) as Map<String, Object?>;
      expect(deleted.statusCode, 200);
      expect(body['deleted'], isTrue);
      expect(body['auth_identity_deleted'], isFalse);
      expect(body['external_provider_deletion_requested'], isFalse);
      expect(backend.store.listSessions(), isEmpty);
      expect(backend.store.contacts(), isEmpty);
    },
  );

  test('members may export but cannot run destructive operations', () async {
    await backend.dispose();
    backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': token,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only-not-used',
      }),
      requestAuthenticator: const _StaticRequestAuthenticator(
        AuthPrincipal(
          userId: '00000000-0000-4000-8000-000000000001',
          workspaceId: '00000000-0000-4000-8000-000000000002',
          mode: AuthMode.supabaseJwt,
          membershipRole: WorkspaceMembershipRole.member,
        ),
      ),
    );
    await backend.initialize();
    handler = ApiRouter(backend: backend).handler;

    final Response export = await handler(
      authenticated('GET', '/v1/privacy/export'),
    );
    final Response retention = await handler(
      authenticated('GET', '/v1/privacy/retention'),
    );
    final Response deletion = await handler(
      authenticated(
        'DELETE',
        '/v1/privacy/workspace-data',
        body: const <String, Object?>{
          'confirmation': WorkspacePrivacyService.deletionConfirmation,
        },
      ),
    );

    expect(export.statusCode, 200);
    expect(retention.statusCode, 403);
    expect(deletion.statusCode, 403);
    expect(deletion.headers['cache-control'], 'private, no-store');
  });

  test('privacy errors are private and never cacheable', () async {
    final Response response = await handler(
      Request('GET', Uri.parse('http://localhost/v1/privacy/export')),
    );

    expect(response.statusCode, 401);
    expect(response.headers['cache-control'], 'private, no-store');
    expect(response.headers['pragma'], 'no-cache');
  });

  test('the shared POC bearer cannot mutate privacy data', () async {
    await backend.dispose();
    backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': token,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only-not-used',
      }),
    );
    await backend.initialize();
    handler = ApiRouter(backend: backend, retentionDays: 90).handler;

    final Response retention = await handler(
      authenticated(
        'POST',
        '/v1/privacy/retention/apply',
        body: const <String, Object?>{'confirmation': 'APPLY 90 DAY RETENTION'},
      ),
    );
    final Response deletion = await handler(
      authenticated(
        'DELETE',
        '/v1/privacy/workspace-data',
        body: const <String, Object?>{
          'confirmation': WorkspacePrivacyService.deletionConfirmation,
        },
      ),
    );

    expect(retention.statusCode, 403);
    expect(deletion.statusCode, 403);
    expect(await retention.readAsString(), contains('user_auth_required'));
    expect(await deletion.readAsString(), contains('user_auth_required'));
  });
}

final class _StaticRequestAuthenticator implements RequestAuthenticator {
  const _StaticRequestAuthenticator(this.principal);

  final AuthPrincipal principal;

  @override
  Future<void> initialize() async {}

  @override
  Future<AuthPrincipal> authenticate({
    required String token,
    required String? requestedWorkspaceId,
  }) async => principal;

  @override
  Future<void> dispose() async {}
}
