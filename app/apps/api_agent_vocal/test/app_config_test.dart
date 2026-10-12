import 'package:api_agent_vocal/src/config/app_config.dart';
import 'package:test/test.dart';

const List<String> _providerEndpointVariables = <String>[
  'PUBLIC_BASE_URL',
  'TELNYX_API_BASE_URL',
  'DEEPGRAM_REALTIME_BASE_URL',
  'DEEPGRAM_PRERECORDED_BASE_URL',
  'MISTRAL_REALTIME_BASE_URL',
  'MISTRAL_BATCH_BASE_URL',
  'OPENAI_BASE_URL',
];

Iterable<String> _providerTransportErrors(AppConfig config) {
  return config.validationErrors.where(
    (String error) => _providerEndpointVariables.any(error.startsWith),
  );
}

void main() {
  group('AppConfig', () {
    test('reports missing real providers and durable storage explicitly', () {
      final AppConfig config = AppConfig.fromEnvironment(
        const <String, String>{},
      );

      expect(
        config.validationErrors,
        contains('MISTRAL_API_KEY is required for real transcription.'),
      );
      expect(
        config.validationErrors.join(' '),
        contains('PINKALL_ALLOW_EPHEMERAL_STORE'),
      );
    });

    test('sanitized diagnostics never contain secret values', () {
      const String apiToken = 'pinkall-secret-token-that-must-not-leak';
      const String mistralKey = 'mistral-secret-that-must-not-leak';
      const String deepgramKey = 'deepgram-secret-that-must-not-leak';
      const String openAiKey = 'openai-secret-that-must-not-leak';
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': apiToken,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'PUBLIC_BASE_URL': 'https://pinkall.example',
        'STT_PROVIDER': 'deepgram_flux',
        'DEEPGRAM_API_KEY': deepgramKey,
        'MISTRAL_API_KEY': mistralKey,
        'OPENAI_API_KEY': openAiKey,
        'TELNYX_API_KEY': 'telnyx-secret-that-must-not-leak',
        'TELNYX_TELEPHONY_CREDENTIAL_ID': 'credential-123',
        'TELNYX_PUBLIC_KEY': 'test-public-key',
        'TELNYX_WEBRTC_CONNECTION_ID': 'webrtc-connection-123',
        'TELNYX_CALL_CONTROL_CONNECTION_ID': 'connection-123',
        'TELNYX_FROM_NUMBER': '+33102030405',
        'TELNYX_CALLER_NAME': 'Pinkall',
      });

      final String diagnostic = config.toSanitizedJson().toString();
      expect(diagnostic, isNot(contains(apiToken)));
      expect(diagnostic, isNot(contains(mistralKey)));
      expect(diagnostic, isNot(contains(deepgramKey)));
      expect(diagnostic, isNot(contains(openAiKey)));
      expect(diagnostic, isNot(contains('telnyx-secret-that-must-not-leak')));
      expect(config.validationErrors, isEmpty);
    });

    test('keeps the legacy POC bearer only as an explicit auth mode', () {
      final AppConfig legacy = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': 'legacy-token-with-more-than-24-characters',
      });
      final AppConfig disabled =
          AppConfig.fromEnvironment(const <String, String>{
            'PINKALL_API_TOKEN': 'legacy-token-with-more-than-24-characters',
            'PINKALL_ALLOW_POC_BEARER': 'false',
          });

      expect(legacy.allowPocBearer, isTrue);
      expect(legacy.toSanitizedJson()['poc_bearer_enabled'], isTrue);
      expect(disabled.allowPocBearer, isFalse);
      expect(
        disabled.validationErrors.join(' '),
        contains('SUPABASE_URL/SUPABASE_JWT_ISSUER'),
      );
    });

    test('derives Supabase issuer and JWKS but requires workspace binding', () {
      const String workspaceId = '11111111-1111-4111-8111-111111111111';
      final AppConfig configured =
          AppConfig.fromEnvironment(const <String, String>{
            'SUPABASE_URL': 'https://project.supabase.co',
            'DATABASE_URL':
                'postgresql://user:password@pooler.example.test:5432/postgres'
                '?sslmode=require',
            'PINKALL_STORAGE_TENANT_ID': 'pinkall-poc',
            'PINKALL_SNAPSHOT_WORKSPACE_ID': workspaceId,
          });
      final AppConfig missingBinding =
          AppConfig.fromEnvironment(const <String, String>{
            'SUPABASE_URL': 'https://project.supabase.co',
            'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
          });

      expect(
        configured.supabaseJwtIssuer,
        'https://project.supabase.co/auth/v1',
      );
      expect(
        configured.supabaseJwksUrl,
        'https://project.supabase.co/auth/v1/.well-known/jwks.json',
      );
      expect(configured.supabaseJwtAudience, 'authenticated');
      expect(configured.allowPocBearer, isFalse);
      expect(configured.snapshotWorkspaceId, workspaceId);
      expect(
        configured.validationErrors.join(' '),
        isNot(contains('Supabase workspace memberships')),
      );
      expect(
        missingBinding.validationErrors.join(' '),
        allOf(
          contains('DATABASE_URL'),
          contains('PINKALL_SNAPSHOT_WORKSPACE_ID'),
        ),
      );
    });

    test('strict Supabase auth requires HTTPS issuer and JWKS', () {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'STRICT_CONFIG': 'true',
        'SUPABASE_JWT_ISSUER': 'http://localhost:54321/auth/v1',
        'SUPABASE_JWKS_URL':
            'http://localhost:54321/auth/v1/.well-known/jwks.json',
        'DATABASE_URL':
            'postgresql://user:password@pooler.example.test:5432/postgres'
            '?sslmode=verify-full&sslrootcert=%2Ftmp%2Fca.crt',
        'PINKALL_STORAGE_TENANT_ID': 'pinkall-poc',
        'PINKALL_SNAPSHOT_WORKSPACE_ID': '11111111-1111-4111-8111-111111111111',
      });

      expect(
        config.validationErrors.join(' '),
        allOf(contains('SUPABASE_JWT_ISSUER'), contains('SUPABASE_JWKS_URL')),
      );
    });

    test(
      'configures French Flux realtime with Voxtral-compatible defaults',
      () {
        final AppConfig config =
            AppConfig.fromEnvironment(const <String, String>{
              'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
              'STT_PROVIDER': 'deepgram_flux',
              'DEEPGRAM_API_KEY': 'deepgram-key',
              'MISTRAL_API_KEY': 'mistral-key',
            });

        expect(config.sttProvider, 'deepgram_flux');
        expect(config.deepgramRealtimeBaseUrl, 'wss://api.eu.deepgram.com');
        expect(config.deepgramFluxModel, 'flux-general-multi');
        expect(config.deepgramLanguageHint, 'fr');
        expect(config.deepgramEndOfTurnThreshold, 0.7);
        expect(config.deepgramEagerEndOfTurnThreshold, 0.45);
        expect(config.deepgramEndOfTurnTimeoutMs, 6000);
        expect(
          config.validationErrors.where(
            (String error) =>
                error.startsWith('DEEPGRAM_') || error.startsWith('MISTRAL_'),
          ),
          isEmpty,
        );
        expect(config.toSanitizedJson()['deepgram_api_key_configured'], isTrue);
      },
    );

    test('validates Flux credentials, model and turn detection ranges', () {
      final AppConfig missingKey =
          AppConfig.fromEnvironment(const <String, String>{
            'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
            'STT_PROVIDER': 'deepgram_flux',
            'MISTRAL_API_KEY': 'mistral-key',
          });
      final AppConfig invalid =
          AppConfig.fromEnvironment(const <String, String>{
            'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
            'STT_PROVIDER': 'deepgram_flux',
            'DEEPGRAM_API_KEY': 'deepgram-key',
            'DEEPGRAM_REALTIME_BASE_URL': 'https://api.deepgram.com',
            'DEEPGRAM_FLUX_MODEL': 'nova-3',
            'DEEPGRAM_EOT_THRESHOLD': '0.4',
            'DEEPGRAM_EAGER_EOT_THRESHOLD': '0.95',
            'DEEPGRAM_EOT_TIMEOUT_MS': '12000',
            'MISTRAL_API_KEY': 'mistral-key',
          });

      expect(
        missingKey.validationErrors,
        contains(
          'DEEPGRAM_API_KEY is required when STT_PROVIDER=deepgram_flux.',
        ),
      );
      expect(
        invalid.validationErrors,
        contains(
          'DEEPGRAM_REALTIME_BASE_URL must use wss://; ws:// is allowed only '
          'for loopback hosts when STRICT_CONFIG=false.',
        ),
      );
      expect(
        invalid.validationErrors.join(' '),
        allOf(
          contains('DEEPGRAM_FLUX_MODEL'),
          contains('DEEPGRAM_EOT_THRESHOLD'),
          contains('DEEPGRAM_EAGER_EOT_THRESHOLD'),
          contains('DEEPGRAM_EOT_TIMEOUT_MS'),
        ),
      );
    });

    test('accepts HTTP and WS provider endpoints only on local loopback', () {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'PUBLIC_BASE_URL': 'http://localhost:8080',
        'TELNYX_API_BASE_URL': 'http://127.0.0.1:8081/v2',
        'DEEPGRAM_REALTIME_BASE_URL': 'ws://[::1]:8082',
        'DEEPGRAM_PRERECORDED_BASE_URL': 'http://localhost:8083',
        'MISTRAL_REALTIME_BASE_URL': 'ws://127.0.0.2:8084',
        'MISTRAL_BATCH_BASE_URL': 'http://[::1]:8085',
        'OPENAI_BASE_URL': 'http://localhost:8086/v1',
      });

      expect(_providerTransportErrors(config), isEmpty);
    });

    test('rejects insecure remote provider endpoints outside strict mode', () {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'PUBLIC_BASE_URL': 'http://pinkall.example',
        'TELNYX_API_BASE_URL': 'http://telnyx.example/v2',
        'DEEPGRAM_REALTIME_BASE_URL': 'ws://deepgram.example',
        'DEEPGRAM_PRERECORDED_BASE_URL': 'http://deepgram.example',
        'MISTRAL_REALTIME_BASE_URL': 'ws://mistral.example',
        'MISTRAL_BATCH_BASE_URL': 'http://mistral.example',
        'OPENAI_BASE_URL': 'http://openai.example/v1',
      });

      expect(
        _providerTransportErrors(
          config,
        ).map((String error) => error.split(' ').first),
        containsAll(_providerEndpointVariables),
      );
    });

    test('strict mode rejects insecure provider endpoints on loopback', () {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'STRICT_CONFIG': 'true',
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'PUBLIC_BASE_URL': 'http://localhost:8080',
        'TELNYX_API_BASE_URL': 'http://127.0.0.1:8081/v2',
        'DEEPGRAM_REALTIME_BASE_URL': 'ws://[::1]:8082',
        'DEEPGRAM_PRERECORDED_BASE_URL': 'http://localhost:8083',
        'MISTRAL_REALTIME_BASE_URL': 'ws://127.0.0.2:8084',
        'MISTRAL_BATCH_BASE_URL': 'http://[::1]:8085',
        'OPENAI_BASE_URL': 'http://localhost:8086/v1',
      });

      expect(
        _providerTransportErrors(
          config,
        ).map((String error) => error.split(' ').first),
        containsAll(_providerEndpointVariables),
      );
    });

    test('release channel defaults to strict and diagnoses internal alpha', () {
      final AppConfig strict = AppConfig.fromEnvironment(
        const <String, String>{},
      );
      final AppConfig alpha = AppConfig.fromEnvironment(const <String, String>{
        'COACH_RELEASE_CHANNEL': 'internal_alpha',
      });
      final AppConfig invalid = AppConfig.fromEnvironment(
        const <String, String>{'COACH_RELEASE_CHANNEL': 'public_preview'},
      );

      expect(strict.coachReleaseChannel.wireName, 'strict');
      expect(
        strict.toSanitizedJson()['unreviewed_coach_cards_enabled'],
        isFalse,
      );
      expect(alpha.coachReleaseChannel.wireName, 'internal_alpha');
      expect(alpha.toSanitizedJson()['unreviewed_coach_cards_enabled'], isTrue);
      expect(
        invalid.validationErrors,
        contains('COACH_RELEASE_CHANNEL must be strict or internal_alpha.'),
      );
    });

    test('Mistral is reserved for STT and never configures the coach', () {
      final AppConfig config = AppConfig.fromEnvironment(const <String, String>{
        'MISTRAL_API_KEY': 'mistral-key',
      });

      expect(config.resolvedCoachProvider, 'unavailable');
      expect(config.resolvedPostCallProvider, 'unavailable');
      expect(config.openAiCoachModel, 'gpt-5.4-mini');
      expect(config.openAiPostCallModel, 'gpt-5.4-mini');
      expect(config.openAiCoachReasoningEffort, 'none');
      expect(config.openAiPostCallReasoningEffort, 'low');
    });

    test('OpenAI is the exclusive coach and post-call provider', () {
      final AppConfig openAi = AppConfig.fromEnvironment(const <String, String>{
        'MISTRAL_API_KEY': 'mistral-key',
        'OPENAI_API_KEY': 'openai-key',
        'OPENAI_COACH_MODEL': 'gpt-test',
      });
      final AppConfig forbiddenMistral =
          AppConfig.fromEnvironment(const <String, String>{
            'MISTRAL_API_KEY': 'mistral-key',
            'OPENAI_API_KEY': 'openai-key',
            'COACH_PROVIDER': 'mistral',
            'POST_CALL_PROVIDER': 'mistral',
          });

      expect(openAi.resolvedCoachProvider, 'openai');
      expect(openAi.resolvedPostCallProvider, 'openai');
      expect(forbiddenMistral.resolvedCoachProvider, 'unavailable');
      expect(forbiddenMistral.resolvedPostCallProvider, 'unavailable');
      expect(
        forbiddenMistral.validationErrors,
        contains('COACH_PROVIDER must be openai; Mistral is reserved for STT.'),
      );
      expect(
        forbiddenMistral.validationErrors,
        contains(
          'POST_CALL_PROVIDER must be openai; Mistral is reserved for STT.',
        ),
      );
    });

    test('accepts PostgreSQL snapshot storage only with a stable tenant', () {
      final AppConfig configured =
          AppConfig.fromEnvironment(const <String, String>{
            'DATABASE_URL':
                'postgresql://user:password@pooler.example.test:6543/postgres'
                '?sslmode=require',
            'PINKALL_STORAGE_TENANT_ID': 'workspace-poc-1',
          });
      final AppConfig missingTenant = AppConfig.fromEnvironment(
        const <String, String>{
          'DATABASE_URL': 'postgresql://user:password@db.example.test/postgres',
        },
      );

      expect(
        configured.validationErrors.join(' '),
        isNot(contains('PINKALL_ALLOW_EPHEMERAL_STORE')),
      );
      expect(configured.toSanitizedJson()['storage'], 'postgres_snapshot_poc');
      expect(
        missingTenant.validationErrors.join(' '),
        contains('PINKALL_STORAGE_TENANT_ID'),
      );
      expect(
        configured.toSanitizedJson().toString(),
        isNot(contains('password')),
      );
    });

    test('derives the Render public URL from its external hostname', () {
      final AppConfig renderDefault = AppConfig.fromEnvironment(
        const <String, String>{
          'RENDER_EXTERNAL_HOSTNAME': 'pinkall-api-poc.onrender.com',
        },
      );

      expect(
        renderDefault.publicBaseUrl,
        'https://pinkall-api-poc.onrender.com',
      );
      expect(
        renderDefault.validationErrors,
        isNot(
          contains(
            'PUBLIC_BASE_URL must use https://; http:// is allowed only for '
            'loopback hosts when STRICT_CONFIG=false.',
          ),
        ),
      );
    });

    test('prioritizes the explicit and legacy public URL variables', () {
      final AppConfig legacyRenderUrl =
          AppConfig.fromEnvironment(const <String, String>{
            'RENDER_EXTERNAL_URL': 'https://legacy-pinkall.onrender.com',
            'RENDER_EXTERNAL_HOSTNAME': 'pinkall-api-poc.onrender.com',
          });
      final AppConfig customDomain =
          AppConfig.fromEnvironment(const <String, String>{
            'RENDER_EXTERNAL_URL': 'https://legacy-pinkall.onrender.com',
            'RENDER_EXTERNAL_HOSTNAME': 'pinkall-api-poc.onrender.com',
            'PUBLIC_BASE_URL': 'https://api.pinkall.example',
          });

      expect(
        legacyRenderUrl.publicBaseUrl,
        'https://legacy-pinkall.onrender.com',
      );
      expect(customDomain.publicBaseUrl, 'https://api.pinkall.example');
    });

    test('rejects unsafe Render external hostnames', () {
      const List<String> unsafeHostnames = <String>[
        'https://pinkall-api-poc.onrender.com',
        'pinkall-api-poc.onrender.com/callback',
        'pinkall-api-poc.onrender.com:8443',
        'pinkall-api-poc.onrender.com@attacker.example',
        '-pinkall-api-poc.onrender.com',
      ];

      for (final String hostname in unsafeHostnames) {
        final AppConfig config = AppConfig.fromEnvironment(<String, String>{
          'RENDER_EXTERNAL_HOSTNAME': hostname,
        });

        expect(config.publicBaseUrl, isNull, reason: hostname);
        expect(
          config.validationErrors,
          contains(
            'PUBLIC_BASE_URL must use https://; http:// is allowed only for '
            'loopback hosts when STRICT_CONFIG=false.',
          ),
          reason: hostname,
        );
      }
    });

    test('strict PostgreSQL requires verify-full and a root CA', () {
      const String verifyFullError =
          'DATABASE_URL must set sslmode=verify-full when '
          'STRICT_CONFIG=true.';
      const String missingCaError =
          'DATABASE_SSL_ROOT_CERT or DATABASE_URL sslrootcert is required '
          'when STRICT_CONFIG=true.';
      final AppConfig disabledTls =
          AppConfig.fromEnvironment(const <String, String>{
            'STRICT_CONFIG': 'true',
            'DATABASE_URL':
                'postgresql://user:password@pooler.example.test:5432/postgres'
                '?sslmode=disable',
            'PINKALL_STORAGE_TENANT_ID': 'workspace-poc-1',
          });
      final AppConfig requireTls =
          AppConfig.fromEnvironment(const <String, String>{
            'STRICT_CONFIG': 'true',
            'DATABASE_URL':
                'postgresql://user:password@pooler.example.test:5432/postgres'
                '?sslmode=require',
            'DATABASE_SSL_ROOT_CERT': '/etc/secrets/supabase-ca.crt',
            'PINKALL_STORAGE_TENANT_ID': 'workspace-poc-1',
          });
      final AppConfig missingMode =
          AppConfig.fromEnvironment(const <String, String>{
            'STRICT_CONFIG': 'true',
            'DATABASE_URL':
                'postgresql://user:password@pooler.example.test:5432/postgres',
            'DATABASE_SSL_ROOT_CERT': '/etc/secrets/supabase-ca.crt',
            'PINKALL_STORAGE_TENANT_ID': 'workspace-poc-1',
          });
      final AppConfig missingCa =
          AppConfig.fromEnvironment(const <String, String>{
            'STRICT_CONFIG': 'true',
            'DATABASE_URL':
                'postgresql://user:password@pooler.example.test:5432/postgres'
                '?sslmode=verify-full',
            'PINKALL_STORAGE_TENANT_ID': 'workspace-poc-1',
          });

      expect(disabledTls.validationErrors, contains(verifyFullError));
      expect(requireTls.validationErrors, contains(verifyFullError));
      expect(missingMode.validationErrors, contains(verifyFullError));
      expect(missingCa.validationErrors, contains(missingCaError));
    });

    test('strict PostgreSQL accepts a mounted or URL root CA', () {
      const String mountedCa = '/etc/secrets/supabase-ca.crt';
      final AppConfig environmentCa =
          AppConfig.fromEnvironment(const <String, String>{
            'STRICT_CONFIG': 'true',
            'DATABASE_URL':
                'postgresql://user:password@pooler.example.test:5432/postgres'
                '?sslmode=verify-full',
            'DATABASE_SSL_ROOT_CERT': mountedCa,
            'PINKALL_STORAGE_TENANT_ID': 'workspace-poc-1',
          });
      final AppConfig urlCa = AppConfig.fromEnvironment(const <String, String>{
        'STRICT_CONFIG': 'true',
        'DATABASE_URL':
            'postgresql://user:password@pooler.example.test:5432/postgres'
            '?sslmode=verify-full&sslrootcert=%2Fetc%2Fsecrets%2Fsupabase-ca.crt',
        'PINKALL_STORAGE_TENANT_ID': 'workspace-poc-1',
      });
      final AppConfig relativeCa =
          AppConfig.fromEnvironment(const <String, String>{
            'STRICT_CONFIG': 'true',
            'DATABASE_URL':
                'postgresql://user:password@pooler.example.test:5432/postgres'
                '?sslmode=verify-full',
            'DATABASE_SSL_ROOT_CERT': 'supabase-ca.crt',
            'PINKALL_STORAGE_TENANT_ID': 'workspace-poc-1',
          });

      expect(
        environmentCa.validationErrors.join(' '),
        isNot(contains('PostgreSQL SSL')),
      );
      expect(
        environmentCa.validationErrors.join(' '),
        isNot(contains('sslmode')),
      );
      expect(
        environmentCa
            .toSanitizedJson()['database_ssl_root_certificate_configured'],
        isTrue,
      );
      expect(
        environmentCa.toSanitizedJson().toString(),
        isNot(contains(mountedCa)),
      );
      expect(urlCa.validationErrors.join(' '), isNot(contains('sslmode')));
      expect(
        urlCa.validationErrors.join(' '),
        isNot(contains('absolute path')),
      );
      expect(relativeCa.validationErrors.join(' '), contains('absolute path'));
    });

    test('configures EU prerecorded diarization without exposing its key', () {
      final AppConfig defaults =
          AppConfig.fromEnvironment(const <String, String>{
            'DEEPGRAM_API_KEY': 'deepgram-secret-value',
            'DEEPGRAM_REALTIME_BASE_URL': 'wss://api.eu.deepgram.com',
          });
      final AppConfig invalid =
          AppConfig.fromEnvironment(const <String, String>{
            'DEEPGRAM_PRERECORDED_BASE_URL': 'ftp://api.example.test',
            'DEEPGRAM_DIARIZE_MODEL': 'unknown',
          });

      expect(
        defaults.deepgramPrerecordedBaseUrl,
        'https://api.eu.deepgram.com',
      );
      expect(defaults.deepgramPrerecordedModel, 'nova-3');
      expect(defaults.deepgramDiarizeModel, 'latest');
      expect(
        defaults.toSanitizedJson().toString(),
        isNot(contains('deepgram-secret-value')),
      );
      expect(
        invalid.validationErrors,
        contains(
          'DEEPGRAM_PRERECORDED_BASE_URL must use https://; http:// is allowed '
          'only for loopback hosts when STRICT_CONFIG=false.',
        ),
      );
      expect(
        invalid.validationErrors,
        contains('DEEPGRAM_DIARIZE_MODEL must be latest, v1 or v2.'),
      );
    });
  });
}
