// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transcript_segment.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TranscriptSegmentRemoteModel _$TranscriptSegmentRemoteModelFromJson(
  Map<String, dynamic> json,
) => _TranscriptSegmentRemoteModel(
  id: json['id'] as String,
  sessionId: json['session_id'] as String,
  sequence: (json['sequence'] as num).toInt(),
  speaker: json['speaker'] as String,
  text: json['text'] as String,
  startedAt: DateTime.parse(json['started_at'] as String),
  isFinal: json['is_final'] as bool,
  endedAt: json['ended_at'] == null
      ? null
      : DateTime.parse(json['ended_at'] as String),
  confidence: (json['confidence'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TranscriptSegmentRemoteModelToJson(
  _TranscriptSegmentRemoteModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'sequence': instance.sequence,
  'speaker': instance.speaker,
  'text': instance.text,
  'started_at': instance.startedAt.toIso8601String(),
  'is_final': instance.isFinal,
  'ended_at': instance.endedAt?.toIso8601String(),
  'confidence': instance.confidence,
};
