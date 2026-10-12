import 'package:freezed_annotation/freezed_annotation.dart';

part 'incoming_call_native_event.remote.model.freezed.dart';

/// Sanitized event payload decoded from the native event channel.
@freezed
abstract class IncomingCallNativeEventRemoteModel
    with _$IncomingCallNativeEventRemoteModel {
  /// Creates a native event model.
  const factory IncomingCallNativeEventRemoteModel({
    required String type,
    String? callId,
    String? callerName,
    String? callerNumber,
    String? voiceSdkId,
  }) = _IncomingCallNativeEventRemoteModel;
}
