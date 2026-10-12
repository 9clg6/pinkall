import 'package:core_domain/domain/entities/conversation_session.entity.dart';
import 'package:core_domain/domain/params/create_conversation_session.param.dart';
import 'package:core_domain/domain/repositories/conversation_session.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Creates a Pinkall processing session for an established voice call.
final class CreateConversationSessionUseCase
    extends
        FutureUseCaseWithParams<
          ConversationSessionEntity,
          CreateConversationSessionParam
        > {
  /// Creates the use case with its [conversationSessionRepository].
  CreateConversationSessionUseCase({
    required ConversationSessionRepository conversationSessionRepository,
  }) : _repository = conversationSessionRepository;

  final ConversationSessionRepository _repository;

  @override
  Future<ConversationSessionEntity> invoke(
    CreateConversationSessionParam params,
  ) => _repository.createSession(params);
}
