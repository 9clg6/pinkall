import 'package:core_domain/domain/enum/incoming_call_native_event_type.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_call_native_event.entity.freezed.dart';

/// Sanitized event emitted by PushKit/CallKit or FCM/ConnectionService.
@freezed
abstract class IncomingCallNativeEventEntity
    with _$IncomingCallNativeEventEntity {
  /// Creates an event containing only Telnyx routing metadata.
  const factory IncomingCallNativeEventEntity({
    required IncomingCallNativeEventType type,
    String? callId,
    String? callerName,
    String? callerNumber,
    String? voiceSdkId,
  }) = _IncomingCallNativeEventEntity;
}
