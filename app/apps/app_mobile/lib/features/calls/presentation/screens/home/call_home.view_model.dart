import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:core_domain/core_domain.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pinkall/core/config/pinkall_backend_configuration.dart';
import 'package:pinkall/core/providers/core/usecases/accept_call.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/connect_telnyx.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/dial_call.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/disconnect_telnyx.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/ensure_microphone_access.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/reject_call.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/watch_call_states.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/watch_telnyx_connection_states.use_case.provider.dart';
import 'package:pinkall/core/providers/kernel.provider.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/calls/presentation/screens/home/call_home.state.dart';
import 'package:pinkall/generated/locale_keys.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'call_home.view_model.g.dart';

const bool _manualTelnyxAuthEnabled = bool.fromEnvironment(
  'PINKALL_ENABLE_MANUAL_TELNYX_AUTH',
);

/// Coordinates Telnyx registration, the dialer, and foreground incoming calls.
@riverpod
class CallHomeViewModel extends _$CallHomeViewModel {
  late ConnectTelnyxUseCase _connectTelnyxUseCase;
  late DisconnectTelnyxUseCase _disconnectTelnyxUseCase;
  late DialCallUseCase _dialCallUseCase;
  late EnsureMicrophoneAccessUseCase _ensureMicrophoneAccessUseCase;
  late AcceptCallUseCase _acceptCallUseCase;
  late RejectCallUseCase _rejectCallUseCase;
  late PinkallBackendConfiguration _backendConfiguration;
  CallEligibilityRepository? _callEligibilityRepository;
  ConversationSessionRepository? _conversationSessionRepository;
  CoachingRepository? _coachingRepository;
  VoiceAccessRepository? _voiceAccessRepository;
  IncomingCallRepository? _incomingCallRepository;
  String? _deviceId;
  StreamSubscription<ResultState<TelnyxConnectionStateEntity>>?
  _connectionSubscription;
  StreamSubscription<ResultState<CallStateEntity>>? _callSubscription;
  StreamSubscription<IncomingCallNativeEventEntity>?
  _incomingCallNativeSubscription;
  Timer? _activeSessionsPollingTimer;
  Timer? _autoConnectTimer;
  bool _isRefreshingActiveSessions = false;
  bool _isRequestingVoiceAccess = false;

