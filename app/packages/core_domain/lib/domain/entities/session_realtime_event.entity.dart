import 'package:core_domain/domain/entities/coach_status.entity.dart';
import 'package:core_domain/domain/entities/coaching_suggestion.entity.dart';
import 'package:core_domain/domain/entities/conversation_session.entity.dart';
import 'package:core_domain/domain/entities/transcript_segment.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_realtime_event.entity.freezed.dart';

/// Provider-independent event delivered on a Pinkall session stream.
@freezed
sealed class SessionRealtimeEventEntity with _$SessionRealtimeEventEntity {
  /// Delivers a partial or final speaker-attributed transcript segment.
  const factory SessionRealtimeEventEntity.transcriptSegment(
    TranscriptSegmentEntity segment,
  ) = SessionTranscriptSegmentEventEntity;

  /// Delivers a live or shadow coaching suggestion.
  const factory SessionRealtimeEventEntity.coachingSuggestion(
    CoachingSuggestionEntity suggestion,
  ) = SessionCoachingSuggestionEventEntity;

  /// Delivers the real execution state of the optional live coach.
  const factory SessionRealtimeEventEntity.coachStatus(
    CoachStatusEntity coachStatus,
  ) = SessionCoachStatusEventEntity;

  /// Delivers a session lifecycle snapshot.
  const factory SessionRealtimeEventEntity.sessionState(
    ConversationSessionEntity session,
  ) = SessionStateEventEntity;

  /// Preserves a future event without interrupting the realtime stream.
  const factory SessionRealtimeEventEntity.unknown({
    required String type,
    required Map<String, Object?> payload,
  }) = SessionUnknownEventEntity;
}
