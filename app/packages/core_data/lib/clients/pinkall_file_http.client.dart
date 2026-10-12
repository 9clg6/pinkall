/// Authenticated same-origin upload boundary for app-owned temporary files.
abstract interface class PinkallFileHttpClient {
  /// Streams one local file with an exact expected size to a relative [path].
  Future<Map<String, dynamic>> putFile(
    String path, {
    required String filePath,
    required int sizeBytes,
    required String contentType,
  });
}
