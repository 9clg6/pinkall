import 'dart:async';
import 'dart:convert';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';
import 'package:api_agent_vocal/src/domain/workspace_sales_context.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:postgres/postgres.dart';

/// One optimistic-concurrency snapshot loaded from durable storage.
final class StoredPocSnapshot {
  const StoredPocSnapshot({
    required this.schemaVersion,
    required this.revision,
    required this.payload,
  });

  final int schemaVersion;
  final int revision;
  final Map<String, Object?> payload;
}

/// Small repository boundary that keeps PostgreSQL integration testable.
abstract interface class PocSnapshotRepository {
  Future<void> initialize();

  Future<StoredPocSnapshot?> load(String tenantId);

  Future<int> save({
    required String tenantId,
    required int schemaVersion,
    required int? expectedRevision,
    required Map<String, Object?> payload,
  });

  Future<void> close();
}

/// PostgreSQL JSONB repository compatible with Supabase pooler modes.
///
/// Queries intentionally use the simple protocol. Values are either strictly
/// validated identifiers/integers or base64-encoded JSON, so no user-provided
/// SQL is interpolated and no server-side prepared statement is required.
final class PostgresPocSnapshotRepository implements PocSnapshotRepository {
  PostgresPocSnapshotRepository(
    String databaseUrl, {
    String? sslRootCertificatePath,
  }) : _pool = Pool<Object?>.withUrl(
         _withPoolDefaults(databaseUrl, sslRootCertificatePath),
       );

  final Pool<Object?> _pool;

  static final RegExp _tenantPattern = RegExp(r'^[A-Za-z0-9._:-]{1,128}$');

  @override
  Future<void> initialize() async {
    await _pool.execute(_createTableSql, queryMode: QueryMode.simple);
  }

  @override
  Future<StoredPocSnapshot?> load(String tenantId) async {
    final String safeTenant = _validatedTenant(tenantId);
    final Result result = await _pool.execute('''
SELECT schema_version, revision, payload
FROM public.pinkall_poc_snapshots
WHERE tenant_id = '$safeTenant'
''', queryMode: QueryMode.simple);
    if (result.isEmpty) {
      return null;
    }
    final Map<String, Object?> row = result.first.toColumnMap();
    final Object? rawPayload = row['payload'];
    late final Map<String, Object?> payload;
    if (rawPayload is String) {
      payload = _objectMap(jsonDecode(rawPayload), 'payload');
    } else {
      payload = _objectMap(rawPayload, 'payload');
    }
    return StoredPocSnapshot(
      schemaVersion: _integer(row['schema_version'], 'schema_version'),
      revision: _integer(row['revision'], 'revision'),
      payload: payload,
    );
  }

  @override
  Future<int> save({
    required String tenantId,
    required int schemaVersion,
    required int? expectedRevision,
    required Map<String, Object?> payload,
  }) async {
    final String safeTenant = _validatedTenant(tenantId);
    if (schemaVersion < 1) {
      throw const FormatException('Snapshot schema version must be positive.');
    }
    final String encodedPayload = base64Encode(
      utf8.encode(jsonEncode(payload)),
    );
    final String sql = expectedRevision == null
        ? '''
INSERT INTO public.pinkall_poc_snapshots (
  tenant_id,
  schema_version,
  revision,
  payload,
  updated_at
) VALUES (
  '$safeTenant',
  $schemaVersion,
  1,
  convert_from(decode('$encodedPayload', 'base64'), 'UTF8')::jsonb,
  now()
)
ON CONFLICT (tenant_id) DO NOTHING
RETURNING revision
'''
        : '''
UPDATE public.pinkall_poc_snapshots
SET schema_version = $schemaVersion,
    revision = revision + 1,
    payload = convert_from(decode('$encodedPayload', 'base64'), 'UTF8')::jsonb,
    updated_at = now()
WHERE tenant_id = '$safeTenant'
  AND revision = $expectedRevision
RETURNING revision
''';
    final Result result = await _pool.execute(sql, queryMode: QueryMode.simple);
    if (result.isEmpty) {
      throw const DurabilityException(
        'snapshot_revision_conflict',
        'The durable snapshot changed in another server instance.',
      );
    }
    return _integer(result.first.toColumnMap()['revision'], 'revision');
  }

