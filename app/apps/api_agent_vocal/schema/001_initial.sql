-- Target relational SaaS schema. It is intentionally NOT used by the current
-- PostgreSQL snapshot POC; see 002_poc_snapshot.sql. Migrating snapshots into
-- these normalized tables remains required before multi-instance production.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE workspaces (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
  external_subject text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (workspace_id, external_subject)
);

CREATE TABLE contacts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
  phone_e164 text NOT NULL,
  name text,
  company text,
  email text,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (workspace_id, phone_e164)
);

CREATE TABLE call_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL REFERENCES workspaces(id) ON DELETE CASCADE,
  owner_user_id uuid NOT NULL REFERENCES users(id),
  contact_id uuid REFERENCES contacts(id),
  external_call_id text NOT NULL,
  destination_e164 text NOT NULL,
  status text NOT NULL,
  coach_mode text NOT NULL CHECK (coach_mode IN ('off', 'shadow', 'live')),
  seller_track text NOT NULL CHECK (seller_track IN ('inbound', 'outbound')),
  telnyx_stream_id text,
  telnyx_call_control_id text,
  telnyx_call_session_id text,
  telnyx_agent_call_control_id text,
  telnyx_agent_call_session_id text,
  telnyx_pstn_call_control_id text,
  telnyx_pstn_call_session_id text,
  telnyx_outbound_dial_reserved boolean NOT NULL DEFAULT false,
  media_token_hash bytea NOT NULL,
  media_encoding text,
  media_sample_rate integer,
  transcription_allowed boolean NOT NULL DEFAULT false,
  transcription_consent_method text,
  transcription_consent_at timestamptz,
  outcome text,
  failure text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE transcript_segments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL REFERENCES call_sessions(id) ON DELETE CASCADE,
  track text NOT NULL CHECK (track IN ('inbound', 'outbound')),
  speaker text NOT NULL CHECK (speaker IN ('seller', 'prospect')),
  text text NOT NULL,
  start_seconds double precision NOT NULL,
  end_seconds double precision NOT NULL,
  is_final boolean NOT NULL,
  provider text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX transcript_segments_session_time_idx
  ON transcript_segments(session_id, start_seconds, created_at);

CREATE TABLE coaching_exposures (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL REFERENCES call_sessions(id) ON DELETE CASCADE,
  recommendation_id text NOT NULL,
  mode text NOT NULL CHECK (mode IN ('shadow', 'live')),
  confidence double precision NOT NULL CHECK (confidence BETWEEN 0 AND 1),
  exposed_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE coaching_feedback (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  exposure_id uuid NOT NULL REFERENCES coaching_exposures(id) ON DELETE CASCADE,
  useful boolean NOT NULL,
  used boolean NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE coach_preferences (
  user_id uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  preferences jsonb NOT NULL DEFAULT '{}'::jsonb,
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE processed_telnyx_events (
  event_id text PRIMARY KEY,
  session_id uuid REFERENCES call_sessions(id) ON DELETE SET NULL,
  processed_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE contacts ENABLE ROW LEVEL SECURITY;
ALTER TABLE call_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE transcript_segments ENABLE ROW LEVEL SECURITY;
ALTER TABLE coaching_exposures ENABLE ROW LEVEL SECURITY;
ALTER TABLE coaching_feedback ENABLE ROW LEVEL SECURITY;
ALTER TABLE coach_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE processed_telnyx_events ENABLE ROW LEVEL SECURITY;

-- Application-specific RLS policies must be installed together with the real
-- authentication and PostgreSQL adapter. No permissive policy is supplied.
