import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/conversation_transcript.remote.model.dart';
import 'package:core_data/model/remote/transcript_segment.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Mapping extensions for [TranscriptSegmentRemoteModel].
extension TranscriptSegmentRemoteModelX on TranscriptSegmentRemoteModel {
  /// Converts the remote transcript segment to a domain entity.
  TranscriptSegmentEntity toEntity() => TranscriptSegmentEntity(
    id: id,
    sessionId: sessionId,
    sequence: sequence,
    speaker: enumFromWireName<TranscriptSpeaker>(
      TranscriptSpeaker.values,
      speaker,
    ),
    text: text,
    startedAt: startedAt,
    endedAt: endedAt,
    isFinal: isFinal,
    confidence: confidence,
  );
}

/// Mapping extensions for [ConversationTranscriptRemoteModel].
extension ConversationTranscriptRemoteModelX
    on ConversationTranscriptRemoteModel {
  /// Converts the remote final transcript to a domain entity.
  ConversationTranscriptEntity toEntity() => ConversationTranscriptEntity(
    sessionId: sessionId,
    segments: segments
        .map((TranscriptSegmentRemoteModel model) => model.toEntity())
        .toList(growable: false),
    finalizedAt: finalizedAt,
    languageCode: languageCode,
  );
}
