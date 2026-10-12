import 'package:core_domain/domain/entities/conversation_session.entity.dart';
import 'package:core_domain/domain/params/session_action.param.dart';
import 'package:core_domain/domain/repositories/conversation_session.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Retrieves the latest state of one Pinkall conversation session.
final class GetConversationSessionUseCase
    extends
        FutureUseCaseWithParams<ConversationSessionEntity, SessionActionParam> {
  /// Creates the use case with its [conversationSessionRepository].
  GetConversationSessionUseCase({
    required ConversationSessionRepository conversationSessionRepository,
  }) : _repository = conversationSessionRepository;

  final ConversationSessionRepository _repository;

  @override
  Future<ConversationSessionEntity> invoke(SessionActionParam params) =>
      _repository.getSession(params.sessionId);
}
