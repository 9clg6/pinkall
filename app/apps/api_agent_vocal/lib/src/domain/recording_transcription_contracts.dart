/// Opens a fresh byte stream for one transient uploaded recording.
typedef RecordedAudioStreamFactory = Stream<List<int>> Function();

/// Provider-neutral input for prerecorded call transcription.
///
/// The stream factory lets infrastructure forward a staged upload without
/// retaining the complete recording in process memory. The application owns
/// the transient file lifecycle and deletes it after the provider job ends.
final class RecordedAudioInput {
  const RecordedAudioInput({
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    required this.openRead,
  });

  final String fileName;
  final String mimeType;
  final int sizeBytes;
  final RecordedAudioStreamFactory openRead;
}

/// One diarized but deliberately role-free provider segment.
final class DiarizedRecordingSegment {
  const DiarizedRecordingSegment({
    required this.voiceId,
    required this.text,
    required this.startSeconds,
    required this.endSeconds,
    required this.confidence,
  });

  /// Opaque provider speaker identity; it is never a seller/prospect role.
  final String voiceId;
  final String text;
  final double startSeconds;
  final double endSeconds;
  final double? confidence;
}

/// Complete provider-neutral prerecorded diarization result.
final class DiarizedRecordingTranscript {
  const DiarizedRecordingTranscript({
    required this.durationSeconds,
    required this.language,
    required this.segments,
    required this.provider,
  });

  final double durationSeconds;
  final String? language;
  final List<DiarizedRecordingSegment> segments;
  final String provider;
}

/// Safe failure contract for a prerecorded transcription adapter.
final class RecordedTranscriptionException implements Exception {
  const RecordedTranscriptionException({
    required this.code,
    required this.message,
    required this.retryable,
  });

  final String code;
  final String message;
  final bool retryable;

  @override
  String toString() => 'RecordedTranscriptionException($code)';
}

/// Replaceable boundary for transcription and diarization of uploaded audio.
abstract interface class RecordedCallTranscriptionProvider {
  String get name;

  bool get isConfigured;

  Future<DiarizedRecordingTranscript> transcribe({
    required RecordedAudioInput audio,
    required String locale,
  });

  Future<void> dispose();
}

/// Explicit unavailable adapter used when prerecorded STT is not configured.
final class UnavailableRecordedCallTranscriptionProvider
    implements RecordedCallTranscriptionProvider {
  const UnavailableRecordedCallTranscriptionProvider(this.reason);

  final String reason;

  @override
  bool get isConfigured => false;

  @override
  String get name => 'unavailable';

  @override
  Future<DiarizedRecordingTranscript> transcribe({
    required RecordedAudioInput audio,
    required String locale,
  }) {
    throw RecordedTranscriptionException(
      code: 'provider_unavailable',
      message: reason,
      retryable: true,
    );
  }

  @override
  Future<void> dispose() async {}
}
