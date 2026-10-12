import 'package:core_domain/domain/entities/conversation_session.entity.dart';
import 'package:core_domain/domain/params/update_session_coach_mode.param.dart';
import 'package:core_domain/domain/repositories/conversation_session.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Applies an off, shadow, or live override to one active call session.
final class UpdateSessionCoachModeUseCase
    extends
        FutureUseCaseWithParams<
          ConversationSessionEntity,
          UpdateSessionCoachModeParam
        > {
  /// Creates the use case with its [conversationSessionRepository].
  UpdateSessionCoachModeUseCase({
    required ConversationSessionRepository conversationSessionRepository,
  }) : _repository = conversationSessionRepository;

  final ConversationSessionRepository _repository;

  @override
  Future<ConversationSessionEntity> invoke(
    UpdateSessionCoachModeParam params,
  ) => _repository.updateCoachMode(params);
}
