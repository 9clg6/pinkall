import 'package:core_data/datasources/remote/voice_access.remote.data_source.dart';
import 'package:core_data/mappers/voice_access_token.mapper.dart';
import 'package:core_domain/core_domain.dart';

/// Pinkall-backend implementation of [VoiceAccessRepository].
final class VoiceAccessRepositoryImpl implements VoiceAccessRepository {
  /// Creates the repository with its [remoteDataSource].
  const VoiceAccessRepositoryImpl({
    required VoiceAccessRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final VoiceAccessRemoteDataSource _remoteDataSource;

  @override
  Future<VoiceAccessTokenEntity> requestToken(
    RequestVoiceAccessTokenParam params,
  ) async {
    return (await _remoteDataSource.requestToken(params.toJson())).toEntity();
  }
}
