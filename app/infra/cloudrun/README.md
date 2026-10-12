# Pinkall API on Cloud Run

This folder packages the current Dart API for a low-cost POC in Paris
(`europe-west9`). It deliberately separates image construction from service
deployment.

## Safety boundary

The repository requires every deployment to use `--prebuilt`. Cloud Run's
`gcloud run deploy` command does not provide that flag, so this folder contains
**no deployment command or deployment script**. `cloudbuild.yaml` only builds
and pushes an OCI image. `poc.service.template.yaml` is a declarative template
for an approved deployment runner that can enforce the repository rule.

Never change the manifest image back to a tag. Resolve the pushed image digest
and keep the `@sha256:...` reference so the deployed artifact is exactly the
one that was built and reviewed.

## 1. Build locally

Run from `app/`:

```bash
docker build \
  --pull \
  --platform=linux/amd64 \
  --file apps/api_agent_vocal/Dockerfile \
  --tag pinkall-api:local \
  .
```

Cloud Run requires a Linux `amd64` image. The builder is pinned by digest to
the official Dart 3.12.2 image. The Dockerfile isolates the API's production
dependencies from the Flutter workspace and enforces the dedicated
`api-pubspec.lock`; the scratch runtime contains only the compiled server, its
matching native runtime files and the coaching catalogue.

## 2. Build and push with Cloud Build

First create an Artifact Registry Docker repository named `pinkall` in
`europe-west9`. Then submit the `app/` directory with an immutable revision as
the image tag:

```bash
gcloud builds submit \
  --config infra/cloudrun/cloudbuild.yaml \
  --substitutions _IMAGE_TAG=REPLACE_WITH_GIT_SHA \
  .
```

This step is a build/push, not a deployment. Cloud Build currently includes
2,500 free `e2-standard-2` build minutes per month; Artifact Registry includes
0.5 GiB of storage before paid usage.

## 3. Prepare the service template

Copy `poc.service.template.yaml` outside the tracked template and replace all
`__PLACEHOLDER__` values:

- GCP project ID and the pushed image's digest;
- a stable `PINKALL_STORAGE_TENANT_ID` unique to this POC workspace;
- the final HTTPS Cloud Run URL in `PUBLIC_BASE_URL` (Telnyx uses it for
  callbacks and media streaming);
- distinct Telnyx WebRTC and Call Control connection IDs;
- the Telnyx telephony credential ID, Ed25519 public key, caller name and E.164
  numbers.

The first service creation and `PUBLIC_BASE_URL` therefore need a two-phase
approved rollout, unless a stable custom domain is already available.

The service must be publicly invokable at the Cloud Run IAM layer because
Telnyx cannot present a Google identity token. Pinkall still protects private
routes with `PINKALL_API_TOKEN`, verifies signed Telnyx webhooks and tokenizes
media-stream URLs. Granting the public invoker role is an infrastructure-policy
step and is intentionally not automated here.

## Secrets and service identity

Create these Secret Manager secrets before the approved rollout, each with a
pinned version `1` matching the manifest:

- `pinkall-api-token` — at least 24 random characters;
- `pinkall-database-url` — the PostgreSQL URI, including the password;
- `pinkall-supabase-ca` — the Supabase project CA certificate downloaded from
  Database Settings → SSL Configuration;
- `pinkall-telnyx-api-key`;
- `pinkall-deepgram-api-key` — Flux turn-aware realtime STT only;
- `pinkall-mistral-api-key` — Voxtral final batch STT and realtime fallback;
- `pinkall-openai-api-key` — live coach and post-call debrief only.

Grant only the runtime service account
`pinkall-api@PROJECT_ID.iam.gserviceaccount.com` the Secret Manager Secret
Accessor role for those seven secrets. Secret Manager has a small free tier (six
active versions and 10,000 access operations per month), but Cloud Run does not
support regional Secret Manager secrets. Keep call recordings and transcripts
out of Secret Manager.

The service template mounts version `1` of `pinkall-supabase-ca` at
`/etc/pinkall/certs/supabase-ca.crt` and sets `DATABASE_SSL_ROOT_CERT` to that
path. Enable **Enforce SSL** in Supabase before the rollout.

## PostgreSQL: free Supabase POC

Supabase Free is the lowest-friction durable option for this POC. Its current
free tier includes a 500 MB PostgreSQL database, but free projects can pause
after one week without activity and do not include automatic backups. Recheck
the current limits before promising retention to users.

In the Supabase dashboard, open **Connect** and select the shared **Transaction
pooler** URI. It uses an IPv4 endpoint on port `6543`, which is appropriate for
temporary/serverless Cloud Run instances. The direct database endpoint is IPv6
by default; do not copy it blindly into this manifest. Use a URI shaped like
this, with the real values only in Secret Manager:

```text
postgresql://postgres.PROJECT_REF:URL_ENCODED_PASSWORD@aws-0-REGION.pooler.supabase.com:6543/postgres?sslmode=verify-full&max_connection_count=3&connect_timeout=10&query_timeout=15
```

