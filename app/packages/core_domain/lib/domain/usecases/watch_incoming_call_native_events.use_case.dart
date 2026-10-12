import 'package:core_domain/domain/entities/incoming_call_native_event.entity.dart';
import 'package:core_domain/domain/repositories/incoming_call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Watches native push and system-call actions as explicit domain events.
final class WatchIncomingCallNativeEventsUseCase
    extends StreamUseCase<IncomingCallNativeEventEntity> {
  /// Creates the use case.
  WatchIncomingCallNativeEventsUseCase({
    required IncomingCallRepository incomingCallRepository,
  }) : _repository = incomingCallRepository;

  final IncomingCallRepository _repository;

  @override
  Stream<IncomingCallNativeEventEntity> invoke() =>
      _repository.watchNativeEvents();
}
