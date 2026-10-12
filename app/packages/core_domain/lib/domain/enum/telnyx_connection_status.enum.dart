/// Connection states exposed by the Telnyx calling domain.
enum TelnyxConnectionStatus {
  /// The client is not connected to Telnyx.
  disconnected,

  /// A connection and registration attempt is in progress.
  connecting,

  /// The signaling socket is connected but registration is not complete.
  connected,

  /// The SDK is restoring a lost connection.
  reconnecting,

  /// The client is registered and can place or receive calls.
  ready,

  /// The latest connection attempt failed.
  failure,
}
