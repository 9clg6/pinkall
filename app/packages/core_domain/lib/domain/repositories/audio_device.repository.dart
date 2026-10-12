import 'package:core_domain/domain/entities/audio_device.entity.dart';
import 'package:core_domain/domain/enum/audio_device_kind.enum.dart';

/// Contract exposing native call audio devices without platform SDK types.
abstract interface class AudioDeviceRepository {
  /// Returns all available microphone and playback devices.
  Future<List<AudioDeviceEntity>> listDevices();

  /// Routes [kind] through the native device identified by [deviceId].
  Future<void> selectDevice(String deviceId, {required AudioDeviceKind kind});
}
