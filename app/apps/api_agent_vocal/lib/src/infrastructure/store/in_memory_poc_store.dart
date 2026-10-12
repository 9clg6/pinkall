import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:api_agent_vocal/src/domain/call_preparation.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';

/// Deliberately non-durable POC store. It starts empty on every process boot.
final class InMemoryPocStore implements PinkallStore {
  InMemoryPocStore({required this.maxSessionAudioBytes});

  final int maxSessionAudioBytes;
  final Map<String, _SessionState> _sessions = <String, _SessionState>{};
  final Map<String, ContactRecord> _contacts = <String, ContactRecord>{};
  final StreamController<ClientEvent> _workspaceEvents =
      StreamController<ClientEvent>.broadcast();
  final Map<String, Map<String, Object?>> _coachPreferences =
      <String, Map<String, Object?>>{};
  WorkspaceSalesContext? _workspaceSalesContext;
  final Set<String> _exposedSuggestionIds = <String>{};
  int _generatedShadow = 0;
  int _exposures = 0;
  int _feedbackCount = 0;
  int _usefulCount = 0;
  int _usedCount = 0;
  final Map<String, int> _outcomes = <String, int>{};

  @override
  bool get isDurable => false;

  @override
  bool get isReady => true;

  @override
  String get storageDescription => 'in_memory_non_durable';

  @override
  String? get durabilityFailureCode => null;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> flush() async {}

  /// Serializes only the business state promised by the PostgreSQL POC.
  ///
  /// Buffered audio, provisional transcript deltas, event streams and live
  /// provider handles never enter this representation.
  Map<String, Object?> exportDurableSnapshot() {
    return <String, Object?>{
      'snapshot_version': 1,
      'workspace_sales_context': _workspaceSalesContext?.toJson(),
      'sessions': _sessions.values
          .map((_SessionState state) => state.toDurableJson())
          .toList(growable: false),
      'contacts': _contacts.values
          .map((ContactRecord contact) => contact.toJson())
          .toList(growable: false),
      'coach_preferences': _coachPreferences,
      'coaching_metrics': <String, Object?>{
        'generated_shadow': _generatedShadow,
        'exposures': _exposures,
        'feedback_count': _feedbackCount,
        'useful_count': _usefulCount,
        'used_count': _usedCount,
        'exposed_suggestion_ids': _exposedSuggestionIds.toList(growable: false),
        'outcomes': _outcomes,
      },
    };
  }

  /// Hydrates a fresh in-memory runtime from a validated durable snapshot.
  void restoreDurableSnapshot(Map<String, Object?> payload) {
    if (_sessions.isNotEmpty ||
        _contacts.isNotEmpty ||
        _coachPreferences.isNotEmpty ||
        _workspaceSalesContext != null) {
      throw StateError('Durable snapshot can only hydrate an empty store.');
    }
    if (_requiredInt(payload, 'snapshot_version') != 1) {
      throw const FormatException('Unsupported Pinkall snapshot version.');
    }
    final Object? rawWorkspaceSalesContext = payload['workspace_sales_context'];
    if (rawWorkspaceSalesContext != null) {
      _workspaceSalesContext = WorkspaceSalesContext.fromJson(
        _requiredMapValue(rawWorkspaceSalesContext, 'workspace_sales_context'),
      );
    }
    for (final Object? raw in _requiredList(payload, 'sessions')) {
      final _SessionState state = _SessionState.fromDurableJson(
        _requiredMapValue(raw, 'session'),
      );
      if (_sessions.containsKey(state.id)) {
        throw FormatException('Duplicate session in snapshot: ${state.id}');
      }
      _sessions[state.id] = state;
    }
    for (final Object? raw in _requiredList(payload, 'contacts')) {
      final Map<String, Object?> json = _requiredMapValue(raw, 'contact');
      final ContactRecord contact = ContactRecord(
        id: _requiredString(json, 'id'),
        phoneNumber: _requiredString(json, 'phone_number'),
        name: _optionalString(json['name']),
        company: _optionalString(json['company']),
        email: _optionalString(json['email']),
        metadata: Map<String, Object?>.unmodifiable(
          _requiredMapValue(json['metadata'], 'contact.metadata'),
        ),
        createdAt: _requiredDateTime(json, 'created_at'),
      );
      if (_contacts.containsKey(contact.id)) {
        throw FormatException('Duplicate contact in snapshot: ${contact.id}');
      }
      _contacts[contact.id] = contact;
    }
    final Map<String, Object?> preferences = _requiredMapValue(
      payload['coach_preferences'],
      'coach_preferences',
    );
    for (final MapEntry<String, Object?> entry in preferences.entries) {
      _coachPreferences[entry.key] = Map<String, Object?>.unmodifiable(
        _requiredMapValue(entry.value, 'coach_preferences.${entry.key}'),
      );
    }
    final Map<String, Object?> metrics = _requiredMapValue(
      payload['coaching_metrics'],
      'coaching_metrics',
    );
    _generatedShadow = _requiredInt(metrics, 'generated_shadow');
    _exposures = _requiredInt(metrics, 'exposures');
    _feedbackCount = _requiredInt(metrics, 'feedback_count');
    _usefulCount = _requiredInt(metrics, 'useful_count');
    _usedCount = _requiredInt(metrics, 'used_count');
    _exposedSuggestionIds.addAll(
      _requiredList(metrics, 'exposed_suggestion_ids').map(
        (Object? value) => _requiredScalarString(
          value,
          'coaching_metrics.exposed_suggestion_ids',
        ),
      ),
    );
    final Map<String, Object?> outcomes = _requiredMapValue(
      metrics['outcomes'],
      'coaching_metrics.outcomes',
    );
    for (final MapEntry<String, Object?> entry in outcomes.entries) {
      if (entry.value is! int) {
        throw FormatException(
          'coaching_metrics.outcomes.${entry.key} must be an integer.',
        );
      }
      _outcomes[entry.key] = entry.value! as int;
    }
  }

