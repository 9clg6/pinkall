import 'package:api_agent_vocal/src/application/request_authentication_service.dart';
import 'package:api_agent_vocal/src/domain/auth_contracts.dart';
import 'package:test/test.dart';

void main() {
  const String pocToken = 'poc-token-with-more-than-24-characters';
  const String workspaceId = '11111111-1111-4111-8111-111111111111';
  const String otherWorkspaceId = '22222222-2222-4222-8222-222222222222';
  const String userId = '33333333-3333-4333-8333-333333333333';
  const String sessionId = '44444444-4444-4444-8444-444444444444';

  test(
    'accepts the POC bearer only when explicitly enabled and scoped',
    () async {
      final RequestAuthenticationService service = RequestAuthenticationService(
        supabaseVerifier: null,
        membershipResolver: null,
        allowPocBearer: true,
        pocBearer: pocToken,
        pocWorkspaceId: 'pinkall-poc',
        snapshotWorkspaceId: null,
      );

      final AuthPrincipal principal = await service.authenticate(
        token: pocToken,
        requestedWorkspaceId: 'pinkall-poc',
      );

      expect(principal.mode, AuthMode.pocBearer);
      expect(principal.workspaceId, 'pinkall-poc');
      expect(principal.membershipRole, WorkspaceMembershipRole.owner);
      await expectLater(
        service.authenticate(
          token: pocToken,
          requestedWorkspaceId: 'another-workspace',
        ),
        throwsA(
          isA<AuthenticationException>().having(
            (AuthenticationException error) => error.code,
            'code',
            'workspace_access_denied',
          ),
        ),
      );
    },
  );

  test(
    'resolves Supabase users through the authoritative membership',
    () async {
      final _FakeMembershipResolver resolver = _FakeMembershipResolver(
        membership: const WorkspaceMembership(
          workspaceId: workspaceId,
          role: WorkspaceMembershipRole.admin,
        ),
      );
      final RequestAuthenticationService service = RequestAuthenticationService(
        supabaseVerifier: const _FakeSupabaseVerifier(userId),
        membershipResolver: resolver,
        allowPocBearer: false,
        pocBearer: null,
        pocWorkspaceId: 'pinkall-poc',
        snapshotWorkspaceId: workspaceId,
      );
      await service.initialize();

      final AuthPrincipal principal = await service.authenticate(
        token: 'signed-jwt',
        requestedWorkspaceId: workspaceId,
      );

      expect(principal.userId, userId);
      expect(principal.workspaceId, workspaceId);
      expect(principal.mode, AuthMode.supabaseJwt);
      expect(principal.membershipRole, WorkspaceMembershipRole.admin);
      expect(resolver.lastUserId, userId);
      expect(resolver.lastSessionId, sessionId);
      expect(resolver.lastRequestedWorkspaceId, workspaceId);
      expect(resolver.initialized, isTrue);
      await service.dispose();
      expect(resolver.disposed, isTrue);
    },
  );

  test('rejects a membership outside the snapshot-bound workspace', () async {
    final RequestAuthenticationService service = RequestAuthenticationService(
      supabaseVerifier: const _FakeSupabaseVerifier(userId),
      membershipResolver: _FakeMembershipResolver(
        membership: const WorkspaceMembership(
          workspaceId: otherWorkspaceId,
          role: WorkspaceMembershipRole.member,
        ),
      ),
      allowPocBearer: false,
      pocBearer: null,
      pocWorkspaceId: 'pinkall-poc',
      snapshotWorkspaceId: workspaceId,
    );

    await expectLater(
      service.authenticate(
        token: 'signed-jwt',
        requestedWorkspaceId: otherWorkspaceId,
      ),
      throwsA(
        isA<AuthenticationException>().having(
          (AuthenticationException error) => error.code,
          'code',
          'workspace_not_available_on_snapshot_store',
        ),
      ),
    );
  });

  test('rejects Supabase tokens without an active session binding', () async {
    final RequestAuthenticationService service = RequestAuthenticationService(
      supabaseVerifier: const _SessionlessSupabaseVerifier(userId),
      membershipResolver: _FakeMembershipResolver(
        membership: const WorkspaceMembership(
          workspaceId: workspaceId,
          role: WorkspaceMembershipRole.owner,
        ),
      ),
      allowPocBearer: false,
      pocBearer: null,
      pocWorkspaceId: 'pinkall-poc',
      snapshotWorkspaceId: workspaceId,
    );

    await expectLater(
      service.authenticate(token: 'signed-jwt', requestedWorkspaceId: null),
      throwsA(
        isA<AuthenticationException>().having(
          (AuthenticationException error) => error.code,
          'code',
          'invalid_access_token',
        ),
      ),
    );
  });

  test('fails closed when no authentication strategy is configured', () async {
    const RequestAuthenticationService service = RequestAuthenticationService(
      supabaseVerifier: null,
      membershipResolver: null,
      allowPocBearer: false,
      pocBearer: null,
      pocWorkspaceId: 'pinkall-poc',
      snapshotWorkspaceId: null,
    );

    await expectLater(
      service.authenticate(token: 'anything', requestedWorkspaceId: null),
      throwsA(
        isA<AuthenticationException>().having(
          (AuthenticationException error) => error.code,
          'code',
          'auth_not_configured',
        ),
      ),
    );
  });
}

final class _FakeSupabaseVerifier implements SupabaseAccessTokenVerifier {
  const _FakeSupabaseVerifier(this.userId);

  final String userId;

  @override
  Future<VerifiedSupabaseAccessToken> verify(String token) async {
    return VerifiedSupabaseAccessToken(
      userId: userId,
      sessionId: '44444444-4444-4444-8444-444444444444',
    );
  }
}

final class _SessionlessSupabaseVerifier
    implements SupabaseAccessTokenVerifier {
  const _SessionlessSupabaseVerifier(this.userId);

  final String userId;

  @override
  Future<VerifiedSupabaseAccessToken> verify(String token) async {
    return VerifiedSupabaseAccessToken(userId: userId, sessionId: null);
  }
}

final class _FakeMembershipResolver implements WorkspaceMembershipResolver {
  _FakeMembershipResolver({required this.membership});

  final WorkspaceMembership membership;
  bool initialized = false;
  bool disposed = false;
  String? lastUserId;
  String? lastSessionId;
  String? lastRequestedWorkspaceId;

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<WorkspaceMembership> resolve({
    required String userId,
    required String sessionId,
    required String? requestedWorkspaceId,
  }) async {
    lastUserId = userId;
    lastSessionId = sessionId;
    lastRequestedWorkspaceId = requestedWorkspaceId;
    return membership;
  }

  @override
  Future<void> dispose() async {
    disposed = true;
  }
}
