import 'package:core_domain/domain/entities/call_eligibility.entity.dart';
import 'package:core_domain/domain/params/evaluate_call_eligibility.param.dart';
import 'package:core_domain/domain/repositories/call_eligibility.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Evaluates whether an outbound call is allowed under the backend policy.
final class EvaluateCallEligibilityUseCase
    extends
        FutureUseCaseWithParams<
          CallEligibilityEntity,
          EvaluateCallEligibilityParam
        > {
  /// Creates the use case with its [callEligibilityRepository].
  EvaluateCallEligibilityUseCase({
    required CallEligibilityRepository callEligibilityRepository,
  }) : _repository = callEligibilityRepository;

  final CallEligibilityRepository _repository;

  @override
  Future<CallEligibilityEntity> invoke(EvaluateCallEligibilityParam params) =>
      _repository.evaluate(params);
}
