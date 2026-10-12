import 'package:core_domain/domain/enum/coach_mode.enum.dart';
import 'package:core_domain/domain/enum/conversation_session_status.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_session.entity.freezed.dart';

/// Immutable state of one Pinkall backend conversation session.
@freezed
abstract class ConversationSessionEntity with _$ConversationSessionEntity {
  /// Creates a conversation session snapshot.
  const factory ConversationSessionEntity({
    required String id,
    required String callId,
    required ConversationSessionStatus status,
    required CoachMode coachMode,
    required DateTime createdAt,
    @Default(false) bool transcriptionConsentAcknowledged,
    String? destinationNumber,
    String? contactId,
    String? preparationMarkdown,
    DateTime? startedAt,
    DateTime? endedAt,
    String? failureReason,
  }) = _ConversationSessionEntity;
}