The password must be URL-encoded. `sslmode=verify-full` and the mounted project
CA are mandatory for the hosted connection; `sslmode=require` is rejected in
strict mode because it does not verify the server identity. Supabase
transaction mode does not support prepared statements, so
the Pinkall snapshot repository deliberately uses PostgreSQL's simple query
protocol with strictly validated tenant IDs and base64-encoded JSON values.

At startup, Pinkall creates `pinkall_poc_snapshots` if needed, loads the tenant
snapshot, marks any previously live session as
`interrupted_by_server_restart`, commits that recovery, and only then listens
for HTTP traffic. The same DDL is available in
`apps/api_agent_vocal/schema/002_poc_snapshot.sql`. The POC database role must
therefore own the schema or otherwise be allowed to create this table.

Cloud SQL PostgreSQL in Paris remains a valid paid alternative. It requires an
approved Cloud SQL attachment/service-account change and is not configured by
this template.

## POC runtime choices

- Region: Paris `europe-west9`.
- Request-based billing, one vCPU, 512 MiB.
- Minimum instances `0`, maximum instances `1`.
- HTTP startup probe on `/health`; no periodic liveness probe that would add
  idle probe work.
- Request timeout `3600` seconds, the Cloud Run maximum.
- HTTP/1 to the container; WebSocket upgrade is supported without HTTP/2
  end-to-end mode.
- OpenAI text coach configured but initially off; the client can activate it
  during a call. Deepgram Flux handles realtime STT, Voxtral/Mistral handles
  final batch STT (and the optional live fallback), and
  no audio is sent to OpenAI. `internal_alpha` explicitly enables the POC's small,
  not-yet-reviewed catalogue and must not be presented as public-release
  validation.
- PostgreSQL snapshot storage; the service refuses to start if hydration fails.

Cloud Run's request-based free tier currently covers 180,000 vCPU-seconds,
360,000 GiB-seconds and two million requests per month. At list price, one
active instance with this configuration is roughly `$0.001515` per minute
before free-tier credits. Open WebSockets count as active instance time. Calls
running concurrently on one instance share that compute; provider usage
(Telnyx, Deepgram, Mistral/Voxtral and OpenAI) remains separate.

## Exactly what survives a restart

The versioned JSONB snapshot durably retains:

- CRM contacts;
- session records and terminal statuses;
- final transcript segments;
- post-call debriefs;
- coach preferences, exposure/feedback counters and outcomes.

Durable mutations are coalesced in memory and explicitly awaited at API and
application boundaries. A failed commit returns `503 durability_unavailable`,
degrades `/health`, and remains retryable; it is never reported as successful.
The row revision is optimistic, so a second writer fails instead of silently
overwriting newer state.

The following remain deliberately process-local and are **not resumable**:

- raw/buffered call audio;
- provisional realtime STT deltas;
- active WebSockets, provider handles and event subscriptions;
- Telnyx webhook deduplication memory.

After a crash or scale-to-zero, an active call is restored as failed with
`interrupted_by_server_restart`; Pinkall does not pretend it can resume media.
The snapshot rewrites the tenant's complete durable JSON document at each
flush. This is honest and sufficient for a one-instance POC, but it is not the
normalized or horizontally scalable SaaS storage model.

Keeping `maxScale=1` avoids split live state. The production path is:

1. migrate snapshots into the normalized target schema in
   `schema/001_initial.sql`;
2. store retained audio in object storage only with explicit consent and a
   lifecycle deletion policy;
3. persist Telnyx event idempotency and add durable live-event fan-out;
4. add backups/restore drills, then raise `maxScale`.

A WebSocket is still a Cloud Run request: it can last at most 60 minutes and
clients must reconnect. Session affinity is only best effort. Calls longer than
an hour or strict uninterrupted media requirements eventually justify a
dedicated media worker rather than relying solely on Cloud Run.

## France / Europe boundary

Cloud Run and Cloud SQL can be placed in Paris. With Supabase, choose the
closest suitable EU project region and verify its current contractual data
location; it is a separate provider boundary. Requests to Telnyx, Deepgram,
Mistral and
OpenAI also leave the GCP regional boundary according to each provider's
routing and data-processing terms. Paris hosting alone is therefore not an
end-to-end data-residency guarantee.

Official references:

- [Cloud Run container contract](https://docs.cloud.google.com/run/docs/container-contract)
- [Cloud Run WebSockets](https://docs.cloud.google.com/run/docs/triggering/websockets)
- [Cloud Run request timeout](https://docs.cloud.google.com/run/docs/configuring/request-timeout)
- [Cloud Run pricing](https://cloud.google.com/run/pricing)
- [Cloud Run secrets](https://docs.cloud.google.com/run/docs/configuring/services/secrets)
- [Cloud SQL from Cloud Run](https://docs.cloud.google.com/sql/docs/postgres/connect-run)
- [Supabase database connection modes](https://supabase.com/docs/guides/database/connecting-to-postgres)
- [Supabase pricing and Free limits](https://supabase.com/pricing)
