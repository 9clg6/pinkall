import 'package:freezed_annotation/freezed_annotation.dart';

part 'provisional_transcript_segment.entity.freezed.dart';

/// Diarized text that deliberately has no seller/prospect meaning yet.
@freezed
abstract class ProvisionalTranscriptSegmentEntity
    with _$ProvisionalTranscriptSegmentEntity {
  /// Creates one voice-labelled provisional segment.
  const factory ProvisionalTranscriptSegmentEntity({
    required String id,
    required String voice,
    required String text,
    required double startSeconds,
    required double endSeconds,
    required double confidence,
  }) = _ProvisionalTranscriptSegmentEntity;
}
