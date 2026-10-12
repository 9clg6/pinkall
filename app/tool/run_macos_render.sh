#!/usr/bin/env bash

set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly project_root
readonly app_dir="${project_root}/apps/app_mobile"
readonly launch_mode="${1:-debug}"
readonly pinkall_config_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/pinkall"
# Deployment endpoints stay outside the repository: export them or define them
# in ${pinkall_config_dir}/render.env.
if [[ -r "${pinkall_config_dir}/render.env" ]]; then
  # shellcheck disable=SC1091
  source "${pinkall_config_dir}/render.env"
fi
readonly api_base_url="${PINKALL_API_BASE_URL:?Définis PINKALL_API_BASE_URL (ex. https://YOUR_SERVICE.onrender.com)}"
readonly ws_base_url="${PINKALL_WS_BASE_URL:-${api_base_url/#http/ws}}"
readonly supabase_url="${PINKALL_SUPABASE_URL:?Définis PINKALL_SUPABASE_URL (ex. https://PROJECT_REF.supabase.co)}"
readonly supabase_keychain_account="pinkall-poc"
readonly supabase_keychain_service="com.pinkall.supabase.publishable-key"
readonly release_binary="${app_dir}/build/macos/Build/Products/Release/pinkall.app/Contents/MacOS/pinkall"

usage() {
  echo "Usage : ./tool/run_macos_render.sh [debug|release]" >&2
}

if [[ "$#" -gt 1 || ("${launch_mode}" != "debug" && "${launch_mode}" != "release") ]]; then
  usage
  exit 64
fi

# Keep the public client key out of shell history and repository files. It is
# intentionally compiled into the client as a dart-define: Supabase
# publishable keys are public and must be protected by Auth/RLS, never treated
# like a backend secret or a service-role key.
supabase_publishable_key="$(
  /usr/bin/security find-generic-password \
    -w \
    -a "${supabase_keychain_account}" \
    -s "${supabase_keychain_service}" 2>/dev/null || true
)"
readonly supabase_publishable_key

if [[ ! "${supabase_publishable_key}" =~ ^sb_publishable_[A-Za-z0-9_-]+$ ]]; then
  echo "Clé publique Supabase Pinkall absente ou invalide dans le Trousseau." >&2
  echo "Compte attendu : ${supabase_keychain_account}" >&2
  echo "Service attendu : ${supabase_keychain_service}" >&2
  exit 78
fi

if ! /usr/bin/curl \
  --silent \
  --show-error \
  --fail \
  --connect-timeout 10 \
  --max-time 30 \
  "${api_base_url}/health" | \
  /usr/bin/python3 -c '
import json
import sys

try:
    health = json.load(sys.stdin)
except (json.JSONDecodeError, UnicodeDecodeError):
    raise SystemExit(1)

raise SystemExit(0 if health.get("ready") is True else 1)
'; then
  echo "L'API Pinkall Render n'est pas prête : ${api_base_url}/health" >&2
  exit 69
fi

echo "API Pinkall Render prête : ${api_base_url}"
echo "Authentification Supabase sur invitation activée."

# Never let a stale development bearer override the invite-only client.
unset PINKALL_API_TOKEN

readonly -a flutter_defines=(
  "--dart-define=PINKALL_API_BASE_URL=${api_base_url}"
  "--dart-define=PINKALL_WS_BASE_URL=${ws_base_url}"
  "--dart-define=PINKALL_SUPABASE_URL=${supabase_url}"
  "--dart-define=PINKALL_SUPABASE_PUBLISHABLE_KEY=${supabase_publishable_key}"
)

if [[ "${launch_mode}" == "release" ]]; then
  (
    cd "${app_dir}"
    "${project_root}/tool/flutter.sh" build macos --release \
      "${flutter_defines[@]}"
  )

  if [[ ! -x "${release_binary}" ]]; then
    echo "Binaire macOS Release introuvable : ${release_binary}" >&2
    exit 70
  fi

  exec "${release_binary}"
fi

cd "${app_dir}"
exec "${project_root}/tool/flutter.sh" run -d macos \
  "${flutter_defines[@]}"
