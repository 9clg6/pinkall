import 'dart:async';
import 'dart:math';

import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinkall/core/config/pinkall_backend_configuration.dart';
import 'package:pinkall/core/config/pinkall_supabase_configuration.dart';
import 'package:pinkall/features/auth/data/clients/supabase_pinkall_auth.remote.client.impl.dart';
import 'package:pinkall/features/auth/data/datasources/pinkall_auth.remote.data_source.impl.dart';
import 'package:pinkall/features/auth/data/repositories/legacy_development_auth.repository.impl.dart';
import 'package:pinkall/features/auth/data/repositories/pinkall_auth.repository.impl.dart';
import 'package:pinkall/features/auth/data/repositories/unavailable_auth.repository.impl.dart';
import 'package:pinkall/features/auth/domain/repositories/pinkall_auth.repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Runtime Pinkall backend configuration with local macOS POC defaults.
final Provider<PinkallBackendConfiguration>
pinkallBackendConfigurationProvider = Provider<PinkallBackendConfiguration>(
  (Ref ref) => PinkallBackendConfiguration.fromEnvironment(),
);

/// Public Supabase configuration supplied through compile-time dart defines.
final Provider<PinkallSupabaseConfiguration>
pinkallSupabaseConfigurationProvider = Provider<PinkallSupabaseConfiguration>(
  (Ref ref) => PinkallSupabaseConfiguration.fromEnvironment(),
);

/// Initialized official client, overridden once during application startup.
final Provider<SupabaseClient?> pinkallSupabaseClientProvider =
    Provider<SupabaseClient?>((Ref ref) => null);

/// Invite-only authentication boundary selected for this runtime.
final Provider<PinkallAuthRepository> pinkallAuthRepositoryProvider =
    Provider<PinkallAuthRepository>((Ref ref) {
      final PinkallSupabaseConfiguration supabase = ref.watch(
        pinkallSupabaseConfigurationProvider,
      );
      final PinkallBackendConfiguration backend = ref.watch(
        pinkallBackendConfigurationProvider,
      );
      if (supabase.hasAnyValue) {
        final SupabaseClient? client = ref.watch(pinkallSupabaseClientProvider);
        if (!supabase.isConfigured || client == null) {
          return UnavailableAuthRepositoryImpl(
            supabase.configurationError ??
                'La connexion Pinkall est temporairement indisponible.',
          );
        }
        return PinkallAuthRepositoryImpl(
          PinkallAuthRemoteDataSourceImpl(
            client: SupabasePinkallAuthRemoteClientImpl(client),
          ),
        );
      }
      if (backend.apiToken.isNotEmpty) {
        return LegacyDevelopmentAuthRepositoryImpl(backend.apiToken);
      }
      return const UnavailableAuthRepositoryImpl(
        'La connexion Pinkall n’est pas configurée sur cet appareil.',
      );
    });

/// Resolves a fresh bearer token for every HTTP request or WebSocket opening.
///
/// The legacy runtime value is reachable only through the development
/// repository. Once any Supabase configuration is supplied, it can never be
/// used as a fallback.
final Provider<PinkallAccessTokenProvider> pinkallAccessTokenProvider =
    Provider<PinkallAccessTokenProvider>((Ref ref) {
      final PinkallAuthRepository repository = ref.watch(
        pinkallAuthRepositoryProvider,
      );
      return repository.currentAccessToken;
    });

/// Opaque installation ID; random, non-secret, and not hardware-derived.
final FutureProvider<String> pinkallDeviceIdProvider = FutureProvider<String>((
  Ref ref,
) async {
  const String storageKey = 'pinkall.installation_id';
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  final String? existing = preferences.getString(storageKey);
  if (existing != null && existing.isNotEmpty) {
    return existing;
  }
  final String created = _newUuidV4();
  await preferences.setString(storageKey, created);
  return created;
});

/// Authenticated JSON client for the Pinkall SaaS API.
final Provider<PinkallHttpClient> pinkallHttpClientProvider =
    Provider<PinkallHttpClient>((Ref ref) {
      final PinkallBackendConfiguration configuration = ref.watch(
        pinkallBackendConfigurationProvider,
      );
      if (!configuration.isConfigured) {
        throw StateError(
          configuration.configurationError ?? 'Backend Pinkall non configuré.',
        );
      }
      final PinkallAccessTokenProvider accessTokenProvider = ref.watch(
        pinkallAccessTokenProvider,
      );
      return DioPinkallHttpClientImpl(
        baseUri: configuration.requireApiBaseUri(),
        accessTokenProvider: accessTokenProvider,
      );
    });

/// Authenticated provider-independent realtime client.
final Provider<PinkallRealtimeClient> pinkallRealtimeClientProvider =
    Provider<PinkallRealtimeClient>((Ref ref) {
      final PinkallBackendConfiguration configuration = ref.watch(
        pinkallBackendConfigurationProvider,
      );
      if (!configuration.isConfigured) {
        throw StateError(
          configuration.configurationError ?? 'Backend Pinkall non configuré.',
        );
      }
      final PinkallAccessTokenProvider accessTokenProvider = ref.watch(
        pinkallAccessTokenProvider,
      );
      return WebSocketPinkallRealtimeClientImpl(
        baseUri: configuration.requireWebSocketBaseUri(),
        accessTokenProvider: accessTokenProvider,
      );
    });

