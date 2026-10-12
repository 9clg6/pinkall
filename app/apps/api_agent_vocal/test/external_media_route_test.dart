import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/api_agent_vocal.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:test/test.dart';

void main() {
  const String apiToken = 'external-media-test-token-more-than-24-chars';
  late PinkallBackend backend;
  late Handler handler;
  late HttpServer server;

  setUp(() async {
    backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': apiToken,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'COACH_MODE_DEFAULT': 'off',
      }),
    );
    await backend.initialize();
    handler = ApiRouter(backend: backend).handler;
    server = await shelf_io.serve(handler, InternetAddress.loopbackIPv4, 0);
  });

  tearDown(() async {
    await server.close(force: true);
    await backend.dispose();
  });

  test('creates an authenticated external media session contract', () async {
    final Response unauthenticated = await handler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/sessions/external'),
        headers: const <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(const <String, Object?>{'source': 'macos_meeting'}),
      ),
    );
    expect(unauthenticated.statusCode, HttpStatus.unauthorized);

    final Map<String, Object?> body = await _createExternalSession(
      handler,
      apiToken: apiToken,
      body: const <String, Object?>{
        'source': 'macos_meeting',
        'title': 'Démo Acme',
        'locale': 'fr-FR',
        'preparation_markdown': '# Objectif\r\nQualifier le besoin.',
        'coach_mode_override': 'off',
      },
    );
    final String sessionId = body['id']! as String;
    final String mediaToken = body['media_token']! as String;
    final Map<String, Object?> media = body['media']! as Map<String, Object?>;

    expect(body['source'], 'macos_meeting');
    expect(body['title'], 'Démo Acme');
    expect(body['locale'], 'fr-FR');
    expect(body['consent_required'], isTrue);
    expect(body['preparation_markdown'], '# Objectif\nQualifier le besoin.');
    expect(
      body['media_websocket_path'],
      '/v1/sessions/$sessionId/media/client',
    );
    expect(media, containsPair('encoding', 'pcm_s16le'));
    expect(media, containsPair('sample_rate', 16000));
    expect(media, containsPair('channels', 1));
    expect(
      media['seller_websocket_url'],
      allOf(
        contains('track=seller'),
        contains('sample_rate=16000'),
        contains(Uri.encodeQueryComponent(mediaToken)),
      ),
    );
    expect(
      media['prospect_websocket_url'],
      allOf(contains('track=prospect'), contains('sample_rate=16000')),
    );

    final Response invalidSource = await _authenticatedJson(
      handler,
      apiToken: apiToken,
      path: '/v1/sessions/external',
      body: const <String, Object?>{'source': 'telnyx'},
    );
    expect(invalidSource.statusCode, HttpStatus.badRequest);

    final Response invalidLocale = await _authenticatedJson(
      handler,
      apiToken: apiToken,
      path: '/v1/sessions/external',
      body: const <String, Object?>{
        'source': 'macos_meeting',
        'locale': '../../not-a-locale',
      },
    );
    expect(invalidLocale.statusCode, HttpStatus.badRequest);
  });

  test(
    'ingests binary PCM only after consent and never durably stores it',
    () async {
      final Map<String, Object?> created = await _createExternalSession(
        handler,
        apiToken: apiToken,
      );
      final String sessionId = created['id']! as String;
      final InMemoryPocStore store = backend.store as InMemoryPocStore;
      final WebSocket socket = await _connectTrack(
        server,
        created,
        track: 'seller',
      );

      await _waitUntil(
        () => store.session(sessionId)?.status == SessionStatus.streaming,
      );
      socket.add(<int>[2, 4, 6, 8]);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(store.audio(sessionId, MediaTrack.outbound), isEmpty);

      final Response consent = await _authenticatedJson(
        handler,
        apiToken: apiToken,
        path: '/v1/sessions/$sessionId/transcription-consent',
        body: <String, Object?>{
          'acknowledged': true,
          'method': 'verbal_notice',
          'acknowledged_at': DateTime.now().toUtc().toIso8601String(),
        },
      );
      expect(consent.statusCode, HttpStatus.ok);

      final List<int> pcm = List<int>.generate(128, (int index) => index);
      socket.add(pcm);
      await _waitUntil(
        () => store.audio(sessionId, MediaTrack.outbound).length == pcm.length,
      );
      final String durableJson = jsonEncode(store.exportDurableSnapshot());
      expect(durableJson, isNot(contains(base64Encode(pcm))));

      await socket.close(WebSocketStatus.normalClosure);
      await _waitUntil(
        () => store.session(sessionId)?.status == SessionStatus.stopped,
      );
    },
  );

  test('rejects invalid media credentials and PCM framing', () async {
    final Map<String, Object?> created = await _createExternalSession(
      handler,
      apiToken: apiToken,
    );
    final String sessionId = created['id']! as String;
    final String mediaToken = created['media_token']! as String;

    final Response invalidToken = await handler(
      Request(
        'GET',
        Uri.parse(
          'http://localhost/v1/sessions/$sessionId/media/client'
          '?track=seller&sample_rate=16000&token=invalid',
        ),
      ),
    );
    expect(invalidToken.statusCode, HttpStatus.unauthorized);

    final Response invalidRate = await handler(
      Request(
        'GET',
        Uri.parse(
          'http://localhost/v1/sessions/$sessionId/media/client'
          '?track=seller&sample_rate=48000&token=$mediaToken',
        ),
      ),
    );
    expect(invalidRate.statusCode, HttpStatus.unprocessableEntity);

    final WebSocket textSocket = await _connectTrack(
      server,
      created,
      track: 'seller',
    );
    textSocket.add('not binary');
    await textSocket.drain<void>().timeout(const Duration(seconds: 2));
    expect(textSocket.closeCode, 4003);

    final Map<String, Object?> oddSession = await _createExternalSession(
      handler,
      apiToken: apiToken,
    );
    final WebSocket oddSocket = await _connectTrack(
      server,
      oddSession,
      track: 'prospect',
    );
    oddSocket.add(<int>[1, 2, 3]);
    await oddSocket.drain<void>().timeout(const Duration(seconds: 2));
    expect(oddSocket.closeCode, 4007);

    final Map<String, Object?> largeSession = await _createExternalSession(
      handler,
      apiToken: apiToken,
    );
    final WebSocket largeSocket = await _connectTrack(
      server,
      largeSession,
      track: 'seller',
    );
    largeSocket.add(List<int>.filled(64 * 1024 + 2, 0));
    await largeSocket.drain<void>().timeout(const Duration(seconds: 2));
    expect(largeSocket.closeCode, 4009);
  });

  test('bounds duplicate tracks and rolling media byte rate', () async {
    final Map<String, Object?> duplicateSession = await _createExternalSession(
      handler,
      apiToken: apiToken,
    );
    final String duplicateSessionId = duplicateSession['id']! as String;
    final WebSocket first = await _connectTrack(
      server,
      duplicateSession,
      track: 'seller',
    );
    await _waitUntil(
      () =>
          backend.store.session(duplicateSessionId)?.status ==
          SessionStatus.streaming,
    );
    final WebSocket duplicate = await _connectTrack(
      server,
      duplicateSession,
      track: 'seller',
    );
    await duplicate.drain<void>().timeout(const Duration(seconds: 2));
    expect(duplicate.closeCode, 4008);
    await first.close(WebSocketStatus.normalClosure);

    final Map<String, Object?> rateSession = await _createExternalSession(
      handler,
      apiToken: apiToken,
    );
    final WebSocket rateSocket = await _connectTrack(
      server,
      rateSession,
      track: 'prospect',
    );
    final List<int> maximumFrame = List<int>.filled(64 * 1024, 0);
    for (int index = 0; index < 9; index += 1) {
      rateSocket.add(maximumFrame);
    }
    await rateSocket.drain<void>().timeout(const Duration(seconds: 3));
    expect(rateSocket.closeCode, 4013);
  });
}

