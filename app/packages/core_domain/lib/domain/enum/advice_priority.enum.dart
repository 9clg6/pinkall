/// Relative priority of one post-call recommendation.
enum AdvicePriority {
  /// Should be applied on the next call.
  high,

  /// Material improvement after the main priority.
  medium,

  /// Useful refinement with lower immediate impact.
  low,
}
