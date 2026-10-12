-- Active PostgreSQL persistence for the single-tenant/single-instance POC.
--
-- This JSONB snapshot is deliberately not presented as the final SaaS schema.
-- The runtime also issues this idempotent DDL during initialization so a fresh
-- Supabase POC can start without a separate migration runner.

CREATE TABLE IF NOT EXISTS public.pinkall_poc_snapshots (
  tenant_id text PRIMARY KEY,
  schema_version integer NOT NULL CHECK (schema_version > 0),
  revision bigint NOT NULL CHECK (revision > 0),
  payload jsonb NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now(),
  CHECK (tenant_id ~ '^[A-Za-z0-9._:-]{1,128}$')
);

COMMENT ON TABLE public.pinkall_poc_snapshots IS
  'Versioned Pinkall POC snapshots; not the normalized SaaS data model.';

-- The Flutter clients never read this table through PostgREST. The server
-- connects with the database owner through a Supabase pooler. Enabling RLS and
-- withholding policies makes the snapshot inaccessible to Supabase's
-- anon/authenticated roles while preserving access for the server owner.
ALTER TABLE public.pinkall_poc_snapshots ENABLE ROW LEVEL SECURITY;

DO $pinkall_supabase_roles$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
    EXECUTE
      'REVOKE ALL ON TABLE public.pinkall_poc_snapshots FROM anon';
  END IF;
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticated') THEN
    EXECUTE
      'REVOKE ALL ON TABLE public.pinkall_poc_snapshots FROM authenticated';
  END IF;
END
$pinkall_supabase_roles$;
