// ignore_for_file: invalid_annotation_target

import 'package:core_data/model/remote/provisional_transcript_segment.remote.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recording_import.remote.model.freezed.dart';
part 'recording_import.remote.model.g.dart';

/// Backend snapshot for one post-call recording import.
@freezed
abstract class RecordingImportRemoteModel with _$RecordingImportRemoteModel {
  /// Creates a recording-import remote model.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RecordingImportRemoteModel({
    required String id,
    required String sessionId,
    required String status,
    @Default(true) bool consentRequired,
    @Default(<String>[]) List<String> acceptedMimeTypes,
    @Default(<String>[]) List<String> voices,
    @Default(<ProvisionalTranscriptSegmentRemoteModel>[])
    List<ProvisionalTranscriptSegmentRemoteModel> provisionalSegments,
    String? uploadUrl,
    int? maxSizeBytes,
    int? maxDurationSeconds,
    String? failureCode,
    String? failureReason,
    bool? failureRetryable,
  }) = _RecordingImportRemoteModel;

  /// Decodes one backend snapshot.
  factory RecordingImportRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$RecordingImportRemoteModelFromJson(json);
}
