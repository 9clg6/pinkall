/// Platform owning the incoming-call delivery lifecycle.
enum IncomingCallPlatform {
  /// Apple iPhone/iPad application.
  ios,

  /// Android application.
  android,

  /// macOS desktop application.
  macos,

  /// Web or an unrecognized target.
  other,
}