  @override
  Future<CallHomeState> build() async {
    await ref.watch(kernelProvider.future);
    _connectTelnyxUseCase = await ref.watch(
      connectTelnyxUseCaseProvider.future,
    );
    _disconnectTelnyxUseCase = await ref.watch(
      disconnectTelnyxUseCaseProvider.future,
    );
    _dialCallUseCase = await ref.watch(dialCallUseCaseProvider.future);
    _ensureMicrophoneAccessUseCase = await ref.watch(
      ensureMicrophoneAccessUseCaseProvider.future,
    );
    _acceptCallUseCase = await ref.watch(acceptCallUseCaseProvider.future);
    _rejectCallUseCase = await ref.watch(rejectCallUseCaseProvider.future);
    final WatchTelnyxConnectionStatesUseCase watchConnection = await ref.watch(
      watchTelnyxConnectionStatesUseCaseProvider.future,
    );
    final WatchCallStatesUseCase watchCalls = await ref.watch(
      watchCallStatesUseCaseProvider.future,
    );

    _connectionSubscription = watchConnection.execute().listen(
      _onConnectionResult,
    );
    _callSubscription = watchCalls.execute().listen(_onCallResult);
    ref.onDispose(() {
      unawaited(_connectionSubscription?.cancel());
      unawaited(_callSubscription?.cancel());
      unawaited(_incomingCallNativeSubscription?.cancel());
      _activeSessionsPollingTimer?.cancel();
      _autoConnectTimer?.cancel();
    });

    _backendConfiguration = ref.watch(pinkallBackendConfigurationProvider);
    _incomingCallRepository = ref.watch(incomingCallRepositoryProvider);
    IncomingCallCapabilityEntity incomingCallCapability;
    try {
      _incomingCallNativeSubscription = _incomingCallRepository!
          .watchNativeEvents()
          .listen(
            _onIncomingCallNativeEvent,
            onError: (_) => unawaited(refreshIncomingCallCapability()),
          );
      incomingCallCapability = await _incomingCallRepository!.initialize();
    } catch (_) {
      incomingCallCapability = const IncomingCallCapabilityEntity(
        status: IncomingCallCapabilityStatus.error,
        platform: IncomingCallPlatform.other,
        transport: IncomingCallTransport.none,
        tokenAvailable: false,
        backgroundDeliveryReady: false,
        nativeCallUiReady: false,
        missingRequirements: <String>['native_capability_inspection_failed'],
      );
    }
    CallHomeState initial = CallHomeState.initial().copyWith(
      isBackendConfigured: _backendConfiguration.isConfigured,
      manualTelnyxAuthEnabled: _manualTelnyxAuthEnabled,
      incomingCallCapability: incomingCallCapability,
      isCheckingIncomingCallCapability: false,
      backendFailure: _backendConfiguration.configurationError,
    );
    if (!_backendConfiguration.isConfigured) {
      return initial;
    }
    try {
      _callEligibilityRepository = ref.watch(callEligibilityRepositoryProvider);
      _conversationSessionRepository = ref.watch(
        conversationSessionRepositoryProvider,
      );
      _coachingRepository = ref.watch(coachingRepositoryProvider);
      _voiceAccessRepository = ref.watch(voiceAccessRepositoryProvider);
      _deviceId = await ref.watch(pinkallDeviceIdProvider.future);
      final CoachPreferenceEntity preference = await _coachingRepository!
          .getPreference();
      final List<ConversationSessionEntity> activeSessions =
          await _conversationSessionRepository!.listActiveSessions();
      initial = initial.copyWith(
        coachMode: preference.defaultMode == CoachMode.live
            ? CoachMode.live
            : CoachMode.off,
        backendFailure: null,
        activeBackendSessions: activeSessions,
      );
    } catch (error) {
      initial = initial.copyWith(backendFailure: _backendFailure(error));
    }
    if (_voiceAccessRepository != null) {
      _autoConnectTimer = Timer(
        Duration.zero,
        () => unawaited(connectAutomatically()),
      );
    }
    return initial;
  }

  /// Requests an ephemeral Telnyx token and connects without exposing it.
  Future<void> connectAutomatically() async {
    final VoiceAccessRepository? repository = _voiceAccessRepository;
    final String? deviceId = _deviceId;
    final CallHomeState? current = state.value;
    if (repository == null ||
        deviceId == null ||
        current == null ||
        _isRequestingVoiceAccess ||
        <TelnyxConnectionStatus>{
          TelnyxConnectionStatus.connecting,
          TelnyxConnectionStatus.connected,
          TelnyxConnectionStatus.ready,
          TelnyxConnectionStatus.reconnecting,
        }.contains(current.connection.status)) {
      return;
    }
    _isRequestingVoiceAccess = true;
    _setOperation(isOperating: true);
    try {
      final VoiceAccessTokenEntity voiceAccess = await repository.requestToken(
        RequestVoiceAccessTokenParam(deviceId: deviceId),
      );
      if (voiceAccess.isExpiredAt(DateTime.now().toUtc())) {
        throw StateError('Le jeton vocal reçu est déjà expiré.');
      }
      final String? notificationToken = await _notificationTokenOrNull();
      final ResultState<void> result = await _connectTelnyxUseCase.execute(
        ConnectTelnyxParam(
          configuration: TelnyxConfigurationEntity(
            authentication: TelnyxAuthenticationEntity.token(
              sipToken: voiceAccess.token,
            ),
            callerName: voiceAccess.callerName,
            callerNumber: voiceAccess.callerNumber,
            notificationToken: notificationToken,
          ),
        ),
      );
      result.when<void>(
        success: (_) => _setOperation(isOperating: false),
        failure: (Exception error) => _setOperation(
          isOperating: false,
          operationFailure:
              'Connexion impossible. Vérifie ta connexion puis réessaie.',
        ),
      );
    } catch (error) {
      _setOperation(
        isOperating: false,
        operationFailure:
            'Connexion impossible. Vérifie ta connexion puis réessaie.',
      );
    } finally {
      _isRequestingVoiceAccess = false;
    }
  }

