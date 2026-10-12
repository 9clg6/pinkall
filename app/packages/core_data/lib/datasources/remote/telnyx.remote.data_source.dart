import 'package:core_data/model/remote/telnyx_call.remote.model.dart';
import 'package:core_data/model/remote/telnyx_configuration.remote.model.dart';
import 'package:core_data/model/remote/telnyx_connection.remote.model.dart';

/// Remote source contract for Telnyx signaling and WebRTC calls.
abstract interface class TelnyxRemoteDataSource {
  /// Emits signaling connection changes.
  Stream<TelnyxConnectionRemoteModel> watchConnectionStates();

  /// Emits call state changes.
  Stream<TelnyxCallRemoteModel> watchCallStates();

  /// Replays and emits changes for the call identified by [callId].
  Stream<TelnyxCallRemoteModel> watchCallState(String callId);

  /// Ensures microphone access and releases the probe stream immediately.
  Future<void> ensureMicrophoneAccess();

  /// Connects and registers the Telnyx SDK client.
  Future<void> connect(TelnyxConfigurationRemoteModel configuration);

  /// Disconnects the Telnyx SDK client.
  Future<void> disconnect();

  /// Places an outbound call and returns its identifier.
  Future<String> dial({
    required String destinationNumber,
    required String clientState,
    required Map<String, String> customHeaders,
  });

  /// Accepts an incoming call.
  Future<void> accept(String callId);

  /// Rejects an incoming call.
  Future<void> reject(String callId);

  /// Ends a call.
  Future<void> hangUp(String callId);

  /// Sets microphone mute state for a call.
  Future<void> setMuted(String callId, {required bool isMuted});

  /// Sets speaker routing for a call.
  Future<void> setSpeakerEnabled(String callId, {required bool isEnabled});

  /// Releases the data source resources.
  Future<void> dispose();
}
