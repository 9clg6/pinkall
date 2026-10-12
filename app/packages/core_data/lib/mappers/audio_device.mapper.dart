import 'package:core_data/clients/audio_device.client.dart' as data;
import 'package:core_domain/core_domain.dart' as domain;

/// Maps one native WebRTC descriptor to the call domain.
extension AudioDeviceDescriptorMapper on data.AudioDeviceDescriptor {
  /// Converts this descriptor into a platform-neutral domain entity.
  domain.AudioDeviceEntity toEntity() {
    return domain.AudioDeviceEntity(
      id: id,
      label: label,
      kind: switch (kind) {
        data.AudioDeviceKind.input => domain.AudioDeviceKind.input,
        data.AudioDeviceKind.output => domain.AudioDeviceKind.output,
      },
      groupId: groupId,
    );
  }
}
