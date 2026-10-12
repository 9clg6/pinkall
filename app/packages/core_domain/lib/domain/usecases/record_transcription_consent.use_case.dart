import 'package:core_domain/domain/entities/transcription_consent.entity.dart';
import 'package:core_domain/domain/params/record_transcription_consent.param.dart';
import 'package:core_domain/domain/repositories/conversation_session.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Records the notice acknowledgement that gates session transcription.
final class RecordTranscriptionConsentUseCase
    extends
        FutureUseCaseWithParams<
          TranscriptionConsentEntity,
          RecordTranscriptionConsentParam
        > {
  /// Creates the use case with its [conversationSessionRepository].
  RecordTranscriptionConsentUseCase({
    required ConversationSessionRepository conversationSessionRepository,
  }) : _repository = conversationSessionRepository;

  final ConversationSessionRepository _repository;

  @override
  Future<TranscriptionConsentEntity> invoke(
    RecordTranscriptionConsentParam params,
  ) => _repository.recordTranscriptionConsent(params);
}
