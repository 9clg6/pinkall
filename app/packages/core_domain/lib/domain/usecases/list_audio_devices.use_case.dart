import 'package:core_domain/domain/entities/audio_device.entity.dart';
import 'package:core_domain/domain/repositories/audio_device.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Lists native input and output devices available for a WebRTC call.
final class ListAudioDevicesUseCase
    extends FutureUseCase<List<AudioDeviceEntity>> {
  /// Creates the use case with its [audioDeviceRepository].
  ListAudioDevicesUseCase({
    required AudioDeviceRepository audioDeviceRepository,
  }) : _audioDeviceRepository = audioDeviceRepository;

  final AudioDeviceRepository _audioDeviceRepository;

  @override
  Future<List<AudioDeviceEntity>> invoke() {
    return _audioDeviceRepository.listDevices();
  }
}
