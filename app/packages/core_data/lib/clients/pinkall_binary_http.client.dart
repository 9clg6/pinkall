import 'dart:typed_data';

/// Authenticated binary upload boundary for short-lived media payloads.
abstract interface class PinkallBinaryHttpClient {
  /// Uploads [body] and returns the backend JSON object response.
  Future<Map<String, dynamic>> postBinary(
    String path, {
    required Uint8List body,
    required String contentType,
    Map<String, dynamic>? queryParameters,
  });
}
