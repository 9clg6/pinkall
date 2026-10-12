import 'package:core_domain/domain/entities/call_debrief.entity.dart';
import 'package:core_domain/domain/params/session_action.param.dart';
import 'package:core_domain/domain/repositories/conversation_session.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Retrieves the grounded post-call artifact of one finalized session.
final class GetCallDebriefUseCase
    extends FutureUseCaseWithParams<CallDebriefEntity, SessionActionParam> {
  /// Creates the use case with its repository boundary.
  GetCallDebriefUseCase({
    required ConversationSessionRepository conversationSessionRepository,
  }) : _repository = conversationSessionRepository;

  final ConversationSessionRepository _repository;

  @override
  Future<CallDebriefEntity> invoke(SessionActionParam params) =>
      _repository.getDebrief(params.sessionId);
}
