import 'package:core_data/clients/pinkall_http.client.dart';
import 'package:core_data/datasources/remote/voice_access.remote.data_source.dart';
import 'package:core_data/model/remote/voice_access_token.remote.model.dart';

/// HTTP implementation of [VoiceAccessRemoteDataSource].
final class VoiceAccessRemoteDataSourceImpl
    implements VoiceAccessRemoteDataSource {
  /// Creates the source from an authenticated Pinkall [httpClient].
  const VoiceAccessRemoteDataSourceImpl({required PinkallHttpClient httpClient})
    : _httpClient = httpClient;

  final PinkallHttpClient _httpClient;

  @override
  Future<VoiceAccessTokenRemoteModel> requestToken(
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/voice/token',
      body: body,
    );
    return VoiceAccessTokenRemoteModel.fromJson(json);
  }
}
