import 'dart:io';

import 'package:api_agent_vocal/src/application/outbound_call_service.dart';
import 'package:api_agent_vocal/src/application/post_call_service.dart';
import 'package:api_agent_vocal/src/application/recording_import_service.dart';
import 'package:api_agent_vocal/src/application/request_authentication_service.dart';
import 'package:api_agent_vocal/src/application/session_service.dart';
import 'package:api_agent_vocal/src/config/app_config.dart';
import 'package:api_agent_vocal/src/domain/auth_contracts.dart';
import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/objection_learning.dart';
import 'package:api_agent_vocal/src/domain/post_call_contracts.dart';
import 'package:api_agent_vocal/src/domain/recording_transcription_contracts.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';
import 'package:api_agent_vocal/src/domain/stt_contracts.dart';
import 'package:api_agent_vocal/src/domain/telnyx_call_control_contracts.dart';
import 'package:api_agent_vocal/src/domain/voice_contracts.dart';
import 'package:api_agent_vocal/src/infrastructure/auth/postgres_workspace_membership_resolver.dart';
import 'package:api_agent_vocal/src/infrastructure/auth/supabase_jwt_verifier.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/file_coach_catalog.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/file_objection_learning_sink.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/objection_aware_coach_catalog.dart';
import 'package:api_agent_vocal/src/infrastructure/coach/openai_coach_gateway.dart';
import 'package:api_agent_vocal/src/infrastructure/coach/openai_post_call_gateway.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:api_agent_vocal/src/infrastructure/store/postgres_snapshot_store.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/deepgram_flux_stt_provider.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/deepgram_prerecorded_transcription_provider.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/voxtral_stt_provider.dart';
import 'package:api_agent_vocal/src/infrastructure/telnyx/telnyx_call_control_gateway.dart';
import 'package:api_agent_vocal/src/infrastructure/telnyx/telnyx_webhook_verifier.dart';
import 'package:api_agent_vocal/src/infrastructure/voice/telnyx_voice_token_provider.dart';

/// Runtime dependency graph for the modular backend POC.
final class PinkallBackend {
  PinkallBackend._({
    required this.config,
    required this.authentication,
    required this.store,
    required this.sttProvider,
    required this.coachGateway,
    required this.coachCatalog,
    required this.objectionLibrary,
    required this.postCallGateway,
    required this.voiceTokenProvider,
    required this.outboundCalls,
    required this.sessions,
    required this.postCalls,
    required this.recordingImports,
  });

