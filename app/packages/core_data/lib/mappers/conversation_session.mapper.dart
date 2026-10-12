import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/conversation_session.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Mapping extensions for [ConversationSessionRemoteModel].
extension ConversationSessionRemoteModelX on ConversationSessionRemoteModel {
  /// Converts the remote model to a provider-independent domain entity.
  ConversationSessionEntity toEntity() => ConversationSessionEntity(
    id: id,
    callId: callId,
    destinationNumber: destinationNumber,
    contactId: contactId,
    preparationMarkdown: preparationMarkdown,
    status: enumFromWireName<ConversationSessionStatus>(
      ConversationSessionStatus.values,
      status,
    ),
    coachMode: enumFromWireName<CoachMode>(CoachMode.values, coachMode),
    createdAt: createdAt,
    transcriptionConsentAcknowledged: transcriptionConsentAcknowledged,
    startedAt: startedAt,
    endedAt: endedAt,
    failureReason: failureReason,
  );
}
