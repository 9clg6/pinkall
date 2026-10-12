// ignore_for_file: invalid_annotation_target

import 'package:core_data/model/remote/transcript_segment.remote.model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_transcript.remote.model.freezed.dart';
part 'conversation_transcript.remote.model.g.dart';

/// JSON model for a reconciled final conversation transcript.
@freezed
abstract class ConversationTranscriptRemoteModel
    with _$ConversationTranscriptRemoteModel {
  /// Creates a remote final transcript.
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ConversationTranscriptRemoteModel({
    required String sessionId,
    required List<TranscriptSegmentRemoteModel> segments,
    required DateTime finalizedAt,
    String? languageCode,
  }) = _ConversationTranscriptRemoteModel;

  /// Creates a remote final transcript from JSON.
  factory ConversationTranscriptRemoteModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ConversationTranscriptRemoteModelFromJson(json);
}
