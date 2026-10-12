// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coaching_feedback.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoachingFeedbackRemoteModel _$CoachingFeedbackRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CoachingFeedbackRemoteModel(
  id: json['id'] as String,
  sessionId: json['session_id'] as String,
  suggestionId: json['suggestion_id'] as String,
  value: json['value'] as String,
  applied: json['applied'] as bool,
  submittedAt: DateTime.parse(json['submitted_at'] as String),
  note: json['note'] as String?,
);

Map<String, dynamic> _$CoachingFeedbackRemoteModelToJson(
  _CoachingFeedbackRemoteModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'suggestion_id': instance.suggestionId,
  'value': instance.value,
  'applied': instance.applied,
  'submitted_at': instance.submittedAt.toIso8601String(),
  'note': instance.note,
};
