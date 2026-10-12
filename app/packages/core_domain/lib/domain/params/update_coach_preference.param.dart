// ignore_for_file: invalid_annotation_target

import 'package:core_domain/domain/enum/coach_mode.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_coach_preference.param.freezed.dart';
part 'update_coach_preference.param.g.dart';

/// Parameters for changing the user's default optional-coach mode.
@freezed
abstract class UpdateCoachPreferenceParam with _$UpdateCoachPreferenceParam {
  /// Creates a coaching preference update.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UpdateCoachPreferenceParam({required CoachMode defaultMode}) =
      _UpdateCoachPreferenceParam;

  /// Creates a coaching preference update from JSON.
  factory UpdateCoachPreferenceParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateCoachPreferenceParamFromJson(json);
}
