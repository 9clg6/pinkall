import 'dart:typed_data';

/// Stable native failure categories for macOS call-audio capture.
enum MacosCallAudioCaptureFailure {
  /// The client was invoked outside macOS.
  unsupportedPlatform,

  /// The installed macOS release cannot expose separate ScreenCaptureKit audio.
  unsupportedOperatingSystem,

  /// Screen Recording access was refused in System Settings.
  screenCapturePermissionDenied,

  /// Microphone access was refused in System Settings.
  microphonePermissionDenied,

  /// A capture session is already active.
  alreadyRunning,

  /// No capture session is active.
  notRunning,

  /// Native capture could not start or stopped unexpectedly.
  captureFailure,

  /// Flutter's native channel returned an invalid response.
  channelFailure,

  /// The client has already been disposed.
  disposed,
}

/// Explicit failure raised by the native macOS call-audio boundary.
final class MacosCallAudioCaptureException implements Exception {
  /// Creates a failure safe to interpret outside the data layer.
  const MacosCallAudioCaptureException({
    required this.failure,
    required this.message,
    this.details,
  });

  /// Machine-readable failure category.
  final MacosCallAudioCaptureFailure failure;

  /// Human-readable detail that never includes captured audio or credentials.
  final String message;

  /// Optional platform diagnostic value.
  final Object? details;

  @override
  String toString() => 'MacosCallAudioCaptureException($failure): $message';
}

/// Memory-only native capture of the two sides of a macOS call.
///
/// Both streams emit signed 16-bit little-endian mono PCM at the sample rate
/// requested by [start]. Consumers should subscribe before starting capture so
/// the first audio frames are not dropped by the platform event channels.
abstract interface class MacosCallAudioCaptureClient {
  /// System output audio captured by ScreenCaptureKit.
  Stream<Uint8List> get systemAudio;

  /// Microphone audio captured independently by ScreenCaptureKit.
  Stream<Uint8List> get microphoneAudio;

  /// Starts one memory-only native session.
  Future<void> start({int sampleRate = 16000});

  /// Stops the active session after flushing native capture.
  Future<void> stop();

  /// Discards the active session without persisting any audio.
  Future<void> cancel();

  /// Releases the native capture session.
  Future<void> dispose();
}
