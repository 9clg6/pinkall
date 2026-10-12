import 'package:core_data/model/remote/telnyx_call.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Maps SDK call models to vendor-independent domain snapshots.
extension TelnyxCallMapper on TelnyxCallRemoteModel {
  /// Converts this remote model to a domain entity.
  CallStateEntity toEntity() {
    return CallStateEntity(
      callId: callId,
      direction: _directionFromRemote(direction),
      status: _callStatusFromRemote(status),
      remoteName: remoteName,
      remoteNumber: remoteNumber,
      isMuted: isMuted,
      isSpeakerEnabled: isSpeakerEnabled,
      failureReason: failureReason,
    );
  }
}

CallDirection _directionFromRemote(String direction) {
  return switch (direction) {
    'incoming' => CallDirection.incoming,
    'outgoing' => CallDirection.outgoing,
    _ => throw FormatException('Unknown Telnyx call direction: $direction'),
  };
}

CallLifecycleStatus _callStatusFromRemote(String status) {
  return switch (status) {
    'newCall' => CallLifecycleStatus.newCall,
    'connecting' => CallLifecycleStatus.connecting,
    'ringing' => CallLifecycleStatus.ringing,
    'active' => CallLifecycleStatus.active,
    'held' => CallLifecycleStatus.held,
    'reconnecting' => CallLifecycleStatus.reconnecting,
    'renegotiating' => CallLifecycleStatus.renegotiating,
    'dropped' => CallLifecycleStatus.dropped,
    'ended' => CallLifecycleStatus.ended,
    'error' => CallLifecycleStatus.error,
    _ => throw FormatException('Unknown Telnyx call status: $status'),
  };
}
