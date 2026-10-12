import 'package:core_data/mappers/coaching.mapper.dart';
import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/call_debrief.remote.model.dart';
import 'package:core_data/model/remote/coaching_source.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Domain mapping for transcript-grounded text.
extension GroundedCallTextRemoteModelX on GroundedCallTextRemoteModel {
  /// Converts this API model to an immutable domain entity.
  GroundedCallTextEntity toEntity() => GroundedCallTextEntity(
    text: text,
    evidenceSegmentIds: evidenceSegmentIds,
  );
}

/// Domain mapping for a commitment.
extension CallCommitmentRemoteModelX on CallCommitmentRemoteModel {
  /// Converts this API model to an immutable domain entity.
  CallCommitmentEntity toEntity() => CallCommitmentEntity(
    owner: enumFromWireName<CallCommitmentOwner>(
      CallCommitmentOwner.values,
      owner,
    ),
    text: text,
    dueAt: dueAt,
    evidenceSegmentIds: evidenceSegmentIds,
  );
}

/// Domain mapping for a follow-up draft.
extension CallFollowUpRemoteModelX on CallFollowUpRemoteModel {
  /// Converts this API model to an immutable domain entity.
  CallFollowUpEntity toEntity() => CallFollowUpEntity(
    subject: subject,
    body: body,
    nextAction: nextAction,
    dueAt: dueAt,
    evidenceSegmentIds: evidenceSegmentIds,
  );
}

/// Domain mapping for a source-backed improvement.
extension CallImprovementRemoteModelX on CallImprovementRemoteModel {
  /// Converts this API model to an immutable domain entity.
  CallImprovementEntity toEntity() => CallImprovementEntity(
    recommendationId: recommendationId,
    text: text,
    rationale: rationale,
    evidenceSegmentIds: evidenceSegmentIds,
    sources: sources
        .map((CoachingSourceRemoteModel source) => source.toEntity())
        .toList(growable: false),
    confidence: confidence,
  );
}

/// Domain mapping for a radar competency.
extension CallPerformanceAxisRemoteModelX on CallPerformanceAxisRemoteModel {
  /// Converts this API model to an immutable domain entity.
  CallPerformanceAxisEntity toEntity() => CallPerformanceAxisEntity(
    axis: enumFromWireName<CallPerformanceAxis>(
      CallPerformanceAxis.values,
      axis,
    ),
    score: score,
    signal: enumFromWireName<CallPerformanceSignal>(
      CallPerformanceSignal.values,
      signal,
    ),
    observation: observation,
    evidenceSegmentIds: evidenceSegmentIds,
  );
}

/// Domain mapping for phrase-level coaching.
extension PhraseCoachingRemoteModelX on PhraseCoachingRemoteModel {
  /// Converts this API model to an immutable domain entity.
  PhraseCoachingEntity toEntity() => PhraseCoachingEntity(
    focus: enumFromWireName<PhraseCoachingFocus>(
      PhraseCoachingFocus.values,
      focus,
    ),
    originalText: originalText,
    improvedText: improvedText,
    rationale: rationale,
    evidenceSegmentIds: evidenceSegmentIds,
    recommendationId: recommendationId,
    sources: sources
        .map((CoachingSourceRemoteModel source) => source.toEntity())
        .toList(growable: false),
    confidence: confidence,
  );
}

/// Domain mapping for broader strategic advice.
extension StrategicCallAdviceRemoteModelX on StrategicCallAdviceRemoteModel {
  /// Converts this API model to an immutable domain entity.
  StrategicCallAdviceEntity toEntity() => StrategicCallAdviceEntity(
    category: enumFromWireName<StrategicAdviceCategory>(
      StrategicAdviceCategory.values,
      category,
    ),
    priority: enumFromWireName<AdvicePriority>(AdvicePriority.values, priority),
    title: title,
    advice: advice,
    rationale: rationale,
    evidenceSegmentIds: evidenceSegmentIds,
    recommendationId: recommendationId,
    sources: sources
        .map((CoachingSourceRemoteModel source) => source.toEntity())
        .toList(growable: false),
    confidence: confidence,
  );
}

/// Domain mapping for a complete post-call debrief.
extension CallDebriefRemoteModelX on CallDebriefRemoteModel {
  /// Converts this API model to an immutable domain entity.
  CallDebriefEntity toEntity() => CallDebriefEntity(
    sessionId: sessionId,
    summary: summary.toEntity(),
    keyPoints: keyPoints
        .map((GroundedCallTextRemoteModel item) => item.toEntity())
        .toList(growable: false),
    commitments: commitments
        .map((CallCommitmentRemoteModel item) => item.toEntity())
        .toList(growable: false),
    followUp: followUp.toEntity(),
    improvement: improvement?.toEntity(),
    strengths: strengths
        .map((GroundedCallTextRemoteModel item) => item.toEntity())
        .toList(growable: false),
    performanceAxes: performanceAxes
        .map((CallPerformanceAxisRemoteModel item) => item.toEntity())
        .toList(growable: false),
    phraseCoaching: phraseCoaching
        .map((PhraseCoachingRemoteModel item) => item.toEntity())
        .toList(growable: false),
    strategicAdvice: strategicAdvice
        .map((StrategicCallAdviceRemoteModel item) => item.toEntity())
        .toList(growable: false),
    generatedAt: generatedAt,
    provider: provider,
    model: model,
  );
}
