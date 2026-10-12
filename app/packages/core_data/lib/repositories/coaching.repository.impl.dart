import 'package:core_data/datasources/remote/coaching.remote.data_source.dart';
import 'package:core_data/mappers/coaching.mapper.dart';
import 'package:core_data/model/remote/objection_knowledge_entry.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Pinkall-backend implementation of [CoachingRepository].
final class CoachingRepositoryImpl implements CoachingRepository {
  /// Creates the repository with its [remoteDataSource].
  const CoachingRepositoryImpl({
    required CoachingRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final CoachingRemoteDataSource _remoteDataSource;

  @override
  Future<List<ObjectionKnowledgeEntryEntity>> listObjections() async {
    final ObjectionKnowledgeListRemoteModel result = await _remoteDataSource
        .listObjections();
    return result.items
        .map((ObjectionKnowledgeEntryRemoteModel item) => item.toEntity())
        .toList(growable: false);
  }

  @override
  Future<ObjectionKnowledgeEntryEntity> createCustomObjection(
    CreateCustomObjectionParam params,
  ) async {
    return (await _remoteDataSource.createCustomObjection(
      params.toJson(),
    )).toEntity();
  }

  @override
  Future<CoachPreferenceEntity> getPreference() async {
    return (await _remoteDataSource.getPreference()).toEntity();
  }

  @override
  Future<CallOutcomeEntity> recordOutcome(RecordCallOutcomeParam params) async {
    final Map<String, dynamic> body = params.toJson()..remove('session_id');
    return (await _remoteDataSource.recordOutcome(
      params.sessionId,
      body,
    )).toEntity();
  }

  @override
  Future<CoachingFeedbackEntity> submitFeedback(
    SubmitCoachingFeedbackParam params,
  ) async {
    return (await _remoteDataSource.submitFeedback(params.toJson())).toEntity();
  }

  @override
  Future<CoachPreferenceEntity> updatePreference(
    UpdateCoachPreferenceParam params,
  ) async {
    return (await _remoteDataSource.updatePreference(
      params.toJson(),
    )).toEntity();
  }
}
