import 'package:core_domain/domain/entities/voice_access_token.entity.dart';
import 'package:core_domain/domain/params/request_voice_access_token.param.dart';

/// Boundary for obtaining ephemeral, server-issued Telnyx voice credentials.
abstract interface class VoiceAccessRepository {
  /// Requests a new short-lived credential for the authenticated device.
  Future<VoiceAccessTokenEntity> requestToken(
    RequestVoiceAccessTokenParam params,
  );
}
