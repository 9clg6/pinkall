import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_speaker_enabled.param.freezed.dart';
part 'set_speaker_enabled.param.g.dart';

/// Parameters used to set the speaker route of one call.
@freezed
abstract class SetSpeakerEnabledParam with _$SetSpeakerEnabledParam {
  /// Creates speaker control parameters.
  const factory SetSpeakerEnabledParam({
    required String callId,
    required bool isEnabled,
  }) = _SetSpeakerEnabledParam;

  /// Creates speaker control parameters from JSON.
  factory SetSpeakerEnabledParam.fromJson(Map<String, dynamic> json) =>
      _$SetSpeakerEnabledParamFromJson(json);
}
