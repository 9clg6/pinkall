import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/api_agent_vocal.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:test/test.dart';

void main() {
  late PinkallBackend backend;
  late Handler handler;
  late Directory coachCatalogDirectory;
  const String token = 'test-token-with-more-than-24-characters';

  setUp(() {
    coachCatalogDirectory = Directory.systemTemp.createTempSync(
      'pinkall-api-catalog-',
    );
    final AppConfig config = AppConfig.fromEnvironment(
      <String, String>{
        'PINKALL_API_TOKEN': token,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only-not-used',
      }..['COACH_CATALOG_DIR'] = coachCatalogDirectory.path,
    );
    backend = PinkallBackend.create(config);
    handler = ApiRouter(backend: backend).handler;
  });

  tearDown(() async {
    await backend.dispose();
    coachCatalogDirectory.deleteSync(recursive: true);
  });

  test('keeps the public health probe minimal', () async {
    final Response response = await handler(
      Request('GET', Uri.parse('http://localhost/health')),
    );
    final Map<String, Object?> body =
        jsonDecode(await response.readAsString()) as Map<String, Object?>;

    expect(response.statusCode, 503);
    expect(body, <String, Object?>{'status': 'degraded', 'ready': false});
    expect(response.headers[HttpHeaders.cacheControlHeader], 'no-store');
  });

  test('protects detailed health diagnostics', () async {
    final Response response = await handler(
      Request('GET', Uri.parse('http://localhost/v1/health')),
    );

    expect(response.statusCode, 401);
  });

  test('protects business endpoints with bearer auth', () async {
    final Response response = await handler(
      Request('GET', Uri.parse('http://localhost/v1/sessions')),
    );

    expect(response.statusCode, 401);
  });

  test('exposes the authenticated workspace principal', () async {
    final Response response = await handler(
      Request(
        'GET',
        Uri.parse('http://localhost/v1/me'),
        headers: const <String, String>{'authorization': 'Bearer $token'},
      ),
    );
    final Map<String, Object?> body =
        jsonDecode(await response.readAsString()) as Map<String, Object?>;

    expect(response.statusCode, 200);
    expect(body['user_id'], 'pinkall-poc-service');
    expect(body['workspace_id'], 'poc-local');
    expect(body['membership_role'], 'owner');
    expect(body['auth_mode'], 'poc_bearer');
    expect(body['storage_scope'], 'single_snapshot_workspace');
  });

  test('lists and creates custom objection responses', () async {
    const Map<String, String> headers = <String, String>{
      'authorization': 'Bearer $token',
      'content-type': 'application/json',
    };
    final Response empty = await handler(
      Request(
        'GET',
        Uri.parse('http://localhost/v1/coaching/objections'),
        headers: headers,
      ),
    );
    expect(empty.statusCode, 200);
    expect(
      (jsonDecode(await empty.readAsString()) as Map<String, Object?>)['items'],
      isEmpty,
    );

    final Response created = await handler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/coaching/objections'),
        headers: headers,
        body: jsonEncode(<String, Object?>{
          'category': 'price',
          'text': 'Votre solution est trop chère.',
          'response_content': 'Revenir au coût du problème avant le prix.',
          'response_source_type': 'file',
          'response_source_name': 'prix.md',
        }),
      ),
    );
    final Map<String, Object?> body =
        jsonDecode(await created.readAsString()) as Map<String, Object?>;
    expect(created.statusCode, 201);
    expect(body['review_status'], 'live');
    expect(body['origin'], 'custom');
    expect(
      (body['response']! as Map<String, Object?>)['source_name'],
      'prix.md',
    );

    final Response listed = await handler(
      Request(
        'GET',
        Uri.parse('http://localhost/v1/coaching/objections'),
        headers: headers,
      ),
    );
    final Map<String, Object?> listBody =
        jsonDecode(await listed.readAsString()) as Map<String, Object?>;
    expect(listBody['items'], hasLength(1));
  });

  test(
    'returns bounded workspace coaching progress without a global score',
    () async {
      final CallSessionSnapshot session = backend.store.createSession(
        callId: 'call-progress',
        destinationNumber: '+33102030408',
        contactId: null,
        coachMode: CoachMode.off,
        sellerTrack: MediaTrack.outbound,
      );
      backend.store.replaceFinalTranscript(session.id, <TranscriptSegment>[
        TranscriptSegment(
          id: 'progress-segment',
          track: MediaTrack.outbound,
          speaker: SpeakerRole.seller,
          text: 'Quelle est votre priorité ?',
          startSeconds: 0,
          endSeconds: 2,
          isFinal: true,
          provider: 'test',
          createdAt: DateTime.utc(2026, 7, 14),
        ),
      ]);
      backend.store.savePostCallDebrief(
        session.id,
        PostCallDebrief(
          sessionId: session.id,
          summary: const PostCallGroundedText(
            text: 'Résumé progression',
            evidenceSegmentIds: <String>[],
          ),
          keyPoints: const <PostCallGroundedText>[],
          commitments: const <PostCallCommitment>[],
          followUp: const PostCallFollowUp(
            subject: 'Suite',
            body: 'Merci',
            nextAction: null,
            dueAt: null,
            evidenceSegmentIds: <String>[],
          ),
          improvement: null,
          generatedAt: DateTime.utc(2026, 7, 14),
          provider: 'test',
          model: 'test',
          performanceAxes: PostCallPerformanceAxisName.values
              .map(
                (PostCallPerformanceAxisName axis) => PostCallPerformanceAxis(
                  axis: axis,
                  score: 65,
                  signal: PostCallPerformanceSignal.balanced,
                  observation: 'Observation ${axis.name}',
                  evidenceSegmentIds: const <String>[],
                ),
              )
              .toList(growable: false),
        ),
      );

      final Response response = await handler(
        Request(
          'GET',
          Uri.parse('http://localhost/v1/coaching/progress?window=5&limit=20'),
          headers: const <String, String>{'authorization': 'Bearer $token'},
        ),
      );
      final String raw = await response.readAsString();
      final Map<String, Object?> body = jsonDecode(raw) as Map<String, Object?>;

      expect(response.statusCode, 200);
      expect(body['analyzed_call_count'], 1);
      expect(body['axes'], hasLength(8));
      final List<Object?> recentCalls = body['recent_calls']! as List<Object?>;
      expect(recentCalls, hasLength(1));
      expect(
        (recentCalls.single! as Map<String, Object?>)['call_id'],
        'call-progress',
      );
      expect(body['rubric_version'], 'performance-v1');
      expect(body['scope'], 'single_snapshot_workspace');
      expect(body['workspace_id'], 'poc-local');
      expect(body['auth_mode'], 'poc_bearer');
      expect(raw, isNot(contains('overall_score')));

      final Response invalid = await handler(
        Request(
          'GET',
          Uri.parse('http://localhost/v1/coaching/progress?window=0'),
          headers: const <String, String>{'authorization': 'Bearer $token'},
        ),
      );
      expect(invalid.statusCode, 400);
    },
  );

  test('keeps a successful WebSocket upgrade hijacked', () async {
    final HttpServer server = await shelf_io.serve(
      handler,
      InternetAddress.loopbackIPv4,
      0,
    );
    addTearDown(() => server.close(force: true));

    final WebSocket socket = await WebSocket.connect(
      'ws://127.0.0.1:${server.port}/v1/events',
      headers: const <String, String>{'authorization': 'Bearer $token'},
    );
    addTearDown(socket.close);

    final Object? firstMessage = await socket.first.timeout(
      const Duration(seconds: 2),
    );
    final Map<String, Object?> event =
        jsonDecode(firstMessage! as String) as Map<String, Object?>;

    expect(event['type'], 'workspace.snapshot');
    await socket.close(WebSocketStatus.normalClosure);
  });

  test('creates and updates the durable workspace sales context', () async {
    Request authenticated(
      String method,
      String path, {
      Map<String, Object?>? body,
    }) {
      return Request(
        method,
        Uri.parse('http://localhost$path'),
        headers: const <String, String>{
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: body == null ? null : jsonEncode(body),
      );
    }

    final Response empty = await handler(
      authenticated('GET', '/v1/workspace/sales-context'),
    );
    expect(empty.statusCode, 200);
    expect(jsonDecode(await empty.readAsString()), <String, Object?>{
      'data': null,
    });

    final Response created = await handler(
      authenticated(
        'PUT',
        '/v1/workspace/sales-context',
        body: const <String, Object?>{
          'company_name': 'Pinkall',
          'product_name': 'Coach IA',
          'pitch_markdown': '# Promesse\r\nConseiller chaque appel.',
          'expected_revision': null,
        },
      ),
    );
    final Map<String, Object?> createdBody =
        jsonDecode(await created.readAsString()) as Map<String, Object?>;
    final Map<String, Object?> createdContext =
        createdBody['data']! as Map<String, Object?>;
    expect(created.statusCode, 200);
    expect(createdContext['revision'], 1);
    expect(
      createdContext['pitch_markdown'],
      '# Promesse\nConseiller chaque appel.',
    );

    final Response stale = await handler(
      authenticated(
        'PUT',
        '/v1/workspace/sales-context',
        body: const <String, Object?>{
          'company_name': 'Ne doit pas gagner',
          'product_name': 'Coach IA',
          'pitch_markdown': 'Contenu concurrent secret.',
          'expected_revision': null,
        },
      ),
    );
    final String staleBody = await stale.readAsString();
    expect(stale.statusCode, 409);
    expect(staleBody, contains('revision_conflict'));
    expect(staleBody, isNot(contains('Contenu concurrent secret')));

    final Response updated = await handler(
      authenticated(
        'PUT',
        '/v1/workspace/sales-context',
        body: const <String, Object?>{
          'company_name': 'Pinkall',
          'product_name': 'Coach IA temps réel',
          'pitch_markdown': '# Promesse V2\nLe bon conseil au bon moment.',
          'expected_revision': 1,
        },
      ),
    );
    final Map<String, Object?> updatedBody =
        jsonDecode(await updated.readAsString()) as Map<String, Object?>;
    expect(updated.statusCode, 200);
    expect((updatedBody['data']! as Map<String, Object?>)['revision'], 2);

    final Response sessionResponse = await handler(
      authenticated(
        'POST',
        '/v1/sessions',
        body: const <String, Object?>{
          'call_id': 'call-context',
          'destination_number': '+33102030405',
          'coach_mode_override': 'off',
          'workspace_sales_context': <String, Object?>{
            'pitch_markdown': 'Contexte client falsifié',
          },
        },
      ),
    );
    final String sessionRawBody = await sessionResponse.readAsString();
    final Map<String, Object?> sessionBody =
        jsonDecode(sessionRawBody) as Map<String, Object?>;
    expect(sessionResponse.statusCode, 201);
    expect(sessionBody['workspace_sales_context_revision'], 2);
    expect(sessionRawBody, isNot(contains('Le bon conseil au bon moment')));
    expect(sessionRawBody, isNot(contains('Contexte client falsifié')));
    expect(
      backend.store
          .session(sessionBody['id']! as String)
          ?.workspaceSalesContext
          ?.pitchMarkdown,
      '# Promesse V2\nLe bon conseil au bon moment.',
    );
  });

  test('validates workspace sales context before mutating it', () async {
    Future<Response> put(Map<String, Object?> body) async {
      return await handler(
        Request(
          'PUT',
          Uri.parse('http://localhost/v1/workspace/sales-context'),
          headers: const <String, String>{
            'authorization': 'Bearer $token',
            'content-type': 'application/json',
          },
          body: jsonEncode(body),
        ),
      );
    }

    final Response invalidRevision = await put(const <String, Object?>{
      'company_name': 'Pinkall',
      'product_name': 'Coach IA',
      'pitch_markdown': 'Promesse',
      'expected_revision': '1',
    });
    expect(invalidRevision.statusCode, 400);

    final Response oversized = await put(<String, Object?>{
      'company_name': 'Pinkall',
      'product_name': 'Coach IA',
      'pitch_markdown': List<String>.filled(16 * 1024 + 1, 'a').join(),
      'expected_revision': null,
    });
    expect(oversized.statusCode, 400);
    expect(backend.sessions.workspaceSalesContext, isNull);
  });

  test('creates a real empty session with transcription disabled', () async {
    final Response response = await handler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/sessions'),
        headers: const <String, String>{
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: jsonEncode(<String, Object?>{
          'call_id': 'call-1',
          'destination_number': '+33102030405',
          'coach_mode_override': 'off',
          'seller_track': 'outbound',
          'preparation_markdown':
              '  # Objectif\r\nQualifier le budget et le calendrier.  ',
        }),
      ),
    );
    final Map<String, Object?> body =
        jsonDecode(await response.readAsString()) as Map<String, Object?>;

    expect(response.statusCode, 201);
    expect(body['transcription_consent_acknowledged'], isFalse);
    expect(body['status'], 'created');
    expect(body['call_id'], 'call-1');
    expect(
      body['preparation_markdown'],
      '# Objectif\nQualifier le budget et le calendrier.',
    );
    expect(body['media_stream_url'], contains('/v1/telnyx/media/'));

    final Response activeResponse = await handler(
      Request(
        'GET',
        Uri.parse('http://localhost/v1/sessions/active'),
        headers: const <String, String>{'authorization': 'Bearer $token'},
      ),
    );
    final Map<String, Object?> activeBody =
        jsonDecode(await activeResponse.readAsString()) as Map<String, Object?>;
    expect(activeResponse.statusCode, 200);
    expect(activeBody['items'], hasLength(1));
  });

  test('rejects invalid or oversized preparation Markdown', () async {
    Future<Response> createWith(Object? preparation) async {
      return await handler(
        Request(
          'POST',
          Uri.parse('http://localhost/v1/sessions'),
          headers: const <String, String>{
            'authorization': 'Bearer $token',
            'content-type': 'application/json',
          },
          body: jsonEncode(<String, Object?>{
            'call_id': 'call-invalid-preparation',
            'destination_number': '+33102030405',
            'coach_mode_override': 'off',
            'preparation_markdown': preparation,
          }),
        ),
      );
    }

    final Response wrongType = await createWith(<String, Object?>{
      'content': '# Objectif',
    });
    expect(wrongType.statusCode, 400);

    final Response oversized = await createWith(
      List<String>.filled(32 * 1024 + 1, 'a').join(),
    );
    expect(oversized.statusCode, 400);

    final Response controlCharacter = await createWith(
      '# Objectif\nprospect\u0000secret',
    );
    expect(controlCharacter.statusCode, 400);

    final Response invalidUtf8 = await handler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/sessions'),
        headers: const <String, String>{
          'authorization': 'Bearer $token',
          'content-type': 'application/json',
        },
        body: <int>[
          ...utf8.encode(
            '{"call_id":"invalid-utf8","destination_number":'
            '"+33102030405","preparation_markdown":"',
          ),
          0xC3,
          0x28,
          ...utf8.encode('"}'),
        ],
      ),
    );
    expect(invalidUtf8.statusCode, 400);
    expect(backend.store.listSessions(), isEmpty);
  });

  test('returns the persisted grounded post-call debrief', () async {
    final CallSessionSnapshot session = backend.store.createSession(
      callId: 'call-debrief',
      destinationNumber: '+33102030407',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    backend.store.replaceFinalTranscript(session.id, <TranscriptSegment>[
      TranscriptSegment(
        id: 'segment-1',
        track: MediaTrack.inbound,
        speaker: SpeakerRole.prospect,
        text: 'Rappelez-moi mardi.',
        startSeconds: 0,
        endSeconds: 1,
        isFinal: true,
        provider: 'test',
        createdAt: DateTime.utc(2026, 7, 11),
      ),
    ]);
    backend.store.savePostCallDebrief(
      session.id,
      PostCallDebrief(
        sessionId: session.id,
        summary: const PostCallGroundedText(
          text: 'Le prospect souhaite être rappelé mardi.',
          evidenceSegmentIds: <String>['segment-1'],
        ),
        keyPoints: const <PostCallGroundedText>[],
        commitments: const <PostCallCommitment>[],
        followUp: const PostCallFollowUp(
          subject: 'Notre échange',
          body: 'Je vous rappelle mardi.',
          nextAction: 'Rappeler mardi',
          dueAt: null,
          evidenceSegmentIds: <String>['segment-1'],
        ),
        improvement: null,
        generatedAt: DateTime.utc(2026, 7, 11, 10),
        provider: 'test',
        model: 'test-model',
      ),
    );

    final Response response = await handler(
      Request(
        'GET',
        Uri.parse('http://localhost/v1/sessions/${session.id}/debrief'),
        headers: const <String, String>{'authorization': 'Bearer $token'},
      ),
    );
    final Map<String, Object?> body =
        jsonDecode(await response.readAsString()) as Map<String, Object?>;

    expect(response.statusCode, 200);
    expect(body['session_id'], session.id);
    expect(body['provider'], 'test');
    expect(
      (body['summary']! as Map<String, Object?>)['evidence_segment_ids'],
      <String>['segment-1'],
    );
  });

  test('keeps finalize successful when the post-call provider fails', () async {
    final HttpServer server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      0,
    );
    addTearDown(() => server.close(force: true));
    int providerRequestCount = 0;
    server.listen((HttpRequest request) async {
      providerRequestCount += 1;
      await request.drain<void>();
      request.response
        ..statusCode = HttpStatus.serviceUnavailable
        ..write('provider secret detail');
      await request.response.close();
    });
    final PinkallBackend failureBackend = PinkallBackend.create(
      AppConfig.fromEnvironment(<String, String>{
        'PINKALL_API_TOKEN': token,
        'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
        'MISTRAL_API_KEY': 'test-only-not-used',
        'OPENAI_API_KEY': 'test-openai-key',
        'OPENAI_POST_CALL_MODEL': 'test-model',
        'OPENAI_BASE_URL': 'http://127.0.0.1:${server.port}',
      }),
    );
    addTearDown(failureBackend.dispose);
    final Handler failureHandler = ApiRouter(backend: failureBackend).handler;
    final CallSessionSnapshot session = failureBackend.store.createSession(
      callId: 'call-provider-failure',
      destinationNumber: '+33102030408',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    failureBackend.store.acknowledgeTranscriptionConsent(
      sessionId: session.id,
      method: 'test_notice',
      acknowledgedAt: DateTime.utc(2026, 7, 11),
    );
    failureBackend.store.replaceFinalTranscript(session.id, <TranscriptSegment>[
      TranscriptSegment(
        id: 'segment-1',
        track: MediaTrack.inbound,
        speaker: SpeakerRole.prospect,
        text: 'Rappelez-moi mardi.',
        startSeconds: 0,
        endSeconds: 1,
        isFinal: true,
        provider: 'test',
        createdAt: DateTime.utc(2026, 7, 11),
      ),
    ]);

    final Response response = await failureHandler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/sessions/${session.id}/finalize'),
        headers: const <String, String>{'authorization': 'Bearer $token'},
      ),
    );
    final Map<String, Object?> body =
        jsonDecode(await response.readAsString()) as Map<String, Object?>;
    final Map<String, Object?> error =
        body['debrief_error']! as Map<String, Object?>;

    expect(response.statusCode, 200);
    expect(body['status'], 'completed');
    expect(body['debrief_status'], 'failed');
    expect(error['code'], 'provider_temporarily_unavailable');
    expect(error['retryable'], isTrue);
    final Map<String, Object?> generation =
        body['debrief_generation']! as Map<String, Object?>;
    expect(generation['status'], 'failed');
    expect(generation['attempt_count'], 1);
    expect(generation['failure_code'], 'provider_temporarily_unavailable');
    expect(generation['retryable'], isTrue);
    expect(providerRequestCount, 3, reason: 'provider retries stay bounded');
    expect(jsonEncode(body), isNot(contains('provider secret detail')));
    expect(failureBackend.store.finalTranscript(session.id), isNotEmpty);
  });
}