  /// Converts sessions that cannot be resumed without their live media state
  /// into explicit terminal failures after hydration.
  int interruptActiveSessions({required DateTime interruptedAt}) {
    int interrupted = 0;
    for (final _SessionState state in _sessions.values) {
      if (state.status != SessionStatus.awaitingMedia &&
          state.status != SessionStatus.streaming &&
          state.status != SessionStatus.finalizing) {
        continue;
      }
      state
        ..status = SessionStatus.failed
        ..failure = 'interrupted_by_server_restart'
        ..telnyxOutboundDialReserved = false
        ..updatedAt = interruptedAt.toUtc()
        ..endedAt = interruptedAt.toUtc();
      interrupted += 1;
    }
    return interrupted;
  }

  @override
  WorkspaceSalesContext? get workspaceSalesContext => _workspaceSalesContext;

  @override
  WorkspaceSalesContext upsertWorkspaceSalesContext({
    required String companyName,
    required String productName,
    required String pitchMarkdown,
    required int? expectedRevision,
  }) {
    final WorkspaceSalesContext? current = _workspaceSalesContext;
    if (current?.revision != expectedRevision) {
      throw WorkspaceSalesContextRevisionConflict(
        expectedRevision: expectedRevision,
        actualRevision: current?.revision,
      );
    }
    final DateTime now = DateTime.now().toUtc();
    final WorkspaceSalesContext updated = current == null
        ? WorkspaceSalesContext.create(
            companyName: companyName,
            productName: productName,
            pitchMarkdown: pitchMarkdown,
            now: now,
          )
        : current.update(
            companyName: companyName,
            productName: productName,
            pitchMarkdown: pitchMarkdown,
            now: now,
          );
    _workspaceSalesContext = updated;
    return updated;
  }

  /// Creates an empty session and a high-entropy one-session media credential.
  CallSessionSnapshot createSession({
    required String callId,
    required String destinationNumber,
    required String? contactId,
    String? preparationMarkdown,
    required CoachMode coachMode,
    required MediaTrack sellerTrack,
  }) {
    final DateTime now = DateTime.now().toUtc();
    final String id = _randomId('ses');
    final _SessionState state = _SessionState(
      id: id,
      callId: callId,
      destinationNumber: destinationNumber,
      contactId: contactId,
      preparationMarkdown: normalizeCallPreparationMarkdown(
        preparationMarkdown,
      ),
      workspaceSalesContext: _workspaceSalesContext,
      createdAt: now,
      updatedAt: now,
      status: SessionStatus.awaitingMedia,
      coachMode: coachMode,
      sellerTrack: sellerTrack,
      mediaToken: _randomId('media'),
    );
    _sessions[id] = state;
    emit(
      ClientEvent(
        type: 'session_state',
        sessionId: id,
        at: now,
        data: state.snapshot.toJson(),
      ),
    );
    return state.snapshot;
  }

  List<CallSessionSnapshot> listSessions() {
    final List<CallSessionSnapshot> sessions = _sessions.values
        .map((_SessionState state) => state.snapshot)
        .toList(growable: false);
    sessions.sort(
      (CallSessionSnapshot left, CallSessionSnapshot right) =>
          right.createdAt.compareTo(left.createdAt),
    );
    return sessions;
  }

  @override
  List<CallSessionSnapshot> listActiveSessions() {
    return listSessions()
        .where(
          (CallSessionSnapshot session) =>
              session.status != SessionStatus.stopped &&
              session.status != SessionStatus.finalized &&
              session.status != SessionStatus.failed,
        )
        .toList(growable: false);
  }

  CallSessionSnapshot? session(String id) => _sessions[id]?.snapshot;

  bool validateMediaToken(String sessionId, String candidate) {
    final _SessionState? state = _sessions[sessionId];
    if (state == null ||
        (state.status != SessionStatus.awaitingMedia &&
            state.status != SessionStatus.streaming)) {
      return false;
    }
    final String expected = state.mediaToken;
    if (expected.length != candidate.length) {
      return false;
    }
    int difference = 0;
    for (int index = 0; index < expected.length; index += 1) {
      difference |= expected.codeUnitAt(index) ^ candidate.codeUnitAt(index);
    }
    return difference == 0;
  }

  void markMediaStarted({
    required String sessionId,
    required String? streamId,
    required String? callControlId,
    required String? callSessionId,
    required String encoding,
    required int sampleRate,
  }) {
    final _SessionState state = _requiredSession(sessionId)
      ..status = SessionStatus.streaming
      ..updatedAt = DateTime.now().toUtc()
      ..telnyxStreamId = streamId
      ..telnyxCallControlId = callControlId
      ..telnyxCallSessionId = callSessionId
      ..mediaEncoding = encoding
      ..mediaSampleRate = sampleRate;
    state.startedAt ??= state.updatedAt;
    emit(
      ClientEvent(
        type: 'session_state',
        sessionId: sessionId,
        at: state.updatedAt,
        data: state.snapshot.toJson(),
      ),
    );
  }

  @override
  void attachOutboundCall({
    required String sessionId,
    required String agentCallControlId,
    required String agentCallSessionId,
    required String pstnCallControlId,
    required String pstnCallSessionId,
  }) {
    final _SessionState state = _requiredSession(sessionId);
    if (!state.telnyxOutboundDialReserved ||
        state.telnyxAgentCallControlId != agentCallControlId) {
      throw StateError(
        'Outbound Dial was not reserved for this Telnyx agent leg.',
      );
    }
    state
      ..telnyxAgentCallControlId = agentCallControlId
      ..telnyxAgentCallSessionId = agentCallSessionId
      ..telnyxPstnCallControlId = pstnCallControlId
      ..telnyxPstnCallSessionId = pstnCallSessionId
      ..telnyxCallControlId = pstnCallControlId
      ..telnyxCallSessionId = pstnCallSessionId
      ..telnyxOutboundDialReserved = false
      ..updatedAt = DateTime.now().toUtc();
    emit(
      ClientEvent(
        type: 'session_state',
        sessionId: sessionId,
        at: state.updatedAt,
        data: state.snapshot.toJson(),
      ),
    );
  }