/// Short-lived binary WebSocket client for externally captured PCM tracks.
final Provider<PinkallBinaryRealtimeClient>
pinkallBinaryRealtimeClientProvider = Provider<PinkallBinaryRealtimeClient>(
  (Ref ref) => const WebSocketPinkallBinaryRealtimeClientImpl(),
);

/// Native macOS system-audio and microphone capture boundary.
final Provider<MacosCallAudioCaptureClient>
macosCallAudioCaptureClientProvider = Provider<MacosCallAudioCaptureClient>((
  Ref ref,
) {
  final MacosCallAudioCaptureClient client =
      MethodChannelMacosCallAudioCaptureClientImpl();
  ref.onDispose(() => unawaited(client.dispose()));
  return client;
});

/// Native iOS/Android open-in and launcher-shortcut recording boundary.
final Provider<RecordingImportClient> recordingImportClientProvider =
    Provider<RecordingImportClient>(
      (Ref ref) => const MethodChannelRecordingImportClientImpl(),
    );

/// Native PushKit/CallKit or FCM/ConnectionService bridge.
final Provider<IncomingCallPlatformClient> incomingCallPlatformClientProvider =
    Provider<IncomingCallPlatformClient>((Ref ref) {
      return const MethodChannelIncomingCallPlatformClientImpl();
    });

/// Vendor-neutral background incoming-call capability boundary.
final Provider<IncomingCallRepository> incomingCallRepositoryProvider =
    Provider<IncomingCallRepository>((Ref ref) {
      final IncomingCallRepository repository = IncomingCallRepositoryImpl(
        client: ref.watch(incomingCallPlatformClientProvider),
      );
      ref.onDispose(() => unawaited(repository.dispose()));
      return repository;
    });

/// Consent-gated post-call upload, diarization and speaker assignment.
final Provider<RecordingImportRepository> recordingImportRepositoryProvider =
    Provider<RecordingImportRepository>((Ref ref) {
      final PinkallHttpClient client = ref.watch(pinkallHttpClientProvider);
      if (client is! PinkallFileHttpClient) {
        throw StateError(
          'The configured Pinkall backend cannot stream recording imports.',
        );
      }
      return RecordingImportRepositoryImpl(
        remoteDataSource: RecordingImportRemoteDataSourceImpl(
          httpClient: client,
          fileHttpClient: client as PinkallFileHttpClient,
        ),
      );
    });

/// Versioned outbound-call policy boundary.
final Provider<CallEligibilityRepository> callEligibilityRepositoryProvider =
    Provider<CallEligibilityRepository>((Ref ref) {
      return CallEligibilityRepositoryImpl(
        remoteDataSource: CallEligibilityRemoteDataSourceImpl(
          httpClient: ref.watch(pinkallHttpClientProvider),
        ),
      );
    });

/// Conversation sessions, transcript events and final artifacts boundary.
final Provider<ConversationSessionRepository>
conversationSessionRepositoryProvider = Provider<ConversationSessionRepository>(
  (Ref ref) {
    return ConversationSessionRepositoryImpl(
      remoteDataSource: ConversationSessionRemoteDataSourceImpl(
        httpClient: ref.watch(pinkallHttpClientProvider),
        realtimeClient: ref.watch(pinkallRealtimeClientProvider),
      ),
    );
  },
);

/// User-level and per-call coaching preference boundary.
final Provider<CoachingRepository> coachingRepositoryProvider =
    Provider<CoachingRepository>((Ref ref) {
      return CoachingRepositoryImpl(
        remoteDataSource: CoachingRemoteDataSourceImpl(
          httpClient: ref.watch(pinkallHttpClientProvider),
        ),
      );
    });

/// Minimal SaaS CRM boundary.
final Provider<ContactRepository> contactRepositoryProvider =
    Provider<ContactRepository>((Ref ref) {
      return ContactRepositoryImpl(
        remoteDataSource: ContactRemoteDataSourceImpl(
          httpClient: ref.watch(pinkallHttpClientProvider),
        ),
      );
    });

/// Ephemeral Telnyx voice credentials issued by the authenticated backend.
final Provider<VoiceAccessRepository> voiceAccessRepositoryProvider =
    Provider<VoiceAccessRepository>((Ref ref) {
      return VoiceAccessRepositoryImpl(
        remoteDataSource: VoiceAccessRemoteDataSourceImpl(
          httpClient: ref.watch(pinkallHttpClientProvider),
        ),
      );
    });

String _newUuidV4() {
  final Random random = Random.secure();
  final List<int> bytes = List<int>.generate(
    16,
    (_) => random.nextInt(256),
    growable: false,
  );
  bytes[6] = (bytes[6] & 0x0F) | 0x40;
  bytes[8] = (bytes[8] & 0x3F) | 0x80;
  final String hex = bytes
      .map<String>((int value) => value.toRadixString(16).padLeft(2, '0'))
      .join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-'
      '${hex.substring(20)}';
}
