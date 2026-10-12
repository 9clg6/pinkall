import 'package:core_domain/domain/entities/incoming_call_capability.entity.dart';
import 'package:core_domain/domain/repositories/incoming_call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Initializes background incoming calls only when native configuration allows.
final class InitializeIncomingCallsUseCase
    extends FutureUseCase<IncomingCallCapabilityEntity> {
  /// Creates the use case.
  InitializeIncomingCallsUseCase({
    required IncomingCallRepository incomingCallRepository,
  }) : _repository = incomingCallRepository;

  final IncomingCallRepository _repository;

  @override
  Future<IncomingCallCapabilityEntity> invoke() => _repository.initialize();
}
