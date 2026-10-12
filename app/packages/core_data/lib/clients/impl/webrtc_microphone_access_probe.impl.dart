import 'package:core_data/clients/microphone_access_probe.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// Function opening a WebRTC media stream with the supplied constraints.
typedef WebRtcUserMediaProvider =
    Future<MediaStream> Function(Map<String, dynamic> constraints);

/// Microphone permission probe backed directly by `flutter_webrtc`.
final class WebRtcMicrophoneAccessProbe implements MicrophoneAccessProbe {
  /// Creates a WebRTC microphone probe using an optional testable provider.
  const WebRtcMicrophoneAccessProbe({
    WebRtcUserMediaProvider? userMediaProvider,
  }) : _userMediaProvider = userMediaProvider;

  final WebRtcUserMediaProvider? _userMediaProvider;

  @override
  Future<void> ensureAccess() async {
    final Map<String, dynamic> constraints = <String, dynamic>{
      'audio': true,
      'video': false,
    };
    final WebRtcUserMediaProvider? provider = _userMediaProvider;
    final MediaStream stream = provider == null
        ? await navigator.mediaDevices.getUserMedia(constraints)
        : await provider(constraints);

    try {
      await Future.wait<void>(
        stream.getTracks().map((MediaStreamTrack track) => track.stop()),
      );
    } finally {
      await stream.dispose();
    }
  }
}
