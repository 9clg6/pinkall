import 'dart:io';

import 'package:api_agent_vocal/src/domain/models.dart';

/// Immutable server configuration loaded exclusively from process variables.
final class AppConfig {
  const AppConfig({
    required this.host,
    required this.port,
    required this.apiToken,
    required this.allowPocBearer,
    required this.supabaseJwtIssuer,
    required this.supabaseJwksUrl,
    required this.supabaseJwtAudience,
    required this.snapshotWorkspaceId,
    required this.publicBaseUrl,
    required this.telnyxApiKey,
    required this.telnyxApiBaseUrl,
    required this.telnyxTelephonyCredentialId,
    required this.telnyxPublicKey,
    required this.telnyxWebrtcConnectionId,
    required this.telnyxCallControlConnectionId,
    required this.telnyxFromNumber,
    required this.telnyxCallerName,
    required this.telnyxCallerNumber,
    required this.sttProvider,
    required this.deepgramApiKey,
    required this.deepgramRealtimeBaseUrl,
    required this.deepgramPrerecordedBaseUrl,
    required this.deepgramPrerecordedModel,
    required this.deepgramDiarizeModel,
    required this.deepgramFluxModel,
    required this.deepgramLanguageHint,
    required this.deepgramEndOfTurnThreshold,
    required this.deepgramEagerEndOfTurnThreshold,
    required this.deepgramEndOfTurnTimeoutMs,
    required this.mistralApiKey,
    required this.mistralRealtimeBaseUrl,
    required this.mistralRealtimeModel,
    required this.mistralBatchBaseUrl,
    required this.mistralBatchModel,
    required this.mistralTargetDelayMs,
    required this.coachProvider,
    required this.postCallProvider,
    required this.openAiApiKey,
    required this.openAiBaseUrl,
    required this.openAiCoachModel,
    required this.openAiPostCallModel,
    required this.openAiCoachReasoningEffort,
    required this.openAiPostCallReasoningEffort,
    required this.defaultCoachMode,
    required this.coachReleaseChannel,
    required this.coachReleaseChannelValue,
    required this.coachCatalogDirectory,
    required this.coachMinimumConfidence,
    required this.coachMinimumInterval,
    required this.maxSessionAudioBytes,
    required this.allowEphemeralStore,
    required this.databaseUrl,
    required this.databaseSslRootCertificate,
    required this.storageTenantId,
    required this.strictConfiguration,
  });

  /// Creates a configuration from [Platform.environment].
  factory AppConfig.fromPlatformEnvironment() {
    return AppConfig.fromEnvironment(Platform.environment);
  }

