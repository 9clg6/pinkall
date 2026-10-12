/// Native push transport used to wake Pinkall for an incoming call.
enum IncomingCallTransport {
  /// Apple PushKit VoIP pushes.
  apnsVoip,

  /// Firebase Cloud Messaging data pushes.
  fcm,

  /// No background push transport exists on this platform.
  none,
}
