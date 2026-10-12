import 'package:core_domain/domain/enum/transcript_speaker.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcript_segment.entity.freezed.dart';

/// Immutable partial or final transcript segment for one known speaker role.
@freezed
abstract class TranscriptSegmentEntity with _$TranscriptSegmentEntity {
  /// Creates a transcript segment.
  const factory TranscriptSegmentEntity({
    required String id,
    required String sessionId,
    required int sequence,
    required TranscriptSpeaker speaker,
    required String text,
    required DateTime startedAt,
    required bool isFinal,
    DateTime? endedAt,
    double? confidence,
  }) = _TranscriptSegmentEntity;
}
