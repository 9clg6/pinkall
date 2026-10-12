// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_coaching_progress.param.freezed.dart';
part 'get_coaching_progress.param.g.dart';

/// Parameters controlling the recent and comparison call windows.
@freezed
abstract class GetCoachingProgressParam with _$GetCoachingProgressParam {
  /// Creates a progress request.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GetCoachingProgressParam({
    @Default(5) int windowSize,
    @Default(20) int recentLimit,
  }) = _GetCoachingProgressParam;

  /// Parses persisted request parameters.
  factory GetCoachingProgressParam.fromJson(Map<String, dynamic> json) =>
      _$GetCoachingProgressParamFromJson(json);
}
