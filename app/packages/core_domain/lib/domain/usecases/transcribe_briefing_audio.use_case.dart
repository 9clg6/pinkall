import 'package:core_domain/domain/entities/briefing_transcription.entity.dart';
import 'package:core_domain/domain/params/transcribe_briefing_audio.param.dart';
import 'package:core_domain/domain/repositories/briefing_transcription.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Turns a short microphone recording into editable briefing text.
final class TranscribeBriefingAudioUseCase
    extends
        FutureUseCaseWithParams<
          BriefingTranscriptionEntity,
          TranscribeBriefingAudioParam
        > {
  /// Creates the use case with its provider-neutral repository.
  TranscribeBriefingAudioUseCase({
    required BriefingTranscriptionRepository repository,
  }) : _repository = repository;

  final BriefingTranscriptionRepository _repository;

  @override
  Future<BriefingTranscriptionEntity> invoke(
    TranscribeBriefingAudioParam params,
  ) => _repository.transcribe(params);
}
