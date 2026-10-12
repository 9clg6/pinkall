/// Authentication source attached to an authenticated request.
enum AuthMode {
  /// Temporary shared bearer retained only for the single-workspace POC.
  pocBearer('poc_bearer'),

  /// Supabase user access token verified against the project's JWKS.
  supabaseJwt('supabase_jwt');

  const AuthMode(this.wireName);

  /// Stable value exposed in transport diagnostics.
  final String wireName;
}

/// Workspace role resolved from the durable membership table.
enum WorkspaceMembershipRole {
  owner,
  admin,
  member;

  /// Parses the constrained PostgreSQL representation.
  static WorkspaceMembershipRole parse(String value) {
    return WorkspaceMembershipRole.values.firstWhere(
      (WorkspaceMembershipRole role) => role.name == value,
      orElse: () =>
          throw FormatException('Unsupported Pinkall workspace role: $value.'),
    );
  }
}

/// Authenticated request identity after signature and workspace checks.
final class AuthPrincipal {
  const AuthPrincipal({
    required this.userId,
    required this.workspaceId,
    required this.mode,
    required this.membershipRole,
  });

  /// Supabase user UUID, or the stable POC service identity.
  final String userId;

  /// Workspace that every downstream operation must remain scoped to.
  final String workspaceId;

  /// Authentication strategy that produced this principal.
  final AuthMode mode;

  /// Authorization role inside [workspaceId].
  final WorkspaceMembershipRole membershipRole;
}

/// Minimal claims trusted after a Supabase access token is fully verified.
final class VerifiedSupabaseAccessToken {
  const VerifiedSupabaseAccessToken({
    required this.userId,
    required this.sessionId,
  });

  /// Supabase `auth.users.id` from the signed `sub` claim.
  final String userId;

  /// Supabase Auth session identifier when present in the token.
  final String? sessionId;
}

/// Durable workspace membership selected for one authenticated user.
final class WorkspaceMembership {
  const WorkspaceMembership({required this.workspaceId, required this.role});

  /// Authorized workspace UUID.
  final String workspaceId;

  /// Role granted by `pinkall_workspace_members`.
  final WorkspaceMembershipRole role;
}

/// Stable authentication failure used internally by the HTTP middleware.
final class AuthenticationException implements Exception {
  const AuthenticationException(this.code, this.message);

  /// Machine-readable diagnostic that is never returned with token details.
  final String code;

  /// Operator-facing explanation without credentials or claims.
  final String message;

  @override
  String toString() => 'AuthenticationException($code, $message)';
}

/// Verifies a Supabase access token before any claim can be trusted.
abstract interface class SupabaseAccessTokenVerifier {
  /// Verifies signature, algorithm, issuer, audience and temporal claims.
  Future<VerifiedSupabaseAccessToken> verify(String token);
}

/// Resolves workspace access from the authoritative membership table.
abstract interface class WorkspaceMembershipResolver {
  /// Checks that the relational auth foundation exists and is reachable.
  Future<void> initialize();

  /// Resolves an explicit workspace, or an unambiguous/default membership.
  Future<WorkspaceMembership> resolve({
    required String userId,
    required String sessionId,
    required String? requestedWorkspaceId,
  });

  /// Releases resolver resources.
  Future<void> dispose();
}

/// Authenticates one HTTP bearer and produces a workspace-bound principal.
abstract interface class RequestAuthenticator {
  /// Initializes external authorization dependencies.
  Future<void> initialize();

  /// Verifies [token] and selects an authorized workspace.
  Future<AuthPrincipal> authenticate({
    required String token,
    required String? requestedWorkspaceId,
  });

  /// Releases authentication resources.
  Future<void> dispose();
}
