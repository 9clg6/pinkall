import 'package:core_data/model/remote/incoming_call_capability.remote.model.dart';
import 'package:core_data/model/remote/incoming_call_native_event.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Maps native incoming-call readiness into vendor-neutral domain values.
extension IncomingCallCapabilityRemoteModelMapper
    on IncomingCallCapabilityRemoteModel {
  /// Converts this remote model to an immutable domain entity.
  IncomingCallCapabilityEntity toDomain() => IncomingCallCapabilityEntity(
    status: switch (status) {
      'unsupported' => IncomingCallCapabilityStatus.unsupported,
      'disabled' => IncomingCallCapabilityStatus.disabled,
      'registering' => IncomingCallCapabilityStatus.registering,
      'configurationRequired' =>
        IncomingCallCapabilityStatus.configurationRequired,
      'ready' => IncomingCallCapabilityStatus.ready,
      _ => IncomingCallCapabilityStatus.error,
    },
    platform: switch (platform) {
      'ios' => IncomingCallPlatform.ios,
      'android' => IncomingCallPlatform.android,
      'macos' => IncomingCallPlatform.macos,
      _ => IncomingCallPlatform.other,
    },
    transport: switch (transport) {
      'apnsVoip' => IncomingCallTransport.apnsVoip,
      'fcm' => IncomingCallTransport.fcm,
      _ => IncomingCallTransport.none,
    },
    tokenAvailable: tokenAvailable,
    backgroundDeliveryReady: backgroundDeliveryReady,
    nativeCallUiReady: nativeCallUiReady,
    missingRequirements: missingRequirements,
    detail: detail,
  );
}

/// Maps sanitized platform events into domain values.
extension IncomingCallNativeEventRemoteModelMapper
    on IncomingCallNativeEventRemoteModel {
  /// Converts this remote event to a domain event.
  IncomingCallNativeEventEntity toDomain() => IncomingCallNativeEventEntity(
    type: switch (type) {
      'tokenUpdated' => IncomingCallNativeEventType.tokenUpdated,
      'incomingCall' => IncomingCallNativeEventType.incomingCall,
      'answerRequested' => IncomingCallNativeEventType.answerRequested,
      'declineRequested' => IncomingCallNativeEventType.declineRequested,
      _ => IncomingCallNativeEventType.tokenInvalidated,
    },
    callId: callId,
    callerName: callerName,
    callerNumber: callerNumber,
    voiceSdkId: voiceSdkId,
  );
}
