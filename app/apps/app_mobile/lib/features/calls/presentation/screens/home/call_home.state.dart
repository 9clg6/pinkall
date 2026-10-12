import 'package:core_domain/core_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_home.state.freezed.dart';

/// Immutable state displayed by the Telnyx connection and dialer screen.
@Freezed(copyWith: true)
abstract class CallHomeState with _$CallHomeState {
  /// Creates the Telnyx phone home state.
  const factory CallHomeState({
    required TelnyxConnectionStateEntity connection,
    required CallStateEntity? incomingCall,
    required CallStateEntity? lastCall,
    required List<ConversationSessionEntity> activeBackendSessions,
    required CoachMode coachMode,
    required bool isBackendConfigured,
    required bool manualTelnyxAuthEnabled,
    required IncomingCallCapabilityEntity incomingCallCapability,
    required bool isCheckingIncomingCallCapability,
    required bool isOperating,
    required String? operationFailure,
    required String? backendFailure,
  }) = _CallHomeState;

  /// Creates the disconnected initial state without demonstration data.
  factory CallHomeState.initial() => const CallHomeState(
    connection: TelnyxConnectionStateEntity(
      status: TelnyxConnectionStatus.disconnected,
    ),
    incomingCall: null,
    lastCall: null,
    activeBackendSessions: const <ConversationSessionEntity>[],
    coachMode: CoachMode.off,
    isBackendConfigured: false,
    manualTelnyxAuthEnabled: false,
    incomingCallCapability: IncomingCallCapabilityEntity(
      status: IncomingCallCapabilityStatus.registering,
      platform: IncomingCallPlatform.other,
      transport: IncomingCallTransport.none,
      tokenAvailable: false,
      backgroundDeliveryReady: false,
      nativeCallUiReady: false,
      missingRequirements: <String>['native_capability_not_checked'],
    ),
    isCheckingIncomingCallCapability: false,
    isOperating: false,
    operationFailure: null,
    backendFailure: null,
  );
}
