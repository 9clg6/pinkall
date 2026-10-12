import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/api_agent_vocal.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  test(
    'issues the exact Voice token contract through the Telnyx API',
    () async {
      final HttpServer telnyx = await HttpServer.bind(
        InternetAddress.loopbackIPv4,
        0,
      );
      final DateTime expiry = DateTime.fromMillisecondsSinceEpoch(
        (DateTime.now()
                    .toUtc()
                    .add(const Duration(hours: 1))
                    .millisecondsSinceEpoch ~/
                1000) *
            1000,
        isUtc: true,
      );
      final String jwt = _jwt(expiry);
      late String requestMethod;
      late String requestPath;
      late String? authorization;
      telnyx.listen((HttpRequest request) async {
        requestMethod = request.method;
        requestPath = request.uri.path;
        authorization = request.headers.value(HttpHeaders.authorizationHeader);
        request.response
          ..statusCode = HttpStatus.created
          ..headers.contentType = ContentType.text
          ..write(jwt);
        await request.response.close();
      });
      addTearDown(() => telnyx.close(force: true));

      const String apiToken = 'test-token-with-more-than-24-characters';
      final PinkallBackend backend = PinkallBackend.create(
        AppConfig.fromEnvironment(<String, String>{
          'PINKALL_API_TOKEN': apiToken,
          'PINKALL_ALLOW_EPHEMERAL_STORE': 'true',
          'MISTRAL_API_KEY': 'test-only-not-called',
          'TELNYX_API_KEY': 'telnyx-secret',
          'TELNYX_API_BASE_URL': 'http://127.0.0.1:${telnyx.port}/v2',
          'TELNYX_TELEPHONY_CREDENTIAL_ID': 'credential-123',
          'TELNYX_CALLER_NAME': 'Pinkall',
          'TELNYX_CALLER_NUMBER': '+33102030405',
        }),
      );
      addTearDown(backend.dispose);
      final Handler handler = ApiRouter(backend: backend).handler;

      final Response response = await handler(
        Request(
          'POST',
          Uri.parse('http://localhost/v1/voice/token'),
          headers: const <String, String>{
            'authorization': 'Bearer $apiToken',
            'content-type': 'application/json',
          },
          body: jsonEncode(<String, Object?>{'device_id': 'ios-device-1'}),
        ),
      );
      final Map<String, Object?> body =
          jsonDecode(await response.readAsString()) as Map<String, Object?>;

      expect(response.statusCode, 201);
      expect(body.keys, <String>{
        'token',
        'expires_at',
        'caller_name',
        'caller_number',
      });
      expect(body['token'], jwt);
      expect(DateTime.parse(body['expires_at']! as String), expiry);
      expect(body['caller_name'], 'Pinkall');
      expect(body['caller_number'], '+33102030405');
      expect(requestMethod, 'POST');
      expect(requestPath, '/v2/telephony_credentials/credential-123/token');
      expect(authorization, 'Bearer telnyx-secret');
    },
  );
}

String _jwt(DateTime expiry) {
  String part(Map<String, Object?> value) {
    return base64UrlEncode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  }

  return '${part(<String, Object?>{'alg': 'HS512', 'typ': 'JWT'})}.'
      '${part(<String, Object?>{'exp': expiry.millisecondsSinceEpoch ~/ 1000})}.'
      'test-signature';
}
