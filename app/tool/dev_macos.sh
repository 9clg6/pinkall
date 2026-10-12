#!/usr/bin/env bash

set -euo pipefail

readonly project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly runtime_dir="${project_root}/.dart_tool/pinkall-dev"
readonly api_log="${runtime_dir}/api.log"
readonly ngrok_log="${runtime_dir}/ngrok.log"
readonly launch_mode="${1:-debug}"
readonly keychain_account="pinkall-poc"

if [[ "$#" -gt 1 || ("${launch_mode}" != "debug" && "${launch_mode}" != "release") ]]; then
  echo "Usage : ./tool/dev_macos.sh [debug|release]" >&2
  exit 64
fi

mkdir -p "${runtime_dir}"

api_pid=""
ngrok_pid=""

ngrok_has_https_tunnel() {
  /usr/bin/curl --silent --fail \
    http://127.0.0.1:4040/api/tunnels | \
    /usr/bin/python3 -c '
import json
import sys

try:
    tunnels = json.load(sys.stdin).get("tunnels", [])
except (json.JSONDecodeError, AttributeError):
    raise SystemExit(1)

raise SystemExit(
    0 if any(item.get("proto") == "https" for item in tunnels) else 1
)
'
}

keychain_value() {
  /usr/bin/security find-generic-password \
    -w \
    -a "${keychain_account}" \
    -s "$1"
}

cleanup() {
  if [[ -n "${api_pid}" ]]; then
    kill "${api_pid}" >/dev/null 2>&1 || true
  fi
  if [[ -n "${ngrok_pid}" ]]; then
    kill "${ngrok_pid}" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT INT TERM

if ! /usr/bin/curl --silent --fail \
  http://127.0.0.1:4040/api/tunnels >/dev/null 2>&1; then
  if ! command -v ngrok >/dev/null 2>&1; then
    echo "ngrok est requis pour exposer les webhooks Telnyx locaux." >&2
    exit 69
  fi
  ngrok http 8080 --log=stdout >"${ngrok_log}" 2>&1 &
  ngrok_pid="$!"
fi

for _ in {1..80}; do
  if ngrok_has_https_tunnel >/dev/null 2>&1; then
    break
  fi
  sleep 0.25
done

if ! ngrok_has_https_tunnel >/dev/null 2>&1; then
  echo "Le tunnel ngrok n'a pas démarré. Voir ${ngrok_log}." >&2
  exit 70
fi

if /usr/bin/curl --silent --fail \
  http://127.0.0.1:8080/health >/dev/null 2>&1; then
  echo "Le port 8080 répond déjà. Arrête l'ancien backend Pinkall avant de relancer." >&2
  exit 69
fi

"${project_root}/apps/api_agent_vocal/bin/run_poc.sh" >"${api_log}" 2>&1 &
api_pid="$!"

for _ in {1..60}; do
  if /usr/bin/curl --silent --fail \
    http://127.0.0.1:8080/health >/dev/null 2>&1; then
    break
  fi
  if ! kill -0 "${api_pid}" >/dev/null 2>&1; then
    echo "L'API Pinkall s'est arrêtée. Voir ${api_log}." >&2
    exit 70
  fi
  sleep 0.25
done

if ! /usr/bin/curl --silent --fail \
  http://127.0.0.1:8080/health >/dev/null 2>&1; then
  echo "L'API Pinkall ne répond pas. Voir ${api_log}." >&2
  exit 70
fi

echo "API locale prête. Les webhooks Telnyx passent par ngrok."
echo "Logs API : ${api_log}"

if [[ "${launch_mode}" == "release" ]]; then
  (
    cd "${project_root}/apps/app_mobile"
    "${project_root}/tool/flutter.sh" build macos --release
    PINKALL_API_TOKEN="$(keychain_value com.pinkall.api-token)" \
      build/macos/Build/Products/Release/pinkall.app/Contents/MacOS/pinkall
  )
else
  PINKALL_API_BASE_URL="http://127.0.0.1:8080" \
  PINKALL_WS_BASE_URL="ws://127.0.0.1:8080" \
    "${project_root}/apps/app_mobile/run_poc_macos.sh"
fi
