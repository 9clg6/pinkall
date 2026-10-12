import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';

/// A sanitized durability failure safe to propagate through API boundaries.
final class DurabilityException implements Exception {
  const DurabilityException(this.code, this.message, [this.cause]);

  final String code;
  final String message;
  final Object? cause;

  @override
  String toString() => 'DurabilityException($code): $message';
}

/// Persistence boundary shared by application services.
abstract interface class PinkallStore {
  /// Opens durable dependencies and hydrates state before the HTTP server
  /// starts accepting requests.
  Future<void> initialize();

  /// Persists every durable mutation observed before this call completes.
  ///
  /// Live audio and provisional STT deltas are intentionally excluded.
  Future<void> flush();

  bool get isDurable;

  bool get isReady;

  String get storageDescription;

  /// Sanitized machine-readable failure code, never a connection string.
  String? get durabilityFailureCode;

  WorkspaceSalesContext? get workspaceSalesContext;

  WorkspaceSalesContext upsertWorkspaceSalesContext({
    required String companyName,
    required String productName,
    required String pitchMarkdown,
    required int? expectedRevision,
  });

  CallSessionSnapshot createSession({
    required String callId,
    required String destinationNumber,
    required String? contactId,
    String? preparationMarkdown,
    required CoachMode coachMode,
    required MediaTrack sellerTrack,
  });

  List<CallSessionSnapshot> listSessions();

  List<CallSessionSnapshot> listActiveSessions();

  CallSessionSnapshot? session(String id);

  bool validateMediaToken(String sessionId, String candidate);

  void markMediaStarted({
    required String sessionId,
    required String? streamId,
    required String? callControlId,
    required String? callSessionId,
    required String encoding,
    required int sampleRate,
  });

  void attachOutboundCall({
    required String sessionId,
    required String agentCallControlId,
    required String agentCallSessionId,
    required String pstnCallControlId,
    required String pstnCallSessionId,
  });

  void reserveOutboundCall({
    required String sessionId,
    required String agentCallControlId,
    required String agentCallSessionId,
  });

  void releaseOutboundCallReservation({
    required String sessionId,
    required String agentCallControlId,
  });

  void appendAudio(String sessionId, MediaTrack track, List<int> bytes);

  List<int> audio(String sessionId, MediaTrack track);

  void upsertTranscriptSegment(String sessionId, TranscriptSegment segment);

  List<TranscriptSegment> transcript(String sessionId);

  void replaceFinalTranscript(
    String sessionId,
    List<TranscriptSegment> segments,
  );

  List<TranscriptSegment>? finalTranscript(String sessionId);

  void savePostCallDebrief(String sessionId, PostCallDebrief debrief);

  PostCallDebrief? postCallDebrief(String sessionId);

  void savePostCallGeneration(PostCallGenerationSnapshot generation);

  PostCallGenerationSnapshot? postCallGeneration(String sessionId);

  void updateStatus(String sessionId, SessionStatus status);

  void failSession(String sessionId, String failure);

  CallSessionSnapshot setCoachMode(String sessionId, CoachMode mode);

  CallSessionSnapshot acknowledgeTranscriptionConsent({
    required String sessionId,
    required String method,
    required DateTime acknowledgedAt,
  });

  Stream<ClientEvent> events(String sessionId);

  Stream<ClientEvent> workspaceEvents();

  void emit(ClientEvent event);

  ContactRecord addContact({
    required String phoneNumber,
    String? name,
    String? company,
    String? email,
    Map<String, Object?> metadata = const <String, Object?>{},
  });

  List<ContactRecord> contacts();

  Map<String, Object?> coachPreferences(String userId);

  Map<String, Object?> setCoachPreferences(
    String userId,
    Map<String, Object?> preferences,
  );

  void recordShadowGeneration();

  void recordExposure(String suggestionId);

  void recordFeedback({
    required String suggestionId,
    required bool useful,
    required bool used,
  });

  void setOutcome(String sessionId, String outcome);

  CoachingMetricsSnapshot metrics();

  /// Deletes terminal call sessions whose retention reference timestamp is
  /// strictly older than [cutoff]. Active calls are never eligible.
  ///
  /// Returns the number of deleted sessions. Buffered audio, transcripts and
  /// debriefs owned by those sessions are removed with them.
  int deleteSessionsEndedBefore(DateTime cutoff);

  /// Removes every durable business record owned by the current workspace.
  ///
  /// Implementations must reject this operation while a call is active. The
  /// caller is responsible for flushing durable storage after the mutation.
  void clearWorkspaceData();

  Future<void> dispose();
}
