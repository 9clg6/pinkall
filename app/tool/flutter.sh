#!/usr/bin/env bash

set -euo pipefail

readonly project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly pinned_version="3.44.3"

flutter_candidates=(
  "${PINKALL_FLUTTER_BIN:-}"
  "${project_root}/.fvm/flutter_sdk/bin/flutter"
  "${FVM_HOME:-${HOME}/fvm}/versions/${pinned_version}/bin/flutter"
)

for candidate in "${flutter_candidates[@]}"; do
  if [[ -n "${candidate}" && -x "${candidate}" ]]; then
    exec "${candidate}" "$@"
  fi
done

echo "Flutter ${pinned_version} est introuvable." >&2
echo "Installe-le avec FVM ou définis PINKALL_FLUTTER_BIN." >&2
exit 69
