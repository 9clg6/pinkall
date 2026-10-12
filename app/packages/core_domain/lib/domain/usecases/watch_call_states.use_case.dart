import 'package:core_domain/domain/entities/call_state.entity.dart';
import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Watches state transitions for incoming and outgoing calls.
final class WatchCallStatesUseCase extends StreamUseCase<CallStateEntity> {
  /// Creates the use case with its [callRepository].
  WatchCallStatesUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Stream<CallStateEntity> invoke() => _callRepository.watchCallStates();
}
