import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/stt_contracts.dart';
import 'package:api_agent_vocal/src/infrastructure/stt/voxtral_stt_provider.dart';
import 'package:test/test.dart';

void main() {
  test('uses the official Voxtral realtime WebSocket message flow', () async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final List<Map<String, Object?>> received = <Map<String, Object?>>[];
    final Completer<void> serverCompleted = Completer<void>();
    server.listen((HttpRequest request) async {
      expect(request.uri.path, '/v1/audio/transcriptions/realtime');
      expect(request.uri.queryParameters['model'], 'voxtral-test-model');
      expect(request.headers.value('authorization'), 'Bearer test-key');
      final WebSocket socket = await WebSocketTransformer.upgrade(request);
      socket.add(jsonEncode(<String, Object?>{'type': 'session.created'}));
      await for (final dynamic raw in socket) {
        final Map<String, Object?> message =
            jsonDecode(raw as String) as Map<String, Object?>;
        received.add(message);
        if (message['type'] == 'input_audio.end') {
          socket.add(
            jsonEncode(<String, Object?>{
              'type': 'transcription.done',
              'text': 'bonjour',
            }),
          );
          await socket.close();
          serverCompleted.complete();
        }
      }
    });
    addTearDown(() => server.close(force: true));

    final VoxtralRealtimeSession session = await VoxtralRealtimeSession.connect(
      apiKey: 'test-key',
      baseUrl: 'ws://127.0.0.1:${server.port}',
      model: 'voxtral-test-model',
      audioFormat: const SttAudioFormat(
        encoding: 'pcm_s16le',
        sampleRate: 8000,
      ),
      targetDelayMs: 480,
    );
    final List<SttEvent> events = <SttEvent>[];
    final StreamSubscription<SttEvent> subscription = session.events.listen(
      events.add,
    );
    await session.addAudio(<int>[0, 0, 1, 0]);
    await session.close();
    await serverCompleted.future.timeout(const Duration(seconds: 2));
    await subscription.cancel();

    expect(
      received.map((Map<String, Object?> event) => event['type']),
      <Object?>[
        'session.update',
        'input_audio.append',
        'input_audio.flush',
        'input_audio.end',
      ],
    );
    expect(events.whereType<SttDone>().single.text, 'bonjour');
  });

  test('turns a provider error during close into a fail-soft event', () async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    final Completer<void> serverCompleted = Completer<void>();
    server.listen((HttpRequest request) async {
      final WebSocket socket = await WebSocketTransformer.upgrade(request);
      socket.add(jsonEncode(<String, Object?>{'type': 'session.created'}));
      await for (final dynamic raw in socket) {
        final Map<String, Object?> message =
            jsonDecode(raw as String) as Map<String, Object?>;
        if (message['type'] == 'input_audio.end') {
          socket.add(
            jsonEncode(<String, Object?>{
              'type': 'error',
              'error': <String, Object?>{
                'message':
                    'Timeout waiting for response from streaming transcription.',
              },
            }),
          );
          await socket.close();
          serverCompleted.complete();
        }
      }
    });
    addTearDown(() => server.close(force: true));

    final VoxtralRealtimeSession session = await VoxtralRealtimeSession.connect(
      apiKey: 'test-key',
      baseUrl: 'ws://127.0.0.1:${server.port}',
      model: 'voxtral-test-model',
      audioFormat: const SttAudioFormat(
        encoding: 'pcm_s16le',
        sampleRate: 8000,
      ),
      targetDelayMs: 480,
    );
    final List<SttEvent> events = <SttEvent>[];
    final StreamSubscription<SttEvent> subscription = session.events.listen(
      events.add,
    );

    await session.addAudio(<int>[0, 0, 1, 0]);
    await expectLater(session.close(), completes);
    await serverCompleted.future.timeout(const Duration(seconds: 2));
    await subscription.cancel();

    expect(events.whereType<SttFailure>(), hasLength(1));
    expect(
      events.whereType<SttFailure>().single.message,
      contains('Timeout waiting for response'),
    );
  });
}
