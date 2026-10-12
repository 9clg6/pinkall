/// Direction of a selectable audio device.
enum AudioDeviceKind {
  /// Audio capture device, such as a microphone.
  input,

  /// Audio playback device, such as headphones or speakers.
  output,
}

/// Platform-neutral description of an audio device exposed by WebRTC.
final class AudioDeviceDescriptor {
  /// Creates an immutable audio device description.
  const AudioDeviceDescriptor({
    required this.id,
    required this.label,
    required this.kind,
    this.groupId,
  });

  /// Native WebRTC device identifier used for selection.
  final String id;

  /// Human-readable device name supplied by the operating system.
  final String label;

  /// Whether this device captures or plays audio.
  final AudioDeviceKind kind;

  /// Optional identifier shared by inputs and outputs on one physical device.
  final String? groupId;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AudioDeviceDescriptor &&
            other.id == id &&
            other.label == label &&
            other.kind == kind &&
            other.groupId == groupId;
  }

  @override
  int get hashCode => Object.hash(id, label, kind, groupId);
}

/// Testable boundary for enumerating and selecting desktop audio devices.
abstract interface class AudioDeviceClient {
  /// Returns available WebRTC microphone devices.
  Future<List<AudioDeviceDescriptor>> listInputs();

  /// Returns available WebRTC playback devices.
  Future<List<AudioDeviceDescriptor>> listOutputs();

  /// Routes subsequent WebRTC audio capture through [deviceId].
  Future<void> selectInput(String deviceId);

  /// Routes WebRTC audio playback through [deviceId].
  Future<void> selectOutput(String deviceId);
}
