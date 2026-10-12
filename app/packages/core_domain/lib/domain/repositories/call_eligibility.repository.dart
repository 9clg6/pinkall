import 'package:core_domain/domain/entities/call_eligibility.entity.dart';
import 'package:core_domain/domain/params/evaluate_call_eligibility.param.dart';

/// Contract for the versioned server-side outbound-call policy evaluator.
abstract interface class CallEligibilityRepository {
  /// Evaluates known facts without embedding mutable legal rules in the client.
  Future<CallEligibilityEntity> evaluate(EvaluateCallEligibilityParam params);
}
