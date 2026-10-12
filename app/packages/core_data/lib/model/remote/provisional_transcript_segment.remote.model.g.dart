// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provisional_transcript_segment.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProvisionalTranscriptSegmentRemoteModel
_$ProvisionalTranscriptSegmentRemoteModelFromJson(Map<String, dynamic> json) =>
    _ProvisionalTranscriptSegmentRemoteModel(
      id: json['id'] as String,
      voice: json['voice'] as String,
      text: json['text'] as String,
      startSeconds: (json['start_seconds'] as num).toDouble(),
      endSeconds: (json['end_seconds'] as num).toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
    );

Map<String, dynamic> _$ProvisionalTranscriptSegmentRemoteModelToJson(
  _ProvisionalTranscriptSegmentRemoteModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'voice': instance.voice,
  'text': instance.text,
  'start_seconds': instance.startSeconds,
  'end_seconds': instance.endSeconds,
  'confidence': instance.confidence,
};
