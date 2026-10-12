# Pinkall API on Render

This folder prepares the current Dart API as an always-on Render web service in
Frankfurt. Render only pulls a prebuilt `linux/amd64` OCI image pinned by
digest. It never receives the source as a Docker build context.

## Safety boundary

- `runtime: image` is mandatory. `runtime: docker` would make Render rebuild
  the repository and is forbidden here.
- The image reference must end in `@sha256:<64 lowercase hex characters>`.
  Tags such as `latest`, a Git SHA tag by itself, or a floating release tag are
  not deployable.
- Repository automation must go through `tool/deploy_render.sh --prebuilt`.
  The wrapper rejects a missing flag or a mutable image. Render workspace
  owners can still bypass repository safeguards from the dashboard or direct
  API, so keep owner/API credentials restricted and audit deployments.
- This preparation does not create a Render resource and does not incur cost.

Render supports image-backed web services and private Google Artifact Registry
images. It also supports image digests, health checks, graceful `SIGTERM`, and
WebSockets without a platform-enforced maximum duration. Render can still
replace an instance during maintenance or deployment, so all clients must keep
their existing reconnect logic.

Official references:

- <https://render.com/docs/deploying-an-image>
- <https://render.com/docs/blueprint-spec>
- <https://render.com/docs/health-checks>
- <https://render.com/docs/websocket>
- <https://render.com/docs/configure-environment-variables#secret-files>
- <https://api-docs.render.com/reference/create-deploy>
- <https://supabase.com/docs/guides/platform/ssl-enforcement>

## 1. Build and push the image

The existing Cloud Build configuration builds and pushes only; it never deploys
a service. From `app/`, submit an immutable source revision as the tag:

```bash
gcloud builds submit \
  --config infra/cloudrun/cloudbuild.yaml \
  --substitutions _IMAGE_TAG=REPLACE_WITH_GIT_SHA \
  .
```

Resolve that tag to the registry digest and retain the complete URL shaped as:

```text
europe-west9-docker.pkg.dev/PROJECT_ID/pinkall/pinkall-api@sha256:64_HEX_CHARACTERS
```

The tag is useful for discovery only. Render must receive the digest URL. Keep
that registry object available because Render pulls it again when restarting,
scaling, and rolling back.

## 2. Give Render read-only registry access

In Google Cloud, create a dedicated service account that has only
`roles/artifactregistry.reader` on the `pinkall` repository. Do not reuse the
Cloud Build writer or a project owner account.

In **Render → Workspace Settings → Container Registry Credentials**, add a
Google Artifact Registry credential named exactly `pinkall-gar-reader` with
that read-only service account. Never commit its JSON key.

## 3. Prepare the Blueprint

Copy `poc.blueprint.template.yaml` to a tracked Blueprint file, then replace:

- `__GCP_PROJECT_ID__` with the Google Cloud project ID;
- `__IMAGE_DIGEST_64_HEX__` with the digest only, without the `sha256:` prefix.

Do not replace `runtime: image`, remove the digest, or add `repo`,
`buildCommand`, `dockerfilePath`, or `dockerContext`.

When the Blueprint is first created, Render prompts for every variable marked
`sync: false`. Provide these values:

| Variable | Value / source |
|---|---|
| `PINKALL_API_TOKEN` | New random token of at least 24 characters; also configure it in the Pinkall client. |
| `DATABASE_URL` | Supabase **Shared Session pooler** IPv4 URI on port `5432`, with `sslmode=verify-full`. |
| `PINKALL_STORAGE_TENANT_ID` | Stable POC workspace identifier, for example `pinkall-poc`. |
| `SUPABASE_URL` | Public project URL used to validate invite-only user JWTs. |
| `PINKALL_SNAPSHOT_WORKSPACE_ID` | UUID of the single workspace authorized to access this snapshot instance. |
| `TELNYX_API_KEY` | Server-side Telnyx API key. |
| `TELNYX_TELEPHONY_CREDENTIAL_ID` | Credential connection used to issue Voice SDK JWTs. |
| `TELNYX_PUBLIC_KEY` | Telnyx Ed25519 webhook verification public key. |
| `TELNYX_WEBRTC_CONNECTION_ID` | WebRTC connection ID. |
| `TELNYX_CALL_CONTROL_CONNECTION_ID` | Distinct Call Control connection ID. |
| `TELNYX_FROM_NUMBER` | Pinkall caller number in E.164 format. |
| `TELNYX_CALLER_NAME` | Caller display name. |
| `TELNYX_CALLER_NUMBER` | Caller number in E.164 format. |
| `DEEPGRAM_API_KEY` | Flux turn-aware realtime transcription only; keep server-side. |
| `MISTRAL_API_KEY` | Voxtral final batch transcription and optional realtime fallback. |
| `OPENAI_API_KEY` | Live coach and post-call analysis only. |

