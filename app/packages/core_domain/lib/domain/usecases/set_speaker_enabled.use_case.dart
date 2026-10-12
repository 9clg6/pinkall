import 'package:core_domain/domain/params/set_speaker_enabled.param.dart';
import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Sets the local speaker route of a Telnyx call.
final class SetSpeakerEnabledUseCase
    extends FutureUseCaseWithParams<void, SetSpeakerEnabledParam> {
  /// Creates the use case with its [callRepository].
  SetSpeakerEnabledUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Future<void> invoke(SetSpeakerEnabledParam params) {
    return _callRepository.setSpeakerEnabled(
      params.callId,
      isEnabled: params.isEnabled,
    );
  }
}
