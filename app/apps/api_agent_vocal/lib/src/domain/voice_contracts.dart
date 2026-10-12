/// Short-lived runtime credential returned to a Pinkall Voice SDK client.
final class VoiceAccessToken {
  const VoiceAccessToken({
    required this.token,
    required this.expiresAt,
    required this.callerName,
    required this.callerNumber,
  });

  final String token;
  final DateTime expiresAt;
  final String callerName;
  final String callerNumber;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'token': token,
      'expires_at': expiresAt.toUtc().toIso8601String(),
      'caller_name': callerName,
      'caller_number': callerNumber,
    };
  }
}

/// Server-side boundary for issuing Telnyx Voice SDK access tokens.
abstract interface class VoiceTokenProvider {
  bool get isConfigured;

  Future<VoiceAccessToken> issue({required String deviceId});

  void dispose();
}

/// Explicitly unavailable adapter; it never fabricates a token.
final class UnavailableVoiceTokenProvider implements VoiceTokenProvider {
  const UnavailableVoiceTokenProvider(this.reason);

  final String reason;

  @override
  bool get isConfigured => false;

  @override
  Future<VoiceAccessToken> issue({required String deviceId}) {
    throw StateError(reason);
  }

  @override
  void dispose() {}
}
