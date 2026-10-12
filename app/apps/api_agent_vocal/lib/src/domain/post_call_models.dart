import 'package:api_agent_vocal/src/domain/models.dart';

/// Durable lifecycle of the asynchronous post-call generation.
enum PostCallGenerationStatus {
  pending,
  running,
  retrying,
  completed,
  failed,
  unavailable;

  /// Parses a value stored in the durable workspace snapshot.
  static PostCallGenerationStatus parse(String value) {
    return PostCallGenerationStatus.values.firstWhere(
      (PostCallGenerationStatus status) => status.name == value,
      orElse: () => throw FormatException(
        'Unsupported post-call generation status: $value',
      ),
    );
  }
}

/// Client-safe and durable diagnostic for one post-call generation job.
final class PostCallGenerationSnapshot {
  const PostCallGenerationSnapshot({
    required this.sessionId,
    required this.status,
    required this.attemptCount,
    required this.updatedAt,
    required this.failureCode,
    required this.retryable,
    required this.nextRetryAt,
  });

  final String sessionId;
  final PostCallGenerationStatus status;
  final int attemptCount;
  final DateTime updatedAt;
  final String? failureCode;
  final bool? retryable;
  final DateTime? nextRetryAt;

  Map<String, Object?> toJson() => <String, Object?>{
    'session_id': sessionId,
    'status': status.name,
    'attempt_count': attemptCount,
    'updated_at': updatedAt.toUtc().toIso8601String(),
    'failure_code': failureCode,
    'retryable': retryable,
    'next_retry_at': nextRetryAt?.toUtc().toIso8601String(),
  };
}

/// The participant responsible for a commitment extracted from a call.
enum PostCallCommitmentOwner {
  seller,
  prospect,
  mutual;

  static PostCallCommitmentOwner parse(String value) {
    return PostCallCommitmentOwner.values.firstWhere(
      (PostCallCommitmentOwner owner) => owner.name == value,
      orElse: () =>
          throw FormatException('Unknown post-call commitment owner: $value'),
    );
  }
}

/// Stable dimensions used by the post-call performance radar.
enum PostCallPerformanceAxisName {
  listening,
  discovery,
  clarity,
  confidence,
  value,
  personalization,
  progression,
  naturalness;

  static PostCallPerformanceAxisName parse(String value) {
    return PostCallPerformanceAxisName.values.firstWhere(
      (PostCallPerformanceAxisName axis) => axis.name == value,
      orElse: () =>
          throw FormatException('Unknown post-call performance axis: $value'),
    );
  }
}

/// Whether one performance dimension is underused, balanced or overused.
enum PostCallPerformanceSignal {
  tooLow('too_low'),
  balanced('balanced'),
  tooHigh('too_high');

  const PostCallPerformanceSignal(this.wireName);

  final String wireName;

  static PostCallPerformanceSignal parse(String value) {
    return PostCallPerformanceSignal.values.firstWhere(
      (PostCallPerformanceSignal signal) => signal.wireName == value,
      orElse: () =>
          throw FormatException('Unknown post-call performance signal: $value'),
    );
  }
}

/// Communication dimension targeted by one phrase-level rewrite.
enum PostCallPhraseFocus {
  clarity,
  confidence,
  humanity,
  persuasion,
  positioning;

  static PostCallPhraseFocus parse(String value) {
    return PostCallPhraseFocus.values.firstWhere(
      (PostCallPhraseFocus focus) => focus.name == value,
      orElse: () =>
          throw FormatException('Unknown post-call phrase focus: $value'),
    );
  }
}

/// Broader business dimension targeted by strategic post-call advice.
enum PostCallStrategicAdviceCategory {
  sales,
  marketing,
  product,
  strategy,
  communication;

  static PostCallStrategicAdviceCategory parse(String value) {
    return PostCallStrategicAdviceCategory.values.firstWhere(
      (PostCallStrategicAdviceCategory category) => category.name == value,
      orElse: () => throw FormatException(
        'Unknown post-call strategic advice category: $value',
      ),
    );
  }
}

/// Importance assigned to one strategic recommendation.
enum PostCallStrategicAdvicePriority {
  high,
  medium,
  low;

  static PostCallStrategicAdvicePriority parse(String value) {
    return PostCallStrategicAdvicePriority.values.firstWhere(
      (PostCallStrategicAdvicePriority priority) => priority.name == value,
      orElse: () => throw FormatException(
        'Unknown post-call strategic advice priority: $value',
      ),
    );
  }
}

