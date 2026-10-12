import 'package:core_data/clients/audio_device.client.dart';
import 'package:core_data/mappers/audio_device.mapper.dart';
import 'package:core_domain/core_domain.dart' as domain;

/// `flutter_webrtc` implementation of the audio-device repository.
final class AudioDeviceRepositoryImpl implements domain.AudioDeviceRepository {
  /// Creates the repository with its testable [audioDeviceClient].
  const AudioDeviceRepositoryImpl({
    required AudioDeviceClient audioDeviceClient,
  }) : _audioDeviceClient = audioDeviceClient;

  final AudioDeviceClient _audioDeviceClient;

  @override
  Future<List<domain.AudioDeviceEntity>> listDevices() async {
    final List<AudioDeviceDescriptor> inputs = await _audioDeviceClient
        .listInputs();
    final List<AudioDeviceDescriptor> outputs = await _audioDeviceClient
        .listOutputs();
    return List<domain.AudioDeviceEntity>.unmodifiable(
      <AudioDeviceDescriptor>[
        ...inputs,
        ...outputs,
      ].map((AudioDeviceDescriptor device) => device.toEntity()),
    );
  }

  @override
  Future<void> selectDevice(
    String deviceId, {
    required domain.AudioDeviceKind kind,
  }) {
    return switch (kind) {
      domain.AudioDeviceKind.input => _audioDeviceClient.selectInput(deviceId),
      domain.AudioDeviceKind.output => _audioDeviceClient.selectOutput(
        deviceId,
      ),
    };
  }
}
