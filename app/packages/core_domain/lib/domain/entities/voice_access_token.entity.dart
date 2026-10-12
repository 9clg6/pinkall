/// Short-lived Telnyx voice credential issued by the Pinkall backend.
///
/// The sensitive [token] is deliberately excluded from value equality,
/// [hashCode], and [toString]. This entity has no JSON contract so the token
/// cannot be serialized accidentally from the domain layer.
final class VoiceAccessTokenEntity {
  /// Creates an in-memory voice credential.
  const VoiceAccessTokenEntity({
    required this.token,
    required this.expiresAt,
    required this.callerName,
    required this.callerNumber,
  });

  /// Short-lived Telnyx SIP token. Never persist or log this value.
  final String token;

  /// Instant after which [token] must no longer be used.
  final DateTime expiresAt;

  /// Caller name assigned by the backend for this voice session.
  final String callerName;

  /// E.164 caller number assigned by the backend for this voice session.
  final String callerNumber;

  /// Whether the token is already expired at [at].
  bool isExpiredAt(DateTime at) => !expiresAt.isAfter(at);

  @override
  String toString() {
    return 'VoiceAccessTokenEntity('
        'token: <redacted>, '
        'expiresAt: $expiresAt, '
        'callerName: $callerName, '
        'callerNumber: $callerNumber)';
  }
}
