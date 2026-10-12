import 'package:core_domain/domain/entities/briefing_transcription.entity.dart';
import 'package:core_domain/domain/params/transcribe_briefing_audio.param.dart';

/// Provider-neutral boundary for transcribing user-authored briefings.
abstract interface class BriefingTranscriptionRepository {
  /// Transcribes one short microphone recording without persisting the audio.
  Future<BriefingTranscriptionEntity> transcribe(
    TranscribeBriefingAudioParam params,
  );
}