  /// Creates a configuration from an injectable environment map.
  factory AppConfig.fromEnvironment(Map<String, String> environment) {
    String? optional(String name) {
      final String? value = environment[name]?.trim();
      return value == null || value.isEmpty ? null : value;
    }

    int integer(String name, int fallback) {
      return int.tryParse(optional(name) ?? '') ?? fallback;
    }

    double decimal(String name, double fallback) {
      return double.tryParse(optional(name) ?? '') ?? fallback;
    }

    bool boolean(String name, bool fallback) {
      final String? raw = optional(name)?.toLowerCase();
      if (raw == null) {
        return fallback;
      }
      return raw == '1' || raw == 'true' || raw == 'yes';
    }

    String? resolvePublicBaseUrl() {
      final String? explicitUrl = optional('PUBLIC_BASE_URL');
      if (explicitUrl != null) {
        return explicitUrl;
      }

      final String? legacyRenderUrl = optional('RENDER_EXTERNAL_URL');
      if (legacyRenderUrl != null) {
        return legacyRenderUrl;
      }

      final String? renderHostname = optional('RENDER_EXTERNAL_HOSTNAME');
      if (renderHostname == null || renderHostname.length > 253) {
        return null;
      }

      final RegExp dnsLabel = RegExp(
        r'^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$',
        caseSensitive: false,
      );
      final List<String> labels = renderHostname.split('.');
      if (labels.any((String label) => !dnsLabel.hasMatch(label))) {
        return null;
      }

      return Uri(
        scheme: 'https',
        host: renderHostname.toLowerCase(),
      ).toString();
    }

    String resolveDeepgramPrerecordedBaseUrl() {
      final String? explicit = optional('DEEPGRAM_PRERECORDED_BASE_URL');
      if (explicit != null) {
        return explicit;
      }
      final Uri realtime = Uri.parse(
        optional('DEEPGRAM_REALTIME_BASE_URL') ?? 'wss://api.eu.deepgram.com',
      );
      return realtime
          .replace(
            scheme: realtime.scheme == 'ws' ? 'http' : 'https',
            path: '',
            query: null,
            fragment: null,
          )
          .toString();
    }

    String? resolveSupabaseJwtIssuer() {
      final String? explicit = optional('SUPABASE_JWT_ISSUER');
      if (explicit != null) {
        return explicit.replaceFirst(RegExp(r'/+$'), '');
      }
      final String? rawSupabaseUrl = optional('SUPABASE_URL');
      final Uri? supabaseUrl = rawSupabaseUrl == null
          ? null
          : Uri.tryParse(rawSupabaseUrl);
      if (supabaseUrl == null) {
        return null;
      }
      return supabaseUrl
          .replace(path: '/auth/v1', query: null, fragment: null)
          .toString()
          .replaceFirst(RegExp(r'/+$'), '');
    }

    final String? supabaseJwtIssuer = resolveSupabaseJwtIssuer();
    final String? configuredApiToken = optional('PINKALL_API_TOKEN');
    final bool allowPocBearer = boolean(
      'PINKALL_ALLOW_POC_BEARER',
      supabaseJwtIssuer == null && configuredApiToken != null,
    );

    return AppConfig(
      host: optional('HOST') ?? '0.0.0.0',
      port: integer('PORT', 8080),
      apiToken: configuredApiToken,
      allowPocBearer: allowPocBearer,
      supabaseJwtIssuer: supabaseJwtIssuer,
      supabaseJwksUrl:
          optional('SUPABASE_JWKS_URL') ??
          (supabaseJwtIssuer == null
              ? null
              : '$supabaseJwtIssuer/.well-known/jwks.json'),
      supabaseJwtAudience: optional('SUPABASE_JWT_AUDIENCE') ?? 'authenticated',
      snapshotWorkspaceId: optional('PINKALL_SNAPSHOT_WORKSPACE_ID'),
      // Keep explicit and legacy URLs ahead of Render's hostname so custom
      // domains remain supported without a circular first-deploy setup.
      publicBaseUrl: resolvePublicBaseUrl(),
      telnyxApiKey: optional('TELNYX_API_KEY'),
      telnyxApiBaseUrl:
          optional('TELNYX_API_BASE_URL') ?? 'https://api.telnyx.com/v2',
      telnyxTelephonyCredentialId: optional('TELNYX_TELEPHONY_CREDENTIAL_ID'),
      telnyxPublicKey: optional('TELNYX_PUBLIC_KEY'),
      telnyxWebrtcConnectionId: optional('TELNYX_WEBRTC_CONNECTION_ID'),
      telnyxCallControlConnectionId: optional(
        'TELNYX_CALL_CONTROL_CONNECTION_ID',
      ),
      telnyxFromNumber: optional('TELNYX_FROM_NUMBER'),
      telnyxCallerName: optional('TELNYX_CALLER_NAME'),
      telnyxCallerNumber:
          optional('TELNYX_CALLER_NUMBER') ?? optional('TELNYX_FROM_NUMBER'),
      sttProvider: optional('STT_PROVIDER')?.toLowerCase() ?? 'voxtral',
      deepgramApiKey: optional('DEEPGRAM_API_KEY'),
      deepgramRealtimeBaseUrl:
          optional('DEEPGRAM_REALTIME_BASE_URL') ?? 'wss://api.eu.deepgram.com',
      deepgramPrerecordedBaseUrl: resolveDeepgramPrerecordedBaseUrl(),
      deepgramPrerecordedModel:
          optional('DEEPGRAM_PRERECORDED_MODEL') ?? 'nova-3',
      deepgramDiarizeModel: optional('DEEPGRAM_DIARIZE_MODEL') ?? 'latest',
      deepgramFluxModel:
          optional('DEEPGRAM_FLUX_MODEL') ?? 'flux-general-multi',
      deepgramLanguageHint:
          optional('DEEPGRAM_LANGUAGE_HINT') ??
          (optional('DEEPGRAM_FLUX_MODEL') == 'flux-general-en' ? '' : 'fr'),
      deepgramEndOfTurnThreshold: decimal('DEEPGRAM_EOT_THRESHOLD', 0.7),
      deepgramEagerEndOfTurnThreshold: decimal(
        'DEEPGRAM_EAGER_EOT_THRESHOLD',
        0.45,
      ),
      deepgramEndOfTurnTimeoutMs: integer('DEEPGRAM_EOT_TIMEOUT_MS', 6000),
      mistralApiKey: optional('MISTRAL_API_KEY'),
      mistralRealtimeBaseUrl:
          optional('MISTRAL_REALTIME_BASE_URL') ?? 'wss://api.mistral.ai',
      mistralRealtimeModel:
          optional('MISTRAL_REALTIME_MODEL') ??
          'voxtral-mini-transcribe-realtime-2602',
      mistralBatchBaseUrl:
          optional('MISTRAL_BATCH_BASE_URL') ?? 'https://api.mistral.ai',
      mistralBatchModel: optional('MISTRAL_BATCH_MODEL') ?? 'voxtral-mini-2602',
      mistralTargetDelayMs: integer('MISTRAL_TARGET_DELAY_MS', 1000),
      coachProvider: optional('COACH_PROVIDER')?.toLowerCase() ?? 'openai',
      postCallProvider:
          optional('POST_CALL_PROVIDER')?.toLowerCase() ?? 'openai',
      openAiApiKey: optional('OPENAI_API_KEY'),
      openAiBaseUrl: optional('OPENAI_BASE_URL') ?? 'https://api.openai.com/v1',
      openAiCoachModel: optional('OPENAI_COACH_MODEL') ?? 'gpt-5.4-mini',
      openAiPostCallModel:
          optional('OPENAI_POST_CALL_MODEL') ??
          optional('OPENAI_COACH_MODEL') ??
          'gpt-5.4-mini',
      openAiCoachReasoningEffort:
          optional('OPENAI_COACH_REASONING_EFFORT') ?? 'none',
      openAiPostCallReasoningEffort:
          optional('OPENAI_POST_CALL_REASONING_EFFORT') ?? 'low',
      defaultCoachMode: CoachMode.tryParse(
        optional('COACH_MODE_DEFAULT') ?? 'off',
      ),
      coachReleaseChannel: CoachReleaseChannel.parseOrStrict(
        optional('COACH_RELEASE_CHANNEL') ?? 'strict',
      ),
      coachReleaseChannelValue: optional('COACH_RELEASE_CHANNEL') ?? 'strict',
      coachCatalogDirectory: optional('COACH_CATALOG_DIR'),
      coachMinimumConfidence: decimal('COACH_MIN_CONFIDENCE', 0.75),
      coachMinimumInterval: Duration(
        milliseconds: integer('COACH_MIN_INTERVAL_MS', 8000),
      ),
      maxSessionAudioBytes: integer(
        'MAX_SESSION_AUDIO_BYTES',
        64 * 1024 * 1024,
      ),
      allowEphemeralStore: boolean('PINKALL_ALLOW_EPHEMERAL_STORE', false),
      databaseUrl: optional('DATABASE_URL'),
      databaseSslRootCertificate: optional('DATABASE_SSL_ROOT_CERT'),
      storageTenantId: optional('PINKALL_STORAGE_TENANT_ID'),
      strictConfiguration: boolean('STRICT_CONFIG', false),
    );
  }

