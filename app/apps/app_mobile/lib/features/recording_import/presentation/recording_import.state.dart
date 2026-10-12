import 'package:core_domain/core_domain.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_import.state.freezed.dart';

/// Presentation phases for a post-call recording import.
enum RecordingImportStage {
  /// The user chooses and prepares a local audio file.
  selecting,

  /// Metadata, consent and the audio body are being sent.
  uploading,

  /// Deepgram is transcribing and diarizing provisional voices.
  processing,

  /// The user must identify their voice before role attribution.
  assigningVoice,

  /// Pinkall is creating final artifacts after speaker assignment.
  finalizing,

  /// A recoverable or terminal import operation failed.
  failed,
}

/// Immutable state of the recording-import workspace.
@freezed
abstract class RecordingImportState with _$RecordingImportState {
  /// Creates the complete UI state.
  const factory RecordingImportState({
    @Default(RecordingImportStage.selecting) RecordingImportStage stage,
    String? fileName,
    String? filePath,
    String? mimeType,
    int? sizeBytes,
    String? nativeImportId,
    RecordingImportEntity? remoteImport,
    String? selectedVoice,
    String? errorMessage,
  }) = _RecordingImportState;
}

/// Derived state used to keep UI branching explicit.
extension RecordingImportStateX on RecordingImportState {
  /// Whether a complete local audio selection is ready.
  bool get hasFile =>
      fileName != null &&
      filePath != null &&
      mimeType != null &&
      sizeBytes != null;

  /// Whether leaving would interrupt active processing.
  bool get isBusy => <RecordingImportStage>{
    RecordingImportStage.uploading,
    RecordingImportStage.processing,
    RecordingImportStage.finalizing,
  }.contains(stage);
}
