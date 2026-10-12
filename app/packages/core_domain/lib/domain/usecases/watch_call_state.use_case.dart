import 'package:core_domain/domain/entities/call_state.entity.dart';
import 'package:core_domain/domain/params/call_action.param.dart';
import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Watches the replaying state stream for one call.
final class WatchCallStateUseCase
    extends StreamUseCaseWithParams<CallStateEntity, CallActionParam> {
  /// Creates the use case with its [callRepository].
  WatchCallStateUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Stream<CallStateEntity> invoke(CallActionParam params) {
    return _callRepository.watchCallState(params.callId);
  }
}
