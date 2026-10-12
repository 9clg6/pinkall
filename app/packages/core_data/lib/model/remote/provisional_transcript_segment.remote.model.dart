// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'provisional_transcript_segment.remote.model.freezed.dart';
part 'provisional_transcript_segment.remote.model.g.dart';

/// Voice-labelled diarization segment before user assignment.
@freezed
abstract class ProvisionalTranscriptSegmentRemoteModel
    with _$ProvisionalTranscriptSegmentRemoteModel {
  /// Creates one provisional remote segment.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProvisionalTranscriptSegmentRemoteModel({
    required String id,
    required String voice,
    required String text,
    required double startSeconds,
    required double endSeconds,
    required double confidence,
  }) = _ProvisionalTranscriptSegmentRemoteModel;

  /// Decodes a provisional segment.
  factory ProvisionalTranscriptSegmentRemoteModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ProvisionalTranscriptSegmentRemoteModelFromJson(json);
}