  /// Builds only real runtime adapters or explicit unavailable adapters.
  factory PinkallBackend.create(
    AppConfig config, {
    RecordedCallTranscriptionProvider? recordingTranscriptionProvider,
    RequestAuthenticator? requestAuthenticator,
  }) {
    if (config.databaseUrl == null && !config.allowEphemeralStore) {
      throw StateError(
        'Set DATABASE_URL for durable storage or explicitly opt in to '
        'POC-only PINKALL_ALLOW_EPHEMERAL_STORE=true.',
      );
    }
    if (config.databaseUrl != null && config.storageTenantId == null) {
      throw StateError(
        'PINKALL_STORAGE_TENANT_ID is required with DATABASE_URL.',
      );
    }
    if (config.supabaseJwtIssuer != null &&
        (config.databaseUrl == null ||
            config.supabaseJwksUrl == null ||
            config.snapshotWorkspaceId == null)) {
      throw StateError(
        'Supabase JWT authentication requires DATABASE_URL, a JWKS URL and '
        'PINKALL_SNAPSHOT_WORKSPACE_ID until the relational session store is '
        'complete.',
      );
    }
    final PinkallStore store = config.databaseUrl == null
        ? InMemoryPocStore(maxSessionAudioBytes: config.maxSessionAudioBytes)
        : PostgresSnapshotPinkallStore.fromDatabaseUrl(
            databaseUrl: config.databaseUrl!,
            sslRootCertificatePath: config.databaseSslRootCertificate,
            tenantId: config.storageTenantId!,
            maxSessionAudioBytes: config.maxSessionAudioBytes,
          );
    final SttProvider voxtralProvider = config.mistralApiKey == null
        ? const UnavailableSttProvider(
            'MISTRAL_API_KEY is required; no fake STT is installed.',
          )
        : VoxtralSttProvider(
            apiKey: config.mistralApiKey!,
            realtimeBaseUrl: config.mistralRealtimeBaseUrl,
            realtimeModel: config.mistralRealtimeModel,
            batchBaseUrl: config.mistralBatchBaseUrl,
            batchModel: config.mistralBatchModel,
            targetDelayMs: config.mistralTargetDelayMs,
          );
    final SttProvider sttProvider = switch (config.sttProvider) {
      'deepgram_flux' when config.deepgramApiKey != null =>
        DeepgramFluxSttProvider(
          apiKey: config.deepgramApiKey!,
          realtimeBaseUrl: config.deepgramRealtimeBaseUrl,
          model: config.deepgramFluxModel,
          languageHint: config.deepgramLanguageHint.isEmpty
              ? null
              : config.deepgramLanguageHint,
          endOfTurnThreshold: config.deepgramEndOfTurnThreshold,
          eagerEndOfTurnThreshold: config.deepgramEagerEndOfTurnThreshold,
          endOfTurnTimeoutMs: config.deepgramEndOfTurnTimeoutMs,
          batchProvider: voxtralProvider,
        ),
      'deepgram_flux' => const UnavailableSttProvider(
        'DEEPGRAM_API_KEY is required for Flux realtime transcription.',
      ),
      _ => voxtralProvider,
    };
    final RecordedCallTranscriptionProvider prerecordedProvider =
        recordingTranscriptionProvider ??
        (config.deepgramApiKey == null
            ? const UnavailableRecordedCallTranscriptionProvider(
                'DEEPGRAM_API_KEY is required for recording imports.',
              )
            : DeepgramPrerecordedTranscriptionProvider(
                apiKey: config.deepgramApiKey!,
                baseUrl: config.deepgramPrerecordedBaseUrl,
                model: config.deepgramPrerecordedModel,
                diarizeModel: config.deepgramDiarizeModel,
              ));
    final ObjectionKnowledgeStore objectionStore =
        config.coachCatalogDirectory == null
        ? const NoopObjectionKnowledgeStore()
        : FileObjectionLearningSink(
            File.fromUri(
              Directory(
                config.coachCatalogDirectory!,
              ).absolute.uri.resolve('discovered-objections.local.json'),
            ),
          );
    final CoachCatalog coachCatalog = ObjectionAwareCoachCatalog(
      base: FileCoachCatalog.load(
        config.coachCatalogDirectory,
        releaseChannel: config.coachReleaseChannel,
      ),
      objectionLibrary: objectionStore,
    );
    final CoachGateway coachGateway = switch (config.resolvedCoachProvider) {
      'openai' => OpenAiCoachGateway(
        apiKey: config.openAiApiKey!,
        baseUrl: config.openAiBaseUrl,
        model: config.openAiCoachModel!,
        reasoningEffort: config.openAiCoachReasoningEffort,
      ),
      _ => const UnavailableCoachGateway(
        'OPENAI_API_KEY is required for live coaching.',
      ),
    };
    final PostCallGateway postCallGateway =
        switch (config.resolvedPostCallProvider) {
          'openai' => OpenAiPostCallGateway(
            apiKey: config.openAiApiKey!,
            baseUrl: config.openAiBaseUrl,
            model: config.openAiPostCallModel!,
            reasoningEffort: config.openAiPostCallReasoningEffort,
          ),
          _ => const UnavailablePostCallGateway(
            'OPENAI_API_KEY is required for the final debrief.',
          ),
        };
    final VoiceTokenProvider voiceTokenProvider =
        !config.telnyxVoiceTokenIsConfigured
        ? const UnavailableVoiceTokenProvider(
            'TELNYX_API_KEY, TELNYX_TELEPHONY_CREDENTIAL_ID, '
            'TELNYX_CALLER_NAME and TELNYX_CALLER_NUMBER are required.',
          )
        : TelnyxVoiceTokenProvider(
            apiKey: config.telnyxApiKey!,
            apiBaseUrl: config.telnyxApiBaseUrl,
            telephonyCredentialId: config.telnyxTelephonyCredentialId!,
            callerName: config.telnyxCallerName!,
            callerNumber: config.telnyxCallerNumber!,
          );
    final TelnyxCallControlGateway callControlGateway =
        !config.telnyxOutboundIsConfigured
        ? const UnavailableTelnyxCallControlGateway(
            'Signed Telnyx outbound Call Control is not configured.',
          )
        : HttpTelnyxCallControlGateway(
            apiKey: config.telnyxApiKey!,
            apiBaseUrl: config.telnyxApiBaseUrl,
            connectionId: config.telnyxCallControlConnectionId!,
            fromNumber: config.telnyxFromNumber!,
            fromDisplayName: config.telnyxCallerName!,
          );
    final OutboundCallService outboundCalls = OutboundCallService(
      store: store,
      gateway: callControlGateway,
      verifier: TelnyxWebhookVerifier(publicKey: config.telnyxPublicKey),
      publicBaseUrl: config.publicBaseUrl,
      webRtcConnectionId: config.telnyxWebrtcConnectionId,
    );
    final SessionService sessions = SessionService(
      config: config,
      store: store,
      sttProvider: sttProvider,
      coachGateway: coachGateway,
      coachCatalog: coachCatalog,
    );
    final PostCallService postCalls = PostCallService(
      store: store,
      gateway: postCallGateway,
      coachCatalog: coachCatalog,
      objectionLearningSink: objectionStore,
      // The OpenAI adapter already owns its bounded global-deadline retry
      // loop. Do not multiply those provider attempts at the service layer.
      maxAttempts: 1,
    );
    final RecordingImportService recordingImports = RecordingImportService(
      store: store,
      sessions: sessions,
      postCalls: postCalls,
      transcriptionProvider: prerecordedProvider,
    );
    final SupabaseAccessTokenVerifier? supabaseVerifier =
        config.supabaseJwtIssuer == null
        ? null
        : SupabaseJwtVerifier(
            issuer: Uri.parse(config.supabaseJwtIssuer!),
            jwksUrl: Uri.parse(config.supabaseJwksUrl!),
            audience: config.supabaseJwtAudience,
          );
    final WorkspaceMembershipResolver? membershipResolver =
        config.supabaseJwtIssuer == null
        ? null
        : PostgresWorkspaceMembershipResolver(
            config.databaseUrl!,
            sslRootCertificatePath: config.databaseSslRootCertificate,
          );
    final RequestAuthenticator authentication =
        requestAuthenticator ??
        RequestAuthenticationService(
          supabaseVerifier: supabaseVerifier,
          membershipResolver: membershipResolver,
          allowPocBearer: config.allowPocBearer,
          pocBearer: config.apiToken,
          pocWorkspaceId:
              config.snapshotWorkspaceId ??
              config.storageTenantId ??
              'poc-local',
          snapshotWorkspaceId: config.snapshotWorkspaceId,
        );
    return PinkallBackend._(
      config: config,
      authentication: authentication,
      store: store,
      sttProvider: sttProvider,
      coachGateway: coachGateway,
      coachCatalog: coachCatalog,
      objectionLibrary: objectionStore,
      postCallGateway: postCallGateway,
      voiceTokenProvider: voiceTokenProvider,
      outboundCalls: outboundCalls,
      sessions: sessions,
      postCalls: postCalls,
      recordingImports: recordingImports,
    );
  }

  final AppConfig config;
  final RequestAuthenticator authentication;
  final PinkallStore store;
  final SttProvider sttProvider;
  final CoachGateway coachGateway;
  final CoachCatalog coachCatalog;
  final ObjectionLibrary objectionLibrary;
  final PostCallGateway postCallGateway;
  final VoiceTokenProvider voiceTokenProvider;
  final OutboundCallService outboundCalls;
  final SessionService sessions;
  final PostCallService postCalls;
  final RecordingImportService recordingImports;

  Future<void> initialize() async {
    await store.initialize();
    await authentication.initialize();
    await recordingImports.initialize();
    postCalls.resumeInterruptedJobs();
  }

  Future<void> dispose() async {
    await recordingImports.dispose();
    await sessions.dispose();
    voiceTokenProvider.dispose();
    outboundCalls.dispose();
    await authentication.dispose();
    await store.dispose();
  }
}
