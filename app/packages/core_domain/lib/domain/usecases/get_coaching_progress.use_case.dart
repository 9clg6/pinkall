import 'package:core_domain/domain/entities/coaching_progress.entity.dart';
import 'package:core_domain/domain/params/get_coaching_progress.param.dart';
import 'package:core_domain/domain/repositories/conversation_session.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Retrieves the longitudinal coaching profile for the current workspace.
final class GetCoachingProgressUseCase
    extends
        FutureUseCaseWithParams<
          CoachingProgressEntity,
          GetCoachingProgressParam
        > {
  /// Creates the use case with its repository boundary.
  GetCoachingProgressUseCase({
    required ConversationSessionRepository conversationSessionRepository,
  }) : _repository = conversationSessionRepository;

  final ConversationSessionRepository _repository;

  @override
  Future<CoachingProgressEntity> invoke(GetCoachingProgressParam params) =>
      _repository.getCoachingProgress(params);
}
