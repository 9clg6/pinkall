import 'package:core_domain/domain/entities/coaching_source.entity.dart';
import 'package:core_domain/domain/enum/advice_priority.enum.dart';
import 'package:core_domain/domain/enum/call_commitment_owner.enum.dart';
import 'package:core_domain/domain/enum/call_performance_axis.enum.dart';
import 'package:core_domain/domain/enum/call_performance_signal.enum.dart';
import 'package:core_domain/domain/enum/phrase_coaching_focus.enum.dart';
import 'package:core_domain/domain/enum/strategic_advice_category.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_debrief.entity.freezed.dart';

/// One debrief statement grounded in exact transcript segment identifiers.
@freezed
abstract class GroundedCallTextEntity with _$GroundedCallTextEntity {
  /// Creates grounded call text.
  const factory GroundedCallTextEntity({
    required String text,
    required List<String> evidenceSegmentIds,
  }) = _GroundedCallTextEntity;
}

/// An explicit commitment made by one or both call participants.
@freezed
abstract class CallCommitmentEntity with _$CallCommitmentEntity {
  /// Creates a grounded commitment.
  const factory CallCommitmentEntity({
    required CallCommitmentOwner owner,
    required String text,
    required List<String> evidenceSegmentIds,
    DateTime? dueAt,
  }) = _CallCommitmentEntity;
}

/// A ready-to-review follow-up draft grounded in the final transcript.
@freezed
abstract class CallFollowUpEntity with _$CallFollowUpEntity {
  /// Creates a follow-up draft.
  const factory CallFollowUpEntity({
    required String subject,
    required String body,
    required List<String> evidenceSegmentIds,
    String? nextAction,
    DateTime? dueAt,
  }) = _CallFollowUpEntity;
}

/// The single source-backed improvement selected for the next call.
@freezed
abstract class CallImprovementEntity with _$CallImprovementEntity {
  /// Creates a grounded improvement.
  const factory CallImprovementEntity({
    required String recommendationId,
    required String text,
    required String rationale,
    required List<String> evidenceSegmentIds,
    required List<CoachingSourceEntity> sources,
    required double confidence,
  }) = _CallImprovementEntity;
}

/// One competency measured for the post-call performance radar.
@freezed
abstract class CallPerformanceAxisEntity with _$CallPerformanceAxisEntity {
  /// Creates a transcript-grounded performance measurement.
  const factory CallPerformanceAxisEntity({
    required CallPerformanceAxis axis,
    required int score,
    required CallPerformanceSignal signal,
    required String observation,
    required List<String> evidenceSegmentIds,
  }) = _CallPerformanceAxisEntity;
}

/// A seller phrase paired with a clearer and more persuasive alternative.
@freezed
abstract class PhraseCoachingEntity with _$PhraseCoachingEntity {
  /// Creates phrase-level coaching grounded in the seller transcript.
  const factory PhraseCoachingEntity({
    required PhraseCoachingFocus focus,
    required String originalText,
    required String improvedText,
    required String rationale,
    required List<String> evidenceSegmentIds,
    required List<CoachingSourceEntity> sources,
    required double confidence,
    String? recommendationId,
  }) = _PhraseCoachingEntity;
}

/// Broader advice connecting the call to sales and go-to-market execution.
@freezed
abstract class StrategicCallAdviceEntity with _$StrategicCallAdviceEntity {
  /// Creates one prioritized strategic recommendation.
  const factory StrategicCallAdviceEntity({
    required StrategicAdviceCategory category,
    required AdvicePriority priority,
    required String title,
    required String advice,
    required String rationale,
    required List<String> evidenceSegmentIds,
    required List<CoachingSourceEntity> sources,
    required double confidence,
    String? recommendationId,
  }) = _StrategicCallAdviceEntity;
}

/// Final post-call artifact generated from the reconciled transcript.
@freezed
abstract class CallDebriefEntity with _$CallDebriefEntity {
  /// Creates a complete call debrief.
  const factory CallDebriefEntity({
    required String sessionId,
    required GroundedCallTextEntity summary,
    required List<GroundedCallTextEntity> keyPoints,
    required List<CallCommitmentEntity> commitments,
    required CallFollowUpEntity followUp,
    required DateTime generatedAt,
    required String provider,
    required String model,
    @Default(<GroundedCallTextEntity>[]) List<GroundedCallTextEntity> strengths,
    @Default(<CallPerformanceAxisEntity>[])
    List<CallPerformanceAxisEntity> performanceAxes,
    @Default(<PhraseCoachingEntity>[])
    List<PhraseCoachingEntity> phraseCoaching,
    @Default(<StrategicCallAdviceEntity>[])
    List<StrategicCallAdviceEntity> strategicAdvice,
    CallImprovementEntity? improvement,
  }) = _CallDebriefEntity;
}