  final String host;
  final int port;
  final String? apiToken;
  final bool allowPocBearer;
  final String? supabaseJwtIssuer;
  final String? supabaseJwksUrl;
  final String supabaseJwtAudience;
  final String? snapshotWorkspaceId;
  final String? publicBaseUrl;
  final String? telnyxApiKey;
  final String telnyxApiBaseUrl;
  final String? telnyxTelephonyCredentialId;
  final String? telnyxPublicKey;
  final String? telnyxWebrtcConnectionId;
  final String? telnyxCallControlConnectionId;
  final String? telnyxFromNumber;
  final String? telnyxCallerName;
  final String? telnyxCallerNumber;
  final String sttProvider;
  final String? deepgramApiKey;
  final String deepgramRealtimeBaseUrl;
  final String deepgramPrerecordedBaseUrl;
  final String deepgramPrerecordedModel;
  final String deepgramDiarizeModel;
  final String deepgramFluxModel;
  final String deepgramLanguageHint;
  final double deepgramEndOfTurnThreshold;
  final double deepgramEagerEndOfTurnThreshold;
  final int deepgramEndOfTurnTimeoutMs;
  final String? mistralApiKey;
  final String mistralRealtimeBaseUrl;
  final String mistralRealtimeModel;
  final String mistralBatchBaseUrl;
  final String mistralBatchModel;
  final int mistralTargetDelayMs;
  final String coachProvider;
  final String postCallProvider;
  final String? openAiApiKey;
  final String openAiBaseUrl;
  final String? openAiCoachModel;
  final String? openAiPostCallModel;
  final String openAiCoachReasoningEffort;
  final String openAiPostCallReasoningEffort;
  final CoachMode defaultCoachMode;
  final CoachReleaseChannel coachReleaseChannel;
  final String coachReleaseChannelValue;
  final String? coachCatalogDirectory;
  final double coachMinimumConfidence;
  final Duration coachMinimumInterval;
  final int maxSessionAudioBytes;
  final bool allowEphemeralStore;
  final String? databaseUrl;
  final String? databaseSslRootCertificate;
  final String? storageTenantId;
  final bool strictConfiguration;

