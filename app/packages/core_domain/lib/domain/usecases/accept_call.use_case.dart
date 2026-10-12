import 'package:core_domain/domain/params/call_action.param.dart';
import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Accepts an incoming Telnyx call.
final class AcceptCallUseCase
    extends FutureUseCaseWithParams<void, CallActionParam> {
  /// Creates the use case with its [callRepository].
  AcceptCallUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Future<void> invoke(CallActionParam params) {
    return _callRepository.accept(params.callId);
  }
}
