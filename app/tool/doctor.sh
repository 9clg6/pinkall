#!/usr/bin/env bash

set -euo pipefail

readonly project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly keychain_account="pinkall-poc"

failures=0

check_command() {
  local name="$1"
  if command -v "${name}" >/dev/null 2>&1; then
    echo "✓ ${name}"
  else
    echo "✗ ${name} introuvable"
    failures=$((failures + 1))
  fi
}

check_optional_command() {
  local name="$1"
  if command -v "${name}" >/dev/null 2>&1; then
    echo "✓ ${name}"
  else
    echo "· ${name} absent : requis uniquement pour les smokes conteneur/Cloud Run"
  fi
}

check_secret() {
  local service="$1"
  local label="$2"
  if /usr/bin/security find-generic-password \
    -a "${keychain_account}" \
    -s "${service}" >/dev/null 2>&1; then
    echo "✓ ${label} présent"
  else
    echo "✗ ${label} manquant"
    failures=$((failures + 1))
  fi
}

echo "Pinkall · diagnostic local"
"${project_root}/tool/flutter.sh" --version | /usr/bin/head -n 1
check_command ngrok
check_optional_command docker
check_secret com.pinkall.api-token "Token API Pinkall"
check_secret com.pinkall.telnyx.api-key "Clé Telnyx"
check_secret \
  com.pinkall.telnyx.telephony-credential-id \
  "Credential Telnyx"
check_secret com.pinkall.telnyx.public-key "Clé publique Telnyx"
check_secret \
  com.pinkall.telnyx.webrtc-connection-id \
  "Connexion WebRTC Telnyx"
check_secret \
  com.pinkall.telnyx.call-control-connection-id \
  "Connexion Call Control Telnyx"
check_secret com.pinkall.telnyx.from-number "Numéro d’émission Telnyx"
check_secret com.pinkall.mistral.api-key "Clé Mistral/Voxtral"
check_secret com.pinkall.openai.api-key "Clé OpenAI (coach et débrief)"

if ((failures > 0)); then
  echo "${failures} prérequis obligatoire(s) manquant(s)." >&2
  exit 78
fi

echo "Tous les prérequis obligatoires du POC local sont présents."
