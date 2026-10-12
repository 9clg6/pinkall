import 'package:core_domain/domain/enum/coach_analysis_outcome.enum.dart';
import 'package:core_domain/domain/enum/coach_analysis_status.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_status.entity.freezed.dart';

/// Provider-independent state of the optional live coach.
@freezed
abstract class CoachStatusEntity with _$CoachStatusEntity {
  /// Creates one live coach status update.
  const factory CoachStatusEntity({
    required CoachAnalysisStatus status,
    CoachAnalysisOutcome? outcome,
  }) = _CoachStatusEntity;
}
