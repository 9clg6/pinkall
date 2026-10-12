// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_debrief.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GroundedCallTextRemoteModel _$GroundedCallTextRemoteModelFromJson(
  Map<String, dynamic> json,
) => _GroundedCallTextRemoteModel(
  text: json['text'] as String,
  evidenceSegmentIds: (json['evidence_segment_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$GroundedCallTextRemoteModelToJson(
  _GroundedCallTextRemoteModel instance,
) => <String, dynamic>{
  'text': instance.text,
  'evidence_segment_ids': instance.evidenceSegmentIds,
};

_CallCommitmentRemoteModel _$CallCommitmentRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CallCommitmentRemoteModel(
  owner: json['owner'] as String,
  text: json['text'] as String,
  evidenceSegmentIds: (json['evidence_segment_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  dueAt: json['due_at'] == null
      ? null
      : DateTime.parse(json['due_at'] as String),
);

Map<String, dynamic> _$CallCommitmentRemoteModelToJson(
  _CallCommitmentRemoteModel instance,
) => <String, dynamic>{
  'owner': instance.owner,
  'text': instance.text,
  'evidence_segment_ids': instance.evidenceSegmentIds,
  'due_at': instance.dueAt?.toIso8601String(),
};

_CallFollowUpRemoteModel _$CallFollowUpRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CallFollowUpRemoteModel(
  subject: json['subject'] as String,
  body: json['body'] as String,
  evidenceSegmentIds: (json['evidence_segment_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  nextAction: json['next_action'] as String?,
  dueAt: json['due_at'] == null
      ? null
      : DateTime.parse(json['due_at'] as String),
);

Map<String, dynamic> _$CallFollowUpRemoteModelToJson(
  _CallFollowUpRemoteModel instance,
) => <String, dynamic>{
  'subject': instance.subject,
  'body': instance.body,
  'evidence_segment_ids': instance.evidenceSegmentIds,
  'next_action': instance.nextAction,
  'due_at': instance.dueAt?.toIso8601String(),
};

_CallImprovementRemoteModel _$CallImprovementRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CallImprovementRemoteModel(
  recommendationId: json['recommendation_id'] as String,
  text: json['text'] as String,
  rationale: json['rationale'] as String,
  evidenceSegmentIds: (json['evidence_segment_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  sources: (json['sources'] as List<dynamic>)
      .map((e) => CoachingSourceRemoteModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  confidence: (json['confidence'] as num).toDouble(),
);

Map<String, dynamic> _$CallImprovementRemoteModelToJson(
  _CallImprovementRemoteModel instance,
) => <String, dynamic>{
  'recommendation_id': instance.recommendationId,
  'text': instance.text,
  'rationale': instance.rationale,
  'evidence_segment_ids': instance.evidenceSegmentIds,
  'sources': instance.sources.map((e) => e.toJson()).toList(),
  'confidence': instance.confidence,
};

_CallPerformanceAxisRemoteModel _$CallPerformanceAxisRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CallPerformanceAxisRemoteModel(
  axis: json['axis'] as String,
  score: (json['score'] as num).toInt(),
  signal: json['signal'] as String,
  observation: json['observation'] as String,
  evidenceSegmentIds: (json['evidence_segment_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CallPerformanceAxisRemoteModelToJson(
  _CallPerformanceAxisRemoteModel instance,
) => <String, dynamic>{
  'axis': instance.axis,
  'score': instance.score,
  'signal': instance.signal,
  'observation': instance.observation,
  'evidence_segment_ids': instance.evidenceSegmentIds,
};

_PhraseCoachingRemoteModel _$PhraseCoachingRemoteModelFromJson(
  Map<String, dynamic> json,
) => _PhraseCoachingRemoteModel(
  focus: json['focus'] as String,
  originalText: json['original_text'] as String,
  improvedText: json['improved_text'] as String,
  rationale: json['rationale'] as String,
  evidenceSegmentIds: (json['evidence_segment_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  sources:
      (json['sources'] as List<dynamic>?)
          ?.map(
            (e) =>
                CoachingSourceRemoteModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <CoachingSourceRemoteModel>[],
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
  recommendationId: json['recommendation_id'] as String?,
);

Map<String, dynamic> _$PhraseCoachingRemoteModelToJson(
  _PhraseCoachingRemoteModel instance,
) => <String, dynamic>{
  'focus': instance.focus,
  'original_text': instance.originalText,
  'improved_text': instance.improvedText,
  'rationale': instance.rationale,
  'evidence_segment_ids': instance.evidenceSegmentIds,
  'sources': instance.sources,
  'confidence': instance.confidence,
  'recommendation_id': instance.recommendationId,
};

_StrategicCallAdviceRemoteModel _$StrategicCallAdviceRemoteModelFromJson(
  Map<String, dynamic> json,
) => _StrategicCallAdviceRemoteModel(
  category: json['category'] as String,
  priority: json['priority'] as String,
  title: json['title'] as String,
  advice: json['advice'] as String,
  rationale: json['rationale'] as String,
  evidenceSegmentIds: (json['evidence_segment_ids'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  sources:
      (json['sources'] as List<dynamic>?)
          ?.map(
            (e) =>
                CoachingSourceRemoteModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <CoachingSourceRemoteModel>[],
  confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
  recommendationId: json['recommendation_id'] as String?,
);

Map<String, dynamic> _$StrategicCallAdviceRemoteModelToJson(
  _StrategicCallAdviceRemoteModel instance,
) => <String, dynamic>{
  'category': instance.category,
  'priority': instance.priority,
  'title': instance.title,
  'advice': instance.advice,
  'rationale': instance.rationale,
  'evidence_segment_ids': instance.evidenceSegmentIds,
  'sources': instance.sources,
  'confidence': instance.confidence,
  'recommendation_id': instance.recommendationId,
};

_CallDebriefRemoteModel _$CallDebriefRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CallDebriefRemoteModel(
  sessionId: json['session_id'] as String,
  summary: GroundedCallTextRemoteModel.fromJson(
    json['summary'] as Map<String, dynamic>,
  ),
  keyPoints: (json['key_points'] as List<dynamic>)
      .map(
        (e) => GroundedCallTextRemoteModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  commitments: (json['commitments'] as List<dynamic>)
      .map((e) => CallCommitmentRemoteModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  followUp: CallFollowUpRemoteModel.fromJson(
    json['follow_up'] as Map<String, dynamic>,
  ),
  generatedAt: DateTime.parse(json['generated_at'] as String),
  provider: json['provider'] as String,
  model: json['model'] as String,
  strengths:
      (json['strengths'] as List<dynamic>?)
          ?.map(
            (e) =>
                GroundedCallTextRemoteModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <GroundedCallTextRemoteModel>[],
  performanceAxes:
      (json['performance_axes'] as List<dynamic>?)
          ?.map(
            (e) => CallPerformanceAxisRemoteModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const <CallPerformanceAxisRemoteModel>[],
  phraseCoaching:
      (json['phrase_coaching'] as List<dynamic>?)
          ?.map(
            (e) =>
                PhraseCoachingRemoteModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <PhraseCoachingRemoteModel>[],
  strategicAdvice:
      (json['strategic_advice'] as List<dynamic>?)
          ?.map(
            (e) => StrategicCallAdviceRemoteModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const <StrategicCallAdviceRemoteModel>[],
  improvement: json['improvement'] == null
      ? null
      : CallImprovementRemoteModel.fromJson(
          json['improvement'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$CallDebriefRemoteModelToJson(
  _CallDebriefRemoteModel instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'summary': instance.summary.toJson(),
  'key_points': instance.keyPoints.map((e) => e.toJson()).toList(),
  'commitments': instance.commitments.map((e) => e.toJson()).toList(),
  'follow_up': instance.followUp.toJson(),
  'generated_at': instance.generatedAt.toIso8601String(),
  'provider': instance.provider,
  'model': instance.model,
  'strengths': instance.strengths.map((e) => e.toJson()).toList(),
  'performance_axes': instance.performanceAxes.map((e) => e.toJson()).toList(),
  'phrase_coaching': instance.phraseCoaching.map((e) => e.toJson()).toList(),
  'strategic_advice': instance.strategicAdvice.map((e) => e.toJson()).toList(),
  'improvement': instance.improvement?.toJson(),
};
