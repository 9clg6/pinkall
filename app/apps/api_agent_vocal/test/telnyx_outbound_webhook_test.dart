import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/api_agent_vocal.dart';
import 'package:cryptography/cryptography.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  test(
    'verifies, deduplicates and turns a parked WebRTC event into one Dial',
    () async {
      final Ed25519 algorithm = Ed25519();
      final KeyPair keyPair = await algorithm.newKeyPair();
      final SimplePublicKey publicKey =
          (await keyPair.extractPublicKey()) as SimplePublicKey;
      final HttpServer telnyx = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      final List<Map<String, Object?>> dialBodies = <Map<String, Object?>>[];
      final Completer<void> dialReceived = Completer<void>();
      final Completer<void> allowDialResponse = Completer<void>();
      telnyx.listen((HttpRequest request) async {
        expect(request.method, 'POST');
        expect(request.uri.path, '/v2/calls');
        expect(
          request.headers.value(HttpHeaders.authorizationHeader),
          'Bearer telnyx-secret',
        );
        final Map<String, Object?> dialBody =
            jsonDecode(await utf8.decoder.bind(request).join())
                as Map<String, Object?>;
        dialBodies.add(dialBody);
        request.response.headers.contentType = ContentType.json;
        if (dialBodies.length == 1) {
          if (!dialReceived.isCompleted) {
            dialReceived.complete();
          }
          await allowDialResponse.future;
          request.response
            ..statusCode = HttpStatus.ok
            ..write(
              jsonEncode(<String, Object?>{
                'data': <String, Object?>{
                  'call_control_id': 'pstn-control-1',
                  'call_session_id': 'shared-call-session-1',
                },
              }),
            );
        } else {
          request.response
            ..statusCode = HttpStatus.unprocessableEntity
            ..write(
              jsonEncode(<String, Object?>{
                'errors': <Map<String, Object?>>[
                  <String, Object?>{
                    'detail': 'Rejected ${dialBody['stream_url']}',
                  },
                ],
              }),
            );
        }
        await request.response.close();
      });
      addTearDown(() => telnyx.close(force: true));

      const String apiToken = 'test-token-with-more-than-24-characters';
      final PinkallBackend backend = PinkallBackend.create(
        AppConfig.fromEnvironment(<String, String>{
          'PINKALL_API_TOKEN': apiToken,
          'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
          'PUBLIC_BASE_URL': 'https://pinkall.example',
          'MISTRAL_API_KEY': 'test-only-not-called',
          'TELNYX_API_KEY': 'telnyx-secret',
          'TELNYX_API_BASE_URL': 'http://127.0.0.1:${telnyx.port}/v2',
          'TELNYX_TELEPHONY_CREDENTIAL_ID': 'credential-123',
          'TELNYX_PUBLIC_KEY': base64Encode(publicKey.bytes),
          'TELNYX_WEBRTC_CONNECTION_ID': 'webrtc-connection-1',
          'TELNYX_CALL_CONTROL_CONNECTION_ID': 'connection-456',
          'TELNYX_FROM_NUMBER': '+33102030405',
          'TELNYX_CALLER_NAME': 'Pinkall',
        }),
      );
      addTearDown(backend.dispose);
      final Handler handler = ApiRouter(backend: backend).handler;
      final Map<String, Object?> session = await _createSession(
        handler,
        token: apiToken,
        callId: 'correlation-1',
        destination: '+33102030406',
      );
      final String sessionId = session['id']! as String;
      final int now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final String eventId = '891510ac-f3e4-11e8-af5b-de00688a4901';
      final String raw = _event(
        eventId: eventId,
        sessionId: sessionId,
        correlationId: 'correlation-1',
        destination: '+33102030406',
      );
      final String signature = await _sign(
        algorithm,
        keyPair,
        timestamp: now,
        rawBody: raw,
      );

      final Future<Response> firstFuture = _postWebhook(
        handler,
        rawBody: raw,
        timestamp: now,
        signature: signature,
      );
      await dialReceived.future.timeout(const Duration(seconds: 1));
      expect(
        backend.store.session(sessionId)!.telnyxOutboundDialReserved,
        isTrue,
      );

      final String bLegRaw = _event(
        eventId: '891510ac-f3e4-11e8-af5b-de00688a4999',
        sessionId: sessionId,
        correlationId: 'correlation-1',
        destination: '+33102030406',
        connectionId: 'connection-456',
        pinkallLeg: 'pstn',
      );
      final Response bLeg = await _postWebhook(
        handler,
        rawBody: bLegRaw,
        timestamp: now,
        signature: await _sign(
          algorithm,
          keyPair,
          timestamp: now,
          rawBody: bLegRaw,
        ),
      );
      final Map<String, Object?> bLegBody =
          jsonDecode(await bLeg.readAsString()) as Map<String, Object?>;
      expect(bLeg.statusCode, 200);
      expect(bLegBody['action'], 'non_webrtc_connection_ignored');
      expect(dialBodies, hasLength(1));

      final String racingALegRaw = _event(
        eventId: '891510ac-f3e4-11e8-af5b-de00688a4998',
        sessionId: sessionId,
        correlationId: 'correlation-1',
        destination: '+33102030406',
      );
      final Response racingALeg = await _postWebhook(
        handler,
        rawBody: racingALegRaw,
        timestamp: now,
        signature: await _sign(
          algorithm,
          keyPair,
          timestamp: now,
          rawBody: racingALegRaw,
        ),
      );
      expect(racingALeg.statusCode, 409);
      expect(dialBodies, hasLength(1));

      allowDialResponse.complete();
      final Response first = await firstFuture;
      final Map<String, Object?> firstBody =
          jsonDecode(await first.readAsString()) as Map<String, Object?>;
      expect(first.statusCode, 200);
      expect(firstBody['action'], 'pstn_dial_started');
      expect(firstBody['duplicate'], isFalse);
      expect(dialBodies, hasLength(1));

      final Map<String, Object?> dial = dialBodies.single;
      expect(dial['connection_id'], 'connection-456');
      expect(dial['to'], '+33102030406');
      expect(dial['from'], '+33102030405');
      expect(dial['from_display_name'], 'Pinkall');
      expect(dial['command_id'], eventId);
      expect(dial['link_to'], 'agent-control-1');
      expect(dial['bridge_intent'], isTrue);
      expect(dial['bridge_on_answer'], isTrue);
      expect(dial['stream_track'], 'both_tracks');
      expect(dial['stream_establish_before_call_originate'], isTrue);
      expect(dial['webhook_url'], 'https://pinkall.example/v1/telnyx/webhooks');
      final Uri streamUri = Uri.parse(dial['stream_url']! as String);
      expect(streamUri.scheme, 'wss');
      expect(streamUri.path, '/v1/telnyx/media/$sessionId');
      expect(streamUri.queryParameters['token'], isNotEmpty);
      final Map<String, Object?> pstnState =
          jsonDecode(utf8.decode(base64Decode(dial['client_state']! as String)))
              as Map<String, Object?>;
      expect(pstnState, <String, Object?>{
        'pinkall_session_id': sessionId,
        'correlation_id': 'correlation-1',
        'pinkall_leg': 'pstn',
      });
      final CallSessionSnapshot correlated = backend.store.session(sessionId)!;
      expect(correlated.telnyxAgentCallControlId, 'agent-control-1');
      expect(correlated.telnyxAgentCallSessionId, 'agent-session-1');
      expect(correlated.telnyxPstnCallControlId, 'pstn-control-1');
      expect(correlated.telnyxPstnCallSessionId, 'shared-call-session-1');

      final Response duplicate = await _postWebhook(
        handler,
        rawBody: raw,
        timestamp: now,
        signature: signature,
      );
      final Map<String, Object?> duplicateBody =
          jsonDecode(await duplicate.readAsString()) as Map<String, Object?>;
      expect(duplicate.statusCode, 200);
      expect(duplicateBody['duplicate'], isTrue);
      expect(dialBodies, hasLength(1));

      final Response invalidSignature = await _postWebhook(
        handler,
        rawBody: raw,
        timestamp: now,
        signature: base64Encode(List<int>.filled(64, 0)),
      );
      expect(invalidSignature.statusCode, 403);
      expect(dialBodies, hasLength(1));

      final Response shortSignature = await _postWebhook(
        handler,
        rawBody: raw,
        timestamp: now,
        signature: base64Encode(<int>[0]),
      );
      expect(shortSignature.statusCode, 403);
      expect(dialBodies, hasLength(1));

      final int staleTimestamp = now - const Duration(minutes: 5).inSeconds - 1;
      final Response stale = await _postWebhook(
        handler,
        rawBody: raw,
        timestamp: staleTimestamp,
        signature: await _sign(
          algorithm,
          keyPair,
          timestamp: staleTimestamp,
          rawBody: raw,
        ),
      );
      expect(stale.statusCode, 403);
      expect(dialBodies, hasLength(1));

      final Map<String, Object?> providerErrorSession = await _createSession(
        handler,
        token: apiToken,
        callId: 'correlation-provider-error',
        destination: '+33102030408',
      );
      final String providerErrorId = providerErrorSession['id']! as String;
      final String providerErrorRaw = _event(
        eventId: '891510ac-f3e4-11e8-af5b-de00688a4903',
        sessionId: providerErrorId,
        correlationId: 'correlation-provider-error',
        destination: '+33102030408',
      );
      final Response providerError = await _postWebhook(
        handler,
        rawBody: providerErrorRaw,
        timestamp: now,
        signature: await _sign(
          algorithm,
          keyPair,
          timestamp: now,
          rawBody: providerErrorRaw,
        ),
      );
      final String providerErrorBody = await providerError.readAsString();
      final CallSessionSnapshot rolledBack = backend.store.session(
        providerErrorId,
      )!;
      expect(providerError.statusCode, 502);
      expect(providerErrorBody, isNot(contains(rolledBack.mediaToken)));
      expect(providerErrorBody, isNot(contains('stream_url')));
      expect(rolledBack.telnyxOutboundDialReserved, isFalse);
      expect(dialBodies, hasLength(2));

      final Map<String, Object?> mismatchSession = await _createSession(
        handler,
        token: apiToken,
        callId: 'correlation-2',
        destination: '+33102030407',
      );
      final String mismatchId = mismatchSession['id']! as String;
      final String mismatchRaw = _event(
        eventId: '891510ac-f3e4-11e8-af5b-de00688a4902',
        sessionId: mismatchId,
        correlationId: 'correlation-2',
        destination: '+33102039999',
      );
      final Response mismatch = await _postWebhook(
        handler,
        rawBody: mismatchRaw,
        timestamp: now,
        signature: await _sign(
          algorithm,
          keyPair,
          timestamp: now,
          rawBody: mismatchRaw,
        ),
      );
      expect(mismatch.statusCode, 400);
      expect(dialBodies, hasLength(2));
      expect(
        backend.store.session(mismatchId)!.failure,
        'provider_destination_mismatch',
      );
    },
  );
}