  @override
  void reserveOutboundCall({
    required String sessionId,
    required String agentCallControlId,
    required String agentCallSessionId,
  }) {
    final _SessionState state = _requiredSession(sessionId);
    if (state.status != SessionStatus.awaitingMedia ||
        state.telnyxOutboundDialReserved ||
        state.telnyxPstnCallControlId != null) {
      throw StateError('Outbound Dial is already reserved for this session.');
    }
    state
      ..telnyxOutboundDialReserved = true
      ..telnyxAgentCallControlId = agentCallControlId
      ..telnyxAgentCallSessionId = agentCallSessionId
      ..updatedAt = DateTime.now().toUtc();
    emit(
      ClientEvent(
        type: 'session_state',
        sessionId: sessionId,
        at: state.updatedAt,
        data: state.snapshot.toJson(),
      ),
    );
  }

  @override
  void releaseOutboundCallReservation({
    required String sessionId,
    required String agentCallControlId,
  }) {
    final _SessionState state = _requiredSession(sessionId);
    if (!state.telnyxOutboundDialReserved ||
        state.telnyxAgentCallControlId != agentCallControlId ||
        state.telnyxPstnCallControlId != null ||
        state.status != SessionStatus.awaitingMedia) {
      return;
    }
    state
      ..telnyxOutboundDialReserved = false
      ..telnyxAgentCallControlId = null
      ..telnyxAgentCallSessionId = null
      ..updatedAt = DateTime.now().toUtc();
    emit(
      ClientEvent(
        type: 'session_state',
        sessionId: sessionId,
        at: state.updatedAt,
        data: state.snapshot.toJson(),
      ),
    );
  }

  void appendAudio(String sessionId, MediaTrack track, List<int> bytes) {
    final _SessionState state = _requiredSession(sessionId);
    if (state.audioByteCount + bytes.length > maxSessionAudioBytes) {
      throw StateError(
        'Session audio exceeded MAX_SESSION_AUDIO_BYTES=$maxSessionAudioBytes.',
      );
    }
    state.audio[track]!.addAll(bytes);
    state.audioByteCount += bytes.length;
    state.updatedAt = DateTime.now().toUtc();
  }

  List<int> audio(String sessionId, MediaTrack track) {
    return List<int>.unmodifiable(_requiredSession(sessionId).audio[track]!);
  }

  void upsertTranscriptSegment(String sessionId, TranscriptSegment segment) {
    final _SessionState state = _requiredSession(sessionId);
    final int existingIndex = state.transcript.indexWhere(
      (TranscriptSegment item) => item.id == segment.id,
    );
    late final int sequence;
    if (existingIndex < 0) {
      state.transcript.add(segment);
      state.nextTranscriptSequence += 1;
      sequence = state.nextTranscriptSequence;
      state.transcriptSequences[segment.id] = sequence;
    } else {
      state.transcript[existingIndex] = segment;
      sequence = state.transcriptSequences[segment.id]!;
    }
    state.updatedAt = DateTime.now().toUtc();
    emit(
      ClientEvent(
        type: 'transcript_segment',
        sessionId: sessionId,
        at: state.updatedAt,
        data: segment.toClientJson(
          sessionId: sessionId,
          sequence: sequence,
          sessionStartedAt: state.startedAt ?? state.createdAt,
        ),
      ),
    );
  }

  List<TranscriptSegment> transcript(String sessionId) {
    return List<TranscriptSegment>.unmodifiable(
      _requiredSession(sessionId).transcript,
    );
  }

  void replaceFinalTranscript(
    String sessionId,
    List<TranscriptSegment> segments,
  ) {
    final DateTime now = DateTime.now().toUtc();
    final _SessionState state = _requiredSession(sessionId)
      ..finalTranscript = List<TranscriptSegment>.unmodifiable(segments)
      ..postCallDebrief = null
      ..postCallGeneration = PostCallGenerationSnapshot(
        sessionId: sessionId,
        status: PostCallGenerationStatus.pending,
        attemptCount: 0,
        updatedAt: now,
        failureCode: null,
        retryable: null,
        nextRetryAt: null,
      )
      ..status = SessionStatus.finalized
      ..updatedAt = now;
    state.endedAt ??= state.updatedAt;
    emit(
      ClientEvent(
        type: 'session_state',
        sessionId: sessionId,
        at: state.updatedAt,
        data: state.snapshot.toJson(),
      ),
    );
  }

  List<TranscriptSegment>? finalTranscript(String sessionId) {
    return _requiredSession(sessionId).finalTranscript;
  }

  @override
  void savePostCallDebrief(String sessionId, PostCallDebrief debrief) {
    final _SessionState state = _requiredSession(sessionId);
    if (debrief.sessionId != sessionId) {
      throw StateError('Post-call debrief session ID does not match.');
    }
    if (state.finalTranscript == null) {
      throw StateError('A final transcript is required before a debrief.');
    }
    final DateTime now = DateTime.now().toUtc();
    state
      ..postCallDebrief = debrief
      ..postCallGeneration = PostCallGenerationSnapshot(
        sessionId: sessionId,
        status: PostCallGenerationStatus.completed,
        attemptCount: state.postCallGeneration?.attemptCount ?? 0,
        updatedAt: now,
        failureCode: null,
        retryable: null,
        nextRetryAt: null,
      )
      ..updatedAt = now;
  }

  @override
  PostCallDebrief? postCallDebrief(String sessionId) {
    return _requiredSession(sessionId).postCallDebrief;
  }

  @override
  void savePostCallGeneration(PostCallGenerationSnapshot generation) {
    final _SessionState state = _requiredSession(generation.sessionId);
    if (generation.attemptCount < 0) {
      throw StateError('Post-call attempt count cannot be negative.');
    }
    if (generation.status == PostCallGenerationStatus.completed &&
        state.postCallDebrief == null) {
      throw StateError('A completed post-call job requires a debrief.');
    }
    state
      ..postCallGeneration = generation
      ..updatedAt = generation.updatedAt.toUtc();
  }

  @override
  PostCallGenerationSnapshot? postCallGeneration(String sessionId) {
    return _requiredSession(sessionId).postCallGeneration;
  }

