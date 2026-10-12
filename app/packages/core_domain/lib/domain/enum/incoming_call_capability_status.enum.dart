/// Native readiness of background incoming-call delivery.
enum IncomingCallCapabilityStatus {
  /// The current platform has no native background incoming-call adapter.
  unsupported,

  /// The adapter exists but is intentionally gated off in native config.
  disabled,

  /// Native registration started and is waiting for a push token.
  registering,

  /// One or more explicit native/provider requirements are still missing.
  configurationRequired,

  /// Push delivery and the native incoming-call UI are both ready.
  ready,

  /// Native capability inspection failed without claiming readiness.
  error,
}
