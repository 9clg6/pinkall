/// Authenticated JSON WebSocket boundary for Pinkall session events.
abstract interface class PinkallRealtimeClient {
  /// Opens a live JSON stream at the relative backend [path].
  Stream<Map<String, dynamic>> watchJson(String path);
}
