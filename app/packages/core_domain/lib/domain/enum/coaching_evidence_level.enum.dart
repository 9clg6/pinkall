import 'package:json_annotation/json_annotation.dart';

/// Strength of evidence supporting a coaching source.
@JsonEnum(fieldRename: FieldRename.snake)
enum CoachingEvidenceLevel {
  /// Uncorroborated anecdote or hypothesis.
  anecdotal,

  /// Practitioner playbook, course, book, or expert guidance.
  practitioner,

  /// Observational field data without controlled assignment.
  observational,

  /// Peer-reviewed empirical evidence.
  empirical,

  /// Controlled laboratory or field experiment.
  experimental,

  /// Systematic review, meta-analysis, or replicated evidence.
  systematicReview,
}
