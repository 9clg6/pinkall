import 'package:core_domain/domain/entities/telnyx_connection_state.entity.dart';
import 'package:core_domain/domain/repositories/call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Watches Telnyx connection and registration transitions.
final class WatchTelnyxConnectionStatesUseCase
    extends StreamUseCase<TelnyxConnectionStateEntity> {
  /// Creates the use case with its [callRepository].
  WatchTelnyxConnectionStatesUseCase({required CallRepository callRepository})
    : _callRepository = callRepository;

  final CallRepository _callRepository;

  @override
  Stream<TelnyxConnectionStateEntity> invoke() {
    return _callRepository.watchConnectionStates();
  }
}
