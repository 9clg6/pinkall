import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/api_agent_vocal.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  const String apiToken = 'test-token-with-more-than-24-characters';

  test(
    'transcribes authenticated PCM without creating a call session',
    () async {
      final HttpServer provider = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() => provider.close(force: true));
      provider.listen((HttpRequest request) async {
        expect(request.uri.path, '/v1/audio/transcriptions');
        expect(
          request.headers.value('authorization'),
          'Bearer test-mistral-key',
        );
        expect(request.headers.contentType?.mimeType, 'multipart/form-data');
        await request.drain<void>();
        request.response
          ..statusCode = HttpStatus.ok
          ..headers.contentType = ContentType.json
          ..write(
            jsonEncode(<String, Object?>{
              'text': 'Notre objectif est de qualifier le besoin.',
              'language': 'fr',
              'segments': <Map<String, Object?>>[
                <String, Object?>{
                  'text': 'Notre objectif est de qualifier le besoin.',
                  'start': 0,
                  'end': 1.2,
                },
              ],
            }),
          );
        await request.response.close();
      });

      final PinkallBackend backend = PinkallBackend.create(
        AppConfig.fromEnvironment(<String, String>{
          'PINKALL_API_TOKEN': apiToken,
          'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
          'MISTRAL_API_KEY': 'test-mistral-key',
          'MISTRAL_BATCH_BASE_URL':
              'http://${provider.address.address}:${provider.port}',
        }),
      );
      addTearDown(backend.dispose);
      final Handler handler = ApiRouter(backend: backend).handler;

      final Response response = await handler(
        Request(
          'POST',
          Uri.parse(
            'http://localhost/v1/briefings/transcriptions'
            '?encoding=pcm_s16le&sample_rate=16000',
          ),
          headers: const <String, String>{
            'authorization': 'Bearer $apiToken',
            'content-type': 'audio/L16',
          },
          body: List<int>.filled(3200, 1),
        ),
      );
      final Map<String, Object?> body =
          jsonDecode(await response.readAsString()) as Map<String, Object?>;

      expect(response.statusCode, HttpStatus.ok);
      expect(body['text'], 'Notre objectif est de qualifier le besoin.');
      expect(body['language'], 'fr');
      expect(body['provider'], contains('mistral_voxtral'));
      expect(backend.store.listSessions(), isEmpty);
    },
  );

  test('rejects empty briefing audio before contacting STT', () async {
    final PinkallBackend backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': apiToken,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-mistral-key',
      }),
    );
    addTearDown(backend.dispose);

    final Response response = await ApiRouter(backend: backend).handler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/briefings/transcriptions'),
        headers: const <String, String>{
          'authorization': 'Bearer $apiToken',
          'content-type': 'audio/L16',
        },
      ),
    );

    expect(response.statusCode, HttpStatus.badRequest);
    expect(
      await response.readAsString(),
      contains('Briefing audio cannot be empty'),
    );
  });

  test('returns 503 when briefing STT is not configured', () async {
    final PinkallBackend backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': apiToken,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
      }),
    );
    addTearDown(backend.dispose);

    final Response response = await ApiRouter(backend: backend).handler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/briefings/transcriptions'),
        headers: const <String, String>{
          'authorization': 'Bearer $apiToken',
          'content-type': 'audio/L16',
        },
        body: const <int>[1, 2],
      ),
    );

    expect(response.statusCode, HttpStatus.serviceUnavailable);
    expect(await response.readAsString(), contains('stt_not_configured'));
  });

  test('rate limits repeated briefing transcription starts', () async {
    final PinkallBackend backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': apiToken,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-mistral-key',
      }),
    );
    addTearDown(backend.dispose);
    final Handler handler = ApiRouter(backend: backend).handler;

    for (int attempt = 0; attempt < 10; attempt += 1) {
      final Response response = await handler(
        Request(
          'POST',
          Uri.parse('http://localhost/v1/briefings/transcriptions'),
          headers: const <String, String>{
            'authorization': 'Bearer $apiToken',
            'content-type': 'audio/L16',
          },
        ),
      );
      expect(response.statusCode, HttpStatus.badRequest);
      await response.readAsString();
    }

    final Response limited = await handler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/briefings/transcriptions'),
        headers: const <String, String>{
          'authorization': 'Bearer $apiToken',
          'content-type': 'audio/L16',
        },
      ),
    );

    expect(limited.statusCode, HttpStatus.tooManyRequests);
    expect(limited.headers['retry-after'], '60');
    expect(
      await limited.readAsString(),
      contains('briefing_transcription_rate_limited'),
    );
  });
}
