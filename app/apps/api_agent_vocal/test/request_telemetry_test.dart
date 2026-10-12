import 'dart:convert';

import 'package:api_agent_vocal/src/presentation/request_telemetry.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

void main() {
  test(
    'propagates an accepted request ID and emits content-free JSON',
    () async {
      final List<String> logs = <String>[];
      final Handler handler = RequestTelemetry(log: logs.add).middleware()((
        Request request,
      ) {
        expect(request.context[requestIdContextKey], 'test-request-123');
        return Response.ok('secret response body');
      });

      final Response response = await handler(
        Request(
          'POST',
          Uri.parse(
            'https://api.example/v1/sessions/'
            'ses_abcdefghijklmnopqrstuvwxyz/debrief?token=do-not-log',
          ),
          headers: const <String, String>{
            RequestTelemetry.requestIdHeader: 'test-request-123',
            'authorization': 'Bearer do-not-log',
          },
          body: 'transcript must not be logged',
        ),
      );

      expect(
        response.headers[RequestTelemetry.requestIdHeader],
        'test-request-123',
      );
      expect(logs, hasLength(1));
      final Map<String, Object?> event =
          jsonDecode(logs.single) as Map<String, Object?>;
      expect(event['event'], 'http_request');
      expect(event['path'], '/v1/sessions/:id/debrief');
      expect(event['status'], 200);
      expect(logs.single, isNot(contains('do-not-log')));
      expect(logs.single, isNot(contains('transcript')));
      expect(logs.single, isNot(contains('secret response')));
    },
  );

  test('replaces malformed caller IDs with a generated opaque value', () async {
    String? contextId;
    final Handler handler = RequestTelemetry(log: (_) {}).middleware()((
      Request request,
    ) {
      contextId = request.context[requestIdContextKey]! as String;
      return Response(204);
    });

    final Response response = await handler(
      Request(
        'GET',
        Uri.parse('https://api.example/health'),
        headers: const <String, String>{
          RequestTelemetry.requestIdHeader: 'bad id with spaces',
        },
      ),
    );

    expect(contextId, hasLength(24));
    expect(response.headers[RequestTelemetry.requestIdHeader], contextId);
  });
}
