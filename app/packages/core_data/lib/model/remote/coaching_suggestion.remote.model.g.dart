// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coaching_suggestion.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoachingSuggestionRemoteModel _$CoachingSuggestionRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CoachingSuggestionRemoteModel(
  id: json['id'] as String,
  sessionId: json['session_id'] as String,
  kind: json['kind'] as String,
  text: json['text'] as String,
  rationale: json['rationale'] as String,
  sources: (json['sources'] as List<dynamic>)
      .map((e) => CoachingSourceRemoteModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  confidence: (json['confidence'] as num).toDouble(),
  createdAt: DateTime.parse(json['created_at'] as String),
  expiresAt: DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$CoachingSuggestionRemoteModelToJson(
  _CoachingSuggestionRemoteModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'kind': instance.kind,
  'text': instance.text,
  'rationale': instance.rationale,
  'sources': instance.sources.map((e) => e.toJson()).toList(),
  'confidence': instance.confidence,
  'created_at': instance.createdAt.toIso8601String(),
  'expires_at': instance.expiresAt.toIso8601String(),
};