  /// Validation failures that make at least one runtime path unavailable.
  List<String> get validationErrors {
    final List<String> errors = <String>[];
    if (port < 1 || port > 65535) {
      errors.add('PORT must be between 1 and 65535.');
    }
    if (allowPocBearer && (apiToken == null || apiToken!.length < 24)) {
      errors.add(
        'PINKALL_API_TOKEN must contain at least 24 characters when '
        'PINKALL_ALLOW_POC_BEARER=true.',
      );
    }
    if (!allowPocBearer && supabaseJwtIssuer == null) {
      errors.add(
        'Configure SUPABASE_URL/SUPABASE_JWT_ISSUER or explicitly enable '
        'PINKALL_ALLOW_POC_BEARER.',
      );
    }
    if (supabaseJwtIssuer != null) {
      final Uri? issuer = Uri.tryParse(supabaseJwtIssuer!);
      final Uri? jwks = supabaseJwksUrl == null
          ? null
          : Uri.tryParse(supabaseJwksUrl!);
      final Set<String> allowedSchemes = strictConfiguration
          ? const <String>{'https'}
          : const <String>{'http', 'https'};
      if (issuer == null ||
          issuer.host.isEmpty ||
          !allowedSchemes.contains(issuer.scheme)) {
        errors.add(
          'SUPABASE_JWT_ISSUER must use ${strictConfiguration ? 'https://' : 'http:// or https://'} and contain a host.',
        );
      }
      if (jwks == null ||
          jwks.host.isEmpty ||
          !allowedSchemes.contains(jwks.scheme)) {
        errors.add(
          'SUPABASE_JWKS_URL must use ${strictConfiguration ? 'https://' : 'http:// or https://'} and contain a host.',
        );
      }
      if (supabaseJwtAudience.trim().isEmpty) {
        errors.add('SUPABASE_JWT_AUDIENCE cannot be empty.');
      }
      if (databaseUrl == null) {
        errors.add(
          'DATABASE_URL is required to resolve Supabase workspace memberships.',
        );
      }
      if (snapshotWorkspaceId == null || !_isUuid(snapshotWorkspaceId!)) {
        errors.add(
          'PINKALL_SNAPSHOT_WORKSPACE_ID must be a UUID when Supabase JWT '
          'authentication is enabled.',
        );
      }
    } else if (snapshotWorkspaceId != null && !_isUuid(snapshotWorkspaceId!)) {
      errors.add('PINKALL_SNAPSHOT_WORKSPACE_ID must be a UUID.');
    }
    final Uri? telnyxUri = Uri.tryParse(telnyxApiBaseUrl);
    if (!_usesAllowedTransport(
      telnyxUri,
      secureScheme: 'https',
      localScheme: 'http',
    )) {
      errors.add(
        'TELNYX_API_BASE_URL must use https://; http:// is allowed only '
        'for loopback hosts when STRICT_CONFIG=false.',
      );
    }
    if (telnyxApiKey == null || telnyxTelephonyCredentialId == null) {
      errors.add(
        'TELNYX_API_KEY and TELNYX_TELEPHONY_CREDENTIAL_ID are required '
        'for Voice SDK tokens.',
      );
    }
    if (telnyxCallerName == null || telnyxCallerNumber == null) {
      errors.add(
        'TELNYX_CALLER_NAME and TELNYX_CALLER_NUMBER are required for calls.',
      );
    } else if (!RegExp(r'^\+[1-9]\d{6,14}$').hasMatch(telnyxCallerNumber!)) {
      errors.add('TELNYX_CALLER_NUMBER must use E.164 format.');
    }
    if (telnyxPublicKey == null ||
        telnyxWebrtcConnectionId == null ||
        telnyxCallControlConnectionId == null) {
      errors.add(
        'TELNYX_PUBLIC_KEY, TELNYX_WEBRTC_CONNECTION_ID and '
        'TELNYX_CALL_CONTROL_CONNECTION_ID are required for signed outbound '
        'Call Control.',
      );
    }
    if (telnyxWebrtcConnectionId != null &&
        telnyxWebrtcConnectionId == telnyxCallControlConnectionId) {
      errors.add(
        'TELNYX_WEBRTC_CONNECTION_ID and '
        'TELNYX_CALL_CONTROL_CONNECTION_ID must be different.',
      );
    }
    if (telnyxFromNumber == null ||
        !RegExp(r'^\+[1-9]\d{6,14}$').hasMatch(telnyxFromNumber!)) {
      errors.add('TELNYX_FROM_NUMBER must use E.164 format.');
    }
    final Uri? publicUri = publicBaseUrl == null
        ? null
        : Uri.tryParse(publicBaseUrl!);
    if (!_usesAllowedTransport(
      publicUri,
      secureScheme: 'https',
      localScheme: 'http',
    )) {
      errors.add(
        'PUBLIC_BASE_URL must use https://; http:// is allowed only for '
        'loopback hosts when STRICT_CONFIG=false.',
      );
    }
    if (!const <String>{'deepgram_flux', 'voxtral'}.contains(sttProvider)) {
      errors.add('STT_PROVIDER must be deepgram_flux or voxtral.');
    }
    if (sttProvider == 'deepgram_flux' && deepgramApiKey == null) {
      errors.add(
        'DEEPGRAM_API_KEY is required when STT_PROVIDER=deepgram_flux.',
      );
    }
    final Uri? deepgramUri = Uri.tryParse(deepgramRealtimeBaseUrl);
    if (!_usesAllowedTransport(
      deepgramUri,
      secureScheme: 'wss',
      localScheme: 'ws',
    )) {
      errors.add(
        'DEEPGRAM_REALTIME_BASE_URL must use wss://; ws:// is allowed only '
        'for loopback hosts when STRICT_CONFIG=false.',
      );
    }
    final Uri? deepgramPrerecordedUri = Uri.tryParse(
      deepgramPrerecordedBaseUrl,
    );
    if (!_usesAllowedTransport(
      deepgramPrerecordedUri,
      secureScheme: 'https',
      localScheme: 'http',
    )) {
      errors.add(
        'DEEPGRAM_PRERECORDED_BASE_URL must use https://; http:// is allowed '
        'only for loopback hosts when STRICT_CONFIG=false.',
      );
    }
    if (deepgramPrerecordedModel.trim().isEmpty) {
      errors.add('DEEPGRAM_PRERECORDED_MODEL cannot be empty.');
    }
    if (!const <String>{'latest', 'v1', 'v2'}.contains(deepgramDiarizeModel)) {
      errors.add('DEEPGRAM_DIARIZE_MODEL must be latest, v1 or v2.');
    }
    if (!const <String>{
      'flux-general-en',
      'flux-general-multi',
    }.contains(deepgramFluxModel)) {
      errors.add(
        'DEEPGRAM_FLUX_MODEL must be flux-general-en or '
        'flux-general-multi.',
      );
    }
    if (deepgramFluxModel != 'flux-general-multi' &&
        deepgramLanguageHint.isNotEmpty) {
      errors.add('DEEPGRAM_LANGUAGE_HINT requires flux-general-multi.');
    }
    if (deepgramEndOfTurnThreshold < 0.5 || deepgramEndOfTurnThreshold > 0.9) {
      errors.add('DEEPGRAM_EOT_THRESHOLD must be between 0.5 and 0.9.');
    }
    if (deepgramEagerEndOfTurnThreshold < 0.3 ||
        deepgramEagerEndOfTurnThreshold > 0.9) {
      errors.add('DEEPGRAM_EAGER_EOT_THRESHOLD must be between 0.3 and 0.9.');
    }
    if (deepgramEagerEndOfTurnThreshold > deepgramEndOfTurnThreshold) {
      errors.add(
        'DEEPGRAM_EAGER_EOT_THRESHOLD cannot exceed '
        'DEEPGRAM_EOT_THRESHOLD.',
      );
    }
    if (deepgramEndOfTurnTimeoutMs < 500 ||
        deepgramEndOfTurnTimeoutMs > 10000) {
      errors.add('DEEPGRAM_EOT_TIMEOUT_MS must be between 500 and 10000.');
    }
    if (mistralApiKey == null) {
      errors.add('MISTRAL_API_KEY is required for real transcription.');
    }
    final Uri? realtimeUri = Uri.tryParse(mistralRealtimeBaseUrl);
    if (!_usesAllowedTransport(
      realtimeUri,
      secureScheme: 'wss',
      localScheme: 'ws',
    )) {
      errors.add(
        'MISTRAL_REALTIME_BASE_URL must use wss://; ws:// is allowed only '
        'for loopback hosts when STRICT_CONFIG=false.',
      );
    }
    final Uri? batchUri = Uri.tryParse(mistralBatchBaseUrl);
    if (!_usesAllowedTransport(
      batchUri,
      secureScheme: 'https',
      localScheme: 'http',
    )) {
      errors.add(
        'MISTRAL_BATCH_BASE_URL must use https://; http:// is allowed only '
        'for loopback hosts when STRICT_CONFIG=false.',
      );
    }
    if (mistralTargetDelayMs < 0) {
      errors.add('MISTRAL_TARGET_DELAY_MS cannot be negative.');
    }
    final Uri? openAiUri = Uri.tryParse(openAiBaseUrl);
    if (!_usesAllowedTransport(
      openAiUri,
      secureScheme: 'https',
      localScheme: 'http',
    )) {
      errors.add(
        'OPENAI_BASE_URL must use https://; http:// is allowed only for '
        'loopback hosts when STRICT_CONFIG=false.',
      );
    }
    if (coachProvider != 'openai') {
      errors.add('COACH_PROVIDER must be openai; Mistral is reserved for STT.');
    }
    if (postCallProvider != 'openai') {
      errors.add(
        'POST_CALL_PROVIDER must be openai; Mistral is reserved for STT.',
      );
    }
    if (coachMinimumConfidence < 0 || coachMinimumConfidence > 1) {
      errors.add('COACH_MIN_CONFIDENCE must be between 0 and 1.');
    }
    if (!const <String>{
      'none',
      'minimal',
      'low',
      'medium',
      'high',
      'xhigh',
    }.contains(openAiCoachReasoningEffort)) {
      errors.add('OPENAI_COACH_REASONING_EFFORT is invalid.');
    }
    if (!const <String>{
      'none',
      'minimal',
      'low',
      'medium',
      'high',
      'xhigh',
    }.contains(openAiPostCallReasoningEffort)) {
      errors.add('OPENAI_POST_CALL_REASONING_EFFORT is invalid.');
    }
    if (!CoachReleaseChannel.isKnown(coachReleaseChannelValue)) {
      errors.add('COACH_RELEASE_CHANNEL must be strict or internal_alpha.');
    }
    if (maxSessionAudioBytes < 1024) {
      errors.add('MAX_SESSION_AUDIO_BYTES must be at least 1024.');
    }
    if (!allowEphemeralStore && databaseUrl == null) {
      errors.add(
        'DATABASE_URL is required unless '
        'PINKALL_ALLOW_EPHEMERAL_STORE=true is explicitly set.',
      );
    }
    if (databaseUrl != null) {
      final Uri? databaseUri = Uri.tryParse(databaseUrl!);
      if (databaseUri == null ||
          (databaseUri.scheme != 'postgres' &&
              databaseUri.scheme != 'postgresql')) {
        errors.add('DATABASE_URL must use postgres:// or postgresql://.');
      } else {
        if (databaseUri.host.isEmpty) {
          errors.add('DATABASE_URL must contain a PostgreSQL host.');
        }
        final String? sslMode = databaseUri.queryParameters['sslmode']
            ?.toLowerCase();
        final String? sslRootCertificate =
            databaseSslRootCertificate ??
            databaseUri.queryParameters['sslrootcert'];
        if (strictConfiguration && sslMode != 'verify-full') {
          errors.add(
            'DATABASE_URL must set sslmode=verify-full when '
            'STRICT_CONFIG=true.',
          );
        }
        if (strictConfiguration && sslRootCertificate == null) {
          errors.add(
            'DATABASE_SSL_ROOT_CERT or DATABASE_URL sslrootcert is required '
            'when STRICT_CONFIG=true.',
          );
        } else if (strictConfiguration &&
            sslRootCertificate != null &&
            !sslRootCertificate.startsWith('/')) {
          errors.add(
            'The PostgreSQL SSL root certificate must use an absolute path '
            'when STRICT_CONFIG=true.',
          );
        }
      }
      if (storageTenantId == null ||
          !RegExp(r'^[A-Za-z0-9._:-]{1,128}$').hasMatch(storageTenantId!)) {
        errors.add(
          'PINKALL_STORAGE_TENANT_ID is required with DATABASE_URL and may '
          'only contain letters, digits, dot, underscore, colon or dash.',
        );
      }
    }
    if (defaultCoachMode != CoachMode.off && !coachIsConfigured) {
      errors.add(
        'OPENAI_API_KEY and COACH_CATALOG_DIR are required when '
        'COACH_MODE_DEFAULT is not off.',
      );
    }
    return errors;
  }

