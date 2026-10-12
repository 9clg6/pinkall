import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_action.param.freezed.dart';
part 'call_action.param.g.dart';

/// Parameters targeting a single call.
@freezed
abstract class CallActionParam with _$CallActionParam {
  /// Creates call action parameters.
  const factory CallActionParam({required String callId}) = _CallActionParam;

  /// Creates call action parameters from JSON.
  factory CallActionParam.fromJson(Map<String, dynamic> json) =>
      _$CallActionParamFromJson(json);
}
