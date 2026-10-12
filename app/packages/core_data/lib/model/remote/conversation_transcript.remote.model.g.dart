// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_transcript.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationTranscriptRemoteModel _$ConversationTranscriptRemoteModelFromJson(
  Map<String, dynamic> json,
) => _ConversationTranscriptRemoteModel(
  sessionId: json['session_id'] as String,
  segments: (json['segments'] as List<dynamic>)
      .map(
        (e) => TranscriptSegmentRemoteModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  finalizedAt: DateTime.parse(json['finalized_at'] as String),
  languageCode: json['language_code'] as String?,
);

Map<String, dynamic> _$ConversationTranscriptRemoteModelToJson(
  _ConversationTranscriptRemoteModel instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'segments': instance.segments.map((e) => e.toJson()).toList(),
  'finalized_at': instance.finalizedAt.toIso8601String(),
  'language_code': instance.languageCode,
};