  /// Refreshes sessions that another authenticated device may observe.
  Future<void> refreshActiveSessions() async {
    final ConversationSessionRepository? repository =
        _conversationSessionRepository;
    if (repository == null ||
        state.value == null ||
        _isRefreshingActiveSessions) {
      return;
    }
    _isRefreshingActiveSessions = true;
    try {
      final List<ConversationSessionEntity> sessions = await repository
          .listActiveSessions();
      final CallHomeState? latest = state.value;
      if (latest == null) {
        return;
      }
      state = AsyncData<CallHomeState>(
        latest.copyWith(activeBackendSessions: sessions, backendFailure: null),
      );
    } catch (error) {
      _setBackendFailure(
        'Les appels actifs ne peuvent pas être synchronisés pour le moment.',
      );
    } finally {
      _isRefreshingActiveSessions = false;
    }
  }

  /// Polls active sessions while the application is in the foreground.
  void startActiveSessionsPolling() {
    if (_activeSessionsPollingTimer?.isActive == true ||
        _conversationSessionRepository == null) {
      return;
    }
    unawaited(refreshActiveSessions());
    _activeSessionsPollingTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => unawaited(refreshActiveSessions()),
    );
  }

  /// Stops multi-device polling when the app leaves the foreground.
  void stopActiveSessionsPolling() {
    _activeSessionsPollingTimer?.cancel();
    _activeSessionsPollingTimer = null;
  }

  /// Rechecks native/background readiness without guessing missing credentials.
  Future<void> refreshIncomingCallCapability() async {
    final IncomingCallRepository? repository = _incomingCallRepository;
    final CallHomeState? current = state.value;
    if (repository == null || current == null) return;
    state = AsyncData<CallHomeState>(
      current.copyWith(isCheckingIncomingCallCapability: true),
    );
    try {
      final IncomingCallCapabilityEntity capability = await repository
          .inspectCapability();
      final CallHomeState? latest = state.value;
      if (latest == null) return;
      state = AsyncData<CallHomeState>(
        latest.copyWith(
          incomingCallCapability: capability,
          isCheckingIncomingCallCapability: false,
        ),
      );
    } catch (_) {
      final CallHomeState? latest = state.value;
      if (latest == null) return;
      state = AsyncData<CallHomeState>(
        latest.copyWith(
          incomingCallCapability: latest.incomingCallCapability.copyWith(
            status: IncomingCallCapabilityStatus.error,
            detail: 'native_capability_inspection_failed',
          ),
          isCheckingIncomingCallCapability: false,
        ),
      );
    }
  }

  /// Registers the real Telnyx client with runtime-only [configuration].
  Future<void> connect(TelnyxConfigurationEntity configuration) async {
    _setOperation(isOperating: true);
    final TelnyxConfigurationEntity resolvedConfiguration =
        configuration.notificationToken == null
        ? configuration.copyWith(
            notificationToken: await _notificationTokenOrNull(),
          )
        : configuration;
    final ResultState<void> result = await _connectTelnyxUseCase.execute(
      ConnectTelnyxParam(configuration: resolvedConfiguration),
    );
    _finishOperation(result);
  }

  /// Disconnects the current Telnyx session.
  Future<void> disconnect() async {
    _setOperation(isOperating: true);
    final ResultState<void> result = await _disconnectTelnyxUseCase.execute();
    _finishOperation(result);
  }

  /// Evaluates policy, places a real call, and creates its backend session.
  Future<CallLaunchResult?> dial(
    EvaluateCallEligibilityParam eligibilityFacts, {
    String? preparationMarkdown,
  }) async {
    final CallEligibilityRepository? eligibilityRepository =
        _callEligibilityRepository;
    final ConversationSessionRepository? sessionRepository =
        _conversationSessionRepository;
    if (!_backendConfiguration.isConfigured ||
        eligibilityRepository == null ||
        sessionRepository == null) {
      _setOperation(
        isOperating: false,
        operationFailure:
            _backendConfiguration.configurationError ??
            'Pinkall n’est pas disponible pour le moment. Réessaie.',
      );
      return null;
    }
    if (eligibilityFacts.market == ContactMarket.unknown) {
      _setOperation(
        isOperating: false,
        operationFailure:
            'Appel bloqué : indique si le contact est B2B ou B2C.',
      );
      return null;
    }
    _setOperation(isOperating: true);
    try {
      final CallEligibilityEntity decision = await eligibilityRepository
          .evaluate(eligibilityFacts);
      if (decision.status != CallEligibilityStatus.eligible) {
        _setOperation(
          isOperating: false,
          operationFailure: _eligibilityFailure(decision),
        );
        return null;
      }
    } catch (error) {
      _setOperation(
        isOperating: false,
        operationFailure:
            'La vérification avant l’appel est indisponible. Réessaie.',
      );
      return null;
    }
    final ResultState<void> microphoneResult =
        await _ensureMicrophoneAccessUseCase.execute();
    final bool microphoneReady = microphoneResult.when<bool>(
      success: (_) => true,
      failure: (Exception exception) {
        _setOperation(
          isOperating: false,
          operationFailure: _localizedCallFailure(exception),
        );
        return false;
      },
    );
    if (!microphoneReady) {
      return null;
    }
    final String correlationId = _newCallCorrelationId();
    late ConversationSessionEntity backendSession;
    try {
      final CallHomeState? current = state.value;
      backendSession = await sessionRepository.createSession(
        CreateConversationSessionParam(
          callId: correlationId,
          destinationNumber: eligibilityFacts.phoneNumber,
          contactId: eligibilityFacts.contactId,
          coachModeOverride: current?.coachMode ?? CoachMode.off,
          locale: 'fr-FR',
          preparationMarkdown: preparationMarkdown,
          context: const <String, String>{'direction': 'outgoing'},
        ),
      );
    } catch (error) {
      _setOperation(
        isOperating: false,
        operationFailure: 'L’appel n’a pas pu démarrer. Réessaie.',
      );
      return null;
    }
    final String clientState = jsonEncode(<String, String>{
      'pinkall_session_id': backendSession.id,
      'correlation_id': correlationId,
    });
    final ResultState<String> result = await _dialCallUseCase.execute(
      DialCallParam(
        destinationNumber: eligibilityFacts.phoneNumber,
        clientState: clientState,
      ),
    );
    final String? callId = result.when<String?>(
      success: (String value) => value,
      failure: (Exception exception) {
        _setOperation(
          isOperating: false,
          operationFailure:
              'L’appel n’a pas pu être lancé. Vérifie le numéro puis réessaie.',
        );
        return null;
      },
    );
    if (callId == null) {
      try {
        await sessionRepository.cancelSession(backendSession.id);
      } catch (_) {
        // The original, explicit Telnyx failure remains the actionable error.
      }
      return null;
    }
    _setOperation(isOperating: false);
    return CallLaunchResult(callId: callId, backendSession: backendSession);
  }

  /// Creates the processing session, then accepts a real incoming call.
  Future<ConversationSessionEntity?> acceptIncoming(
    CallStateEntity call,
  ) async {
    final ConversationSessionRepository? sessionRepository =
        _conversationSessionRepository;
    if (sessionRepository == null) {
      _setOperation(
        isOperating: false,
        operationFailure:
            _backendConfiguration.configurationError ??
            'Pinkall n’est pas disponible pour le moment. Réessaie.',
      );
      return null;
    }
    _setOperation(isOperating: true);
    final ResultState<void> microphoneResult =
        await _ensureMicrophoneAccessUseCase.execute();
    final bool microphoneReady = microphoneResult.when<bool>(
      success: (_) => true,
      failure: (Exception exception) {
        _setOperation(
          isOperating: false,
          operationFailure: _localizedCallFailure(exception),
        );
        return false;
      },
    );
    if (!microphoneReady) {
      return null;
    }
    ConversationSessionEntity backendSession;
    try {
      final CallHomeState? current = state.value;
      backendSession = await sessionRepository.createSession(
        CreateConversationSessionParam(
          callId: call.callId,
          destinationNumber: call.remoteNumber ?? 'unknown',
          coachModeOverride: current?.coachMode ?? CoachMode.off,
          locale: 'fr-FR',
          context: const <String, String>{'direction': 'incoming'},
        ),
      );
    } catch (error) {
      _setOperation(
        isOperating: false,
        operationFailure: 'L’appel entrant n’a pas pu être préparé. Réessaie.',
      );
      return null;
    }
    final ResultState<void> result = await _acceptCallUseCase.execute(
      CallActionParam(callId: call.callId),
    );
    return result.when<ConversationSessionEntity?>(
      success: (_) {
        _setOperation(isOperating: false);
        return backendSession;
      },
      failure: (Exception exception) {
        _setOperation(
          isOperating: false,
          operationFailure: _localizedCallFailure(exception),
        );
        return null;
      },
    );
  }

  /// Persists the user-level off/live coaching preference.
  Future<void> setCoachEnabled({required bool enabled}) async {
    final CoachingRepository? repository = _coachingRepository;
    if (repository == null) {
      _setBackendFailure(
        _backendConfiguration.configurationError ??
            'Le coach est momentanément indisponible.',
      );
      return;
    }
    final CoachMode mode = enabled ? CoachMode.live : CoachMode.off;
    _setOperation(isOperating: true);
    try {
      final CoachPreferenceEntity preference = await repository
          .updatePreference(UpdateCoachPreferenceParam(defaultMode: mode));
      final CallHomeState? current = state.value;
      if (current == null) {
        return;
      }
      state = AsyncData<CallHomeState>(
        current.copyWith(
          coachMode: preference.defaultMode == CoachMode.live
              ? CoachMode.live
              : CoachMode.off,
          isOperating: false,
          operationFailure: null,
          backendFailure: null,
        ),
      );
    } catch (error) {
      _setOperation(
        isOperating: false,
        operationFailure:
            'Impossible de modifier le coach. ${_backendFailure(error)}',
      );
    }
  }

  /// Rejects a real incoming call.
  Future<void> rejectIncoming(String callId) async {
    _setOperation(isOperating: true);
    final ResultState<void> result = await _rejectCallUseCase.execute(
      CallActionParam(callId: callId),
    );
    _finishOperation(result);
  }

  void _onConnectionResult(ResultState<TelnyxConnectionStateEntity> result) {
    result.when<void>(
      success: (TelnyxConnectionStateEntity connection) {
        final CallHomeState? current = state.value;
        if (current == null) {
          return;
        }
        state = AsyncData<CallHomeState>(
          current.copyWith(
            connection: connection,
            incomingCall:
                connection.status == TelnyxConnectionStatus.disconnected ||
                    connection.status == TelnyxConnectionStatus.failure
                ? null
                : current.incomingCall,
            operationFailure: connection.failureReason == null
                ? null
                : LocaleKeys.error_body.tr(),
          ),
        );
      },
      failure: (Exception exception) => _setOperation(
        isOperating: false,
        operationFailure: _localizedCallFailure(exception),
      ),
    );
  }

  void _onCallResult(ResultState<CallStateEntity> result) {
    result.when<void>(
      success: (CallStateEntity call) {
        final CallHomeState? current = state.value;
        if (current == null) {
          return;
        }
        final bool isIncomingRinging =
            call.direction == CallDirection.incoming &&
            call.status == CallLifecycleStatus.ringing;
        final bool clearsCurrentIncoming =
            current.incomingCall?.callId == call.callId && !isIncomingRinging;
        state = AsyncData<CallHomeState>(
          current.copyWith(
            incomingCall: isIncomingRinging
                ? call
                : clearsCurrentIncoming
                ? null
                : current.incomingCall,
            lastCall: call,
            operationFailure: call.status == CallLifecycleStatus.error
                ? LocaleKeys.error_body.tr()
                : current.operationFailure,
          ),
        );
      },
      failure: (Exception exception) => _setOperation(
        isOperating: false,
        operationFailure: _localizedCallFailure(exception),
      ),
    );
  }

  void _onIncomingCallNativeEvent(IncomingCallNativeEventEntity event) {
    if (<IncomingCallNativeEventType>{
      IncomingCallNativeEventType.tokenUpdated,
      IncomingCallNativeEventType.tokenInvalidated,
    }.contains(event.type)) {
      unawaited(refreshIncomingCallCapability());
    }
  }

  Future<String?> _notificationTokenOrNull() async {
    try {
      return await _incomingCallRepository?.getNotificationToken();
    } catch (_) {
      // Foreground calling must remain usable when background push is gated.
      return null;
    }
  }

  void _finishOperation(ResultState<void> result) {
    result.when<void>(
      success: (_) => _setOperation(isOperating: false),
      failure: (Exception exception) => _setOperation(
        isOperating: false,
        operationFailure: _localizedCallFailure(exception),
      ),
    );
  }

  void _setOperation({required bool isOperating, String? operationFailure}) {
    final CallHomeState? current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncData<CallHomeState>(
      current.copyWith(
        isOperating: isOperating,
        operationFailure: operationFailure,
      ),
    );
  }

  void _setBackendFailure(String message) {
    final CallHomeState? current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncData<CallHomeState>(current.copyWith(backendFailure: message));
  }
}

