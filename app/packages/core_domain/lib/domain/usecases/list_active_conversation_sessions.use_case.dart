import 'package:core_domain/domain/entities/conversation_session.entity.dart';
import 'package:core_domain/domain/repositories/conversation_session.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Lists active Pinkall sessions visible to the authenticated user's devices.
final class ListActiveConversationSessionsUseCase
    extends FutureUseCase<List<ConversationSessionEntity>> {
  /// Creates the use case with its [conversationSessionRepository].
  ListActiveConversationSessionsUseCase({
    required ConversationSessionRepository conversationSessionRepository,
  }) : _repository = conversationSessionRepository;

  final ConversationSessionRepository _repository;

  @override
  Future<List<ConversationSessionEntity>> invoke() =>
      _repository.listActiveSessions();
}
