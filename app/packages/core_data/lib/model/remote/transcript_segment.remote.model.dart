// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcript_segment.remote.model.freezed.dart';
part 'transcript_segment.remote.model.g.dart';

/// JSON model for a partial or final transcript segment.
@freezed
abstract class TranscriptSegmentRemoteModel
    with _$TranscriptSegmentRemoteModel {
  /// Creates a remote transcript segment.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TranscriptSegmentRemoteModel({
    required String id,
    required String sessionId,
    required int sequence,
    required String speaker,
    required String text,
    required DateTime startedAt,
    required bool isFinal,
    DateTime? endedAt,
    double? confidence,
  }) = _TranscriptSegmentRemoteModel;

  /// Creates a remote transcript segment from JSON.
  factory TranscriptSegmentRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$TranscriptSegmentRemoteModelFromJson(json);
}
