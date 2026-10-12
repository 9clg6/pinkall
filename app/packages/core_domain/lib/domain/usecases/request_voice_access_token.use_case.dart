import 'package:core_domain/domain/entities/voice_access_token.entity.dart';
import 'package:core_domain/domain/params/request_voice_access_token.param.dart';
import 'package:core_domain/domain/repositories/voice_access.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Obtains a short-lived Telnyx token from the authenticated Pinkall backend.
final class RequestVoiceAccessTokenUseCase
    extends
        FutureUseCaseWithParams<
          VoiceAccessTokenEntity,
          RequestVoiceAccessTokenParam
        > {
  /// Creates the use case with its [voiceAccessRepository].
  RequestVoiceAccessTokenUseCase({
    required VoiceAccessRepository voiceAccessRepository,
  }) : _repository = voiceAccessRepository;

  final VoiceAccessRepository _repository;

  @override
  Future<VoiceAccessTokenEntity> invoke(RequestVoiceAccessTokenParam params) =>
      _repository.requestToken(params);
}
