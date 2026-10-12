import 'dart:convert';

import 'package:core_data/clients/pinkall_http.client.dart';
import 'package:core_data/clients/pinkall_realtime.client.dart';
import 'package:core_data/exceptions/pinkall_backend.exception.dart';
import 'package:web_socket_channel/io.dart';

/// Real configurable WebSocket implementation of [PinkallRealtimeClient].
final class WebSocketPinkallRealtimeClientImpl
    implements PinkallRealtimeClient {
  /// Creates an authenticated realtime client for an absolute WS(S) [baseUri].
  WebSocketPinkallRealtimeClientImpl({
    required Uri baseUri,
    required PinkallAccessTokenProvider accessTokenProvider,
    Duration pingInterval = const Duration(seconds: 20),
  }) : _baseUri = _validateBaseUri(baseUri),
       _accessTokenProvider = accessTokenProvider,
       _pingInterval = pingInterval;

  final Uri _baseUri;
  final PinkallAccessTokenProvider _accessTokenProvider;
  final Duration _pingInterval;

  @override
  Stream<Map<String, dynamic>> watchJson(String path) async* {
    final String? token = await _accessTokenProvider();
    final Uri uri = _baseUri.resolve(path);
    final IOWebSocketChannel channel = IOWebSocketChannel.connect(
      uri,
      headers: token == null || token.isEmpty
          ? null
          : <String, String>{'Authorization': 'Bearer $token'},
      pingInterval: _pingInterval,
    );
    try {
      await channel.ready;
      await for (final dynamic message in channel.stream) {
        final Object? decoded = jsonDecode(_messageText(message));
        if (decoded is Map<String, dynamic>) {
          yield decoded;
          continue;
        }
        if (decoded is Map<dynamic, dynamic>) {
          yield decoded.map<String, dynamic>(
            (dynamic key, dynamic value) =>
                MapEntry<String, dynamic>(key.toString(), value),
          );
          continue;
        }
        throw PinkallBackendException(
          message: 'Expected a JSON object WebSocket event.',
          path: path,
        );
      }
    } finally {
      await channel.sink.close();
    }
  }

  static String _messageText(dynamic message) {
    if (message is String) {
      return message;
    }
    if (message is List<int>) {
      return utf8.decode(message);
    }
    throw FormatException(
      'Unsupported Pinkall WebSocket frame: ${message.runtimeType}.',
    );
  }

  static Uri _validateBaseUri(Uri baseUri) {
    if (!baseUri.isAbsolute ||
        (baseUri.scheme != 'ws' && baseUri.scheme != 'wss')) {
      throw ArgumentError.value(
        baseUri,
        'baseUri',
        'An absolute WS(S) URI is required.',
      );
    }
    return baseUri;
  }
}
