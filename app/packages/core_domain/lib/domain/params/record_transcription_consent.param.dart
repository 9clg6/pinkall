// ignore_for_file: invalid_annotation_target

import 'package:core_domain/domain/enum/transcription_consent_method.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_transcription_consent.param.freezed.dart';
part 'record_transcription_consent.param.g.dart';

/// Notice acknowledgement required before Pinkall may transcribe a session.
@freezed
abstract class RecordTranscriptionConsentParam
    with _$RecordTranscriptionConsentParam {
  /// Creates transcription-consent parameters.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RecordTranscriptionConsentParam({
    required String sessionId,
    required bool acknowledged,
    required TranscriptionConsentMethod method,
    required DateTime acknowledgedAt,
  }) = _RecordTranscriptionConsentParam;

  /// Creates transcription-consent parameters from JSON.
  factory RecordTranscriptionConsentParam.fromJson(Map<String, dynamic> json) =>
      _$RecordTranscriptionConsentParamFromJson(json);
}