/// Stable buckets used to aggregate equivalent objections across calls.
enum PostCallObjectionCategory {
  price,
  timing,
  need,
  authority,
  trust,
  competition,
  implementation,
  security,
  compliance,
  other;

  static PostCallObjectionCategory parse(String value) {
    return PostCallObjectionCategory.values.firstWhere(
      (PostCallObjectionCategory category) => category.name == value,
      orElse: () =>
          throw FormatException('Unknown post-call objection category: $value'),
    );
  }
}

/// One prospect objection and a safe candidate answer grounded in the call.
final class PostCallObjection {
  const PostCallObjection({
    required this.category,
    required this.text,
    required this.responseAngle,
    required this.suggestedResponse,
    required this.evidenceSegmentIds,
    required this.confidence,
  });

  final PostCallObjectionCategory category;
  final String text;
  final String responseAngle;
  final String suggestedResponse;
  final List<String> evidenceSegmentIds;
  final double confidence;

  Map<String, Object?> toJson() => <String, Object?>{
    'category': category.name,
    'text': text,
    'response_angle': responseAngle,
    'suggested_response': suggestedResponse,
    'evidence_segment_ids': evidenceSegmentIds,
    'confidence': confidence,
  };
}

/// A piece of post-call copy grounded in explicit transcript segment IDs.
final class PostCallGroundedText {
  const PostCallGroundedText({
    required this.text,
    required this.evidenceSegmentIds,
  });

  final String text;
  final List<String> evidenceSegmentIds;

  Map<String, Object?> toJson() => <String, Object?>{
    'text': text,
    'evidence_segment_ids': evidenceSegmentIds,
  };
}

/// A commitment explicitly made during the call.
final class PostCallCommitment {
  const PostCallCommitment({
    required this.owner,
    required this.text,
    required this.dueAt,
    required this.evidenceSegmentIds,
  });

  final PostCallCommitmentOwner owner;
  final String text;
  final DateTime? dueAt;
  final List<String> evidenceSegmentIds;

  Map<String, Object?> toJson() => <String, Object?>{
    'owner': owner.name,
    'text': text,
    'due_at': dueAt?.toUtc().toIso8601String(),
    'evidence_segment_ids': evidenceSegmentIds,
  };
}

/// A follow-up draft generated from facts present in the transcript.
final class PostCallFollowUp {
  const PostCallFollowUp({
    required this.subject,
    required this.body,
    required this.nextAction,
    required this.dueAt,
    required this.evidenceSegmentIds,
  });

  final String subject;
  final String body;
  final String? nextAction;
  final DateTime? dueAt;
  final List<String> evidenceSegmentIds;

  Map<String, Object?> toJson() => <String, Object?>{
    'subject': subject,
    'body': body,
    'next_action': nextAction,
    'due_at': dueAt?.toUtc().toIso8601String(),
    'evidence_segment_ids': evidenceSegmentIds,
  };
}

/// One source-backed improvement selected from the curated catalogue.
final class PostCallImprovement {
  const PostCallImprovement({
    required this.recommendationId,
    required this.text,
    required this.rationale,
    required this.evidenceSegmentIds,
    required this.sources,
    required this.confidence,
  });

  final String recommendationId;
  final String text;
  final String rationale;
  final List<String> evidenceSegmentIds;
  final List<CoachSource> sources;
  final double confidence;

  Map<String, Object?> toJson() => <String, Object?>{
    'recommendation_id': recommendationId,
    'text': text,
    'rationale': rationale,
    'evidence_segment_ids': evidenceSegmentIds,
    'sources': sources
        .map((CoachSource source) => source.toClientJson())
        .toList(growable: false),
    'confidence': confidence,
  };
}

/// One evidence-backed dimension rendered on the performance radar.
final class PostCallPerformanceAxis {
  const PostCallPerformanceAxis({
    required this.axis,
    required this.score,
    required this.signal,
    required this.observation,
    required this.evidenceSegmentIds,
  });

  final PostCallPerformanceAxisName axis;
  final int score;
  final PostCallPerformanceSignal signal;
  final String observation;
  final List<String> evidenceSegmentIds;

  Map<String, Object?> toJson() => <String, Object?>{
    'axis': axis.name,
    'score': score,
    'signal': signal.wireName,
    'observation': observation,
    'evidence_segment_ids': evidenceSegmentIds,
  };
}

/// A rewrite of an exact seller phrase, grounded in the final transcript.
final class PostCallPhraseCoaching {
  const PostCallPhraseCoaching({
    required this.focus,
    required this.originalText,
    required this.improvedText,
    required this.rationale,
    required this.recommendationId,
    required this.evidenceSegmentIds,
    required this.sources,
    required this.confidence,
  });

