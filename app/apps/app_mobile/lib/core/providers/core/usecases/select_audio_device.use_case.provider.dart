import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/core/repositories/audio_device.repository.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_audio_device.use_case.provider.g.dart';

/// Provides the native audio-device selection use case.
@riverpod
SelectAudioDeviceUseCase selectAudioDeviceUseCase(Ref ref) {
  final AudioDeviceRepository repository = ref.watch(
    audioDeviceRepositoryProvider,
  );
  return SelectAudioDeviceUseCase(audioDeviceRepository: repository);
}
