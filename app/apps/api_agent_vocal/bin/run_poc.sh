#!/usr/bin/env bash

set -euo pipefail

readonly keychain_account="pinkall-poc"
readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly project_root="$(cd "${script_dir}/../../.." && pwd)"

keychain_value() {
  /usr/bin/security find-generic-password \
    -w \
    -a "${keychain_account}" \
    -s "$1"
}

ngrok_public_url() {
  /usr/bin/python3 - <<'PY'
import json
import urllib.request

with urllib.request.urlopen("http://127.0.0.1:4040/api/tunnels", timeout=3) as response:
    tunnels = json.load(response).get("tunnels", [])

https_tunnel = next((item for item in tunnels if item.get("proto") == "https"), None)
if https_tunnel is None:
    raise SystemExit("No active ngrok HTTPS tunnel was found.")

print(https_tunnel["public_url"])
PY
}

export PINKALL_API_TOKEN="$(keychain_value com.pinkall.api-token)"
export PINKALL_ALLOW_EPHEMERAL_STORE="${PINKALL_ALLOW_EPHEMERAL_STORE:-true}"
export HOST="${HOST:-0.0.0.0}"
export PORT="${PORT:-8080}"
export PUBLIC_BASE_URL="${PUBLIC_BASE_URL:-$(ngrok_public_url)}"

export TELNYX_API_KEY="$(keychain_value com.pinkall.telnyx.api-key)"
export TELNYX_API_BASE_URL="${TELNYX_API_BASE_URL:-https://api.telnyx.com/v2}"
export TELNYX_TELEPHONY_CREDENTIAL_ID="$(keychain_value com.pinkall.telnyx.telephony-credential-id)"
export TELNYX_PUBLIC_KEY="$(keychain_value com.pinkall.telnyx.public-key)"
export TELNYX_WEBRTC_CONNECTION_ID="$(keychain_value com.pinkall.telnyx.webrtc-connection-id)"
export TELNYX_CALL_CONTROL_CONNECTION_ID="$(keychain_value com.pinkall.telnyx.call-control-connection-id)"
export TELNYX_FROM_NUMBER="$(keychain_value com.pinkall.telnyx.from-number)"
export TELNYX_CALLER_NAME="Pinkall"
export TELNYX_CALLER_NUMBER="${TELNYX_CALLER_NUMBER:-${TELNYX_FROM_NUMBER}}"

export COACH_MODE_DEFAULT="${COACH_MODE_DEFAULT:-off}"
export COACH_PROVIDER="openai"
export POST_CALL_PROVIDER="openai"
export COACH_CATALOG_DIR="${COACH_CATALOG_DIR:-${project_root}/knowledge/coaching}"
export COACH_RELEASE_CHANNEL="${COACH_RELEASE_CHANNEL:-internal_alpha}"
export OPENAI_BASE_URL="${OPENAI_BASE_URL:-https://api.openai.com/v1}"
export OPENAI_COACH_MODEL="${OPENAI_COACH_MODEL:-gpt-5.4-mini}"
export OPENAI_POST_CALL_MODEL="${OPENAI_POST_CALL_MODEL:-${OPENAI_COACH_MODEL}}"
export OPENAI_COACH_REASONING_EFFORT="${OPENAI_COACH_REASONING_EFFORT:-none}"
export OPENAI_POST_CALL_REASONING_EFFORT="${OPENAI_POST_CALL_REASONING_EFFORT:-low}"

if /usr/bin/security find-generic-password \
  -a "${keychain_account}" \
  -s com.pinkall.mistral.api-key >/dev/null 2>&1; then
  export MISTRAL_API_KEY="$(keychain_value com.pinkall.mistral.api-key)"
fi

if /usr/bin/security find-generic-password \
  -a "${keychain_account}" \
  -s com.pinkall.deepgram.api-key >/dev/null 2>&1; then
  export DEEPGRAM_API_KEY="$(keychain_value com.pinkall.deepgram.api-key)"
  export STT_PROVIDER="${STT_PROVIDER:-deepgram_flux}"
else
  export STT_PROVIDER="${STT_PROVIDER:-voxtral}"
  echo "Deepgram absent : Voxtral reste utilisé pour le STT live." >&2
fi

if /usr/bin/security find-generic-password \
  -a "${keychain_account}" \
  -s com.pinkall.openai.api-key >/dev/null 2>&1; then
  export OPENAI_API_KEY="$(keychain_value com.pinkall.openai.api-key)"
else
  echo "OpenAI absent : appels et transcription disponibles, coach désactivé." >&2
fi

cd "${script_dir}/.."

exec "${project_root}/tool/dart.sh" run bin/server.dart