  /// Whether the optional coach has every server-side dependency configured.
  bool get coachIsConfigured {
    return resolvedCoachProvider != 'unavailable' &&
        coachCatalogDirectory != null;
  }

  bool get postCallIsConfigured {
    return resolvedPostCallProvider != 'unavailable';
  }

  /// OpenAI is the only coaching provider; Mistral is reserved for STT.
  String get resolvedCoachProvider {
    return coachProvider == 'openai' &&
            openAiApiKey != null &&
            openAiCoachModel != null
        ? 'openai'
        : 'unavailable';
  }

  String get resolvedPostCallProvider {
    return postCallProvider == 'openai' &&
            openAiApiKey != null &&
            openAiPostCallModel != null
        ? 'openai'
        : 'unavailable';
  }

  /// Configuration diagnostics safe to return or log.
  Map<String, Object?> toSanitizedJson() {
    return <String, Object?>{
      'host': host,
      'port': port,
      'public_base_url_configured': publicBaseUrl != null,
      'api_auth_configured':
          (allowPocBearer && apiToken != null) || supabaseJwtIssuer != null,
      'poc_bearer_enabled': allowPocBearer,
      'supabase_jwt_configured': supabaseJwtIssuer != null,
      'supabase_jwt_audience': supabaseJwtAudience,
      'snapshot_workspace_bound': snapshotWorkspaceId != null,
      'telnyx_voice_token_configured': telnyxVoiceTokenIsConfigured,
      'telnyx_api_base_url': telnyxApiBaseUrl,
      'telnyx_telephony_credential_configured':
          telnyxTelephonyCredentialId != null,
      'telnyx_public_key_configured': telnyxPublicKey != null,
      'telnyx_webrtc_connection_configured': telnyxWebrtcConnectionId != null,
      'telnyx_call_control_connection_configured':
          telnyxCallControlConnectionId != null,
      'telnyx_from_number_configured': telnyxFromNumber != null,
      'telnyx_caller_name_configured': telnyxCallerName != null,
      'telnyx_caller_number_configured': telnyxCallerNumber != null,
      'stt_provider': sttProvider,
      'deepgram_api_key_configured': deepgramApiKey != null,
      'deepgram_realtime_base_url': deepgramRealtimeBaseUrl,
      'deepgram_prerecorded_base_url': deepgramPrerecordedBaseUrl,
      'deepgram_prerecorded_model': deepgramPrerecordedModel,
      'deepgram_diarize_model': deepgramDiarizeModel,
      'deepgram_flux_model': deepgramFluxModel,
      'deepgram_language_hint': deepgramLanguageHint,
      'deepgram_eot_threshold': deepgramEndOfTurnThreshold,
      'deepgram_eager_eot_threshold': deepgramEagerEndOfTurnThreshold,
      'deepgram_eot_timeout_ms': deepgramEndOfTurnTimeoutMs,
      'mistral_api_key_configured': mistralApiKey != null,
      'mistral_realtime_base_url': mistralRealtimeBaseUrl,
      'mistral_realtime_model': mistralRealtimeModel,
      'mistral_batch_base_url': mistralBatchBaseUrl,
      'mistral_batch_model': mistralBatchModel,
      'mistral_target_delay_ms': mistralTargetDelayMs,
      'coach_provider_requested': coachProvider,
      'coach_provider': resolvedCoachProvider,
      'post_call_provider_requested': postCallProvider,
      'post_call_provider': resolvedPostCallProvider,
      'coach_configured': coachIsConfigured,
      'post_call_configured': postCallIsConfigured,
      'openai_api_key_configured': openAiApiKey != null,
      'openai_base_url': openAiBaseUrl,
      'openai_coach_model': openAiCoachModel,
      'openai_post_call_model': openAiPostCallModel,
      'openai_coach_reasoning_effort': openAiCoachReasoningEffort,
      'openai_post_call_reasoning_effort': openAiPostCallReasoningEffort,
      'coach_mode_default': defaultCoachMode.name,
      'coach_release_channel': coachReleaseChannel.wireName,
      'unreviewed_coach_cards_enabled':
          coachReleaseChannel == CoachReleaseChannel.internalAlpha,
      'coach_catalog_configured': coachCatalogDirectory != null,
      'coach_min_confidence': coachMinimumConfidence,
      'coach_min_interval_ms': coachMinimumInterval.inMilliseconds,
      'max_session_audio_bytes': maxSessionAudioBytes,
      'ephemeral_store_explicitly_allowed': allowEphemeralStore,
      'database_url_configured': databaseUrl != null,
      'database_ssl_root_certificate_configured':
          databaseSslRootCertificate != null ||
          (databaseUrl != null &&
              (Uri.tryParse(
                    databaseUrl!,
                  )?.queryParameters['sslrootcert']?.isNotEmpty ??
                  false)),
      'storage_tenant_configured': storageTenantId != null,
      'storage': databaseUrl != null
          ? 'postgres_snapshot_poc'
          : 'in_memory_non_durable',
      'validation_errors': validationErrors,
    };
  }

  bool get telnyxVoiceTokenIsConfigured {
    return telnyxApiKey != null &&
        telnyxTelephonyCredentialId != null &&
        telnyxCallerName != null &&
        telnyxCallerNumber != null;
  }

  static bool _isUuid(String value) {
    return RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    ).hasMatch(value);
  }

  bool _usesAllowedTransport(
    Uri? uri, {
    required String secureScheme,
    required String localScheme,
  }) {
    if (uri == null || !uri.isAbsolute || uri.host.isEmpty) {
      return false;
    }
    if (uri.scheme == secureScheme) {
      return true;
    }
    return !strictConfiguration &&
        uri.scheme == localScheme &&
        _isLoopbackHost(uri.host);
  }

  static bool _isLoopbackHost(String host) {
    if (host.toLowerCase() == 'localhost') {
      return true;
    }
    return InternetAddress.tryParse(host)?.isLoopback ?? false;
  }

  bool get telnyxOutboundIsConfigured {
    return telnyxApiKey != null &&
        telnyxPublicKey != null &&
        telnyxWebrtcConnectionId != null &&
        telnyxCallControlConnectionId != null &&
        telnyxFromNumber != null &&
        telnyxCallerName != null &&
        publicBaseUrl != null;
  }
}