  @override
  Future<void> close() => _pool.close();

  static String _validatedTenant(String tenantId) {
    if (!_tenantPattern.hasMatch(tenantId)) {
      throw const FormatException(
        'PINKALL_STORAGE_TENANT_ID contains unsupported characters.',
      );
    }
    return tenantId;
  }

  static String _withPoolDefaults(
    String databaseUrl,
    String? sslRootCertificatePath,
  ) {
    final Uri uri = Uri.parse(databaseUrl);
    final Map<String, String> query = <String, String>{...uri.queryParameters};
    query.putIfAbsent(
      'sslmode',
      () => sslRootCertificatePath == null ? 'require' : 'verify-full',
    );
    if (sslRootCertificatePath != null) {
      query['sslrootcert'] = sslRootCertificatePath;
    }
    query.putIfAbsent('connect_timeout', () => '10');
    query.putIfAbsent('query_timeout', () => '15');
    query.putIfAbsent('max_connection_count', () => '3');
    query.putIfAbsent('max_connection_age', () => '300');
    query.putIfAbsent('application_name', () => 'pinkall-poc');
    return uri.replace(queryParameters: query).toString();
  }

  static int _integer(Object? value, String field) {
    if (value is! int) {
      throw FormatException('$field returned by PostgreSQL is not an integer.');
    }
    return value;
  }

