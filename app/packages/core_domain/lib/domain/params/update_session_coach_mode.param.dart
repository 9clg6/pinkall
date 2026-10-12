// ignore_for_file: invalid_annotation_target

import 'package:core_domain/domain/enum/coach_mode.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_session_coach_mode.param.freezed.dart';
part 'update_session_coach_mode.param.g.dart';

/// Call-level override applied while a conversation session is active.
@freezed
abstract class UpdateSessionCoachModeParam with _$UpdateSessionCoachModeParam {
  /// Creates a session coaching-mode update.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory UpdateSessionCoachModeParam({
    required String sessionId,
    required CoachMode mode,
  }) = _UpdateSessionCoachModeParam;

  /// Creates a session coaching-mode update from JSON.
  factory UpdateSessionCoachModeParam.fromJson(Map<String, dynamic> json) =>
      _$UpdateSessionCoachModeParamFromJson(json);
}
