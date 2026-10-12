/// Result of one completed live coaching analysis.
enum CoachAnalysisOutcome {
  /// No approved recommendation was sufficiently relevant.
  none,

  /// One approved recommendation was emitted to the client.
  suggestion,

  /// A candidate was rejected by the quality or evidence gates.
  filtered,

  /// The analysis failed without interrupting the call.
  failed,
}
