import 'package:core_data/model/remote/briefing_transcription.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Converts the backend transcription payload into the domain entity.
extension BriefingTranscriptionRemoteModelX
    on BriefingTranscriptionRemoteModel {
  /// Maps this transport model to provider-neutral domain data.
  BriefingTranscriptionEntity toEntity() {
    final String normalizedText = text.trim();
    final String normalizedProvider = provider.trim();
    if (normalizedText.isEmpty) {
      throw const FormatException(
        'Pinkall briefing transcription text is missing.',
      );
    }
    if (normalizedProvider.isEmpty) {
      throw const FormatException(
        'Pinkall briefing transcription provider is missing.',
      );
    }
    final String? normalizedLanguage = languageCode?.trim();
    return BriefingTranscriptionEntity(
      text: normalizedText,
      provider: normalizedProvider,
      languageCode: normalizedLanguage == null || normalizedLanguage.isEmpty
          ? null
          : normalizedLanguage,
    );
  }
}
