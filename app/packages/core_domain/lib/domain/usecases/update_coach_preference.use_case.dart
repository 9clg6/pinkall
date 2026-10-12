import 'package:core_domain/domain/entities/coach_preference.entity.dart';
import 'package:core_domain/domain/params/update_coach_preference.param.dart';
import 'package:core_domain/domain/repositories/coaching.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Changes the authenticated user's default optional-coach mode.
final class UpdateCoachPreferenceUseCase
    extends
        FutureUseCaseWithParams<
          CoachPreferenceEntity,
          UpdateCoachPreferenceParam
        > {
  /// Creates the use case with its [coachingRepository].
  UpdateCoachPreferenceUseCase({required CoachingRepository coachingRepository})
    : _repository = coachingRepository;

  final CoachingRepository _repository;

  @override
  Future<CoachPreferenceEntity> invoke(UpdateCoachPreferenceParam params) =>
      _repository.updatePreference(params);
}
