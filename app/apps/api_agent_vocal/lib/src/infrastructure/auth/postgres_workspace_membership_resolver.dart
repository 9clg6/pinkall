import 'package:api_agent_vocal/src/domain/auth_contracts.dart';
import 'package:postgres/postgres.dart';

/// Resolves authenticated workspace access from the normalized Supabase
/// membership tables.
final class PostgresWorkspaceMembershipResolver
    implements WorkspaceMembershipResolver {
  PostgresWorkspaceMembershipResolver(
    String databaseUrl, {
    String? sslRootCertificatePath,
  }) : _pool = Pool<Object?>.withUrl(
         _withPoolDefaults(databaseUrl, sslRootCertificatePath),
       );

  final Pool<Object?> _pool;

  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
    caseSensitive: false,
  );

  @override
  Future<void> initialize() async {
    final Result result = await _pool.execute('''
SELECT
  to_regclass('public.pinkall_workspace_members')::text AS membership_table,
  to_regclass('auth.sessions')::text AS sessions_table
''', queryMode: QueryMode.simple);
    final Map<String, Object?> tables = result.first.toColumnMap();
    if (tables['membership_table'] == null ||
        tables['sessions_table'] == null) {
      throw StateError(
        'Supabase Auth sessions and the Pinkall workspace migration are '
        'required before enabling JWT authentication.',
      );
    }
  }

  @override
  Future<WorkspaceMembership> resolve({
    required String userId,
    required String sessionId,
    required String? requestedWorkspaceId,
  }) async {
    final String safeUserId = _validatedUuid(userId, 'userId');
    final String safeSessionId = _validatedUuid(sessionId, 'sessionId');
    final String? safeWorkspaceId = requestedWorkspaceId == null
        ? null
        : _validatedUuid(requestedWorkspaceId, 'requestedWorkspaceId');
    final String workspaceFilter = safeWorkspaceId == null
        ? ''
        : "AND members.workspace_id = '$safeWorkspaceId'::uuid";
    final int limit = safeWorkspaceId == null ? 2 : 1;
    final Result result = await _pool.execute('''
SELECT
  members.workspace_id::text AS workspace_id,
  members.role,
  members.is_default
FROM public.pinkall_workspace_members AS members
JOIN public.pinkall_workspaces AS workspaces
  ON workspaces.id = members.workspace_id
JOIN auth.sessions AS sessions
  ON sessions.id = '$safeSessionId'::uuid
  AND sessions.user_id = members.user_id
  AND (sessions.not_after IS NULL OR sessions.not_after > now())
WHERE members.user_id = '$safeUserId'::uuid
  AND workspaces.status = 'active'
  $workspaceFilter
ORDER BY members.is_default DESC, members.created_at, members.workspace_id
LIMIT $limit
''', queryMode: QueryMode.simple);
    if (result.isEmpty) {
      throw const AuthenticationException(
        'workspace_access_denied',
        'No active Pinkall workspace membership was found.',
      );
    }
    final Map<String, Object?> first = result.first.toColumnMap();
    if (safeWorkspaceId == null &&
        result.length > 1 &&
        first['is_default'] != true) {
      throw const AuthenticationException(
        'workspace_required',
        'Select a Pinkall workspace explicitly.',
      );
    }
    final Object? rawWorkspaceId = first['workspace_id'];
    final Object? rawRole = first['role'];
    if (rawWorkspaceId is! String || rawRole is! String) {
      throw const FormatException(
        'The workspace membership query returned invalid data.',
      );
    }
    return WorkspaceMembership(
      workspaceId: _validatedUuid(rawWorkspaceId, 'workspace_id'),
      role: WorkspaceMembershipRole.parse(rawRole),
    );
  }

  @override
  Future<void> dispose() => _pool.close();

  static String _validatedUuid(String value, String field) {
    if (!_uuidPattern.hasMatch(value)) {
      throw FormatException('$field must be a UUID.');
    }
    return value.toLowerCase();
  }

  static String _withPoolDefaults(
    String databaseUrl,
    String? sslRootCertificatePath,
  ) {
    final Uri uri = Uri.parse(databaseUrl);
    final Map<String, String> query = <String, String>{...uri.queryParameters};
    query.putIfAbsent(
      'sslmode',
      () => sslRootCertificatePath == null ? 'require' : 'verify-full',
    );
    if (sslRootCertificatePath != null) {
      query['sslrootcert'] = sslRootCertificatePath;
    }
    query.putIfAbsent('connect_timeout', () => '10');
    query.putIfAbsent('query_timeout', () => '15');
    query.putIfAbsent('max_connection_count', () => '2');
    query.putIfAbsent('max_connection_age', () => '300');
    query.putIfAbsent('application_name', () => 'pinkall-auth');
    return uri.replace(queryParameters: query).toString();
  }
}
