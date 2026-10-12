import 'package:core_data/datasources/remote/conversation_session.remote.data_source.dart';
import 'package:core_data/mappers/call_debrief.mapper.dart';
import 'package:core_data/mappers/coaching_progress.mapper.dart';
import 'package:core_data/mappers/conversation_session.mapper.dart';
import 'package:core_data/mappers/external_conversation_session.mapper.dart';
import 'package:core_data/mappers/session_realtime_event.mapper.dart';
import 'package:core_data/mappers/transcript.mapper.dart';
import 'package:core_data/mappers/transcription_consent.mapper.dart';
import 'package:core_data/model/remote/conversation_session.remote.model.dart';
import 'package:core_data/model/remote/session_realtime_event.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Pinkall-backend implementation of [ConversationSessionRepository].
final class ConversationSessionRepositoryImpl
    implements ConversationSessionRepository {
  /// Creates the repository with its [remoteDataSource].
  const ConversationSessionRepositoryImpl({
    required ConversationSessionRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ConversationSessionRemoteDataSource _remoteDataSource;

  @override
  Future<ConversationSessionEntity> cancelSession(String sessionId) async {
    return (await _remoteDataSource.cancelSession(sessionId)).toEntity();
  }

  @override
  Future<ConversationSessionEntity> createSession(
    CreateConversationSessionParam params,
  ) async {
    return (await _remoteDataSource.createSession(params.toJson())).toEntity();
  }

  @override
  Future<ExternalConversationSessionEntity> createExternalSession(
    CreateExternalConversationSessionParam params,
  ) async {
    return (await _remoteDataSource.createExternalSession(
      params.toJson(),
    )).toEntity();
  }

  @override
  Future<ConversationSessionEntity> finalizeSession(String sessionId) async {
    return (await _remoteDataSource.finalizeSession(sessionId)).toEntity();
  }

  @override
  Future<ConversationTranscriptEntity> getFinalTranscript(
    String sessionId,
  ) async {
    await _ensureTranscriptionConsent(sessionId);
    return (await _remoteDataSource.getFinalTranscript(sessionId)).toEntity();
  }

  @override
  Future<CallDebriefEntity> getDebrief(String sessionId) async {
    await _ensureTranscriptionConsent(sessionId);
    return (await _remoteDataSource.getDebrief(sessionId)).toEntity();
  }

  @override
  Future<CoachingProgressEntity> getCoachingProgress(
    GetCoachingProgressParam params,
  ) async {
    return (await _remoteDataSource.getCoachingProgress(
      windowSize: params.windowSize,
      recentLimit: params.recentLimit,
    )).toEntity();
  }

  @override
  Future<ConversationSessionEntity> getSession(String sessionId) async {
    return (await _remoteDataSource.getSession(sessionId)).toEntity();
  }

  @override
  Future<List<ConversationSessionEntity>> listActiveSessions() async {
    final List<ConversationSessionRemoteModel> models = await _remoteDataSource
        .listActiveSessions();
    return models
        .map((ConversationSessionRemoteModel model) => model.toEntity())
        .toList(growable: false);
  }

  @override
  Future<List<ConversationSessionEntity>> listSessions() async {
    final List<ConversationSessionRemoteModel> models = await _remoteDataSource
        .listSessions();
    return models
        .map((ConversationSessionRemoteModel model) => model.toEntity())
        .toList(growable: false);
  }

  @override
  Future<ConversationSessionEntity> updateCoachMode(
    UpdateSessionCoachModeParam params,
  ) async {
    final Map<String, dynamic> body = params.toJson()..remove('session_id');
    return (await _remoteDataSource.updateCoachMode(
      params.sessionId,
      body,
    )).toEntity();
  }

  @override
  Future<TranscriptionConsentEntity> recordTranscriptionConsent(
    RecordTranscriptionConsentParam params,
  ) async {
    final Map<String, dynamic> body = params.toJson()..remove('session_id');
    return (await _remoteDataSource.recordTranscriptionConsent(
      params.sessionId,
      body,
    )).toEntity();
  }

  @override
  Stream<SessionRealtimeEventEntity> watchSessionEvents(
    String sessionId,
  ) async* {
    await _ensureTranscriptionConsent(sessionId);
    yield* _remoteDataSource
        .watchSessionEvents(sessionId)
        .map((SessionRealtimeEventRemoteModel model) => model.toEntity());
  }

  Future<void> _ensureTranscriptionConsent(String sessionId) async {
    final ConversationSessionEntity session =
        (await _remoteDataSource.getSession(sessionId)).toEntity();
    if (!session.transcriptionConsentAcknowledged) {
      throw TranscriptionConsentRequiredException(sessionId);
    }
  }
}
