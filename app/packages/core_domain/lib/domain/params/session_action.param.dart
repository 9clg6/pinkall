// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_action.param.freezed.dart';
part 'session_action.param.g.dart';

/// Identifies a Pinkall backend session for a single operation.
@freezed
abstract class SessionActionParam with _$SessionActionParam {
  /// Creates session action parameters.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory SessionActionParam({required String sessionId}) =
      _SessionActionParam;

  /// Creates session action parameters from JSON.
  factory SessionActionParam.fromJson(Map<String, dynamic> json) =>
      _$SessionActionParamFromJson(json);
}
