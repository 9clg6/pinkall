import 'package:core_domain/domain/enum/audio_device_kind.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_audio_device.param.freezed.dart';
part 'select_audio_device.param.g.dart';

/// Parameters used to route one side of WebRTC audio to a native device.
@freezed
abstract class SelectAudioDeviceParam with _$SelectAudioDeviceParam {
  /// Creates audio-device selection parameters.
  const factory SelectAudioDeviceParam({
    required String deviceId,
    required AudioDeviceKind kind,
  }) = _SelectAudioDeviceParam;

  /// Creates audio-device selection parameters from JSON.
  factory SelectAudioDeviceParam.fromJson(Map<String, dynamic> json) =>
      _$SelectAudioDeviceParamFromJson(json);
}
