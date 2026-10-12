/// Sensitive sign-in values passed directly to the authentication boundary.
///
/// This type intentionally has no generated `toString` or JSON serializer so
/// a password cannot be included accidentally in logs, analytics, or state.
final class PinkallSignInParam {
  /// Creates sanitized email/password input.
  PinkallSignInParam({required String email, required this.password})
    : email = email.trim().toLowerCase();

  /// Normalized account email.
  final String email;

  /// Ephemeral password. It must never be persisted or logged.
  final String password;
}
