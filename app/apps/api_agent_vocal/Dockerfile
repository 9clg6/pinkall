# syntax=docker/dockerfile:1.7

# The API is pure Dart even though it lives in a Flutter workspace. Isolate its
# production dependencies so Cloud Build does not download Android and Flutter
# tooling. The official image is pinned by digest and matches the repository's
# Dart 3.12.2 SDK.
FROM dart:3.12.2@sha256:a74253f8c88f341629a471b8706f8f7b9938207248d5f2ac6a8c2d2230b466c0 AS build

WORKDIR /build

# Remove workspace resolution and development dependencies inside the image.
# `api-pubspec.lock` is a production-only lockfile; --enforce-lockfile makes
# dependency drift fail the build instead of silently changing the artifact.
COPY apps/api_agent_vocal/pubspec.yaml /tmp/api-pubspec.yaml
RUN sed '/^resolution: workspace$/d; /^dev_dependencies:/,$d' \
      /tmp/api-pubspec.yaml > /build/pubspec.yaml
COPY third_party/postgres /third_party/postgres
COPY infra/cloudrun/api-pubspec.lock pubspec.lock
RUN dart pub get --enforce-lockfile

COPY apps/api_agent_vocal/bin bin
COPY apps/api_agent_vocal/lib lib
COPY knowledge/coaching /knowledge/coaching

RUN dart compile exe bin/server.dart --output=/build/pinkall-api

# The official Dart image prepares /runtime with the exact libc, resolver and
# CA certificates required by its AOT binaries. A scratch stage keeps the final
# image minimal while avoiding a builder/runtime ABI mismatch.
FROM scratch AS runtime

COPY --from=build /runtime/ /
COPY --from=build --chown=65532:65532 /build/pinkall-api /app/pinkall-api
COPY --from=build --chown=65532:65532 /knowledge/coaching /app/knowledge/coaching

ENV HOST=0.0.0.0 \
    PORT=8080 \
    COACH_CATALOG_DIR=/app/knowledge/coaching

EXPOSE 8080
# Render mounts Secret Files for non-root containers with group 1000 access.
# Keep the dedicated unprivileged UID while joining only that runtime group.
USER 65532:1000
ENTRYPOINT ["/app/pinkall-api"]
