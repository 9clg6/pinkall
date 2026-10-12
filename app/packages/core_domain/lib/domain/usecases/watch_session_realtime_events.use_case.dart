import 'package:core_domain/domain/entities/session_realtime_event.entity.dart';
import 'package:core_domain/domain/params/session_action.param.dart';
import 'package:core_domain/domain/repositories/conversation_session.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Watches transcript, suggestion, and lifecycle events for one session.
final class WatchSessionRealtimeEventsUseCase
    extends
        StreamUseCaseWithParams<
          SessionRealtimeEventEntity,
          SessionActionParam
        > {
  /// Creates the use case with its [conversationSessionRepository].
  WatchSessionRealtimeEventsUseCase({
    required ConversationSessionRepository conversationSessionRepository,
  }) : _repository = conversationSessionRepository;

  final ConversationSessionRepository _repository;

  @override
  Stream<SessionRealtimeEventEntity> invoke(SessionActionParam params) =>
      _repository.watchSessionEvents(params.sessionId);
}
