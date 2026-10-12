import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/data/endpoint/audio_device.client.provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_device.repository.provider.g.dart';

/// Provides the native WebRTC audio-device repository.
@riverpod
AudioDeviceRepository audioDeviceRepository(Ref ref) {
  final AudioDeviceClient client = ref.watch(audioDeviceClientProvider);
  return AudioDeviceRepositoryImpl(audioDeviceClient: client);
}
