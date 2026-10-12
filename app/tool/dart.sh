#!/usr/bin/env bash

set -euo pipefail

readonly project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly pinned_version="3.44.3"

dart_candidates=(
  "${PINKALL_DART_BIN:-}"
  "${project_root}/.fvm/flutter_sdk/bin/dart"
  "${FVM_HOME:-${HOME}/fvm}/versions/${pinned_version}/bin/dart"
)

for candidate in "${dart_candidates[@]}"; do
  if [[ -n "${candidate}" && -x "${candidate}" ]]; then
    exec "${candidate}" "$@"
  fi
done

echo "Dart fourni avec Flutter ${pinned_version} est introuvable." >&2
echo "Installe Flutter avec FVM ou définis PINKALL_DART_BIN." >&2
exit 69
