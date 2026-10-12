import 'package:core_data/model/remote/telnyx_call.remote.model.dart';
import 'package:core_data/model/remote/telnyx_configuration.remote.model.dart';
import 'package:core_data/model/remote/telnyx_connection.remote.model.dart';

/// Testable boundary around the concrete Telnyx Flutter SDK.
abstract interface class TelnyxSdkClient {
  /// Emits signaling connection changes from the SDK.
  Stream<TelnyxConnectionRemoteModel> watchConnectionStates();

  /// Emits call changes from the SDK.
  Stream<TelnyxCallRemoteModel> watchCallStates();

  /// Replays and emits changes for the call identified by [callId].
  Stream<TelnyxCallRemoteModel> watchCallState(String callId);

  /// Connects and waits until the Telnyx client is registered.
  Future<void> connect(TelnyxConfigurationRemoteModel configuration);

  /// Disconnects the SDK client.
  Future<void> disconnect();

  /// Places a call and returns its call identifier.
  Future<String> dial({
    required String destinationNumber,
    required String clientState,
    required Map<String, String> customHeaders,
  });

  /// Accepts a pending incoming call.
  Future<void> accept(String callId);

  /// Rejects a pending incoming call.
  Future<void> reject(String callId);

  /// Ends a call.
  Future<void> hangUp(String callId);

  /// Sets microphone mute state for a call.
  Future<void> setMuted(String callId, {required bool isMuted});

  /// Sets speaker routing for a call.
  Future<void> setSpeakerEnabled(String callId, {required bool isEnabled});

  /// Releases native and stream resources.
  Future<void> dispose();
}
