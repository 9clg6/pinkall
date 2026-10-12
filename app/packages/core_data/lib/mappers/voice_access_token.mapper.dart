import 'package:core_data/model/remote/voice_access_token.remote.model.dart';
import 'package:core_domain/domain/entities/voice_access_token.entity.dart';

/// Mapping extensions for ephemeral voice credentials.
extension VoiceAccessTokenRemoteModelX on VoiceAccessTokenRemoteModel {
  /// Moves the sensitive response into the non-serializable domain entity.
  VoiceAccessTokenEntity toEntity() => VoiceAccessTokenEntity(
    token: token,
    expiresAt: expiresAt,
    callerName: callerName,
    callerNumber: callerNumber,
  );
}
