import 'package:core_domain/domain/params/select_audio_device.param.dart';
import 'package:core_domain/domain/repositories/audio_device.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Routes WebRTC capture or playback through a selected native device.
final class SelectAudioDeviceUseCase
    extends FutureUseCaseWithParams<void, SelectAudioDeviceParam> {
  /// Creates the use case with its [audioDeviceRepository].
  SelectAudioDeviceUseCase({
    required AudioDeviceRepository audioDeviceRepository,
  }) : _audioDeviceRepository = audioDeviceRepository;

  final AudioDeviceRepository _audioDeviceRepository;

  @override
  Future<void> invoke(SelectAudioDeviceParam params) {
    return _audioDeviceRepository.selectDevice(
      params.deviceId,
      kind: params.kind,
    );
  }
}
