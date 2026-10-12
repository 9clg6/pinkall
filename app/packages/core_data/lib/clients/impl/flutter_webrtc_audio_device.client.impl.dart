import 'package:core_data/clients/audio_device.client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Function enumerating WebRTC devices of the requested native kind.
typedef WebRtcAudioDeviceEnumerator =
    Future<List<MediaDeviceInfo>> Function(String kind);

/// Function selecting a native WebRTC audio device by identifier.
typedef WebRtcAudioDeviceSelector = Future<void> Function(String deviceId);

/// macOS audio-device routing backed by `flutter_webrtc`.
final class FlutterWebRtcAudioDeviceClient implements AudioDeviceClient {
  /// Creates an audio-device client with optional unit-test seams.
  const FlutterWebRtcAudioDeviceClient({
    WebRtcAudioDeviceEnumerator? deviceEnumerator,
    WebRtcAudioDeviceSelector? inputSelector,
    WebRtcAudioDeviceSelector? outputSelector,
  }) : _deviceEnumerator = deviceEnumerator,
       _inputSelector = inputSelector,
       _outputSelector = outputSelector;

  static const String _audioInputKind = 'audioinput';
  static const String _audioOutputKind = 'audiooutput';

  final WebRtcAudioDeviceEnumerator? _deviceEnumerator;
  final WebRtcAudioDeviceSelector? _inputSelector;
  final WebRtcAudioDeviceSelector? _outputSelector;

  @override
  Future<List<AudioDeviceDescriptor>> listInputs() {
    return _listDevices(_audioInputKind, AudioDeviceKind.input);
  }

  @override
  Future<List<AudioDeviceDescriptor>> listOutputs() {
    return _listDevices(_audioOutputKind, AudioDeviceKind.output);
  }

  @override
  Future<void> selectInput(String deviceId) {
    final String normalizedId = _validateDeviceId(deviceId);
    final WebRtcAudioDeviceSelector? selector = _inputSelector;
    return selector == null
        ? Helper.selectAudioInput(normalizedId)
        : selector(normalizedId);
  }

  @override
  Future<void> selectOutput(String deviceId) {
    final String normalizedId = _validateDeviceId(deviceId);
    final WebRtcAudioDeviceSelector? selector = _outputSelector;
    return selector == null
        ? Helper.selectAudioOutput(normalizedId)
        : selector(normalizedId);
  }

  Future<List<AudioDeviceDescriptor>> _listDevices(
    String nativeKind,
    AudioDeviceKind kind,
  ) async {
    final WebRtcAudioDeviceEnumerator? enumerator = _deviceEnumerator;
    final List<MediaDeviceInfo> devices = enumerator == null
        ? await Helper.enumerateDevices(nativeKind)
        : await enumerator(nativeKind);

    return <AudioDeviceDescriptor>[
      for (final MediaDeviceInfo device in devices)
        if (device.deviceId.trim().isNotEmpty)
          AudioDeviceDescriptor(
            id: device.deviceId.trim(),
            label: device.label.trim(),
            kind: kind,
            groupId: _nullIfBlank(device.groupId),
          ),
    ];
  }

  String _validateDeviceId(String deviceId) {
    final String normalizedId = deviceId.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError.value(
        deviceId,
        'deviceId',
        'An audio device identifier is required',
      );
    }
    return normalizedId;
  }

  String? _nullIfBlank(String? value) {
    final String? normalizedValue = value?.trim();
    if (normalizedValue == null || normalizedValue.isEmpty) {
      return null;
    }
    return normalizedValue;
  }
}
