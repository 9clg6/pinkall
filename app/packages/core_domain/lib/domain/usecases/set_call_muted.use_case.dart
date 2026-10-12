import 'package:core_domain/domain/params/set_call_muted.param.dart';
import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Sets the local microphone state of a Telnyx call.
final class SetCallMutedUseCase
    extends FutureUseCaseWithParams<void, SetCallMutedParam> {
  /// Creates the use case with its [callRepository].
  SetCallMutedUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Future<void> invoke(SetCallMutedParam params) {
    return _callRepository.setMuted(params.callId, isMuted: params.isMuted);
  }
}
