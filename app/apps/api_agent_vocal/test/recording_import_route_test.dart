import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/api_agent_vocal.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  const String token = 'recording-route-token-more-than-24-characters';
  late PinkallBackend backend;
  late Handler handler;
  late _RouteRecordingProvider provider;

  setUp(() async {
    provider = _RouteRecordingProvider();
    backend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': token,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only-not-used',
      }),
      recordingTranscriptionProvider: provider,
    );
    await backend.initialize();
    handler = ApiRouter(backend: backend).handler;
  });

  tearDown(() => backend.dispose());

  test('runs create, consent, stream, poll and speaker assignment', () async {
    final Response unauthenticated = await handler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/recording-imports'),
        headers: const <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: jsonEncode(_createBody),
      ),
    );
    expect(unauthenticated.statusCode, HttpStatus.unauthorized);

    final Response createResponse = await _jsonRequest(
      handler,
      token: token,
      method: 'POST',
      path: '/v1/recording-imports',
      body: _createBody,
    );
    expect(createResponse.statusCode, HttpStatus.created);
    final Map<String, Object?> created =
        jsonDecode(await createResponse.readAsString()) as Map<String, Object?>;
    final String importId = created['id']! as String;
    final String sessionId = created['session_id']! as String;
    expect(created['status'], 'awaiting_consent');
    expect(created['mime_type'], 'audio/mp4');
    expect(created['upload_url'], '/v1/recording-imports/$importId/audio');
    expect(created['max_size_bytes'], 200 * 1024 * 1024);
    expect(created['max_duration_seconds'], 10800.0);
    expect(created['consent_required'], isTrue);
    expect(backend.store.session(sessionId)!.coachMode, CoachMode.off);

    final Response beforeConsent = await _audioRequest(
      handler,
      token: token,
      importId: importId,
      mimeType: 'audio/mp4',
      bytes: <int>[1, 2, 3, 4],
    );
    expect(beforeConsent.statusCode, HttpStatus.conflict);
    expect(await _errorCode(beforeConsent), 'consent_required');
    expect(provider.calls, 0);

    final Response consent = await _jsonRequest(
      handler,
      token: token,
      method: 'POST',
      path: '/v1/sessions/$sessionId/transcription-consent',
      body: <String, Object?>{
        'acknowledged': true,
        'method': 'verbal_notice',
        'acknowledged_at': DateTime.now().toUtc().toIso8601String(),
      },
    );
    expect(consent.statusCode, HttpStatus.ok);

    final Response readyResponse = await _get(
      handler,
      token: token,
      path: '/v1/recording-imports/$importId',
    );
    final Map<String, Object?> ready =
        jsonDecode(await readyResponse.readAsString()) as Map<String, Object?>;
    expect(ready['status'], 'awaiting_upload');
    expect(ready['consent_required'], isFalse);

    final Response mismatchedMime = await _audioRequest(
      handler,
      token: token,
      importId: importId,
      mimeType: 'audio/wav',
      bytes: <int>[1, 2, 3, 4],
    );
    expect(mismatchedMime.statusCode, HttpStatus.unsupportedMediaType);
    expect(await _errorCode(mismatchedMime), 'mime_type_mismatch');

    final List<int> audio = <int>[1, 2, 3, 4];
    final Response upload = await _audioRequest(
      handler,
      token: token,
      importId: importId,
      mimeType: 'audio/x-m4a',
      bytes: audio,
    );
    expect(upload.statusCode, HttpStatus.accepted);
    await _waitUntil(
      () =>
          backend.recordingImports.get(importId).status ==
          RecordingImportStatus.awaitingSpeakerAssignment,
    );

    final Response pollResponse = await _get(
      handler,
      token: token,
      path: '/v1/recording-imports/$importId',
    );
    final String pollRaw = await pollResponse.readAsString();
    final Map<String, Object?> poll =
        jsonDecode(pollRaw) as Map<String, Object?>;
    expect(poll['status'], 'awaiting_speaker_assignment');
    expect(poll['voices'], <Object?>['A', 'B']);
    expect(pollRaw, isNot(contains('seller')));
    expect(pollRaw, isNot(contains('prospect')));
    expect(pollRaw, isNot(contains('"track"')));

    final Response unknown = await _jsonRequest(
      handler,
      token: token,
      method: 'POST',
      path: '/v1/recording-imports/$importId/speaker-assignment',
      body: const <String, Object?>{'user_voice': 'C'},
    );
    expect(unknown.statusCode, HttpStatus.badRequest);
    expect(await _errorCode(unknown), 'unknown_user_voice');

    final Response assignment = await _jsonRequest(
      handler,
      token: token,
      method: 'POST',
      path: '/v1/recording-imports/$importId/speaker-assignment',
      body: const <String, Object?>{'user_voice': 'A'},
    );
    expect(assignment.statusCode, HttpStatus.ok);
    final Map<String, Object?> finalized =
        jsonDecode(await assignment.readAsString()) as Map<String, Object?>;
    expect(finalized['status'], 'finalized');
    expect(finalized['debrief_status'], 'unavailable');
    final List<Object?> transcript =
        finalized['final_transcript']! as List<Object?>;
    expect(
      transcript.cast<Map<String, Object?>>().where(
        (Map<String, Object?> item) => item['speaker'] == 'seller',
      ),
      hasLength(1),
    );
    expect(
      transcript.cast<Map<String, Object?>>().where(
        (Map<String, Object?> item) => item['speaker'] == 'prospect',
      ),
      hasLength(1),
    );
    final String durableJson = jsonEncode(
      (backend.store as InMemoryPocStore).exportDurableSnapshot(),
    );
    expect(durableJson, isNot(contains(base64Encode(audio))));
    expect(provider.calls, 1);
  });

  test('returns stable validation and provider availability errors', () async {
    final Response unsupported = await _jsonRequest(
      handler,
      token: token,
      method: 'POST',
      path: '/v1/recording-imports',
      body: <String, Object?>{..._createBody, 'file_name': 'appel.exe'},
    );
    expect(unsupported.statusCode, HttpStatus.unsupportedMediaType);
    expect(await _errorCode(unsupported), 'unsupported_media');

    final Response oversized = await _jsonRequest(
      handler,
      token: token,
      method: 'POST',
      path: '/v1/recording-imports',
      body: <String, Object?>{
        ..._createBody,
        'size_bytes': RecordingImportService.maxSizeBytes + 1,
      },
    );
    expect(oversized.statusCode, HttpStatus.requestEntityTooLarge);
    expect(await _errorCode(oversized), 'payload_too_large');

    final PinkallBackend unavailableBackend = PinkallBackend.create(
      AppConfig.fromEnvironment(const <String, String>{
        'PINKALL_API_TOKEN': token,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only-not-used',
      }),
    );
    await unavailableBackend.initialize();
    addTearDown(unavailableBackend.dispose);
    final Handler unavailableHandler = ApiRouter(
      backend: unavailableBackend,
    ).handler;
    final Response unavailable = await _jsonRequest(
      unavailableHandler,
      token: token,
      method: 'POST',
      path: '/v1/recording-imports',
      body: _createBody,
    );
    expect(unavailable.statusCode, HttpStatus.serviceUnavailable);
    expect(await _errorCode(unavailable), 'provider_unavailable');
  });
}

