import 'package:core_domain/domain/params/call_action.param.dart';
import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Ends an active, connecting, or ringing Telnyx call.
final class HangUpCallUseCase
    extends FutureUseCaseWithParams<void, CallActionParam> {
  /// Creates the use case with its [callRepository].
  HangUpCallUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Future<void> invoke(CallActionParam params) {
    return _callRepository.hangUp(params.callId);
  }
}
