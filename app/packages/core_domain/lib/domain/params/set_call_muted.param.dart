import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_call_muted.param.freezed.dart';
part 'set_call_muted.param.g.dart';

/// Parameters used to set the microphone state of one call.
@freezed
abstract class SetCallMutedParam with _$SetCallMutedParam {
  /// Creates microphone control parameters.
  const factory SetCallMutedParam({
    required String callId,
    required bool isMuted,
  }) = _SetCallMutedParam;

  /// Creates microphone control parameters from JSON.
  factory SetCallMutedParam.fromJson(Map<String, dynamic> json) =>
      _$SetCallMutedParamFromJson(json);
}
