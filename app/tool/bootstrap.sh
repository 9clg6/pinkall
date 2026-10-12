#!/usr/bin/env bash

set -euo pipefail

readonly project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "${project_root}"
"${project_root}/tool/flutter.sh" pub get
"${project_root}/tool/flutter.sh" precache --macos

echo "Pinkall est prêt avec Flutter 3.44.3 / Dart 3.12.2."
