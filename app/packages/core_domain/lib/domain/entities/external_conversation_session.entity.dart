import 'package:core_domain/domain/entities/conversation_session.entity.dart';
import 'package:core_domain/domain/entities/external_media_configuration.entity.dart';
import 'package:core_domain/domain/enum/external_conversation_source.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_conversation_session.entity.freezed.dart';

/// Session and short-lived media credentials for an external conversation.
@freezed
abstract class ExternalConversationSessionEntity
    with _$ExternalConversationSessionEntity {
  /// Creates an external conversation launch contract.
  const factory ExternalConversationSessionEntity({
    required ConversationSessionEntity session,
    required ExternalConversationSource source,
    required String locale,
    required String mediaToken,
    required ExternalMediaConfigurationEntity media,
    @Default(true) bool consentRequired,
    String? title,
  }) = _ExternalConversationSessionEntity;
}
