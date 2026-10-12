/// Supabase session subset kept inside the data layer.
///
/// This deliberately avoids Freezed/JSON generation: generated `toString`
/// methods would otherwise include the bearer token. The explicit override is
/// safe to log during diagnostics because it only exposes non-secret metadata.
final class PinkallAuthSessionRemoteModel {
  /// Creates a remote authentication session.
  const PinkallAuthSessionRemoteModel({
    required String userId,
    required String accessToken,
    this.expiresAt,
    this.email,
  }) : _userId = userId,
       _accessToken = accessToken;

  final String _userId;
  final String _accessToken;

  /// Supabase user identifier.
  String get userId => _userId;

  /// Bearer token available only to the data layer.
  String get accessToken => _accessToken;

  /// Access-token expiry, when the provider exposes it.
  final DateTime? expiresAt;

  /// Account email used only for the authenticated account affordance.
  final String? email;

  @override
  String toString() =>
      'PinkallAuthSessionRemoteModel(userId: $_userId, '
      'expiresAt: $expiresAt, email: $email, accessToken: [REDACTED])';
}
