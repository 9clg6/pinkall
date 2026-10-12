-- Pinkall SaaS authentication foundation.
--
-- This migration normalizes workspaces and memberships only. Call sessions,
-- transcripts and debriefs still live in the mono-workspace POC snapshot.

CREATE SCHEMA IF NOT EXISTS pinkall_private;
REVOKE ALL ON SCHEMA pinkall_private FROM PUBLIC;

CREATE TABLE IF NOT EXISTS public.pinkall_workspaces (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug text NOT NULL UNIQUE,
  name text NOT NULL,
  status text NOT NULL DEFAULT 'active',
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT pinkall_workspaces_slug_format CHECK (
    length(slug) BETWEEN 3 AND 63
    AND slug ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'
  ),
  CONSTRAINT pinkall_workspaces_name_length CHECK (
    length(btrim(name)) BETWEEN 1 AND 120
  ),
  CONSTRAINT pinkall_workspaces_status_check CHECK (
    status IN ('active', 'archived')
  ),
  CONSTRAINT pinkall_workspaces_timestamps_check CHECK (
    updated_at >= created_at
  )
);

CREATE TABLE IF NOT EXISTS public.pinkall_workspace_members (
  workspace_id uuid NOT NULL
    REFERENCES public.pinkall_workspaces(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role text NOT NULL DEFAULT 'member',
  is_default boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (workspace_id, user_id),
  CONSTRAINT pinkall_workspace_members_role_check CHECK (
    role IN ('owner', 'admin', 'member')
  ),
  CONSTRAINT pinkall_workspace_members_timestamps_check CHECK (
    updated_at >= created_at
  )
);

COMMENT ON TABLE public.pinkall_workspaces IS
  'Pinkall SaaS workspaces. Calls are not normalized into this schema yet.';
COMMENT ON TABLE public.pinkall_workspace_members IS
  'Authoritative Pinkall user-to-workspace roles; never derived from user_metadata.';

-- The primary key already indexes (workspace_id, user_id). This inverse index
-- supports membership resolution and auth.uid()-based RLS policies.
CREATE INDEX IF NOT EXISTS pinkall_workspace_members_user_workspace_idx
  ON public.pinkall_workspace_members (user_id, workspace_id);
CREATE UNIQUE INDEX IF NOT EXISTS pinkall_workspace_members_one_default_idx
  ON public.pinkall_workspace_members (user_id)
  WHERE is_default;
CREATE INDEX IF NOT EXISTS pinkall_workspaces_created_by_idx
  ON public.pinkall_workspaces (created_by);

-- Atomically provisions the personal workspace used by a new Auth user. The
-- same idempotent helper is available to the database owner for a targeted
-- backfill of an existing user; it is never executable by client roles.
CREATE OR REPLACE FUNCTION pinkall_private.pinkall_ensure_personal_workspace(
  target_user_id uuid
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
DECLARE
  personal_slug text;
  resolved_workspace_id uuid;
  make_default boolean;
BEGIN
  IF target_user_id IS NULL OR NOT EXISTS (
    SELECT 1 FROM auth.users WHERE id = target_user_id
  ) THEN
    RAISE EXCEPTION 'Pinkall user does not exist';
  END IF;

  personal_slug := 'personal-' || replace(target_user_id::text, '-', '');
  INSERT INTO public.pinkall_workspaces (
    slug,
    name,
    status,
    created_by
  ) VALUES (
    personal_slug,
    'Personal workspace',
    'active',
    target_user_id
  )
  ON CONFLICT (slug) DO NOTHING;

  SELECT id INTO resolved_workspace_id
  FROM public.pinkall_workspaces
  WHERE slug = personal_slug
    AND created_by = target_user_id;

  IF resolved_workspace_id IS NULL THEN
    RAISE EXCEPTION 'Pinkall personal workspace slug conflict';
  END IF;

  SELECT NOT EXISTS (
    SELECT 1
    FROM public.pinkall_workspace_members
    WHERE user_id = target_user_id
      AND is_default
  ) INTO make_default;

  INSERT INTO public.pinkall_workspace_members (
    workspace_id,
    user_id,
    role,
    is_default
  ) VALUES (
    resolved_workspace_id,
    target_user_id,
    'owner',
    make_default
  )
  ON CONFLICT (workspace_id, user_id) DO UPDATE
  SET role = 'owner',
      is_default = public.pinkall_workspace_members.is_default
        OR EXCLUDED.is_default,
      updated_at = now();

  RETURN resolved_workspace_id;
END;
$function$;

CREATE OR REPLACE FUNCTION pinkall_private.pinkall_bootstrap_auth_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $function$
BEGIN
  PERFORM pinkall_private.pinkall_ensure_personal_workspace(NEW.id);
  RETURN NEW;
END;
$function$;

REVOKE ALL ON FUNCTION
  pinkall_private.pinkall_ensure_personal_workspace(uuid) FROM PUBLIC;
REVOKE ALL ON FUNCTION
  pinkall_private.pinkall_bootstrap_auth_user() FROM PUBLIC;

DROP TRIGGER IF EXISTS pinkall_bootstrap_auth_user ON auth.users;
CREATE TRIGGER pinkall_bootstrap_auth_user
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION pinkall_private.pinkall_bootstrap_auth_user();

-- Kept outside exposed schemas because SECURITY DEFINER bypasses table RLS.
-- auth.uid() is always checked inside the function, execution is explicitly
-- revoked from PUBLIC/anon, and the search path is empty.
CREATE OR REPLACE FUNCTION pinkall_private.pinkall_has_workspace_role(
  target_workspace_id uuid,
  allowed_roles text[] DEFAULT NULL
)
RETURNS boolean
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = ''
AS $function$
  SELECT (SELECT auth.uid()) IS NOT NULL
    AND EXISTS (
      SELECT 1
      FROM public.pinkall_workspace_members AS members
      WHERE members.workspace_id = target_workspace_id
        AND members.user_id = (SELECT auth.uid())
        AND (allowed_roles IS NULL OR members.role = ANY (allowed_roles))
    );
$function$;

REVOKE ALL ON FUNCTION pinkall_private.pinkall_has_workspace_role(uuid, text[])
  FROM PUBLIC;

ALTER TABLE public.pinkall_workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pinkall_workspace_members ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS pinkall_workspaces_select_member
  ON public.pinkall_workspaces;
CREATE POLICY pinkall_workspaces_select_member
  ON public.pinkall_workspaces
  FOR SELECT
  TO authenticated
  USING (
    (SELECT pinkall_private.pinkall_has_workspace_role(id, NULL))
  );

DROP POLICY IF EXISTS pinkall_workspace_members_select_member
  ON public.pinkall_workspace_members;
CREATE POLICY pinkall_workspace_members_select_member
  ON public.pinkall_workspace_members
  FOR SELECT
  TO authenticated
  USING (
    (SELECT pinkall_private.pinkall_has_workspace_role(workspace_id, NULL))
  );

-- Provisioning and role changes remain server-side transactions. Direct Data
-- API writes are withheld until last-owner and privilege-escalation invariants
-- have dedicated commands.
DO $pinkall_saas_roles$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
    EXECUTE 'REVOKE ALL ON TABLE public.pinkall_workspaces FROM anon';
    EXECUTE 'REVOKE ALL ON TABLE public.pinkall_workspace_members FROM anon';
    EXECUTE
      'REVOKE ALL ON FUNCTION pinkall_private.pinkall_has_workspace_role(uuid, text[]) FROM anon';
    EXECUTE
      'REVOKE ALL ON FUNCTION pinkall_private.pinkall_ensure_personal_workspace(uuid) FROM anon';
    EXECUTE
      'REVOKE ALL ON FUNCTION pinkall_private.pinkall_bootstrap_auth_user() FROM anon';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    EXECUTE 'REVOKE ALL ON TABLE public.pinkall_workspaces FROM authenticated';
    EXECUTE
      'REVOKE ALL ON TABLE public.pinkall_workspace_members FROM authenticated';
    EXECUTE 'GRANT SELECT ON TABLE public.pinkall_workspaces TO authenticated';
    EXECUTE
      'GRANT SELECT ON TABLE public.pinkall_workspace_members TO authenticated';
    EXECUTE 'GRANT USAGE ON SCHEMA pinkall_private TO authenticated';
    EXECUTE
      'GRANT EXECUTE ON FUNCTION pinkall_private.pinkall_has_workspace_role(uuid, text[]) TO authenticated';
    EXECUTE
      'REVOKE ALL ON FUNCTION pinkall_private.pinkall_ensure_personal_workspace(uuid) FROM authenticated';
    EXECUTE
      'REVOKE ALL ON FUNCTION pinkall_private.pinkall_bootstrap_auth_user() FROM authenticated';
  END IF;
END
$pinkall_saas_roles$;
