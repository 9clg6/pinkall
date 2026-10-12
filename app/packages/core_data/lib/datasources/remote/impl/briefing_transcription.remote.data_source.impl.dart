import 'package:core_data/clients/pinkall_binary_http.client.dart';
import 'package:core_data/datasources/remote/briefing_transcription.remote.data_source.dart';
import 'package:core_data/model/remote/briefing_transcription.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Authenticated binary implementation of [BriefingTranscriptionRemoteDataSource].
final class BriefingTranscriptionRemoteDataSourceImpl
    implements BriefingTranscriptionRemoteDataSource {
  /// Creates the source with its binary-capable [httpClient].
  const BriefingTranscriptionRemoteDataSourceImpl({
    required PinkallBinaryHttpClient httpClient,
  }) : _httpClient = httpClient;

  final PinkallBinaryHttpClient _httpClient;

  @override
  Future<BriefingTranscriptionRemoteModel> transcribe(
    TranscribeBriefingAudioParam params,
  ) async {
    final Map<String, dynamic> json = await _httpClient.postBinary(
      '/v1/briefings/transcriptions',
      body: params.pcmBytes,
      contentType: 'audio/L16',
      queryParameters: <String, dynamic>{
        'encoding': 'pcm_s16le',
        'sample_rate': params.sampleRate,
      },
    );
    return BriefingTranscriptionRemoteModel.fromJson(json);
  }
}