Render is a persistent application server, so use Supabase's Shared Session
pooler rather than the Transaction pooler intended for temporary/serverless
clients. The repository still uses PostgreSQL's simple query protocol, which
remains compatible with Session mode.

Download the project's CA certificate from **Supabase → Database Settings →
SSL Configuration**. Then open **Render service → Environment → Secret Files**
and create a file named exactly `supabase-ca.crt` containing that certificate.
Render mounts it at `/etc/secrets/supabase-ca.crt`; the Blueprint already sets:

```text
DATABASE_SSL_ROOT_CERT=/etc/secrets/supabase-ca.crt
```

The Blueprint cannot contain the Secret File contents. If the first automatic
rollout starts before the file is attached, strict startup fails closed. Add
the file, save the service, then redeploy the same reviewed digest through the
`--prebuilt` wrapper. Do not weaken the URI to `sslmode=require`: that encrypts
traffic but does not verify the Supabase server certificate and hostname.

A correctly shaped connection URI is:

```text
postgresql://postgres.PROJECT_REF:URL_ENCODED_PASSWORD@aws-0-REGION.pooler.supabase.com:5432/postgres?sslmode=verify-full
```

`PUBLIC_BASE_URL` is deliberately absent. Render injects
`RENDER_EXTERNAL_URL`, and the API now uses it automatically for Telnyx webhook
and media URLs. After adding a stable custom domain, define
`PUBLIC_BASE_URL=https://api.your-domain.example` explicitly and update the
Telnyx webhook configuration.

Use the Render Blueprint screen with the custom path to this resolved file.
The service must remain `starter`, `frankfurt`, one instance, and image-backed.
One instance is intentional: active media and event subscriptions remain
process-local in the current POC even though completed state is durable in
Supabase.

## 4. Validate before any deployment

Run the repository tests and validate the resolved Blueprint against Render's
schema. Blueprint/API validation is read-only; it requires a Render API key and
workspace ID if performed with Render's API.

Validate the deployment guard locally with a synthetic digest:

```bash
./tool/deploy_render.sh \
  --prebuilt \
  --dry-run \
  --image europe-west9-docker.pkg.dev/example/pinkall/pinkall-api@sha256:0000000000000000000000000000000000000000000000000000000000000000
```

## 5. Deploy a reviewed digest

After the image-backed service exists, copy its `srv-...` ID and create a
Render API key. Keep both outside Git, then invoke only the guarded wrapper:

```bash
/usr/bin/env \
  RENDER_API_KEY='REPLACE_SECURELY' \
  RENDER_SERVICE_ID='srv-REPLACE' \
  ./tool/deploy_render.sh \
  --prebuilt \
  --image 'europe-west9-docker.pkg.dev/PROJECT_ID/pinkall/pinkall-api@sha256:REPLACE_WITH_64_HEX_DIGEST'
```

The Render API request contains `imageUrl`, which is supported only for an
image-backed service and tells Render to deploy that registry artifact. No
source build occurs. Revoke and replace any API key that is exposed in shell
history; in CI, inject it through the secret store instead.

## 6. Verify the rollout

`GET /health` is intentionally public and returns `200` only when the strict
configuration is internally coherent and durable PostgreSQL storage is ready.
It does not perform a paid or end-to-end request against Deepgram, Voxtral,
OpenAI, or Telnyx. Render uses this endpoint before routing traffic.

```bash
curl --fail --silent --show-error \
  https://YOUR_SERVICE.onrender.com/health
```

Then verify authenticated `GET /v1/health` and `GET /v1/config` with the bearer
token. Their sanitized responses must report PostgreSQL storage, Telnyx
token/call-control readiness, Deepgram/Voxtral readiness, and OpenAI
coach/post-call readiness without exposing any secret. The public probe keeps
those diagnostics private. Finally, use a controlled real call/import to smoke
the provider paths; configuration readiness alone is not provider availability.

## WebSocket and shutdown limits

- Use `wss://` for all public WebSockets. Render redirects plain `ws://`, and
  many clients do not follow that redirect during the upgrade.
- Render does not impose a fixed WebSocket duration, but instance replacement,
  networking, or maintenance can break a connection.
- The API's SSE route emits a 20-second heartbeat. Telnyx media supplies
  continuous frames while an active call is carrying audio. The two client
  event WebSockets do not yet originate protocol pings; reconnect/backoff in
  the Flutter client remains required.
- Render receives up to 300 seconds for graceful shutdown. This reduces abrupt
  termination but cannot make an in-flight call resumable on another instance.
- Do not raise `numInstances` above one until active-session fan-out,
  idempotency, and the normalized multi-tenant store are implemented.