  void updateStatus(String sessionId, SessionStatus status) {
    final _SessionState state = _requiredSession(sessionId)
      ..status = status
      ..updatedAt = DateTime.now().toUtc();
    if (status == SessionStatus.stopped || status == SessionStatus.failed) {
      state.endedAt ??= state.updatedAt;
    }
    emit(
      ClientEvent(
        type: 'session_state',
        sessionId: sessionId,
        at: state.updatedAt,
        data: state.snapshot.toJson(),
      ),
    );
  }

  void failSession(String sessionId, String failure) {
    final _SessionState state = _requiredSession(sessionId)
      ..status = SessionStatus.failed
      ..failure = failure
      ..updatedAt = DateTime.now().toUtc();
    state.endedAt ??= state.updatedAt;
    emit(
      ClientEvent(
        type: 'session_state',
        sessionId: sessionId,
        at: state.updatedAt,
        data: state.snapshot.toJson(),
      ),
    );
  }

  CallSessionSnapshot setCoachMode(String sessionId, CoachMode mode) {
    final _SessionState state = _requiredSession(sessionId)
      ..coachMode = mode
      ..updatedAt = DateTime.now().toUtc();
    emit(
      ClientEvent(
        type: 'session_state',
        sessionId: sessionId,
        at: state.updatedAt,
        data: state.snapshot.toJson(),
      ),
    );
    return state.snapshot;
  }

  CallSessionSnapshot acknowledgeTranscriptionConsent({
    required String sessionId,
    required String method,
    required DateTime acknowledgedAt,
  }) {
    final _SessionState state = _requiredSession(sessionId)
      ..transcriptionAllowed = true
      ..transcriptionConsentMethod = method
      ..transcriptionConsentAt = acknowledgedAt.toUtc()
      ..updatedAt = DateTime.now().toUtc();
    emit(
      ClientEvent(
        type: 'session_state',
        sessionId: sessionId,
        at: state.updatedAt,
        data: state.snapshot.toJson(),
      ),
    );
    return state.snapshot;
  }

  Stream<ClientEvent> events(String sessionId) {
    return _requiredSession(sessionId).events.stream;
  }

  @override
  Stream<ClientEvent> workspaceEvents() => _workspaceEvents.stream;

  void emit(ClientEvent event) {
    final _SessionState? state = _sessions[event.sessionId];
    if (state != null && !state.events.isClosed) {
      state.events.add(event);
    }
    if (!_workspaceEvents.isClosed) {
      _workspaceEvents.add(event);
    }
  }

  ContactRecord addContact({
    required String phoneNumber,
    String? name,
    String? company,
    String? email,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final ContactRecord record = ContactRecord(
      id: _randomId('con'),
      phoneNumber: phoneNumber,
      name: name,
      company: company,
      email: email,
      metadata: Map<String, Object?>.unmodifiable(metadata),
      createdAt: DateTime.now().toUtc(),
    );
    _contacts[record.id] = record;
    return record;
  }

  List<ContactRecord> contacts() {
    return List<ContactRecord>.unmodifiable(_contacts.values);
  }

  Map<String, Object?> coachPreferences(String userId) {
    return Map<String, Object?>.unmodifiable(
      _coachPreferences[userId] ?? const <String, Object?>{},
    );
  }

  Map<String, Object?> setCoachPreferences(
    String userId,
    Map<String, Object?> preferences,
  ) {
    final Map<String, Object?> stored = Map<String, Object?>.unmodifiable(
      preferences,
    );
    _coachPreferences[userId] = stored;
    return stored;
  }

  void recordShadowGeneration() {
    _generatedShadow += 1;
  }

  void recordExposure(String suggestionId) {
    _exposures += 1;
    _exposedSuggestionIds.add(suggestionId);
  }

  void recordFeedback({
    required String suggestionId,
    required bool useful,
    required bool used,
  }) {
    if (!_exposedSuggestionIds.contains(suggestionId)) {
      throw StateError(
        'Feedback references a suggestion that was not exposed.',
      );
    }
    _feedbackCount += 1;
    if (useful) {
      _usefulCount += 1;
    }
    if (used) {
      _usedCount += 1;
    }
  }

  void setOutcome(String sessionId, String outcome) {
    final _SessionState state = _requiredSession(sessionId);
    final String? previous = state.outcome;
    if (previous != null) {
      _outcomes.update(previous, (int count) => max(0, count - 1));
    }
    state
      ..outcome = outcome
      ..updatedAt = DateTime.now().toUtc();
    _outcomes.update(outcome, (int count) => count + 1, ifAbsent: () => 1);
  }

  CoachingMetricsSnapshot metrics() {
    return CoachingMetricsSnapshot(
      generatedShadow: _generatedShadow,
      exposures: _exposures,
      feedbackCount: _feedbackCount,
      usefulCount: _usefulCount,
      usedCount: _usedCount,
      outcomes: Map<String, int>.unmodifiable(_outcomes),
    );
  }

  @override
  int deleteSessionsEndedBefore(DateTime cutoff) {
    final DateTime normalizedCutoff = cutoff.toUtc();
    final List<String> expiredIds = _sessions.entries
        .where((MapEntry<String, _SessionState> entry) {
          final _SessionState state = entry.value;
          final bool terminal =
              state.status == SessionStatus.stopped ||
              state.status == SessionStatus.finalized ||
              state.status == SessionStatus.failed;
          final DateTime retentionReference = state.endedAt ?? state.updatedAt;
          return terminal && retentionReference.isBefore(normalizedCutoff);
        })
        .map((MapEntry<String, _SessionState> entry) => entry.key)
        .toList(growable: false);
    for (final String id in expiredIds) {
      final _SessionState? removed = _sessions.remove(id);
      if (removed != null && !removed.events.isClosed) {
        unawaited(removed.events.close());
      }
    }
    return expiredIds.length;
  }

  @override
  void clearWorkspaceData() {
    if (listActiveSessions().isNotEmpty) {
      throw StateError(
        'Workspace data cannot be deleted while a call is active.',
      );
    }
    for (final _SessionState state in _sessions.values) {
      if (!state.events.isClosed) {
        unawaited(state.events.close());
      }
    }
    _sessions.clear();
    _contacts.clear();
    _coachPreferences.clear();
    _workspaceSalesContext = null;
    _exposedSuggestionIds.clear();
    _generatedShadow = 0;
    _exposures = 0;
    _feedbackCount = 0;
    _usefulCount = 0;
    _usedCount = 0;
    _outcomes.clear();
  }

  Future<void> dispose() async {
    for (final _SessionState session in _sessions.values) {
      await session.events.close();
    }
    await _workspaceEvents.close();
  }

  _SessionState _requiredSession(String id) {
    final _SessionState? session = _sessions[id];
    if (session == null) {
      throw StateError('Session not found: $id');
    }
    return session;
  }

  static String _randomId(String prefix) {
    final Random random = Random.secure();
    final List<int> bytes = List<int>.generate(
      24,
      (int _) => random.nextInt(256),
      growable: false,
    );
    return '${prefix}_${base64UrlEncode(bytes).replaceAll('=', '')}';
  }
}

final class _SessionState {
  _SessionState({
    required this.id,
    required this.callId,
    required this.destinationNumber,
    required this.contactId,
    required this.preparationMarkdown,
    required this.workspaceSalesContext,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.coachMode,
    required this.sellerTrack,
    required this.mediaToken,
  });

