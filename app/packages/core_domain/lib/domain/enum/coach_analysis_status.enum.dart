/// Runtime state of the optional live coaching analysis.
enum CoachAnalysisStatus {
  /// OpenAI is evaluating the latest complete prospect turn.
  analyzing,

  /// The coach is waiting for another useful conversation signal.
  listening,
}
