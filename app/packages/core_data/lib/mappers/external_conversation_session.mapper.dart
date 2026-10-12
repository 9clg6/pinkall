import 'package:core_data/mappers/conversation_session.mapper.dart';
import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/external_conversation_session.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Mapping extensions for external media-session responses.
extension ExternalConversationSessionRemoteModelX
    on ExternalConversationSessionRemoteModel {
  /// Converts the remote model to provider-independent domain values.
  ExternalConversationSessionEntity toEntity() =>
      ExternalConversationSessionEntity(
        session: session.toEntity(),
        source: enumFromWireName<ExternalConversationSource>(
          ExternalConversationSource.values,
          source,
        ),
        locale: locale,
        mediaToken: mediaToken,
        consentRequired: consentRequired,
        title: title,
        media: ExternalMediaConfigurationEntity(
          encoding: media.encoding,
          sampleRate: media.sampleRate,
          channels: media.channels,
          sellerWebSocketUri: Uri.parse(media.sellerWebsocketUrl),
          prospectWebSocketUri: Uri.parse(media.prospectWebsocketUrl),
        ),
      );
}
