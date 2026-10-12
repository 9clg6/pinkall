/// Direction of the observed behaviour relative to the useful balance.
enum CallPerformanceSignal {
  /// The useful behaviour is not present enough.
  tooLow,

  /// The behaviour is within a productive balance.
  balanced,

  /// The behaviour is overused and should be reduced.
  tooHigh,
}
