#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./tool/deploy_render.sh --prebuilt --image <registry/repository@sha256:64hex> [--dry-run]

Required environment variables for a real deployment:
  RENDER_API_KEY     Render API key (secret)
  RENDER_SERVICE_ID  Image-backed Render service ID (srv-...)

The wrapper refuses mutable image tags and never asks Render to build source.
EOF
}

prebuilt=false
dry_run=false
image_url=''

while (($# > 0)); do
  case "$1" in
    --prebuilt)
      prebuilt=true
      shift
      ;;
    --image)
      if (($# < 2)); then
        echo 'Missing value after --image.' >&2
        exit 64
      fi
      image_url="$2"
      shift 2
      ;;
    --dry-run)
      dry_run=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 64
      ;;
  esac
done

if [[ "$prebuilt" != true ]]; then
  echo 'Refusing deployment: --prebuilt is mandatory.' >&2
  exit 64
fi

if [[ ! "$image_url" =~ ^[a-zA-Z0-9._:-]+/[a-zA-Z0-9._/-]+@sha256:[a-f0-9]{64}$ ]]; then
  echo 'Refusing deployment: --image must be an immutable @sha256 digest.' >&2
  exit 64
fi

if [[ "$dry_run" == true ]]; then
  echo "Validated prebuilt Render image: ${image_url}"
  exit 0
fi

: "${RENDER_API_KEY:?RENDER_API_KEY is required.}"
: "${RENDER_SERVICE_ID:?RENDER_SERVICE_ID is required.}"

if [[ ! "$RENDER_SERVICE_ID" =~ ^srv-[a-zA-Z0-9]+$ ]]; then
  echo 'RENDER_SERVICE_ID must start with srv-.' >&2
  exit 64
fi

payload="$(printf '{"imageUrl":"%s"}' "$image_url")"
response="$({
  # Feed the authorization header over stdin so the API key never appears in
  # the curl process arguments or the process list.
  printf 'Authorization: Bearer %s\n' "$RENDER_API_KEY" | \
    curl \
      --fail-with-body \
      --silent \
      --show-error \
      --request POST \
      --url "https://api.render.com/v1/services/${RENDER_SERVICE_ID}/deploys" \
      --header 'Accept: application/json' \
      --header 'Content-Type: application/json' \
      --header @- \
      --data "$payload"
} 2>&1)" || {
  echo 'Render rejected the prebuilt deployment request.' >&2
  echo "$response" >&2
  exit 1
}

echo "Render accepted prebuilt image ${image_url}."
echo "$response"
