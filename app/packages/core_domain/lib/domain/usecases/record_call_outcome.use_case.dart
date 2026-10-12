import 'package:core_domain/domain/entities/call_outcome.entity.dart';
import 'package:core_domain/domain/params/record_call_outcome.param.dart';
import 'package:core_domain/domain/repositories/coaching.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Records the user-qualified commercial outcome of a call session.
final class RecordCallOutcomeUseCase
    extends FutureUseCaseWithParams<CallOutcomeEntity, RecordCallOutcomeParam> {
  /// Creates the use case with its [coachingRepository].
  RecordCallOutcomeUseCase({required CoachingRepository coachingRepository})
    : _repository = coachingRepository;

  final CoachingRepository _repository;

  @override
  Future<CallOutcomeEntity> invoke(RecordCallOutcomeParam params) =>
      _repository.recordOutcome(params);
}
