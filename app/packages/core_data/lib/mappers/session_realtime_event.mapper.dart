import 'package:core_data/mappers/coach_status.mapper.dart';
import 'package:core_data/mappers/coaching.mapper.dart';
import 'package:core_data/mappers/conversation_session.mapper.dart';
import 'package:core_data/mappers/transcript.mapper.dart';
import 'package:core_data/model/remote/coach_status.remote.model.dart';
import 'package:core_data/model/remote/coaching_suggestion.remote.model.dart';
import 'package:core_data/model/remote/conversation_session.remote.model.dart';
import 'package:core_data/model/remote/session_realtime_event.remote.model.dart';
import 'package:core_data/model/remote/transcript_segment.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Mapping extensions for [SessionRealtimeEventRemoteModel].
extension SessionRealtimeEventRemoteModelX on SessionRealtimeEventRemoteModel {
  /// Converts a supported backend event envelope to a domain event.
  SessionRealtimeEventEntity toEntity() {
    return switch (type) {
      'transcript_segment' => SessionRealtimeEventEntity.transcriptSegment(
        TranscriptSegmentRemoteModel.fromJson(payload).toEntity(),
      ),
      'coaching_suggestion' => SessionRealtimeEventEntity.coachingSuggestion(
        CoachingSuggestionRemoteModel.fromJson(payload).toEntity(),
      ),
      'coach_status' => SessionRealtimeEventEntity.coachStatus(
        CoachStatusRemoteModel.fromJson(payload).toEntity(),
      ),
      'session_state' => SessionRealtimeEventEntity.sessionState(
        ConversationSessionRemoteModel.fromJson(payload).toEntity(),
      ),
      _ => SessionRealtimeEventEntity.unknown(
        type: type,
        payload: Map<String, Object?>.unmodifiable(payload),
      ),
    };
  }
}
