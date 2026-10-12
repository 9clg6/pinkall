/// A native launch action related to post-call recording import.
sealed class RecordingImportAction {
  const RecordingImportAction();
}

/// Requests that Flutter open its audio file picker.
final class RecordingImportPickerRequested extends RecordingImportAction {
  /// Creates a picker request produced by a launcher shortcut.
  const RecordingImportPickerRequested();
}

/// App-owned temporary copy of an audio file shared with Pinkall.
final class RecordingAudioImport extends RecordingImportAction {
  /// Creates validated metadata for a native temporary file.
  const RecordingAudioImport({
    required this.id,
    required this.name,
    required this.mimeType,
    required this.path,
    required this.sizeBytes,
  });

  /// Opaque identifier used to discard only this temporary import.
  final String id;

  /// Sanitized display name.
  final String name;

  /// Platform-confirmed audio MIME type.
  final String mimeType;

  /// Absolute path inside Pinkall's temporary application storage.
  final String path;

  /// Validated byte size of the temporary copy.
  final int sizeBytes;
}

/// Stable failures exposed by the platform import boundary.
enum RecordingImportFailure {
  /// The platform channel is not available.
  unsupportedPlatform,

  /// The selected file is not a supported audio recording.
  unsupportedAudio,

  /// The selected recording exceeds the local safety limit.
  tooLarge,

  /// The temporary copy could not be read or created.
  ioFailure,

  /// Native code returned a malformed action.
  invalidResponse,
}

/// Typed platform import error safe for presentation.
final class RecordingImportException implements Exception {
  /// Creates a structured recording-import failure.
  const RecordingImportException(this.failure, this.message);

  /// Machine-readable failure category.
  final RecordingImportFailure failure;

  /// Human-readable diagnostic without source paths or credentials.
  final String message;

  @override
  String toString() => 'RecordingImportException($failure): $message';
}

/// Receives audio shared/opened into Pinkall by the operating system.
abstract interface class RecordingImportClient {
  /// Consumes at most one pending cold- or warm-launch action.
  Future<RecordingImportAction?> consumePendingAction();

  /// Opens the native audio document picker and creates an app-owned copy.
  ///
  /// Native code streams the source into bounded temporary storage so a large
  /// recording is never materialized in Dart memory.
  Future<RecordingAudioImport?> pickRecording();

  /// Deletes the app-owned temporary file associated with [id].
  Future<void> discardImport(String id);
}
