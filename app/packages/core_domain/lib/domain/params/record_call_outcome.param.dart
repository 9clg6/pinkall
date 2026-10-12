// ignore_for_file: invalid_annotation_target

import 'package:core_domain/domain/enum/call_outcome_type.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_call_outcome.param.freezed.dart';
part 'record_call_outcome.param.g.dart';

/// Commercial outcome the user records for a Pinkall session.
@freezed
abstract class RecordCallOutcomeParam with _$RecordCallOutcomeParam {
  /// Creates call outcome parameters.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RecordCallOutcomeParam({
    required String sessionId,
    required CallOutcomeType type,
    String? note,
  }) = _RecordCallOutcomeParam;

  /// Creates call outcome parameters from JSON.
  factory RecordCallOutcomeParam.fromJson(Map<String, dynamic> json) =>
      _$RecordCallOutcomeParamFromJson(json);
}
