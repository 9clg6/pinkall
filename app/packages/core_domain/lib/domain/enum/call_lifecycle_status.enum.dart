/// Vendor-independent lifecycle of a voice call.
enum CallLifecycleStatus {
  /// The outbound call has been created locally.
  newCall,

  /// Media and signaling are being connected.
  connecting,

  /// The call is ringing.
  ringing,

  /// Both participants are connected.
  active,

  /// The call is held.
  held,

  /// The SDK is restoring a temporarily interrupted call.
  reconnecting,

  /// WebRTC media is being renegotiated.
  renegotiating,

  /// The call was dropped after a connectivity failure.
  dropped,

  /// The call ended normally or was rejected.
  ended,

  /// The call failed.
  error,
}
