# Pinkall patch

This directory vendors `postgres` 3.5.12 under its BSD-3-Clause license.

Pinkall adds the endpoint hostname to `SecureSocket.secure` and a fail-closed
fallback for managed chains that include their self-signed root. The fallback
accepts only the exact SHA-256 certificate loaded from `sslrootcert`, then
checks the peer certificate validity and DNS common name. It never enables the
driver's permissive `sslmode=require` behavior.

The pool resolver also preserves the configured `SecurityContext` when it
derives per-endpoint connection settings; upstream 3.5.12 otherwise drops it.

Remove this override once the upstream package includes the same fix and the
live Supabase TLS integration test passes against that release.
