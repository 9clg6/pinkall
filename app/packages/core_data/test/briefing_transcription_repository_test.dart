import 'dart:typed_data';

import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:test/test.dart';

void main() {
  test('uploads mono PCM and maps the editable briefing transcript', () async {
    final _BinaryClient client = _BinaryClient();
    final BriefingTranscriptionRepository repository =
        BriefingTranscriptionRepositoryImpl(
          remoteDataSource: BriefingTranscriptionRemoteDataSourceImpl(
            httpClient: client,
          ),
        );
    final Uint8List audio = Uint8List.fromList(<int>[1, 2, 3, 4]);

    final BriefingTranscriptionEntity result = await repository.transcribe(
      TranscribeBriefingAudioParam(pcmBytes: audio, sampleRate: 16000),
    );

    expect(client.path, '/v1/briefings/transcriptions');
    expect(client.contentType, 'audio/L16');
    expect(client.body, audio);
    expect(client.queryParameters, <String, dynamic>{
      'encoding': 'pcm_s16le',
      'sample_rate': 16000,
    });
    expect(result.text, 'Objectif : qualifier le besoin.');
    expect(result.languageCode, 'fr');
    expect(result.provider, 'mistral_voxtral:voxtral-mini');
  });
}

final class _BinaryClient implements PinkallBinaryHttpClient {
  String? path;
  Uint8List? body;
  String? contentType;
  Map<String, dynamic>? queryParameters;

  @override
  Future<Map<String, dynamic>> postBinary(
    String path, {
    required Uint8List body,
    required String contentType,
    Map<String, dynamic>? queryParameters,
  }) async {
    this.path = path;
    this.body = body;
    this.contentType = contentType;
    this.queryParameters = queryParameters;
    return <String, dynamic>{
      'text': ' Objectif : qualifier le besoin. ',
      'language': 'fr',
      'provider': 'mistral_voxtral:voxtral-mini',
    };
  }
}
