/// Testable boundary for opening and releasing an audio capture stream.
abstract interface class MicrophoneAccessProbe {
  /// Opens the microphone once, then stops and disposes the media stream.
  Future<void> ensureAccess();
}
