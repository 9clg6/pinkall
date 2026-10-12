import 'package:core_domain/domain/entities/provisional_transcript_segment.entity.dart';
import 'package:core_domain/domain/enum/recording_import_status.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_import.entity.freezed.dart';

/// Provider-independent state of one post-call audio import.
@freezed
abstract class RecordingImportEntity with _$RecordingImportEntity {
  /// Creates an immutable recording import snapshot.
  const factory RecordingImportEntity({
    required String id,
    required String sessionId,
    required RecordingImportStatus status,
    @Default(true) bool consentRequired,
    @Default(<String>[]) List<String> acceptedMimeTypes,
    @Default(<String>[]) List<String> voices,
    @Default(<ProvisionalTranscriptSegmentEntity>[])
    List<ProvisionalTranscriptSegmentEntity> provisionalSegments,
    String? uploadPath,
    int? maxSizeBytes,
    int? maxDurationSeconds,
    String? failureCode,
    String? failureReason,
    bool? failureRetryable,
  }) = _RecordingImportEntity;
}
