import 'package:core_domain/domain/entities/conversation_session.entity.dart';
import 'package:core_domain/domain/params/session_action.param.dart';
import 'package:core_domain/domain/repositories/conversation_session.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Requests final transcript reconciliation for a completed voice call.
final class FinalizeConversationSessionUseCase
    extends
        FutureUseCaseWithParams<ConversationSessionEntity, SessionActionParam> {
  /// Creates the use case with its [conversationSessionRepository].
  FinalizeConversationSessionUseCase({
    required ConversationSessionRepository conversationSessionRepository,
  }) : _repository = conversationSessionRepository;

  final ConversationSessionRepository _repository;

  @override
  Future<ConversationSessionEntity> invoke(SessionActionParam params) =>
      _repository.finalizeSession(params.sessionId);
}
