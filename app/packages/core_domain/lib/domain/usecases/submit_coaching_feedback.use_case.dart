import 'package:core_domain/domain/entities/coaching_feedback.entity.dart';
import 'package:core_domain/domain/params/submit_coaching_feedback.param.dart';
import 'package:core_domain/domain/repositories/coaching.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Persists explicit feedback about a live or shadow coaching suggestion.
final class SubmitCoachingFeedbackUseCase
    extends
        FutureUseCaseWithParams<
          CoachingFeedbackEntity,
          SubmitCoachingFeedbackParam
        > {
  /// Creates the use case with its [coachingRepository].
  SubmitCoachingFeedbackUseCase({
    required CoachingRepository coachingRepository,
  }) : _repository = coachingRepository;

  final CoachingRepository _repository;

  @override
  Future<CoachingFeedbackEntity> invoke(SubmitCoachingFeedbackParam params) =>
      _repository.submitFeedback(params);
}