  final PostCallPhraseFocus focus;
  final String originalText;
  final String improvedText;
  final String rationale;
  final String? recommendationId;
  final List<String> evidenceSegmentIds;
  final List<CoachSource> sources;
  final double confidence;

  Map<String, Object?> toJson() => <String, Object?>{
    'focus': focus.name,
    'original_text': originalText,
    'improved_text': improvedText,
    'rationale': rationale,
    'recommendation_id': recommendationId,
    'evidence_segment_ids': evidenceSegmentIds,
    'sources': sources
        .map((CoachSource source) => source.toClientJson())
        .toList(growable: false),
    'confidence': confidence,
  };
}

/// A transcript-grounded recommendation spanning the complete sales context.
final class PostCallStrategicAdvice {
  const PostCallStrategicAdvice({
    required this.category,
    required this.priority,
    required this.title,
    required this.advice,
    required this.rationale,
    required this.recommendationId,
    required this.evidenceSegmentIds,
    required this.sources,
    required this.confidence,
  });

  final PostCallStrategicAdviceCategory category;
  final PostCallStrategicAdvicePriority priority;
  final String title;
  final String advice;
  final String rationale;
  final String? recommendationId;
  final List<String> evidenceSegmentIds;
  final List<CoachSource> sources;
  final double confidence;

  Map<String, Object?> toJson() => <String, Object?>{
    'category': category.name,
    'priority': priority.name,
    'title': title,
    'advice': advice,
    'rationale': rationale,
    'recommendation_id': recommendationId,
    'evidence_segment_ids': evidenceSegmentIds,
    'sources': sources
        .map((CoachSource source) => source.toClientJson())
        .toList(growable: false),
    'confidence': confidence,
  };
}

/// Immutable final artifact generated from a reconciled call transcript.
final class PostCallDebrief {
  static const String currentPerformanceRubricVersion = 'performance-v1';

  const PostCallDebrief({
    required this.sessionId,
    required this.summary,
    required this.keyPoints,
    required this.commitments,
    required this.followUp,
    required this.improvement,
    required this.generatedAt,
    required this.provider,
    required this.model,
    this.performanceRubricVersion = currentPerformanceRubricVersion,
    this.strengths = const <PostCallGroundedText>[],
    this.performanceAxes = const <PostCallPerformanceAxis>[],
    this.phraseCoaching = const <PostCallPhraseCoaching>[],
    this.strategicAdvice = const <PostCallStrategicAdvice>[],
    this.objections = const <PostCallObjection>[],
  });

  final String sessionId;
  final PostCallGroundedText summary;
  final List<PostCallGroundedText> keyPoints;
  final List<PostCallCommitment> commitments;
  final PostCallFollowUp followUp;
  final PostCallImprovement? improvement;
  final DateTime generatedAt;
  final String provider;
  final String model;
  final String performanceRubricVersion;
  final List<PostCallGroundedText> strengths;
  final List<PostCallPerformanceAxis> performanceAxes;
  final List<PostCallPhraseCoaching> phraseCoaching;
  final List<PostCallStrategicAdvice> strategicAdvice;
  final List<PostCallObjection> objections;

  Map<String, Object?> toJson() => <String, Object?>{
    'session_id': sessionId,
    'summary': summary.toJson(),
    'key_points': keyPoints
        .map((PostCallGroundedText item) => item.toJson())
        .toList(growable: false),
    'commitments': commitments
        .map((PostCallCommitment item) => item.toJson())
        .toList(growable: false),
    'follow_up': followUp.toJson(),
    'improvement': improvement?.toJson(),
    'generated_at': generatedAt.toUtc().toIso8601String(),
    'provider': provider,
    'model': model,
    'performance_rubric_version': performanceRubricVersion,
    'strengths': strengths
        .map((PostCallGroundedText item) => item.toJson())
        .toList(growable: false),
    'performance_axes': performanceAxes
        .map((PostCallPerformanceAxis item) => item.toJson())
        .toList(growable: false),
    'phrase_coaching': phraseCoaching
        .map((PostCallPhraseCoaching item) => item.toJson())
        .toList(growable: false),
    'strategic_advice': strategicAdvice
        .map((PostCallStrategicAdvice item) => item.toJson())
        .toList(growable: false),
    'objections': objections
        .map((PostCallObjection item) => item.toJson())
        .toList(growable: false),
    'version': 3,
  };
}
