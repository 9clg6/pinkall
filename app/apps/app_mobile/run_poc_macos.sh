#!/usr/bin/env bash

set -euo pipefail

readonly keychain_account="pinkall-poc"
readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly project_root="$(cd "${script_dir}/../.." && pwd)"

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

readonly api_base_url="${PINKALL_API_BASE_URL:-$(ngrok_public_url)}"
readonly ws_base_url="${PINKALL_WS_BASE_URL:-${api_base_url/https:/wss:}}"
readonly api_token="$(keychain_value com.pinkall.api-token)"
cd "${script_dir}"

export PINKALL_API_TOKEN="${api_token}"

exec "${project_root}/tool/flutter.sh" run -d macos \
  --dart-define="PINKALL_API_BASE_URL=${api_base_url}" \
  --dart-define="PINKALL_WS_BASE_URL=${ws_base_url}"
