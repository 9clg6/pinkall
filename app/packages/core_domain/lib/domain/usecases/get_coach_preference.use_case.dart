import 'package:core_domain/domain/entities/coach_preference.entity.dart';
import 'package:core_domain/domain/repositories/coaching.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Retrieves the authenticated user's default optional-coach mode.
final class GetCoachPreferenceUseCase
    extends FutureUseCase<CoachPreferenceEntity> {
  /// Creates the use case with its [coachingRepository].
  GetCoachPreferenceUseCase({required CoachingRepository coachingRepository})
    : _repository = coachingRepository;

  final CoachingRepository _repository;

  @override
  Future<CoachPreferenceEntity> invoke() => _repository.getPreference();
}
