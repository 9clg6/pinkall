import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_transcript.entity.freezed.dart';

/// Reconciled final transcript produced after a Pinkall session ends.
@freezed
abstract class ConversationTranscriptEntity
    with _$ConversationTranscriptEntity {
  /// Creates a final conversation transcript.
  const factory ConversationTranscriptEntity({
    required String sessionId,
    required List<TranscriptSegmentEntity> segments,
    required DateTime finalizedAt,
    String? languageCode,
  }) = _ConversationTranscriptEntity;
}
