/// Sensitive wire model returned by `POST /v1/voice/token`.
///
/// This model is intentionally read-only and has no `toJson`, value equality,
/// or secret-bearing `toString` implementation.
final class VoiceAccessTokenRemoteModel {
  /// Creates a deserialized token response.
  const VoiceAccessTokenRemoteModel({
    required this.token,
    required this.expiresAt,
    required this.callerName,
    required this.callerNumber,
  });

  /// Parses the direct Pinkall voice-token response.
  factory VoiceAccessTokenRemoteModel.fromJson(Map<String, dynamic> json) {
    String requiredString(String key) {
      final Object? value = json[key];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException('Missing or empty voice-token field: $key.');
      }
      return value.trim();
    }

    final String expiresAtValue = requiredString('expires_at');
    final DateTime? expiresAt = DateTime.tryParse(expiresAtValue);
    if (expiresAt == null) {
      throw const FormatException(
        'Voice-token expires_at must be an ISO-8601 timestamp.',
      );
    }
    return VoiceAccessTokenRemoteModel(
      token: requiredString('token'),
      expiresAt: expiresAt,
      callerName: requiredString('caller_name'),
      callerNumber: requiredString('caller_number'),
    );
  }

  /// Short-lived Telnyx credential. Never persist or log this value.
  final String token;

  /// Server-declared token expiry.
  final DateTime expiresAt;

  /// Server-assigned caller name.
  final String callerName;

  /// Server-assigned E.164 caller number.
  final String callerNumber;

  @override
  String toString() {
    return 'VoiceAccessTokenRemoteModel('
        'token: <redacted>, '
        'expiresAt: $expiresAt, '
        'callerName: $callerName, '
        'callerNumber: $callerNumber)';
  }
}
