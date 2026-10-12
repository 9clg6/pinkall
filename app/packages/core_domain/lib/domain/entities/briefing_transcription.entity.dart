import 'package:freezed_annotation/freezed_annotation.dart';

part 'briefing_transcription.entity.freezed.dart';

/// Editable speech-to-text result produced for a project or call briefing.
@freezed
abstract class BriefingTranscriptionEntity with _$BriefingTranscriptionEntity {
  /// Creates a provider-confirmed briefing transcription.
  const factory BriefingTranscriptionEntity({
    /// Complete transcript ready to insert into the briefing field.
    required String text,

    /// STT adapter and model that produced the transcript.
    required String provider,

    /// Provider-detected language, when available.
    String? languageCode,
  }) = _BriefingTranscriptionEntity;
}
