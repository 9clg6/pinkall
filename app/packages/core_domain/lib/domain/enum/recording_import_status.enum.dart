/// Lifecycle of one consent-gated post-call recording import.
enum RecordingImportStatus {
  /// Metadata exists but participant notice has not been acknowledged.
  awaitingConsent,

  /// Consent exists and the backend is waiting for the audio body.
  awaitingUpload,

  /// The backend is receiving and validating the streamed audio body.
  uploading,

  /// Deepgram is transcribing and diarizing the temporary audio.
  transcribing,

  /// Provisional voices are ready for explicit user identification.
  awaitingSpeakerAssignment,

  /// Speaker attribution is complete and final artifacts are being created.
  finalizing,

  /// Speaker attribution and final post-call artifacts are complete.
  finalized,

  /// Import processing failed and may require a new upload.
  failed,
}
