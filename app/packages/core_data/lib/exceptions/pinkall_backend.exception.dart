/// Failure raised by the authenticated Pinkall backend transport boundary.
final class PinkallBackendException implements Exception {
  /// Creates a backend exception.
  const PinkallBackendException({
    required this.message,
    required this.path,
    this.statusCode,
    this.cause,
  });

  /// Human-readable transport or protocol failure.
  final String message;

  /// Relative backend path involved in the failure.
  final String path;

  /// HTTP status code when the server returned one.
  final int? statusCode;

  /// Original transport error when available.
  final Object? cause;

  @override
  String toString() => 'PinkallBackendException($statusCode, $path): $message';
}