  final String id;
  final String callId;
  final String destinationNumber;
  final String? contactId;
  final String? preparationMarkdown;
  final WorkspaceSalesContext? workspaceSalesContext;
  final DateTime createdAt;
  DateTime updatedAt;
  SessionStatus status;
  CoachMode coachMode;
  final MediaTrack sellerTrack;
  final String mediaToken;
  String? telnyxStreamId;
  String? telnyxCallControlId;
  String? telnyxCallSessionId;
  String? telnyxAgentCallControlId;
  String? telnyxAgentCallSessionId;
  String? telnyxPstnCallControlId;
  String? telnyxPstnCallSessionId;
  bool telnyxOutboundDialReserved = false;
  String? mediaEncoding;
  int? mediaSampleRate;
  String? failure;
  String? outcome;
  DateTime? startedAt;
  DateTime? endedAt;
  bool transcriptionAllowed = false;
  String? transcriptionConsentMethod;
  DateTime? transcriptionConsentAt;
  final Map<MediaTrack, List<int>> audio = <MediaTrack, List<int>>{
    MediaTrack.inbound: <int>[],
    MediaTrack.outbound: <int>[],
  };
  int audioByteCount = 0;
  final List<TranscriptSegment> transcript = <TranscriptSegment>[];
  final Map<String, int> transcriptSequences = <String, int>{};
  List<TranscriptSegment>? finalTranscript;
  PostCallDebrief? postCallDebrief;
  PostCallGenerationSnapshot? postCallGeneration;
  int nextTranscriptSequence = 0;
  final StreamController<ClientEvent> events =
      StreamController<ClientEvent>.broadcast();

  Map<String, Object?> toDurableJson() {
    return <String, Object?>{
      'id': id,
      'call_id': callId,
      'destination_number': destinationNumber,
      'contact_id': contactId,
      'preparation_markdown': preparationMarkdown,
      'workspace_sales_context': workspaceSalesContext?.toJson(),
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'status': status.name,
      'coach_mode': coachMode.name,
      'seller_track': sellerTrack.name,
      'telnyx_stream_id': telnyxStreamId,
      'telnyx_call_control_id': telnyxCallControlId,
      'telnyx_call_session_id': telnyxCallSessionId,
      'telnyx_agent_call_control_id': telnyxAgentCallControlId,
      'telnyx_agent_call_session_id': telnyxAgentCallSessionId,
      'telnyx_pstn_call_control_id': telnyxPstnCallControlId,
      'telnyx_pstn_call_session_id': telnyxPstnCallSessionId,
      'telnyx_outbound_dial_reserved': telnyxOutboundDialReserved,
      'media_encoding': mediaEncoding,
      'media_sample_rate': mediaSampleRate,
      'failure': failure,
      'outcome': outcome,
      'started_at': startedAt?.toUtc().toIso8601String(),
      'ended_at': endedAt?.toUtc().toIso8601String(),
      'transcription_allowed': transcriptionAllowed,
      'transcription_consent_method': transcriptionConsentMethod,
      'transcription_consent_at': transcriptionConsentAt
          ?.toUtc()
          .toIso8601String(),
      'final_transcript': finalTranscript
          ?.map((TranscriptSegment segment) => segment.toJson())
          .toList(growable: false),
      'post_call_debrief': postCallDebrief?.toJson(),
      'post_call_generation': postCallGeneration?.toJson(),
    };
  }

