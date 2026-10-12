import 'package:core_data/model/remote/briefing_transcription.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Remote source for ephemeral project and pre-call dictations.
abstract interface class BriefingTranscriptionRemoteDataSource {
  /// Uploads raw mono PCM to the authenticated Pinkall API.
  Future<BriefingTranscriptionRemoteModel> transcribe(
    TranscribeBriefingAudioParam params,
  );
}
