import 'package:core_data/clients/pinkall_http.client.dart';
import 'package:core_data/datasources/remote/coaching.remote.data_source.dart';
import 'package:core_data/model/remote/call_outcome.remote.model.dart';
import 'package:core_data/model/remote/coach_preference.remote.model.dart';
import 'package:core_data/model/remote/coaching_feedback.remote.model.dart';
import 'package:core_data/model/remote/objection_knowledge_entry.remote.model.dart';

/// HTTP implementation of [CoachingRemoteDataSource].
final class CoachingRemoteDataSourceImpl implements CoachingRemoteDataSource {
  /// Creates the source from a real configurable backend [httpClient].
  const CoachingRemoteDataSourceImpl({required PinkallHttpClient httpClient})
    : _httpClient = httpClient;

  final PinkallHttpClient _httpClient;

  @override
  Future<ObjectionKnowledgeListRemoteModel> listObjections() async {
    final Map<String, dynamic> json = await _httpClient.getJson(
      '/v1/coaching/objections',
    );
    return ObjectionKnowledgeListRemoteModel.fromJson(json);
  }

  @override
  Future<ObjectionKnowledgeEntryRemoteModel> createCustomObjection(
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/coaching/objections',
      body: body,
    );
    return ObjectionKnowledgeEntryRemoteModel.fromJson(json);
  }

  @override
  Future<CoachPreferenceRemoteModel> getPreference() async {
    final Map<String, dynamic> json = await _httpClient.getJson(
      '/v1/coach/preferences/me',
    );
    return CoachPreferenceRemoteModel.fromJson(json);
  }

  @override
  Future<CallOutcomeRemoteModel> recordOutcome(
    String sessionId,
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.putJson(
      '/v1/sessions/${Uri.encodeComponent(sessionId)}/outcome',
      body: body,
    );
    return CallOutcomeRemoteModel.fromJson(json);
  }

  @override
  Future<CoachingFeedbackRemoteModel> submitFeedback(
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/coaching/feedback',
      body: body,
    );
    return CoachingFeedbackRemoteModel.fromJson(json);
  }

  @override
  Future<CoachPreferenceRemoteModel> updatePreference(
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.putJson(
      '/v1/coach/preferences/me',
      body: body,
    );
    return CoachPreferenceRemoteModel.fromJson(json);
  }
}
