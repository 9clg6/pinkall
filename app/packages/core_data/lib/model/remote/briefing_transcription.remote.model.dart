// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'briefing_transcription.remote.model.freezed.dart';
part 'briefing_transcription.remote.model.g.dart';

/// JSON model returned by the Pinkall briefing transcription endpoint.
@freezed
abstract class BriefingTranscriptionRemoteModel
    with _$BriefingTranscriptionRemoteModel {
  /// Creates a decoded transcription payload.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BriefingTranscriptionRemoteModel({
    /// Complete provider transcript.
    required String text,

    /// STT adapter and model identifier.
    required String provider,

    /// Provider-detected language, when available.
    @JsonKey(name: 'language') String? languageCode,
  }) = _BriefingTranscriptionRemoteModel;

  /// Decodes one backend response object.
  factory BriefingTranscriptionRemoteModel.fromJson(
    Map<String, dynamic> json,
  ) => _$BriefingTranscriptionRemoteModelFromJson(json);
}
