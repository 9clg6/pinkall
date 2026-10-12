import 'package:core_data/model/remote/call_debrief.remote.model.dart';
import 'package:core_data/model/remote/coaching_progress.remote.model.dart';
import 'package:core_data/model/remote/conversation_session.remote.model.dart';
import 'package:core_data/model/remote/conversation_transcript.remote.model.dart';
import 'package:core_data/model/remote/external_conversation_session.remote.model.dart';
import 'package:core_data/model/remote/session_realtime_event.remote.model.dart';
import 'package:core_data/model/remote/transcription_consent.remote.model.dart';

/// Remote source for Pinkall sessions, live events, and final transcripts.
abstract interface class ConversationSessionRemoteDataSource {
  /// Creates a backend conversation session.
  Future<ConversationSessionRemoteModel> createSession(
    Map<String, dynamic> body,
  );

  /// Creates an external media session and returns ephemeral upload details.
  Future<ExternalConversationSessionRemoteModel> createExternalSession(
    Map<String, dynamic> body,
  );

  /// Retrieves one backend conversation session.
  Future<ConversationSessionRemoteModel> getSession(String sessionId);

  /// Lists active sessions visible to the authenticated user's devices.
  Future<List<ConversationSessionRemoteModel>> listActiveSessions();

  /// Lists every session visible in the authenticated workspace history.
  Future<List<ConversationSessionRemoteModel>> listSessions();

  /// Retrieves workspace-level coaching progression.
  Future<CoachingProgressRemoteModel> getCoachingProgress({
    required int windowSize,
    required int recentLimit,
  });

  /// Watches authenticated realtime events for one session.
  Stream<SessionRealtimeEventRemoteModel> watchSessionEvents(String sessionId);

  /// Requests final processing of one backend conversation session.
  Future<ConversationSessionRemoteModel> finalizeSession(String sessionId);

  /// Cancels backend processing for one conversation session.
  Future<ConversationSessionRemoteModel> cancelSession(String sessionId);

  /// Retrieves the reconciled final transcript for one session.
  Future<ConversationTranscriptRemoteModel> getFinalTranscript(
    String sessionId,
  );

  /// Retrieves the final grounded debrief for one session.
  Future<CallDebriefRemoteModel> getDebrief(String sessionId);

  /// Applies a call-level coach-mode override.
  Future<ConversationSessionRemoteModel> updateCoachMode(
    String sessionId,
    Map<String, dynamic> body,
  );

  /// Records the notice acknowledgement that gates transcription.
  Future<TranscriptionConsentRemoteModel> recordTranscriptionConsent(
    String sessionId,
    Map<String, dynamic> body,
  );
}