  static Map<String, Object?> _objectMap(Object? raw, String field) {
    if (raw is! Map<Object?, Object?>) {
      throw FormatException('$field returned by PostgreSQL is not an object.');
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

  static const String _createTableSql = r'''
CREATE TABLE IF NOT EXISTS public.pinkall_poc_snapshots (
  tenant_id text PRIMARY KEY,
  schema_version integer NOT NULL CHECK (schema_version > 0),
  revision bigint NOT NULL CHECK (revision > 0),
  payload jsonb NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now(),
  CHECK (tenant_id ~ '^[A-Za-z0-9._:-]{1,128}$')
);
ALTER TABLE public.pinkall_poc_snapshots ENABLE ROW LEVEL SECURITY
''';
}

/// Durable POC store: synchronous in-process state plus explicit JSONB flushes.
///
/// This is not the final SaaS relational adapter. It is intentionally limited
/// to one Cloud Run instance per tenant and fails optimistic writes rather than
/// silently overwriting another instance.
final class PostgresSnapshotPinkallStore implements PinkallStore {
  PostgresSnapshotPinkallStore({
    required this.tenantId,
    required this.repository,
    required int maxSessionAudioBytes,
  }) : _memory = InMemoryPocStore(maxSessionAudioBytes: maxSessionAudioBytes);

  factory PostgresSnapshotPinkallStore.fromDatabaseUrl({
    required String databaseUrl,
    required String? sslRootCertificatePath,
    required String tenantId,
    required int maxSessionAudioBytes,
  }) {
    try {
      return PostgresSnapshotPinkallStore(
        tenantId: tenantId,
        repository: PostgresPocSnapshotRepository(
          databaseUrl,
          sslRootCertificatePath: sslRootCertificatePath,
        ),
        maxSessionAudioBytes: maxSessionAudioBytes,
      );
    } on ArgumentError {
      throw StateError(
        'PostgreSQL connection or root certificate configuration is invalid.',
      );
    }
  }

  static const int snapshotSchemaVersion = 1;

  final String tenantId;
  final PocSnapshotRepository repository;
  final InMemoryPocStore _memory;
  Future<void>? _initialization;
  Future<void>? _flushInFlight;
  int? _revision;
  int _mutationGeneration = 0;
  int _persistedGeneration = 0;
  bool _initialized = false;
  bool _closed = false;
  String? _durabilityFailureCode;

  @override
  bool get isDurable => true;

  @override
  bool get isReady => _initialized && _durabilityFailureCode == null;

  @override
  String get storageDescription => 'postgres_snapshot_poc';

  @override
  String? get durabilityFailureCode => _durabilityFailureCode;

  @override
  WorkspaceSalesContext? get workspaceSalesContext {
    _ensureInitialized();
    return _memory.workspaceSalesContext;
  }

  @override
  WorkspaceSalesContext upsertWorkspaceSalesContext({
    required String companyName,
    required String productName,
    required String pitchMarkdown,
    required int? expectedRevision,
  }) {
    _ensureInitialized();
    final WorkspaceSalesContext result = _memory.upsertWorkspaceSalesContext(
      companyName: companyName,
      productName: productName,
      pitchMarkdown: pitchMarkdown,
      expectedRevision: expectedRevision,
    );
    _markDirty();
    return result;
  }

  @override
  Future<void> initialize() {
    return _initialization ??= _initializeOnce();
  }

  Future<void> _initializeOnce() async {
    try {
      await repository.initialize();
      final StoredPocSnapshot? stored = await repository.load(tenantId);
      if (stored != null) {
        if (stored.schemaVersion != snapshotSchemaVersion) {
          throw DurabilityException(
            'snapshot_schema_unsupported',
            'Snapshot schema ${stored.schemaVersion} is not supported.',
          );
        }
        _memory.restoreDurableSnapshot(stored.payload);
        _revision = stored.revision;
      }
      _initialized = true;
      _durabilityFailureCode = null;
      final int interrupted = _memory.interruptActiveSessions(
        interruptedAt: DateTime.now().toUtc(),
      );
      if (interrupted > 0) {
        _markDirty();
        await flush();
      }
    } on DurabilityException catch (error) {
      _durabilityFailureCode = error.code;
      rethrow;
    } on Object catch (error) {
      _durabilityFailureCode = 'snapshot_initialization_failed';
      throw DurabilityException(
        'snapshot_initialization_failed',
        'PostgreSQL snapshot initialization failed.',
        error,
      );
    }
  }

  @override
  Future<void> flush() {
    _ensureInitialized();
    if (_persistedGeneration >= _mutationGeneration) {
      return Future<void>.value();
    }
    final Future<void>? active = _flushInFlight;
    if (active != null) {
      return active;
    }
    late final Future<void> job;
    job = _flushLoop().whenComplete(() {
      if (identical(_flushInFlight, job)) {
        _flushInFlight = null;
      }
    });
    _flushInFlight = job;
    return job;
  }

  Future<void> _flushLoop() async {
    while (_persistedGeneration < _mutationGeneration) {
      final int targetGeneration = _mutationGeneration;
      final Map<String, Object?> payload = _memory.exportDurableSnapshot();
      try {
        _revision = await repository.save(
          tenantId: tenantId,
          schemaVersion: snapshotSchemaVersion,
          expectedRevision: _revision,
          payload: payload,
        );
        _persistedGeneration = targetGeneration;
        _durabilityFailureCode = null;
      } on DurabilityException catch (error) {
        _durabilityFailureCode = error.code;
        rethrow;
      } on Object catch (error) {
        _durabilityFailureCode = 'snapshot_write_failed';
        throw DurabilityException(
          'snapshot_write_failed',
          'The durable Pinkall snapshot could not be committed.',
          error,
        );
      }
    }
  }

  @override
  CallSessionSnapshot createSession({
    required String callId,
    required String destinationNumber,
    required String? contactId,
    String? preparationMarkdown,
    required CoachMode coachMode,
    required MediaTrack sellerTrack,
  }) {
    _ensureInitialized();
    final CallSessionSnapshot result = _memory.createSession(
      callId: callId,
      destinationNumber: destinationNumber,
      contactId: contactId,
      preparationMarkdown: preparationMarkdown,
      coachMode: coachMode,
      sellerTrack: sellerTrack,
    );
    _markDirty();
    return result;
  }

  @override
  List<CallSessionSnapshot> listSessions() {
    _ensureInitialized();
    return _memory.listSessions();
  }

  @override
  List<CallSessionSnapshot> listActiveSessions() {
    _ensureInitialized();
    return _memory.listActiveSessions();
  }

  @override
  CallSessionSnapshot? session(String id) {
    _ensureInitialized();
    return _memory.session(id);
  }

  @override
  bool validateMediaToken(String sessionId, String candidate) {
    _ensureInitialized();
    return _memory.validateMediaToken(sessionId, candidate);
  }

  @override
  void markMediaStarted({
    required String sessionId,
    required String? streamId,
    required String? callControlId,
    required String? callSessionId,
    required String encoding,
    required int sampleRate,
  }) {
    _memory.markMediaStarted(
      sessionId: sessionId,
      streamId: streamId,
      callControlId: callControlId,
      callSessionId: callSessionId,
      encoding: encoding,
      sampleRate: sampleRate,
    );
    _markDirty();
  }

  @override
  void attachOutboundCall({
    required String sessionId,
    required String agentCallControlId,
    required String agentCallSessionId,
    required String pstnCallControlId,
    required String pstnCallSessionId,
  }) {
    _memory.attachOutboundCall(
      sessionId: sessionId,
      agentCallControlId: agentCallControlId,
      agentCallSessionId: agentCallSessionId,
      pstnCallControlId: pstnCallControlId,
      pstnCallSessionId: pstnCallSessionId,
    );
    _markDirty();
  }

  @override
  void reserveOutboundCall({
    required String sessionId,
    required String agentCallControlId,
    required String agentCallSessionId,
  }) {
    _memory.reserveOutboundCall(
      sessionId: sessionId,
      agentCallControlId: agentCallControlId,
      agentCallSessionId: agentCallSessionId,
    );
    _markDirty();
  }

  @override
  void releaseOutboundCallReservation({
    required String sessionId,
    required String agentCallControlId,
  }) {
    _memory.releaseOutboundCallReservation(
      sessionId: sessionId,
      agentCallControlId: agentCallControlId,
    );
    _markDirty();
  }

  @override
  void appendAudio(String sessionId, MediaTrack track, List<int> bytes) {
    _memory.appendAudio(sessionId, track, bytes);
  }

  @override
  List<int> audio(String sessionId, MediaTrack track) {
    return _memory.audio(sessionId, track);
  }

  @override
  void upsertTranscriptSegment(String sessionId, TranscriptSegment segment) {
    _memory.upsertTranscriptSegment(sessionId, segment);
  }

  @override
  List<TranscriptSegment> transcript(String sessionId) {
    return _memory.transcript(sessionId);
  }

  @override
  void replaceFinalTranscript(
    String sessionId,
    List<TranscriptSegment> segments,
  ) {
    _memory.replaceFinalTranscript(sessionId, segments);
    _markDirty();
  }

  @override
  List<TranscriptSegment>? finalTranscript(String sessionId) {
    return _memory.finalTranscript(sessionId);
  }

  @override
  void savePostCallDebrief(String sessionId, PostCallDebrief debrief) {
    _memory.savePostCallDebrief(sessionId, debrief);
    _markDirty();
  }

  @override
  PostCallDebrief? postCallDebrief(String sessionId) {
    return _memory.postCallDebrief(sessionId);
  }

  @override
  void savePostCallGeneration(PostCallGenerationSnapshot generation) {
    _memory.savePostCallGeneration(generation);
    _markDirty();
  }

  @override
  PostCallGenerationSnapshot? postCallGeneration(String sessionId) {
    return _memory.postCallGeneration(sessionId);
  }

  @override
  void updateStatus(String sessionId, SessionStatus status) {
    _memory.updateStatus(sessionId, status);
    _markDirty();
  }

  @override
  void failSession(String sessionId, String failure) {
    _memory.failSession(sessionId, failure);
    _markDirty();
  }

  @override
  CallSessionSnapshot setCoachMode(String sessionId, CoachMode mode) {
    final CallSessionSnapshot result = _memory.setCoachMode(sessionId, mode);
    _markDirty();
    return result;
  }

  @override
  CallSessionSnapshot acknowledgeTranscriptionConsent({
    required String sessionId,
    required String method,
    required DateTime acknowledgedAt,
  }) {
    final CallSessionSnapshot result = _memory.acknowledgeTranscriptionConsent(
      sessionId: sessionId,
      method: method,
      acknowledgedAt: acknowledgedAt,
    );
    _markDirty();
    return result;
  }

  @override
  Stream<ClientEvent> events(String sessionId) => _memory.events(sessionId);

  @override
  Stream<ClientEvent> workspaceEvents() => _memory.workspaceEvents();

  @override
  void emit(ClientEvent event) => _memory.emit(event);

  @override
  ContactRecord addContact({
    required String phoneNumber,
    String? name,
    String? company,
    String? email,
    Map<String, Object?> metadata = const <String, Object?>{},
  }) {
    final ContactRecord result = _memory.addContact(
      phoneNumber: phoneNumber,
      name: name,
      company: company,
      email: email,
      metadata: metadata,
    );
    _markDirty();
    return result;
  }

  @override
  List<ContactRecord> contacts() => _memory.contacts();

  @override
  Map<String, Object?> coachPreferences(String userId) {
    return _memory.coachPreferences(userId);
  }

  @override
  Map<String, Object?> setCoachPreferences(
    String userId,
    Map<String, Object?> preferences,
  ) {
    final Map<String, Object?> result = _memory.setCoachPreferences(
      userId,
      preferences,
    );
    _markDirty();
    return result;
  }

  @override
  void recordShadowGeneration() {
    _memory.recordShadowGeneration();
    _markDirty();
  }

  @override
  void recordExposure(String suggestionId) {
    _memory.recordExposure(suggestionId);
    _markDirty();
  }

  @override
  void recordFeedback({
    required String suggestionId,
    required bool useful,
    required bool used,
  }) {
    _memory.recordFeedback(
      suggestionId: suggestionId,
      useful: useful,
      used: used,
    );
    _markDirty();
  }

  @override
  void setOutcome(String sessionId, String outcome) {
    _memory.setOutcome(sessionId, outcome);
    _markDirty();
  }

  @override
  CoachingMetricsSnapshot metrics() {
    final CoachingMetricsSnapshot snapshot = _memory.metrics();
    return CoachingMetricsSnapshot(
      generatedShadow: snapshot.generatedShadow,
      exposures: snapshot.exposures,
      feedbackCount: snapshot.feedbackCount,
      usefulCount: snapshot.usefulCount,
      usedCount: snapshot.usedCount,
      outcomes: snapshot.outcomes,
      storage: storageDescription,
    );
  }

  @override
  int deleteSessionsEndedBefore(DateTime cutoff) {
    _ensureInitialized();
    final int deleted = _memory.deleteSessionsEndedBefore(cutoff);
    if (deleted > 0) {
      _markDirty();
    }
    return deleted;
  }

  @override
  void clearWorkspaceData() {
    _ensureInitialized();
    _memory.clearWorkspaceData();
    _markDirty();
  }

  @override
  Future<void> dispose() async {
    if (_closed) {
      return;
    }
    Object? firstError;
    StackTrace? firstStackTrace;
    if (_initialized) {
      try {
        await flush();
      } on Object catch (error, stackTrace) {
        firstError = error;
        firstStackTrace = stackTrace;
      }
    }
    _closed = true;
    try {
      await _memory.dispose();
    } on Object catch (error, stackTrace) {
      firstError ??= error;
      firstStackTrace ??= stackTrace;
    }
    try {
      await repository.close();
    } on Object catch (error, stackTrace) {
      firstError ??= error;
      firstStackTrace ??= stackTrace;
    }
    if (firstError != null) {
      Error.throwWithStackTrace(firstError, firstStackTrace!);
    }
  }

  void _markDirty() {
    _ensureInitialized();
    _mutationGeneration += 1;
  }

  void _ensureInitialized() {
    if (!_initialized) {
      throw StateError(
        'PostgresSnapshotPinkallStore.initialize must complete before use.',
      );
    }
    if (_closed) {
      throw StateError('PostgresSnapshotPinkallStore is closed.');
    }
  }
}
