import 'dart:typed_data';

/// Completed mono PCM recording captured for one briefing dictation.
final class VoiceDictationRecording {
  /// Creates an immutable recording result.
  VoiceDictationRecording({
    required Uint8List pcmBytes,
    required this.sampleRate,
    required this.duration,
  }) : pcmBytes = Uint8List.fromList(pcmBytes);

  /// Signed 16-bit little-endian mono PCM.
  final Uint8List pcmBytes;

  /// Effective native recorder sample rate.
  final int sampleRate;

  /// Wall-clock recording duration.
  final Duration duration;
}

/// Stable failure categories surfaced by the platform recorder boundary.
enum VoiceDictationRecordingFailure {
  /// The operating system denied microphone access.
  permissionDenied,

  /// The requested recording state transition was invalid.
  invalidState,

  /// The recorder completed without usable audio bytes.
  noAudio,

  /// The configured maximum in-memory recording size was exceeded.
  tooLarge,

  /// A native recorder or stream operation failed.
  inputFailure,
}

/// Structured platform-recording failure safe to interpret in presentation.
final class VoiceDictationRecordingException implements Exception {
  /// Creates a failure with a stable [code].
  const VoiceDictationRecordingException(this.code, this.message);

  /// Machine-readable failure category.
  final VoiceDictationRecordingFailure code;

  /// Developer-facing detail that must not contain credentials.
  final String message;

  @override
  String toString() => 'VoiceDictationRecordingException($code): $message';
}

/// Testable boundary around a platform microphone recording session.
abstract interface class VoiceDictationRecorderClient {
  /// Starts one mono PCM recording and requests microphone access if needed.
  Future<void> start();

  /// Stops the active recording and returns all captured bytes.
  Future<VoiceDictationRecording> stop();

  /// Discards an active recording.
  Future<void> cancel();

  /// Releases the native recorder.
  Future<void> dispose();
}
