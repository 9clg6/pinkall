// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcription_consent.remote.model.freezed.dart';
part 'transcription_consent.remote.model.g.dart';

/// JSON model for a transcription notice acknowledgement.
@freezed
abstract class TranscriptionConsentRemoteModel
    with _$TranscriptionConsentRemoteModel {
  /// Creates a remote transcription acknowledgement.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TranscriptionConsentRemoteModel({
    required String sessionId,
    required bool acknowledged,
    required String method,
    required DateTime acknowledgedAt,
  }) = _TranscriptionConsentRemoteModel;

  /// Creates a remote transcription acknowledgement from JSON.
  factory TranscriptionConsentRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$TranscriptionConsentRemoteModelFromJson(json);
}
