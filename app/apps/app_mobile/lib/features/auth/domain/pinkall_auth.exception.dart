/// Sanitized authentication failure categories safe for UI decisions.
enum PinkallAuthFailureCode {
  /// The supplied credentials are not accepted.
  invalidCredentials,

  /// The authentication provider cannot be reached.
  networkUnavailable,

  /// Authentication is not configured for this build.
  unavailable,

  /// A sanitized fallback for an unclassified provider failure.
  unknown,
}

/// Authentication exception that carries no provider message or credential.
final class PinkallAuthException implements Exception {
  /// Creates a sanitized authentication failure.
  const PinkallAuthException(this.code);

  /// Stable UI-safe failure category.
  final PinkallAuthFailureCode code;
}
