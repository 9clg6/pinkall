import 'package:core_domain/domain/entities/incoming_call_capability.entity.dart';
import 'package:core_domain/domain/repositories/incoming_call.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Reads native incoming-call readiness without inferring missing credentials.
final class InspectIncomingCallCapabilityUseCase
    extends FutureUseCase<IncomingCallCapabilityEntity> {
  /// Creates the use case.
  InspectIncomingCallCapabilityUseCase({
    required IncomingCallRepository incomingCallRepository,
  }) : _repository = incomingCallRepository;

  final IncomingCallRepository _repository;

  @override
  Future<IncomingCallCapabilityEntity> invoke() =>
      _repository.inspectCapability();
}
