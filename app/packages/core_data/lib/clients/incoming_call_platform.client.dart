import 'package:core_data/model/remote/incoming_call_capability.remote.model.dart';
import 'package:core_data/model/remote/incoming_call_native_event.remote.model.dart';

/// Testable boundary around PushKit/CallKit and FCM/ConnectionService.
abstract interface class IncomingCallPlatformClient {
  /// Starts only adapters enabled by native build configuration.
  Future<IncomingCallCapabilityRemoteModel> initialize();

  /// Returns the latest native readiness snapshot.
  Future<IncomingCallCapabilityRemoteModel> inspectCapability();

  /// Returns the opaque current notification token, when one exists.
  Future<String?> getNotificationToken();

  /// Emits sanitized native token and call lifecycle events.
  Stream<IncomingCallNativeEventRemoteModel> watchEvents();

  /// Detaches the Flutter event consumer without unregistering push at OS level.
  Future<void> dispose();
}
