import 'package:api_agent_vocal/src/domain/auth_contracts.dart';

/// Composes Supabase JWT authentication with an explicit POC compatibility
/// path while keeping every accepted request bound to one workspace.
final class RequestAuthenticationService implements RequestAuthenticator {
  const RequestAuthenticationService({
    required this.supabaseVerifier,
    required this.membershipResolver,
    required this.allowPocBearer,
    required this.pocBearer,
    required this.pocWorkspaceId,
    required this.snapshotWorkspaceId,
  });

  /// Supabase verifier, absent while the SaaS auth mode is disabled.
  final SupabaseAccessTokenVerifier? supabaseVerifier;

  /// Authoritative membership resolver required with [supabaseVerifier].
  final WorkspaceMembershipResolver? membershipResolver;

  /// Whether the legacy shared token may still authenticate a request.
  final bool allowPocBearer;

  /// Legacy shared token. It is never exposed in diagnostics.
  final String? pocBearer;

  /// Stable workspace identity used by the mono-workspace POC path.
  final String pocWorkspaceId;

  /// Workspace UUID currently bound to the legacy snapshot store.
  ///
  /// Supabase users from other workspaces are rejected until the relational
  /// call/session store replaces the global JSON snapshot.
  final String? snapshotWorkspaceId;

  @override
  Future<void> initialize() async {
    if (supabaseVerifier != null && membershipResolver == null) {
      throw StateError(
        'Supabase JWT authentication requires a workspace membership resolver.',
      );
    }
    await membershipResolver?.initialize();
  }

  @override
  Future<AuthPrincipal> authenticate({
    required String token,
    required String? requestedWorkspaceId,
  }) async {
    if (allowPocBearer &&
        pocBearer != null &&
        _constantTimeEquals(pocBearer!, token)) {
      if (requestedWorkspaceId != null &&
          requestedWorkspaceId != pocWorkspaceId) {
        throw const AuthenticationException(
          'workspace_access_denied',
          'The POC bearer is restricted to its configured workspace.',
        );
      }
      return AuthPrincipal(
        userId: 'pinkall-poc-service',
        workspaceId: pocWorkspaceId,
        mode: AuthMode.pocBearer,
        membershipRole: WorkspaceMembershipRole.owner,
      );
    }

    final SupabaseAccessTokenVerifier? verifier = supabaseVerifier;
    final WorkspaceMembershipResolver? resolver = membershipResolver;
    if (verifier == null || resolver == null) {
      final String code = allowPocBearer && pocBearer != null
          ? 'invalid_access_token'
          : 'auth_not_configured';
      throw AuthenticationException(
        code,
        code == 'auth_not_configured'
            ? 'No request authentication strategy is configured.'
            : 'The bearer token is invalid.',
      );
    }

    final VerifiedSupabaseAccessToken verified = await verifier.verify(token);
    final String? sessionId = verified.sessionId;
    if (sessionId == null) {
      throw const AuthenticationException(
        'invalid_access_token',
        'The Supabase access token is not bound to an active session.',
      );
    }
    final WorkspaceMembership membership = await resolver.resolve(
      userId: verified.userId,
      sessionId: sessionId,
      requestedWorkspaceId: requestedWorkspaceId,
    );
    final String? boundWorkspace = snapshotWorkspaceId;
    if (boundWorkspace == null || membership.workspaceId != boundWorkspace) {
      throw const AuthenticationException(
        'workspace_not_available_on_snapshot_store',
        'This API instance is not bound to the authorized workspace.',
      );
    }
    return AuthPrincipal(
      userId: verified.userId,
      workspaceId: membership.workspaceId,
      mode: AuthMode.supabaseJwt,
      membershipRole: membership.role,
    );
  }

  @override
  Future<void> dispose() async {
    await membershipResolver?.dispose();
  }

  static bool _constantTimeEquals(String expected, String actual) {
    int difference = expected.length ^ actual.length;
    final int maximumLength = expected.length > actual.length
        ? expected.length
        : actual.length;
    for (int index = 0; index < maximumLength; index += 1) {
      final int expectedCode = index < expected.length
          ? expected.codeUnitAt(index)
          : 0;
      final int actualCode = index < actual.length
          ? actual.codeUnitAt(index)
          : 0;
      difference |= expectedCode ^ actualCode;
    }
    return difference == 0;
  }
}