Future<Map<String, Object?>> _createSession(
  Handler handler, {
  required String token,
  required String callId,
  required String destination,
}) async {
  final Response response = await handler(
    Request(
      'POST',
      Uri.parse('http://localhost/v1/sessions'),
      headers: <String, String>{
        'authorization': 'Bearer $token',
        'content-type': 'application/json',
      },
      body: jsonEncode(<String, Object?>{
        'call_id': callId,
        'destination_number': destination,
        'coach_mode_override': 'off',
      }),
    ),
  );
  expect(response.statusCode, 201);
  return jsonDecode(await response.readAsString()) as Map<String, Object?>;
}

Future<Response> _postWebhook(
  Handler handler, {
  required String rawBody,
  required int timestamp,
  required String signature,
}) {
  return Future<Response>.value(
    handler(
      Request(
        'POST',
        Uri.parse('http://localhost/v1/telnyx/webhooks'),
        headers: <String, String>{
          'content-type': 'application/json',
          'telnyx-timestamp': timestamp.toString(),
          'telnyx-signature-ed25519': signature,
        },
        body: rawBody,
      ),
    ),
  );
}

String _event({
  required String eventId,
  required String sessionId,
  required String correlationId,
  required String destination,
  String connectionId = 'webrtc-connection-1',
  String? pinkallLeg,
}) {
  final String clientState = base64Encode(
    utf8.encode(
      jsonEncode(<String, Object?>{
        'pinkall_session_id': sessionId,
        'correlation_id': correlationId,
        if (pinkallLeg != null) 'pinkall_leg': pinkallLeg,
      }),
    ),
  );
  return jsonEncode(<String, Object?>{
    'data': <String, Object?>{
      'record_type': 'event',
      'event_type': 'call.initiated',
      'id': eventId,
      'occurred_at': DateTime.now().toUtc().toIso8601String(),
      'payload': <String, Object?>{
        'call_control_id': 'agent-control-1',
        'call_session_id': 'agent-session-1',
        'connection_id': connectionId,
        'client_state': clientState,
        'from': '+33102030405',
        'to': destination,
        'direction': 'outgoing',
        'state': 'parked',
      },
    },
  });
}

Future<String> _sign(
  Ed25519 algorithm,
  KeyPair keyPair, {
  required int timestamp,
  required String rawBody,
}) async {
  final Signature signature = await algorithm.sign(
    utf8.encode('$timestamp|$rawBody'),
    keyPair: keyPair,
  );
  return base64Encode(signature.bytes);
}
