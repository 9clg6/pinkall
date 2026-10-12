/// Raised when transcript access is attempted before notice acknowledgement.
final class TranscriptionConsentRequiredException implements Exception {
  /// Creates the exception for the blocked [sessionId].
  const TranscriptionConsentRequiredException(this.sessionId);

  /// Session that has not acknowledged transcription notice.
  final String sessionId;

  @override
  String toString() =>
      'TranscriptionConsentRequiredException(sessionId: $sessionId)';
}
