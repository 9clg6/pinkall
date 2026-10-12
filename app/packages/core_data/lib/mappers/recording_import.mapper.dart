import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/provisional_transcript_segment.remote.model.dart';
import 'package:core_data/model/remote/recording_import.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Maps provisional diarization without assigning commercial speaker roles.
extension ProvisionalTranscriptSegmentRemoteModelX
    on ProvisionalTranscriptSegmentRemoteModel {
  /// Converts the raw voice label and text to domain values.
  ProvisionalTranscriptSegmentEntity toEntity() =>
      ProvisionalTranscriptSegmentEntity(
        id: id,
        voice: voice,
        text: text,
        startSeconds: startSeconds,
        endSeconds: endSeconds,
        confidence: confidence,
      );
}

/// Maps recording import snapshots to provider-independent values.
extension RecordingImportRemoteModelX on RecordingImportRemoteModel {
  /// Converts the backend snapshot and validates a same-origin upload path.
  RecordingImportEntity toEntity() => RecordingImportEntity(
    id: id,
    sessionId: sessionId,
    status: enumFromWireName<RecordingImportStatus>(
      RecordingImportStatus.values,
      status,
    ),
    consentRequired: consentRequired,
    acceptedMimeTypes: List<String>.unmodifiable(acceptedMimeTypes),
    voices: List<String>.unmodifiable(voices),
    provisionalSegments: provisionalSegments
        .map(
          (ProvisionalTranscriptSegmentRemoteModel model) => model.toEntity(),
        )
        .toList(growable: false),
    uploadPath: _validatedUploadPath(uploadUrl),
    maxSizeBytes: maxSizeBytes,
    maxDurationSeconds: maxDurationSeconds,
    failureCode: failureCode,
    failureReason: failureReason,
    failureRetryable: failureRetryable,
  );
}

String? _validatedUploadPath(String? value) {
  if (value == null) return null;
  final Uri uri = Uri.parse(value);
  if (uri.isAbsolute ||
      !uri.path.startsWith('/v1/recording-imports/') ||
      !uri.path.endsWith('/audio')) {
    throw const FormatException(
      'Recording upload URL must be a relative Pinkall API path.',
    );
  }
  return uri.toString();
}
