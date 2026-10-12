import 'package:core_domain/domain/entities/call_state.entity.dart';
import 'package:core_domain/domain/entities/telnyx_configuration.entity.dart';
import 'package:core_domain/domain/entities/telnyx_connection_state.entity.dart';

/// Contract exposing Telnyx voice calling without leaking vendor SDK types.
abstract interface class CallRepository {
  /// Emits every Telnyx signaling connection transition.
  Stream<TelnyxConnectionStateEntity> watchConnectionStates();

  /// Emits immutable state snapshots for incoming and outgoing calls.
  Stream<CallStateEntity> watchCallStates();

  /// Replays and emits state snapshots for the call identified by [callId].
  Stream<CallStateEntity> watchCallState(String callId);

  /// Requests microphone access and immediately releases the probe stream.
  Future<void> ensureMicrophoneAccess();

  /// Connects and registers a Telnyx WebRTC client.
  Future<void> connect(TelnyxConfigurationEntity configuration);

  /// Disconnects the Telnyx WebRTC client.
  Future<void> disconnect();

  /// Places an outbound call and returns its Telnyx call identifier.
  Future<String> dial({
    required String destinationNumber,
    required String clientState,
    required Map<String, String> customHeaders,
  });

  /// Accepts an incoming call identified by [callId].
  Future<void> accept(String callId);

  /// Rejects a ringing incoming call identified by [callId].
  Future<void> reject(String callId);

  /// Ends the call identified by [callId].
  Future<void> hangUp(String callId);

  /// Sets the local microphone state for [callId].
  Future<void> setMuted(String callId, {required bool isMuted});

  /// Sets the speaker route for [callId].
  Future<void> setSpeakerEnabled(String callId, {required bool isEnabled});

  /// Releases streams and native resources held by the repository.
  Future<void> dispose();
}
