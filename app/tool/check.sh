#!/usr/bin/env bash

set -euo pipefail

readonly project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "${project_root}"
/bin/bash -n "${project_root}/tool/run_macos_render.sh"
"${project_root}/tool/dart.sh" format --output=none --set-exit-if-changed \
  apps packages
"${project_root}/tool/dart.sh" analyze
"${project_root}/tool/dart.sh" test apps/api_agent_vocal
(
  cd "${project_root}/packages/core_domain"
  "${project_root}/tool/flutter.sh" test
)
(
  cd "${project_root}/packages/core_data"
  "${project_root}/tool/flutter.sh" test
)
(
  cd "${project_root}/apps/app_mobile"
  # Widget suites change the one Flutter engine view and plugin handlers.
  # Running files concurrently makes those process-wide test surfaces race.
  "${project_root}/tool/flutter.sh" test --concurrency=1
)
(
  cd "${project_root}/apps/app_mobile"
  "${project_root}/tool/flutter.sh" build macos --release
)
(
  cd "${project_root}/apps/app_mobile/macos"
  /usr/bin/env PINKALL_API_TOKEN=native-test-placeholder \
    /usr/bin/xcodebuild -quiet test \
    -workspace Runner.xcworkspace \
    -scheme Runner \
    -configuration Debug \
    -destination platform=macOS \
    CODE_SIGNING_ALLOWED=NO
)

echo "Analyse, tests et build macOS terminés."
