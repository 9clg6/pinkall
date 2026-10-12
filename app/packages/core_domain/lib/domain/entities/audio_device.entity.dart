import 'package:core_domain/domain/enum/audio_device_kind.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_device.entity.freezed.dart';

/// Platform-neutral audio device available during a call.
@freezed
abstract class AudioDeviceEntity with _$AudioDeviceEntity {
  /// Creates an immutable audio device.
  const factory AudioDeviceEntity({
    required String id,
    required String label,
    required AudioDeviceKind kind,
    String? groupId,
  }) = _AudioDeviceEntity;
}
