// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objection_knowledge_entry.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ObjectionResponseRemoteModel _$ObjectionResponseRemoteModelFromJson(
  Map<String, dynamic> json,
) => _ObjectionResponseRemoteModel(
  content: json['content'] as String,
  sourceType: json['source_type'] as String,
  sourceName: json['source_name'] as String?,
);

Map<String, dynamic> _$ObjectionResponseRemoteModelToJson(
  _ObjectionResponseRemoteModel instance,
) => <String, dynamic>{
  'content': instance.content,
  'source_type': instance.sourceType,
  'source_name': instance.sourceName,
};

_ObjectionKnowledgeEntryRemoteModel
_$ObjectionKnowledgeEntryRemoteModelFromJson(Map<String, dynamic> json) =>
    _ObjectionKnowledgeEntryRemoteModel(
      id: json['id'] as String,
      category: json['category'] as String,
      text: json['text'] as String,
      reviewStatus: json['review_status'] as String,
      origin: json['origin'] as String,
      occurrenceCount: (json['occurrence_count'] as num).toInt(),
      firstSeenAt: DateTime.parse(json['first_seen_at'] as String),
      lastSeenAt: DateTime.parse(json['last_seen_at'] as String),
      response: json['response'] == null
          ? null
          : ObjectionResponseRemoteModel.fromJson(
              json['response'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ObjectionKnowledgeEntryRemoteModelToJson(
  _ObjectionKnowledgeEntryRemoteModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'text': instance.text,
  'review_status': instance.reviewStatus,
  'origin': instance.origin,
  'occurrence_count': instance.occurrenceCount,
  'first_seen_at': instance.firstSeenAt.toIso8601String(),
  'last_seen_at': instance.lastSeenAt.toIso8601String(),
  'response': instance.response,
};

_ObjectionKnowledgeListRemoteModel _$ObjectionKnowledgeListRemoteModelFromJson(
  Map<String, dynamic> json,
) => _ObjectionKnowledgeListRemoteModel(
  items: (json['items'] as List<dynamic>)
      .map(
        (e) => ObjectionKnowledgeEntryRemoteModel.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
);

Map<String, dynamic> _$ObjectionKnowledgeListRemoteModelToJson(
  _ObjectionKnowledgeListRemoteModel instance,
) => <String, dynamic>{'items': instance.items};
