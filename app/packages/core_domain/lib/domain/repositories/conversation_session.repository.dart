import 'package:core_domain/domain/entities/call_debrief.entity.dart';
import 'package:core_domain/domain/entities/coaching_progress.entity.dart';
import 'package:core_domain/domain/entities/conversation_session.entity.dart';
import 'package:core_domain/domain/entities/conversation_transcript.entity.dart';
import 'package:core_domain/domain/entities/external_conversation_session.entity.dart';
import 'package:core_domain/domain/entities/session_realtime_event.entity.dart';
import 'package:core_domain/domain/entities/transcription_consent.entity.dart';
import 'package:core_domain/domain/params/create_conversation_session.param.dart';
import 'package:core_domain/domain/params/create_external_conversation_session.param.dart';
import 'package:core_domain/domain/params/get_coaching_progress.param.dart';
import 'package:core_domain/domain/params/record_transcription_consent.param.dart';
import 'package:core_domain/domain/params/update_session_coach_mode.param.dart';

/// Contract for Pinkall backend sessions, live events, and final transcripts.
abstract interface class ConversationSessionRepository {
  /// Creates a backend processing session attached to an existing voice call.
  Future<ConversationSessionEntity> createSession(
    CreateConversationSessionParam params,
  );

  /// Creates a session for system-audio and microphone media supplied by a client.
  Future<ExternalConversationSessionEntity> createExternalSession(
    CreateExternalConversationSessionParam params,
  );

  /// Retrieves the latest snapshot for [sessionId].
  Future<ConversationSessionEntity> getSession(String sessionId);

  /// Lists active sessions visible to every authenticated user device.
  Future<List<ConversationSessionEntity>> listActiveSessions();

  /// Lists the complete call history visible to the authenticated workspace.
  Future<List<ConversationSessionEntity>> listSessions();

  /// Retrieves longitudinal coaching statistics for the current workspace.
  Future<CoachingProgressEntity> getCoachingProgress(
    GetCoachingProgressParam params,
  );

  /// Opens the authenticated live event stream for [sessionId].
  Stream<SessionRealtimeEventEntity> watchSessionEvents(String sessionId);

  /// Requests post-call reconciliation and returns the resulting session state.
  Future<ConversationSessionEntity> finalizeSession(String sessionId);

  /// Cancels backend processing and releases resources for [sessionId].
  Future<ConversationSessionEntity> cancelSession(String sessionId);

  /// Retrieves the reconciled final transcript for [sessionId].
  Future<ConversationTranscriptEntity> getFinalTranscript(String sessionId);

  /// Retrieves the grounded summary, follow-up, and coaching improvement.
  Future<CallDebriefEntity> getDebrief(String sessionId);

  /// Applies a call-level coaching override to an active session.
  Future<ConversationSessionEntity> updateCoachMode(
    UpdateSessionCoachModeParam params,
  );

  /// Records the notice acknowledgement required before transcription starts.
  Future<TranscriptionConsentEntity> recordTranscriptionConsent(
    RecordTranscriptionConsentParam params,
  );
}