Future<Map<String, Object?>> _createExternalSession(
  Handler handler, {
  required String apiToken,
  Map<String, Object?> body = const <String, Object?>{
    'source': 'macos_meeting',
    'coach_mode_override': 'off',
  },
}) async {
  final Response response = await _authenticatedJson(
    handler,
    apiToken: apiToken,
    path: '/v1/sessions/external',
    body: body,
  );
  expect(response.statusCode, HttpStatus.created);
  return jsonDecode(await response.readAsString()) as Map<String, Object?>;
}

Future<Response> _authenticatedJson(
  Handler handler, {
  required String apiToken,
  required String path,
  required Map<String, Object?> body,
}) async {
  return await handler(
    Request(
      'POST',
      Uri.parse('http://localhost$path'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer $apiToken',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(body),
    ),
  );
}

Future<WebSocket> _connectTrack(
  HttpServer server,
  Map<String, Object?> created, {
  required String track,
}) {
  final String sessionId = created['id']! as String;
  final String mediaToken = created['media_token']! as String;
  return WebSocket.connect(
    Uri(
      scheme: 'ws',
      host: '127.0.0.1',
      port: server.port,
      path: '/v1/sessions/$sessionId/media/client',
      queryParameters: <String, String>{
        'track': track,
        'sample_rate': '16000',
        'token': mediaToken,
      },
    ).toString(),
  );
}

Future<void> _waitUntil(
  bool Function() predicate, {
  Duration timeout = const Duration(seconds: 2),
}) async {
  final DateTime deadline = DateTime.now().add(timeout);
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Condition was not met within $timeout.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}
