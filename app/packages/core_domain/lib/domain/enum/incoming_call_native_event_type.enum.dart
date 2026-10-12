/// Events emitted by the native background incoming-call bridge.
enum IncomingCallNativeEventType {
  /// A fresh APNS VoIP or FCM token is available.
  tokenUpdated,

  /// The push transport delivered an incoming-call invitation.
  incomingCall,

  /// The user answered from the native system surface.
  answerRequested,

  /// The user declined from the native system surface.
  declineRequested,

  /// The operating system invalidated the current push token.
  tokenInvalidated,
}
