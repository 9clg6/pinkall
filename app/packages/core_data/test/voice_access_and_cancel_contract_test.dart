import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core_data/core_data.dart';
import 'package:core_data/model/remote/voice_access_token.remote.model.dart';
import 'package:core_domain/core_domain.dart';
import 'package:test/test.dart';

void main() {
  group('Pinkall SaaS voice access contract', () {
    test(
      'requests and maps a short-lived Telnyx token over real HTTP',
      () async {
        final HttpServer server = await HttpServer.bind(
          InternetAddress.loopbackIPv4,
          0,
        );
        addTearDown(() => server.close(force: true));
        final Completer<_CapturedRequest> captured =
            Completer<_CapturedRequest>();
        server.listen((HttpRequest request) async {
          final String body = await utf8.decoder.bind(request).join();
          captured.complete(
            _CapturedRequest(
              method: request.method,
              path: request.uri.path,
              authorization: request.headers.value(
                HttpHeaders.authorizationHeader,
              ),
              body: body,
            ),
          );
          request.response.headers.contentType = ContentType.json;
          request.response.write(
            jsonEncode(<String, dynamic>{
              'token': 'telnyx-sensitive-token',
              'expires_at': '2026-07-11T11:00:00.000Z',
              'caller_name': 'Pinkall',
              'caller_number': '+33102030405',
            }),
          );
          await request.response.close();
        });
        final DioPinkallHttpClientImpl httpClient = DioPinkallHttpClientImpl(
          baseUri: Uri.parse('http://${server.address.address}:${server.port}'),
          accessTokenProvider: () async => 'pinkall-user-jwt',
        );
        final VoiceAccessRepository repository = VoiceAccessRepositoryImpl(
          remoteDataSource: VoiceAccessRemoteDataSourceImpl(
            httpClient: httpClient,
          ),
        );

        final VoiceAccessTokenEntity credential = await repository.requestToken(
          const RequestVoiceAccessTokenParam(deviceId: 'device-macos-1'),
        );
        final _CapturedRequest request = await captured.future;

        expect(request.method, 'POST');
        expect(request.path, '/v1/voice/token');
        expect(request.authorization, 'Bearer pinkall-user-jwt');
        expect(jsonDecode(request.body), <String, dynamic>{
          'device_id': 'device-macos-1',
        });
        expect(credential.token, 'telnyx-sensitive-token');
        expect(credential.expiresAt, DateTime.utc(2026, 7, 11, 11));
        expect(credential.callerName, 'Pinkall');
        expect(credential.callerNumber, '+33102030405');
        expect(credential.toString(), isNot(contains(credential.token)));
      },
    );

    test('remote model never renders or serializes the token', () {
      final VoiceAccessTokenRemoteModel model =
          VoiceAccessTokenRemoteModel.fromJson(<String, dynamic>{
            'token': 'do-not-render',
            'expires_at': '2026-07-11T11:00:00.000Z',
            'caller_name': 'Pinkall',
            'caller_number': '+33102030405',
          });

      expect(model.toString(), contains('<redacted>'));
      expect(model.toString(), isNot(contains(model.token)));
    });
  });

  group('Conversation session cancel contract', () {
    test('posts without a body and maps the returned session', () async {
      final HttpServer server = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      addTearDown(() => server.close(force: true));
      final Completer<_CapturedRequest> captured =
          Completer<_CapturedRequest>();
      server.listen((HttpRequest request) async {
        final String body = await utf8.decoder.bind(request).join();
        captured.complete(
          _CapturedRequest(
            method: request.method,
            path: request.uri.path,
            authorization: request.headers.value(
              HttpHeaders.authorizationHeader,
            ),
            body: body,
          ),
        );
        request.response.headers.contentType = ContentType.json;
        request.response.write(
          jsonEncode(<String, dynamic>{
            'id': 'session-1',
            'call_id': 'call-1',
            'status': 'failed',
            'coach_mode': 'off',
            'created_at': '2026-07-11T10:00:00.000Z',
            'ended_at': '2026-07-11T10:01:00.000Z',
            'failure_reason': 'cancelled',
          }),
        );
        await request.response.close();
      });
      final DioPinkallHttpClientImpl httpClient = DioPinkallHttpClientImpl(
        baseUri: Uri.parse('http://${server.address.address}:${server.port}'),
        accessTokenProvider: () async => 'pinkall-user-jwt',
      );
      final ConversationSessionRepository repository =
          ConversationSessionRepositoryImpl(
            remoteDataSource: ConversationSessionRemoteDataSourceImpl(
              httpClient: httpClient,
              realtimeClient: const _NeverRealtimeClient(),
            ),
          );

      final ConversationSessionEntity session = await repository.cancelSession(
        'session-1',
      );
      final _CapturedRequest request = await captured.future;

      expect(request.method, 'POST');
      expect(request.path, '/v1/sessions/session-1/cancel');
      expect(request.authorization, 'Bearer pinkall-user-jwt');
      expect(request.body, isEmpty);
      expect(session.id, 'session-1');
      expect(session.status, ConversationSessionStatus.failed);
      expect(session.failureReason, 'cancelled');
    });
  });
}

final class _NeverRealtimeClient implements PinkallRealtimeClient {
  const _NeverRealtimeClient();

  @override
  Stream<Map<String, dynamic>> watchJson(String path) =>
      const Stream<Map<String, dynamic>>.empty();
}

final class _CapturedRequest {
  const _CapturedRequest({
    required this.method,
    required this.path,
    required this.authorization,
    required this.body,
  });

  final String method;
  final String path;
  final String? authorization;
  final String body;
}
