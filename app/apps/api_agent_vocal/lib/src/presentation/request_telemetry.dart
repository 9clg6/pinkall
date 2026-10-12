import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:shelf/shelf.dart';

/// Request context key carrying Pinkall's opaque correlation identifier.
const String requestIdContextKey = 'pinkall.request_id';

/// Emits content-free structured request telemetry and propagates a request ID.
final class RequestTelemetry {
  RequestTelemetry({void Function(String line)? log})
    : _log = log ?? stdout.writeln;

  static const String requestIdHeader = 'x-request-id';

  final void Function(String line) _log;
  final Random _random = Random.secure();

  Middleware middleware() {
    return (Handler inner) {
      return (Request request) async {
        final String requestId = _requestId(request);
        final Stopwatch stopwatch = Stopwatch()..start();
        try {
          final Response response = await inner(
            request.change(
              context: <String, Object?>{requestIdContextKey: requestId},
            ),
          );
          stopwatch.stop();
          _write(
            request: request,
            requestId: requestId,
            statusCode: response.statusCode,
            elapsed: stopwatch.elapsed,
          );
          return response.change(
            headers: <String, String>{requestIdHeader: requestId},
          );
        } on HijackException {
          stopwatch.stop();
          _write(
            request: request,
            requestId: requestId,
            statusCode: 101,
            elapsed: stopwatch.elapsed,
          );
          rethrow;
        } on Object {
          stopwatch.stop();
          _write(
            request: request,
            requestId: requestId,
            statusCode: 500,
            elapsed: stopwatch.elapsed,
          );
          rethrow;
        }
      };
    };
  }

  void _write({
    required Request request,
    required String requestId,
    required int statusCode,
    required Duration elapsed,
  }) {
    _log(
      jsonEncode(<String, Object?>{
        'event': 'http_request',
        'request_id': requestId,
        'method': request.method,
        // Never serialize a query string, request body or authorization value.
        'path': _sanitizedPath(request.requestedUri.path),
        'status': statusCode,
        'duration_ms': elapsed.inMicroseconds / 1000,
      }),
    );
  }

  String _requestId(Request request) {
    final String candidate = request.headers[requestIdHeader]?.trim() ?? '';
    if (RegExp(r'^[A-Za-z0-9_-]{8,80}$').hasMatch(candidate)) {
      return candidate;
    }
    final List<int> bytes = List<int>.generate(
      18,
      (_) => _random.nextInt(256),
      growable: false,
    );
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  static String _sanitizedPath(String path) {
    final List<String> segments = Uri(path: path).pathSegments;
    final List<String> sanitized = <String>[];
    for (final String segment in segments) {
      final bool looksOpaque =
          RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F-]{20,}$').hasMatch(segment) ||
          RegExp(
            r'^(?:ses|rec|con|call|imp|media)_[A-Za-z0-9_-]{12,}$',
          ).hasMatch(segment) ||
          (segment.length >= 24 &&
              RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(segment) &&
              RegExp(r'[0-9_A-Z]').hasMatch(segment));
      sanitized.add(looksOpaque ? ':id' : segment);
    }
    return '/${sanitized.join('/')}';
  }
}
