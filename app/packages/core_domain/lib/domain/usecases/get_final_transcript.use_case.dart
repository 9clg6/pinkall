import 'package:core_domain/domain/entities/conversation_transcript.entity.dart';
import 'package:core_domain/domain/params/session_action.param.dart';
import 'package:core_domain/domain/repositories/conversation_session.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Retrieves the reconciled final transcript of one call session.
final class GetFinalTranscriptUseCase
    extends
        FutureUseCaseWithParams<
          ConversationTranscriptEntity,
          SessionActionParam
        > {
  /// Creates the use case with its [conversationSessionRepository].
  GetFinalTranscriptUseCase({
    required ConversationSessionRepository conversationSessionRepository,
  }) : _repository = conversationSessionRepository;

  final ConversationSessionRepository _repository;

  @override
  Future<ConversationTranscriptEntity> invoke(SessionActionParam params) =>
      _repository.getFinalTranscript(params.sessionId);
}