const Map<String, Object?> _createBody = <String, Object?>{
  'source': 'recording_import',
  'file_name': 'appel.m4a',
  'mime_type': 'audio/x-m4a',
  'size_bytes': 4,
  'title': 'Discovery Acme',
  'locale': 'fr-FR',
  'preparation_markdown': '# Objectif\nQualifier le besoin.',
};

Future<Response> _jsonRequest(
  Handler handler, {
  required String token,
  required String method,
  required String path,
  required Map<String, Object?> body,
}) async {
  return await handler(
    Request(
      method,
      Uri.parse('http://localhost$path'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(body),
    ),
  );
}

Future<Response> _get(
  Handler handler, {
  required String token,
  required String path,
}) async {
  return await handler(
    Request(
      'GET',
      Uri.parse('http://localhost$path'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    ),
  );
}

Future<Response> _audioRequest(
  Handler handler, {
  required String token,
  required String importId,
  required String mimeType,
  required List<int> bytes,
}) async {
  return await handler(
    Request(
      'PUT',
      Uri.parse('http://localhost/v1/recording-imports/$importId/audio'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.contentTypeHeader: mimeType,
        HttpHeaders.contentLengthHeader: bytes.length.toString(),
      },
      body: Stream<List<int>>.value(bytes),
    ),
  );
}

Future<String> _errorCode(Response response) async {
  final Map<String, Object?> body =
      jsonDecode(await response.readAsString()) as Map<String, Object?>;
  return (body['error']! as Map<String, Object?>)['code']! as String;
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

final class _RouteRecordingProvider
    implements RecordedCallTranscriptionProvider {
  int calls = 0;

  @override
  bool get isConfigured => true;

  @override
  String get name => 'route_fake';

  @override
  Future<DiarizedRecordingTranscript> transcribe({
    required RecordedAudioInput audio,
    required String locale,
  }) async {
    calls += 1;
    final List<int> received = await audio.openRead().expand((List<int> chunk) {
      return chunk;
    }).toList();
    expect(received, hasLength(audio.sizeBytes));
    return const DiarizedRecordingTranscript(
      durationSeconds: 15,
      language: 'fr',
      provider: 'route_fake',
      segments: <DiarizedRecordingSegment>[
        DiarizedRecordingSegment(
          voiceId: 'deepgram-2',
          text: 'Bonjour.',
          startSeconds: 0,
          endSeconds: 1,
          confidence: 0.9,
        ),
        DiarizedRecordingSegment(
          voiceId: 'deepgram-8',
          text: 'Bonjour, je vous écoute.',
          startSeconds: 1.1,
          endSeconds: 2.5,
          confidence: 0.88,
        ),
      ],
    );
  }

  @override
  Future<void> dispose() async {}
}
