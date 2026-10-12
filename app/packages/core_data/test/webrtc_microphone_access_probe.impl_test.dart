import 'package:core_data/clients/impl/webrtc_microphone_access_probe.impl.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:test/test.dart';

void main() {
  group('WebRtcMicrophoneAccessProbe', () {
    test('requests audio only, then stops and disposes the stream', () async {
      final _FakeMediaStreamTrack track = _FakeMediaStreamTrack();
      final _FakeMediaStream stream = _FakeMediaStream(<MediaStreamTrack>[
        track,
      ]);
      Map<String, dynamic>? requestedConstraints;
      final WebRtcMicrophoneAccessProbe probe = WebRtcMicrophoneAccessProbe(
        userMediaProvider: (Map<String, dynamic> constraints) async {
          requestedConstraints = constraints;
          return stream;
        },
      );

      await probe.ensureAccess();

      expect(requestedConstraints, <String, dynamic>{
        'audio': true,
        'video': false,
      });
      expect(track.didStop, isTrue);
      expect(stream.didDispose, isTrue);
    });

    test('still disposes the stream when stopping a track fails', () async {
      final _FakeMediaStream stream = _FakeMediaStream(<MediaStreamTrack>[
        _FakeMediaStreamTrack(exception: StateError('stop failed')),
      ]);
      final WebRtcMicrophoneAccessProbe probe = WebRtcMicrophoneAccessProbe(
        userMediaProvider: (Map<String, dynamic> _) async => stream,
      );

      await expectLater(probe.ensureAccess(), throwsStateError);

      expect(stream.didDispose, isTrue);
    });
  });
}

final class _FakeMediaStream implements MediaStream {
  _FakeMediaStream(this._tracks);

  final List<MediaStreamTrack> _tracks;
  bool didDispose = false;

  @override
  Future<void> dispose() async {
    didDispose = true;
  }

  @override
  List<MediaStreamTrack> getTracks() => _tracks;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeMediaStreamTrack implements MediaStreamTrack {
  _FakeMediaStreamTrack({this.exception});

  final Object? exception;
  bool didStop = false;

  @override
  Future<void> stop() async {
    didStop = true;
    final Object? currentException = exception;
    if (currentException != null) {
      throw currentException;
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
