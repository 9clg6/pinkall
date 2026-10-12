import 'dart:typed_data';

import 'package:core_data/clients/pinkall_binary_realtime.client.dart';
import 'package:web_socket_channel/io.dart';

/// Binary WebSocket uploader for raw external PCM frames.
final class WebSocketPinkallBinaryRealtimeClientImpl
    implements PinkallBinaryRealtimeClient {
  /// Creates a binary uploader.
  const WebSocketPinkallBinaryRealtimeClientImpl({
    this.pingInterval = const Duration(seconds: 20),
  });

  /// Keeps long desktop captures alive across quiet periods.
  final Duration pingInterval;

  @override
  Future<PinkallBinaryRealtimeConnection> connect(Uri uri) async {
    _validateUri(uri);
    final IOWebSocketChannel channel = IOWebSocketChannel.connect(
      uri,
      pingInterval: pingInterval,
    );
    await channel.ready;
    return _WebSocketBinaryRealtimeConnection(channel);
  }

  static void _validateUri(Uri uri) {
    if (!uri.isAbsolute || (uri.scheme != 'wss' && uri.scheme != 'ws')) {
      throw ArgumentError.value(
        uri,
        'uri',
        'An absolute WS(S) URI is required.',
      );
    }
    final bool localHost = <String>{
      'localhost',
      '127.0.0.1',
      '::1',
    }.contains(uri.host.toLowerCase());
    if (uri.scheme != 'wss' && !localHost) {
      throw ArgumentError.value(
        uri,
        'uri',
        'Unencrypted media upload is only allowed on localhost.',
      );
    }
  }
}

final class _WebSocketBinaryRealtimeConnection
    implements PinkallBinaryRealtimeConnection {
  _WebSocketBinaryRealtimeConnection(this._channel);

  static const int _maximumFrameBytes = 64 * 1024;
  final IOWebSocketChannel _channel;
  bool _closed = false;

  @override
  Future<void> send(Uint8List bytes) async {
    if (_closed) {
      throw StateError('The external media connection is closed.');
    }
    if (bytes.isEmpty ||
        bytes.length.isOdd ||
        bytes.length > _maximumFrameBytes) {
      throw ArgumentError.value(
        bytes.length,
        'bytes',
        'PCM16 frames must be non-empty, even-sized, and at most 64 KiB.',
      );
    }
    _channel.sink.add(bytes);
  }

  @override
  Future<void> close() async {
    if (_closed) {
      return;
    }
    _closed = true;
    await _channel.sink.close();
  }
}