  factory _SessionState.fromDurableJson(Map<String, Object?> json) {
    final _SessionState state =
        _SessionState(
            id: _requiredString(json, 'id'),
            callId: _requiredString(json, 'call_id'),
            destinationNumber: _requiredString(json, 'destination_number'),
            contactId: _optionalString(json['contact_id']),
            preparationMarkdown: normalizeCallPreparationMarkdown(
              _optionalString(json['preparation_markdown']),
            ),
            workspaceSalesContext: json['workspace_sales_context'] == null
                ? null
                : WorkspaceSalesContext.fromJson(
                    _requiredMapValue(
                      json['workspace_sales_context'],
                      'session.workspace_sales_context',
                    ),
                  ),
            createdAt: _requiredDateTime(json, 'created_at'),
            updatedAt: _requiredDateTime(json, 'updated_at'),
            status: _sessionStatus(_requiredString(json, 'status')),
            coachMode: CoachMode.tryParse(_requiredString(json, 'coach_mode')),
            sellerTrack: MediaTrack.parse(
              _requiredString(json, 'seller_track'),
            ),
            // Live media credentials are deliberately rotated during hydration.
            mediaToken: InMemoryPocStore._randomId('media'),
          )
          ..telnyxStreamId = _optionalString(json['telnyx_stream_id'])
          ..telnyxCallControlId = _optionalString(
            json['telnyx_call_control_id'],
          )
          ..telnyxCallSessionId = _optionalString(
            json['telnyx_call_session_id'],
          )
          ..telnyxAgentCallControlId = _optionalString(
            json['telnyx_agent_call_control_id'],
          )
          ..telnyxAgentCallSessionId = _optionalString(
            json['telnyx_agent_call_session_id'],
          )
          ..telnyxPstnCallControlId = _optionalString(
            json['telnyx_pstn_call_control_id'],
          )
          ..telnyxPstnCallSessionId = _optionalString(
            json['telnyx_pstn_call_session_id'],
          )
          ..telnyxOutboundDialReserved =
              json['telnyx_outbound_dial_reserved'] == true
          ..mediaEncoding = _optionalString(json['media_encoding'])
          ..mediaSampleRate = _optionalInt(json['media_sample_rate'])
          ..failure = _optionalString(json['failure'])
          ..outcome = _optionalString(json['outcome'])
          ..startedAt = _optionalDateTime(json['started_at'])
          ..endedAt = _optionalDateTime(json['ended_at'])
          ..transcriptionAllowed = json['transcription_allowed'] == true
          ..transcriptionConsentMethod = _optionalString(
            json['transcription_consent_method'],
          )
          ..transcriptionConsentAt = _optionalDateTime(
            json['transcription_consent_at'],
          );

    final Object? rawFinalTranscript = json['final_transcript'];
    if (rawFinalTranscript != null) {
      if (rawFinalTranscript is! List<Object?>) {
        throw const FormatException('final_transcript must be a list.');
      }
      final List<TranscriptSegment> restored = rawFinalTranscript
          .map(
            (Object? raw) => _transcriptSegmentFromJson(
              _requiredMapValue(raw, 'final_transcript.segment'),
            ),
          )
          .toList(growable: false);
      state.finalTranscript = List<TranscriptSegment>.unmodifiable(restored);
      for (final TranscriptSegment segment in restored) {
        state.transcript.add(segment);
        state.nextTranscriptSequence += 1;
        state.transcriptSequences[segment.id] = state.nextTranscriptSequence;
      }
    }
    final Object? rawDebrief = json['post_call_debrief'];
    if (rawDebrief != null) {
      state.postCallDebrief = _postCallDebriefFromJson(
        _requiredMapValue(rawDebrief, 'post_call_debrief'),
      );
    }
    final Object? rawGeneration = json['post_call_generation'];
    if (rawGeneration != null) {
      state.postCallGeneration = _postCallGenerationFromJson(
        _requiredMapValue(rawGeneration, 'post_call_generation'),
      );
      if (state.postCallGeneration!.sessionId != state.id) {
        throw const FormatException(
          'post_call_generation.session_id does not match its session.',
        );
      }
      if (state.postCallGeneration!.status ==
              PostCallGenerationStatus.completed &&
          state.postCallDebrief == null) {
        throw const FormatException(
          'A completed post-call generation requires a debrief.',
        );
      }
    } else if (state.postCallDebrief != null) {
      state.postCallGeneration = PostCallGenerationSnapshot(
        sessionId: state.id,
        status: PostCallGenerationStatus.completed,
        attemptCount: 0,
        updatedAt: state.postCallDebrief!.generatedAt,
        failureCode: null,
        retryable: null,
        nextRetryAt: null,
      );
    } else if (state.finalTranscript != null) {
      state.postCallGeneration = PostCallGenerationSnapshot(
        sessionId: state.id,
        status: PostCallGenerationStatus.pending,
        attemptCount: 0,
        updatedAt: state.updatedAt,
        failureCode: null,
        retryable: null,
        nextRetryAt: null,
      );
    }
    return state;
  }

