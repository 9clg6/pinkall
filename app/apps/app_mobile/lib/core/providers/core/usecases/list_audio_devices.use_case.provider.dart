import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/audio_device.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_audio_devices.use_case.provider.g.dart';

/// Provides the native audio-device enumeration use case.
@riverpod
ListAudioDevicesUseCase listAudioDevicesUseCase(Ref ref) {
  final AudioDeviceRepository repository = ref.watch(
    audioDeviceRepositoryProvider,
  );
  return ListAudioDevicesUseCase(audioDeviceRepository: repository);
}
