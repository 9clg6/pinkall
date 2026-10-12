/// Produces the current short-lived Pinkall API access token.
typedef PinkallAccessTokenProvider = Future<String?> Function();

/// Small authenticated JSON HTTP boundary used by Pinkall data sources.
abstract interface class PinkallHttpClient {
  /// Performs a JSON GET request.
  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
  });

  /// Performs a JSON POST request.
  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
  });

  /// Performs a JSON PUT request.
  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
  });

  /// Performs a JSON PATCH request.
  Future<Map<String, dynamic>> patchJson(
    String path, {
    Map<String, dynamic>? body,
  });
}
