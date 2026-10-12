import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Bounded HTTP transport for non-streaming OpenAI Responses requests.
final class OpenAiResponsesTransport {
  OpenAiResponsesTransport({
    required String apiKey,
    required http.Client httpClient,
    this.requestDeadline = const Duration(seconds: 30),
    this.maxAttempts = 3,
    this.retryBaseDelay = const Duration(milliseconds: 200),
  }) : _apiKey = apiKey,
       _httpClient = httpClient {
    if (requestDeadline <= Duration.zero) {
      throw ArgumentError.value(
        requestDeadline,
        'requestDeadline',
        'must be positive',
      );
    }
    if (maxAttempts < 1) {
      throw ArgumentError.value(maxAttempts, 'maxAttempts', 'must be positive');
    }
    if (retryBaseDelay < Duration.zero) {
      throw ArgumentError.value(
        retryBaseDelay,
        'retryBaseDelay',
        'must not be negative',
      );
    }
  }

  final String _apiKey;
  final http.Client _httpClient;
  final Duration requestDeadline;
  final int maxAttempts;
  final Duration retryBaseDelay;

  /// Sends one encoded Responses request within the configured total deadline.
  Future<http.Response> post({
    required Uri endpoint,
    required String encodedBody,
  }) async {
    final Stopwatch elapsed = Stopwatch()..start();
    for (int attempt = 1; attempt <= maxAttempts; attempt += 1) {
      final Duration remaining = requestDeadline - elapsed.elapsed;
      if (remaining <= Duration.zero) {
        throw _timeoutException(endpoint);
      }
      try {
        final http.Response response = await _sendOnce(
          endpoint: endpoint,
          encodedBody: encodedBody,
          timeout: remaining,
        );
        if (!_isRetryableStatus(response.statusCode) ||
            attempt == maxAttempts) {
          return response;
        }
      } on http.RequestAbortedException {
        throw _timeoutException(endpoint);
      } on http.ClientException catch (error) {
        if (attempt == maxAttempts) {
          throw HttpException(
            'OpenAI Responses transport failed.',
            uri: error.uri ?? endpoint,
          );
        }
      } on SocketException {
        if (attempt == maxAttempts) {
          throw HttpException(
            'OpenAI Responses transport failed.',
            uri: endpoint,
          );
        }
      }
      final Duration delay = _retryDelay(attempt);
      final Duration afterAttempt = requestDeadline - elapsed.elapsed;
      if (delay >= afterAttempt) {
        throw _timeoutException(endpoint);
      }
      if (delay > Duration.zero) {
        await Future<void>.delayed(delay);
      }
    }
    throw StateError('OpenAI Responses retry loop exited unexpectedly.');
  }

  Future<http.Response> _sendOnce({
    required Uri endpoint,
    required String encodedBody,
    required Duration timeout,
  }) async {
    final Completer<void> abortTrigger = Completer<void>();
    final http.AbortableRequest request =
        http.AbortableRequest(
            'POST',
            endpoint,
            abortTrigger: abortTrigger.future,
          )
          ..headers.addAll(<String, String>{
            HttpHeaders.authorizationHeader: 'Bearer $_apiKey',
            HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
          })
          ..body = encodedBody;
    bool deadlineExpired = false;
    final Future<http.Response> response = () async {
      final http.StreamedResponse streamed = await _httpClient.send(request);
      return http.Response.fromStream(streamed);
    }();
    try {
      return await response.timeout(
        timeout,
        onTimeout: () {
          deadlineExpired = true;
          if (!abortTrigger.isCompleted) {
            abortTrigger.complete();
          }
          throw _timeoutException(endpoint);
        },
      );
    } on http.RequestAbortedException {
      if (deadlineExpired) {
        throw _timeoutException(endpoint);
      }
      rethrow;
    }
  }

  Duration _retryDelay(int completedAttempt) {
    final int multiplier = 1 << (completedAttempt - 1).clamp(0, 8);
    return retryBaseDelay * multiplier;
  }

  static bool _isRetryableStatus(int statusCode) {
    return statusCode == HttpStatus.tooManyRequests || statusCode >= 500;
  }

  static HttpException _timeoutException(Uri endpoint) {
    return HttpException('OpenAI Responses request timed out.', uri: endpoint);
  }
}