/// Voice call and backend processing session created as one UI operation.
final class CallLaunchResult {
  /// Creates a successful launch result.
  const CallLaunchResult({required this.callId, required this.backendSession});

  /// Telnyx call identifier.
  final String callId;

  /// Provider-independent Pinkall processing session.
  final ConversationSessionEntity backendSession;
}

String _eligibilityFailure(CallEligibilityEntity decision) {
  final List<String> reasons = decision.reasons
      .map<String>(_eligibilityReasonLabel)
      .toList(growable: false);
  final String details = reasons.isEmpty
      ? 'la politique serveur demande une vérification.'
      : reasons.join(' · ');
  return 'Appel bloqué par la politique ${decision.policyVersion} : $details';
}

String _eligibilityReasonLabel(CallEligibilityReason reason) =>
    switch (reason) {
      CallEligibilityReason.optedOut => 'le contact s’est opposé aux appels',
      CallEligibilityReason.b2cConsentMissing =>
        'consentement ou relation contractuelle B2C manquant',
      CallEligibilityReason.professionalRelevanceMissing =>
        'pertinence professionnelle B2B non confirmée',
      CallEligibilityReason.marketUnknown => 'relation B2B/B2C inconnue',
      CallEligibilityReason.phoneNumberInvalid => 'numéro invalide',
      CallEligibilityReason.policyUnavailable => 'politique indisponible',
    };

String _backendFailure(Object error) {
  final String value = error.toString();
  return value.startsWith('Exception: ') ? value.substring(11) : value;
}

String _newCallCorrelationId() {
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

String _localizedCallFailure(Exception exception) {
  if (exception is CallOperationException &&
      exception.code == CallFailureCode.microphoneAccessDenied) {
    return LocaleKeys.error_microphone.tr();
  }
  return LocaleKeys.error_body.tr();
}
