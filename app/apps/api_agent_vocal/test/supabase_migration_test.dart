import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('Supabase POC migration mirrors the runtime schema contract', () {
    final File schema = _firstExisting(<String>[
      'apps/api_agent_vocal/schema/002_poc_snapshot.sql',
      'schema/002_poc_snapshot.sql',
    ]);
    final File migration = _firstExisting(<String>[
      'supabase/migrations/202607130001_poc_snapshot.sql',
      '../../supabase/migrations/202607130001_poc_snapshot.sql',
    ]);

    final String sql = schema.readAsStringSync();
    expect(migration.readAsStringSync(), sql);
    expect(sql, contains('public.pinkall_poc_snapshots'));
    expect(sql, contains('ENABLE ROW LEVEL SECURITY'));
    expect(sql, contains('FROM anon'));
    expect(sql, contains('FROM authenticated'));
    expect(sql, isNot(contains('CREATE POLICY')));
    expect(sql, isNot(contains('FORCE ROW LEVEL SECURITY')));
  });

  test('SaaS auth migration mirrors its reviewed schema contract', () {
    final File schema = _firstExisting(<String>[
      'apps/api_agent_vocal/schema/003_saas_auth_foundation.sql',
      'schema/003_saas_auth_foundation.sql',
    ]);
    final File migration = _firstExisting(<String>[
      'supabase/migrations/202607140001_saas_auth_foundation.sql',
      '../../supabase/migrations/202607140001_saas_auth_foundation.sql',
    ]);

    final String sql = schema.readAsStringSync();
    expect(migration.readAsStringSync(), sql);
    expect(sql, contains('public.pinkall_workspaces'));
    expect(sql, contains('public.pinkall_workspace_members'));
    expect(sql, contains('REFERENCES auth.users(id)'));
    expect(sql, contains('ENABLE ROW LEVEL SECURITY'));
    expect(sql, contains('TO authenticated'));
    expect(sql, contains('FOR SELECT'));
    expect(sql, contains('(user_id, workspace_id)'));
    expect(sql, contains('WHERE is_default'));
    expect(sql, contains('pinkall_private.pinkall_has_workspace_role'));
    expect(sql, contains('SECURITY DEFINER'));
    expect(sql, contains("SET search_path = ''"));
    expect(sql, contains('REVOKE ALL ON FUNCTION'));
    expect(sql, isNot(contains('raw_user_meta_data')));
    expect(sql, isNot(contains("auth.jwt() -> 'user_metadata'")));
    expect(sql, isNot(contains('FOR INSERT')));
    expect(sql, isNot(contains('FOR UPDATE')));
    expect(sql, isNot(contains('FOR DELETE')));
  });

  test('new Auth users receive an atomic personal workspace membership', () {
    final File schema = _firstExisting(<String>[
      'apps/api_agent_vocal/schema/003_saas_auth_foundation.sql',
      'schema/003_saas_auth_foundation.sql',
    ]);
    final String sql = schema.readAsStringSync();

    expect(sql, contains('pinkall_ensure_personal_workspace'));
    expect(sql, contains('pinkall_bootstrap_auth_user'));
    expect(sql, contains('AFTER INSERT ON auth.users'));
    expect(sql, contains("'owner'"));
    expect(sql, contains('make_default'));
    expect(sql, contains('ON CONFLICT (workspace_id, user_id) DO UPDATE'));
    expect(
      sql,
      contains(
        'REVOKE ALL ON FUNCTION\n'
        '  pinkall_private.pinkall_ensure_personal_workspace(uuid) FROM PUBLIC',
      ),
    );
  });
}

File _firstExisting(List<String> candidates) {
  for (final String path in candidates) {
    final File file = File(path);
    if (file.existsSync()) {
      return file;
    }
  }
  throw StateError('Expected one of these files: ${candidates.join(', ')}');
}
