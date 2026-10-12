import 'dart:typed_data';

/// One authenticated-by-URL binary WebSocket upload connection.
abstract interface class PinkallBinaryRealtimeConnection {
  /// Sends one bounded raw audio frame.
  Future<void> send(Uint8List bytes);

  /// Closes the media track cleanly.
  Future<void> close();
}

/// Opens short-lived binary uploads described by the Pinkall backend.
abstract interface class PinkallBinaryRealtimeClient {
  /// Connects to an absolute backend-issued [uri].
  Future<PinkallBinaryRealtimeConnection> connect(Uri uri);
}