  CallSessionSnapshot get snapshot {
    return CallSessionSnapshot(
      id: id,
      callId: callId,
      destinationNumber: destinationNumber,
      contactId: contactId,
      preparationMarkdown: preparationMarkdown,
      workspaceSalesContext: workspaceSalesContext,
      createdAt: createdAt,
      updatedAt: updatedAt,
      status: status,
      coachMode: coachMode,
      sellerTrack: sellerTrack,
      mediaToken: mediaToken,
      telnyxStreamId: telnyxStreamId,
      telnyxCallControlId: telnyxCallControlId,
      telnyxCallSessionId: telnyxCallSessionId,
      telnyxAgentCallControlId: telnyxAgentCallControlId,
      telnyxAgentCallSessionId: telnyxAgentCallSessionId,
      telnyxPstnCallControlId: telnyxPstnCallControlId,
      telnyxPstnCallSessionId: telnyxPstnCallSessionId,
      telnyxOutboundDialReserved: telnyxOutboundDialReserved,
      mediaEncoding: mediaEncoding,
      mediaSampleRate: mediaSampleRate,
      transcriptionAllowed: transcriptionAllowed,
      transcriptionConsentMethod: transcriptionConsentMethod,
      transcriptionConsentAt: transcriptionConsentAt,
      failure: failure,
      outcome: outcome,
      startedAt: startedAt,
      endedAt: endedAt,
      postCallGeneration: postCallGeneration,
    );
  }
}

Map<String, Object?> _requiredMapValue(Object? raw, String field) {
  if (raw is! Map<Object?, Object?>) {
    throw FormatException('$field must be an object.');
  }
  final Map<String, Object?> result = <String, Object?>{};
  for (final MapEntry<Object?, Object?> entry in raw.entries) {
    if (entry.key is! String) {
      throw FormatException('$field contains a non-string key.');
    }
    result[entry.key! as String] = entry.value;
  }
  return result;
}

List<Object?> _requiredList(Map<String, Object?> json, String field) {
  final Object? raw = json[field];
  if (raw is! List<Object?>) {
    throw FormatException('$field must be a list.');
  }
  return raw;
}

String _requiredString(Map<String, Object?> json, String field) {
  return _requiredScalarString(json[field], field);
}

String _requiredScalarString(Object? raw, String field) {
  if (raw is! String || raw.trim().isEmpty) {
    throw FormatException('$field must be a non-empty string.');
  }
  return raw;
}

String? _optionalString(Object? raw) {
  if (raw == null) {
    return null;
  }
  if (raw is! String) {
    throw const FormatException('Optional snapshot text must be a string.');
  }
  return raw;
}

int _requiredInt(Map<String, Object?> json, String field) {
  final Object? raw = json[field];
  if (raw is! int) {
    throw FormatException('$field must be an integer.');
  }
  return raw;
}

int? _optionalInt(Object? raw) {
  if (raw == null) {
    return null;
  }
  if (raw is! int) {
    throw const FormatException('Optional snapshot number must be an integer.');
  }
  return raw;
}

double _requiredDouble(Map<String, Object?> json, String field) {
  final Object? raw = json[field];
  if (raw is! num) {
    throw FormatException('$field must be numeric.');
  }
  return raw.toDouble();
}

bool _requiredBool(Map<String, Object?> json, String field) {
  final Object? raw = json[field];
  if (raw is! bool) {
    throw FormatException('$field must be a boolean.');
  }
  return raw;
}

DateTime _requiredDateTime(Map<String, Object?> json, String field) {
  final DateTime? parsed = _optionalDateTime(json[field]);
  if (parsed == null) {
    throw FormatException('$field must be an ISO-8601 timestamp.');
  }
  return parsed;
}

DateTime? _optionalDateTime(Object? raw) {
  if (raw == null) {
    return null;
  }
  if (raw is! String) {
    throw const FormatException('Snapshot timestamp must be a string.');
  }
  final DateTime? parsed = DateTime.tryParse(raw);
  if (parsed == null) {
    throw const FormatException('Snapshot timestamp must be ISO-8601.');
  }
  return parsed.toUtc();
}

SessionStatus _sessionStatus(String value) {
  return SessionStatus.values.firstWhere(
    (SessionStatus status) => status.name == value,
    orElse: () => throw FormatException('Unknown session status: $value'),
  );
}

SpeakerRole _speakerRole(String value) {
  return SpeakerRole.values.firstWhere(
    (SpeakerRole role) => role.name == value,
    orElse: () => throw FormatException('Unknown speaker role: $value'),
  );
}

TranscriptSegment _transcriptSegmentFromJson(Map<String, Object?> json) {
  return TranscriptSegment(
    id: _requiredString(json, 'id'),
    track: MediaTrack.parse(_requiredString(json, 'track')),
    speaker: _speakerRole(_requiredString(json, 'speaker')),
    text: _requiredString(json, 'text'),
    startSeconds: _requiredDouble(json, 'start_seconds'),
    endSeconds: _requiredDouble(json, 'end_seconds'),
    isFinal: _requiredBool(json, 'is_final'),
    provider: _requiredString(json, 'provider'),
    createdAt: _requiredDateTime(json, 'created_at'),
  );
}

PostCallGenerationSnapshot _postCallGenerationFromJson(
  Map<String, Object?> json,
) {
  final Object? rawRetryable = json['retryable'];
  if (rawRetryable != null && rawRetryable is! bool) {
    throw const FormatException(
      'post_call_generation.retryable must be a boolean or null.',
    );
  }
  final PostCallGenerationSnapshot generation = PostCallGenerationSnapshot(
    sessionId: _requiredString(json, 'session_id'),
    status: PostCallGenerationStatus.parse(_requiredString(json, 'status')),
    attemptCount: _requiredInt(json, 'attempt_count'),
    updatedAt: _requiredDateTime(json, 'updated_at'),
    failureCode: _optionalString(json['failure_code']),
    retryable: rawRetryable as bool?,
    nextRetryAt: _optionalDateTime(json['next_retry_at']),
  );
  if (generation.attemptCount < 0) {
    throw const FormatException(
      'post_call_generation.attempt_count cannot be negative.',
    );
  }
  return generation;
}

PostCallDebrief _postCallDebriefFromJson(Map<String, Object?> json) {
  final Object? version = json['version'];
  if (version != 1 && version != 2 && version != 3) {
    throw const FormatException('Unsupported post-call debrief version.');
  }
  final bool hasPerformanceCoaching = version == 2 || version == 3;
  final bool hasObjections = version == 3;
  return PostCallDebrief(
    sessionId: _requiredString(json, 'session_id'),
    summary: _groundedTextFromJson(
      _requiredMapValue(json['summary'], 'post_call_debrief.summary'),
    ),
    keyPoints: _requiredList(json, 'key_points')
        .map(
          (Object? raw) => _groundedTextFromJson(
            _requiredMapValue(raw, 'post_call_debrief.key_point'),
          ),
        )
        .toList(growable: false),
    commitments: _requiredList(json, 'commitments')
        .map(
          (Object? raw) => _commitmentFromJson(
            _requiredMapValue(raw, 'post_call_debrief.commitment'),
          ),
        )
        .toList(growable: false),
    followUp: _followUpFromJson(
      _requiredMapValue(json['follow_up'], 'post_call_debrief.follow_up'),
    ),
    improvement: json['improvement'] == null
        ? null
        : _improvementFromJson(
            _requiredMapValue(
              json['improvement'],
              'post_call_debrief.improvement',
            ),
          ),
    generatedAt: _requiredDateTime(json, 'generated_at'),
    provider: _requiredString(json, 'provider'),
    model: _requiredString(json, 'model'),
    performanceRubricVersion:
        _optionalString(json['performance_rubric_version']) ??
        PostCallDebrief.currentPerformanceRubricVersion,
    strengths: hasPerformanceCoaching
        ? _requiredList(json, 'strengths')
              .map(
                (Object? raw) => _groundedTextFromJson(
                  _requiredMapValue(raw, 'post_call_debrief.strength'),
                ),
              )
              .toList(growable: false)
        : const <PostCallGroundedText>[],
    performanceAxes: hasPerformanceCoaching
        ? _requiredList(json, 'performance_axes')
              .map(
                (Object? raw) => _performanceAxisFromJson(
                  _requiredMapValue(raw, 'post_call_debrief.performance_axis'),
                ),
              )
              .toList(growable: false)
        : const <PostCallPerformanceAxis>[],
    phraseCoaching: hasPerformanceCoaching
        ? _requiredList(json, 'phrase_coaching')
              .map(
                (Object? raw) => _phraseCoachingFromJson(
                  _requiredMapValue(raw, 'post_call_debrief.phrase_coaching'),
                ),
              )
              .toList(growable: false)
        : const <PostCallPhraseCoaching>[],
    strategicAdvice: hasPerformanceCoaching
        ? _requiredList(json, 'strategic_advice')
              .map(
                (Object? raw) => _strategicAdviceFromJson(
                  _requiredMapValue(raw, 'post_call_debrief.strategic_advice'),
                ),
              )
              .toList(growable: false)
        : const <PostCallStrategicAdvice>[],
    objections: hasObjections
        ? _requiredList(json, 'objections')
              .map(
                (Object? raw) => _objectionFromJson(
                  _requiredMapValue(raw, 'post_call_debrief.objection'),
                ),
              )
              .toList(growable: false)
        : const <PostCallObjection>[],
  );
}

PostCallObjection _objectionFromJson(Map<String, Object?> json) {
  return PostCallObjection(
    category: PostCallObjectionCategory.parse(
      _requiredString(json, 'category'),
    ),
    text: _requiredString(json, 'text'),
    responseAngle: _requiredString(json, 'response_angle'),
    suggestedResponse: _requiredString(json, 'suggested_response'),
    evidenceSegmentIds: _stringList(json, 'evidence_segment_ids'),
    confidence: _requiredDouble(json, 'confidence'),
  );
}

PostCallGroundedText _groundedTextFromJson(Map<String, Object?> json) {
  return PostCallGroundedText(
    text: _requiredString(json, 'text'),
    evidenceSegmentIds: _stringList(json, 'evidence_segment_ids'),
  );
}

PostCallCommitment _commitmentFromJson(Map<String, Object?> json) {
  return PostCallCommitment(
    owner: PostCallCommitmentOwner.parse(_requiredString(json, 'owner')),
    text: _requiredString(json, 'text'),
    dueAt: _optionalDateTime(json['due_at']),
    evidenceSegmentIds: _stringList(json, 'evidence_segment_ids'),
  );
}

PostCallFollowUp _followUpFromJson(Map<String, Object?> json) {
  return PostCallFollowUp(
    subject: _requiredString(json, 'subject'),
    body: _requiredString(json, 'body'),
    nextAction: _optionalString(json['next_action']),
    dueAt: _optionalDateTime(json['due_at']),
    evidenceSegmentIds: _stringList(json, 'evidence_segment_ids'),
  );
}

PostCallImprovement _improvementFromJson(Map<String, Object?> json) {
  return PostCallImprovement(
    recommendationId: _requiredString(json, 'recommendation_id'),
    text: _requiredString(json, 'text'),
    rationale: _requiredString(json, 'rationale'),
    evidenceSegmentIds: _stringList(json, 'evidence_segment_ids'),
    sources: _requiredList(json, 'sources')
        .map(
          (Object? raw) => _coachSourceFromJson(
            _requiredMapValue(raw, 'post_call_debrief.improvement.source'),
          ),
        )
        .toList(growable: false),
    confidence: _requiredDouble(json, 'confidence'),
  );
}

PostCallPerformanceAxis _performanceAxisFromJson(Map<String, Object?> json) {
  final int score = _requiredInt(json, 'score');
  if (score < 0 || score > 100) {
    throw const FormatException(
      'post_call_debrief.performance_axis.score must be between 0 and 100.',
    );
  }
  return PostCallPerformanceAxis(
    axis: PostCallPerformanceAxisName.parse(_requiredString(json, 'axis')),
    score: score,
    signal: PostCallPerformanceSignal.parse(_requiredString(json, 'signal')),
    observation: _requiredString(json, 'observation'),
    evidenceSegmentIds: _stringList(json, 'evidence_segment_ids'),
  );
}

PostCallPhraseCoaching _phraseCoachingFromJson(Map<String, Object?> json) {
  return PostCallPhraseCoaching(
    focus: PostCallPhraseFocus.parse(_requiredString(json, 'focus')),
    originalText: _requiredString(json, 'original_text'),
    improvedText: _requiredString(json, 'improved_text'),
    rationale: _requiredString(json, 'rationale'),
    recommendationId: _optionalString(json['recommendation_id']),
    evidenceSegmentIds: _stringList(json, 'evidence_segment_ids'),
    sources: _coachSourcesFromJson(
      json,
      'sources',
      'post_call_debrief.phrase_coaching.source',
    ),
    confidence: _requiredDouble(json, 'confidence'),
  );
}

PostCallStrategicAdvice _strategicAdviceFromJson(Map<String, Object?> json) {
  return PostCallStrategicAdvice(
    category: PostCallStrategicAdviceCategory.parse(
      _requiredString(json, 'category'),
    ),
    priority: PostCallStrategicAdvicePriority.parse(
      _requiredString(json, 'priority'),
    ),
    title: _requiredString(json, 'title'),
    advice: _requiredString(json, 'advice'),
    rationale: _requiredString(json, 'rationale'),
    recommendationId: _optionalString(json['recommendation_id']),
    evidenceSegmentIds: _stringList(json, 'evidence_segment_ids'),
    sources: _coachSourcesFromJson(
      json,
      'sources',
      'post_call_debrief.strategic_advice.source',
    ),
    confidence: _requiredDouble(json, 'confidence'),
  );
}

List<CoachSource> _coachSourcesFromJson(
  Map<String, Object?> json,
  String field,
  String itemField,
) {
  return _requiredList(json, field)
      .map(
        (Object? raw) =>
            _coachSourceFromJson(_requiredMapValue(raw, itemField)),
      )
      .toList(growable: false);
}

CoachSource _coachSourceFromJson(Map<String, Object?> json) {
  return CoachSource(
    id: _requiredString(json, 'id'),
    title: _requiredString(json, 'title'),
    evidenceLevel: _requiredString(json, 'evidence_level'),
    author: _optionalString(json['author']),
    url: _optionalString(json['url']),
    locator: _optionalString(json['locator']),
  );
}

List<String> _stringList(Map<String, Object?> json, String field) {
  return _requiredList(json, field)
      .map((Object? raw) => _requiredScalarString(raw, field))
      .toList(growable: false);
}
