import 'package:core_data/datasources/remote/briefing_transcription.remote.data_source.dart';
import 'package:core_data/mappers/briefing_transcription.mapper.dart';
import 'package:core_data/model/remote/briefing_transcription.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Pinkall API implementation of [BriefingTranscriptionRepository].
final class BriefingTranscriptionRepositoryImpl
    implements BriefingTranscriptionRepository {
  /// Creates the repository with its ephemeral media source.
  const BriefingTranscriptionRepositoryImpl({
    required BriefingTranscriptionRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final BriefingTranscriptionRemoteDataSource _remoteDataSource;

  @override
  Future<BriefingTranscriptionEntity> transcribe(
    TranscribeBriefingAudioParam params,
  ) async {
    final BriefingTranscriptionRemoteModel model = await _remoteDataSource
        .transcribe(params);
    return model.toEntity();
  }
}
