import 'package:core_domain/domain/enum/coach_mode.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coach_preference.entity.freezed.dart';

/// User-level default for optional Pinkall coaching.
@freezed
abstract class CoachPreferenceEntity with _$CoachPreferenceEntity {
  /// Creates a coaching preference.
  const factory CoachPreferenceEntity({
    required CoachMode defaultMode,
    required DateTime updatedAt,
  }) = _CoachPreferenceEntity;
}
