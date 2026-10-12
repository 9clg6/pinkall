import 'package:core_domain/domain/entities/incoming_call_capability.entity.dart';
import 'package:core_domain/domain/entities/incoming_call_native_event.entity.dart';

/// Vendor-neutral boundary for native background incoming-call delivery.
abstract interface class IncomingCallRepository {
  /// Initializes only the native adapters explicitly enabled by configuration.
  Future<IncomingCallCapabilityEntity> initialize();

  /// Returns a fresh, truthful capability snapshot.
  Future<IncomingCallCapabilityEntity> inspectCapability();

  /// Returns the current APNS VoIP/FCM token without persisting it in UI state.
  Future<String?> getNotificationToken();

  /// Emits token, push and native answer/decline events.
  Stream<IncomingCallNativeEventEntity> watchNativeEvents();

  /// Releases method/event-channel resources.
  Future<void> dispose();
}
