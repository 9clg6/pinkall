import 'package:core_data/clients/pinkall_http.client.dart';
import 'package:core_data/clients/pinkall_realtime.client.dart';
import 'package:core_data/datasources/remote/conversation_session.remote.data_source.dart';
import 'package:core_data/model/remote/call_debrief.remote.model.dart';
import 'package:core_data/model/remote/coaching_progress.remote.model.dart';
import 'package:core_data/model/remote/conversation_session.remote.model.dart';
import 'package:core_data/model/remote/conversation_transcript.remote.model.dart';
import 'package:core_data/model/remote/external_conversation_session.remote.model.dart';
import 'package:core_data/model/remote/session_realtime_event.remote.model.dart';
import 'package:core_data/model/remote/transcription_consent.remote.model.dart';

/// HTTP and WebSocket implementation of [ConversationSessionRemoteDataSource].
final class ConversationSessionRemoteDataSourceImpl
    implements ConversationSessionRemoteDataSource {
  /// Creates the source from real configurable backend clients.
  const ConversationSessionRemoteDataSourceImpl({
    required PinkallHttpClient httpClient,
    required PinkallRealtimeClient realtimeClient,
  }) : _httpClient = httpClient,
       _realtimeClient = realtimeClient;

  final PinkallHttpClient _httpClient;
  final PinkallRealtimeClient _realtimeClient;

  @override
  Future<ConversationSessionRemoteModel> cancelSession(String sessionId) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/sessions/${Uri.encodeComponent(sessionId)}/cancel',
    );
    return ConversationSessionRemoteModel.fromJson(json);
  }

  @override
  Future<ConversationSessionRemoteModel> createSession(
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/sessions',
      body: body,
    );
    return ConversationSessionRemoteModel.fromJson(json);
  }

  @override
  Future<ExternalConversationSessionRemoteModel> createExternalSession(
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/sessions/external',
      body: body,
    );
    return ExternalConversationSessionRemoteModel.fromJson(json);
  }

  @override
  Future<ConversationSessionRemoteModel> finalizeSession(
    String sessionId,
  ) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/sessions/${Uri.encodeComponent(sessionId)}/finalize',
    );
    return ConversationSessionRemoteModel.fromJson(json);
  }

  @override
  Future<ConversationTranscriptRemoteModel> getFinalTranscript(
    String sessionId,
  ) async {
    final Map<String, dynamic> json = await _httpClient.getJson(
      '/v1/sessions/${Uri.encodeComponent(sessionId)}/transcript/final',
    );
    return ConversationTranscriptRemoteModel.fromJson(json);
  }

  @override
  Future<CallDebriefRemoteModel> getDebrief(String sessionId) async {
    final Map<String, dynamic> json = await _httpClient.getJson(
      '/v1/sessions/${Uri.encodeComponent(sessionId)}/debrief',
    );
    return CallDebriefRemoteModel.fromJson(json);
  }

  @override
  Future<CoachingProgressRemoteModel> getCoachingProgress({
    required int windowSize,
    required int recentLimit,
  }) async {
    final Map<String, dynamic> json = await _httpClient.getJson(
      '/v1/coaching/progress?window=$windowSize&limit=$recentLimit',
    );
    return CoachingProgressRemoteModel.fromJson(json);
  }

  @override
  Future<ConversationSessionRemoteModel> getSession(String sessionId) async {
    final Map<String, dynamic> json = await _httpClient.getJson(
      '/v1/sessions/${Uri.encodeComponent(sessionId)}',
    );
    return ConversationSessionRemoteModel.fromJson(json);
  }

  @override
  Future<List<ConversationSessionRemoteModel>> listActiveSessions() async {
    final Map<String, dynamic> json = await _httpClient.getJson(
      '/v1/sessions/active',
    );
    final Object? rawItems = json['items'];
    if (rawItems is! List<dynamic>) {
      throw const FormatException(
        'Pinkall active sessions response must contain an items list.',
      );
    }
    return rawItems
        .map<ConversationSessionRemoteModel>((dynamic item) {
          if (item is! Map<dynamic, dynamic>) {
            throw const FormatException(
              'A Pinkall active session must be a JSON object.',
            );
          }
          return ConversationSessionRemoteModel.fromJson(
            item.map<String, dynamic>(
              (dynamic key, dynamic value) =>
                  MapEntry<String, dynamic>(key.toString(), value),
            ),
          );
        })
        .toList(growable: false);
  }

  @override
  Future<List<ConversationSessionRemoteModel>> listSessions() async {
    final Map<String, dynamic> json = await _httpClient.getJson('/v1/sessions');
    final Object? rawItems = json['data'];
    if (rawItems is! List<dynamic>) {
      throw const FormatException(
        'Pinkall sessions response must contain a data list.',
      );
    }
    return rawItems
        .map<ConversationSessionRemoteModel>((dynamic item) {
          if (item is! Map<dynamic, dynamic>) {
            throw const FormatException(
              'A Pinkall session must be a JSON object.',
            );
          }
          return ConversationSessionRemoteModel.fromJson(
            item.map<String, dynamic>(
              (dynamic key, dynamic value) =>
                  MapEntry<String, dynamic>(key.toString(), value),
            ),
          );
        })
        .toList(growable: false);
  }

  @override
  Future<ConversationSessionRemoteModel> updateCoachMode(
    String sessionId,
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.patchJson(
      '/v1/sessions/${Uri.encodeComponent(sessionId)}/coach-mode',
      body: body,
    );
    return ConversationSessionRemoteModel.fromJson(json);
  }

  @override
  Future<TranscriptionConsentRemoteModel> recordTranscriptionConsent(
    String sessionId,
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/sessions/${Uri.encodeComponent(sessionId)}/transcription-consent',
      body: body,
    );
    return TranscriptionConsentRemoteModel.fromJson(json);
  }

  @override
  Stream<SessionRealtimeEventRemoteModel> watchSessionEvents(String sessionId) {
    return _realtimeClient
        .watchJson('/v1/sessions/${Uri.encodeComponent(sessionId)}/events')
        .map(SessionRealtimeEventRemoteModel.fromJson);
  }
}
