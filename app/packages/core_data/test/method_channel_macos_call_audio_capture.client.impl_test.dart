import 'dart:async';

import 'package:core_data/core_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel methodChannel = MethodChannel(
    'test.pinkall.call_audio/methods',
  );
  const EventChannel systemChannel = EventChannel(
    'test.pinkall.call_audio/system',
  );
  const EventChannel microphoneChannel = EventChannel(
    'test.pinkall.call_audio/microphone',
  );
  final TestDefaultBinaryMessenger messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() async {
    messenger.setMockMethodCallHandler(methodChannel, null);
    messenger.setMockMethodCallHandler(
      const MethodChannel('test.pinkall.call_audio/system'),
      null,
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('test.pinkall.call_audio/microphone'),
      null,
    );
  });

  test(
    'starts, stops, and cancels through the native method channel',
    () async {
      final List<MethodCall> calls = <MethodCall>[];
      messenger.setMockMethodCallHandler(methodChannel, (
        MethodCall call,
      ) async {
        calls.add(call);
        return null;
      });
      final MethodChannelMacosCallAudioCaptureClientImpl client =
          MethodChannelMacosCallAudioCaptureClientImpl(
            methodChannel: methodChannel,
            systemAudioChannel: systemChannel,
            microphoneAudioChannel: microphoneChannel,
            isMacOS: () => true,
          );

      await client.start();
      await client.stop();
      await client.cancel();

      expect(calls.map((MethodCall call) => call.method), <String>[
        'start',
        'stop',
        'cancel',
      ]);
      expect(calls.first.arguments, <String, Object?>{'sampleRate': 16000});
    },
  );

  test(
    'maps native permission failures to the stable client contract',
    () async {
      messenger.setMockMethodCallHandler(methodChannel, (
        MethodCall call,
      ) async {
        throw PlatformException(
          code: 'microphone_permission_denied',
          message: 'Microphone denied.',
        );
      });
      final MethodChannelMacosCallAudioCaptureClientImpl client =
          MethodChannelMacosCallAudioCaptureClientImpl(
            methodChannel: methodChannel,
            systemAudioChannel: systemChannel,
            microphoneAudioChannel: microphoneChannel,
            isMacOS: () => true,
          );

      await expectLater(
        client.start(),
        throwsA(
          isA<MacosCallAudioCaptureException>().having(
            (MacosCallAudioCaptureException error) => error.failure,
            'failure',
            MacosCallAudioCaptureFailure.microphonePermissionDenied,
          ),
        ),
      );
    },
  );

  test('keeps system and microphone PCM events on separate streams', () async {
    const MethodChannel systemControl = MethodChannel(
      'test.pinkall.call_audio/system',
    );
    const MethodChannel microphoneControl = MethodChannel(
      'test.pinkall.call_audio/microphone',
    );
    messenger.setMockMethodCallHandler(
      systemControl,
      (MethodCall call) async => null,
    );
    messenger.setMockMethodCallHandler(
      microphoneControl,
      (MethodCall call) async => null,
    );
    final MethodChannelMacosCallAudioCaptureClientImpl client =
        MethodChannelMacosCallAudioCaptureClientImpl(
          methodChannel: methodChannel,
          systemAudioChannel: systemChannel,
          microphoneAudioChannel: microphoneChannel,
          isMacOS: () => true,
        );

    final Future<Uint8List> system = client.systemAudio.first;
    final Future<Uint8List> microphone = client.microphoneAudio.first;
    await Future<void>.delayed(Duration.zero);
    await _emitSuccess(
      messenger,
      systemControl.name,
      Uint8List.fromList(<int>[1, 2, 3, 4]),
    );
    await _emitSuccess(
      messenger,
      microphoneControl.name,
      Uint8List.fromList(<int>[5, 6, 7, 8]),
    );

    expect(await system, <int>[1, 2, 3, 4]);
    expect(await microphone, <int>[5, 6, 7, 8]);
  });

  test('rejects non-macOS callers without touching native code', () async {
    bool invoked = false;
    messenger.setMockMethodCallHandler(methodChannel, (MethodCall call) async {
      invoked = true;
      return null;
    });
    final MethodChannelMacosCallAudioCaptureClientImpl client =
        MethodChannelMacosCallAudioCaptureClientImpl(
          methodChannel: methodChannel,
          systemAudioChannel: systemChannel,
          microphoneAudioChannel: microphoneChannel,
          isMacOS: () => false,
        );

    await expectLater(
      client.start(),
      throwsA(
        isA<MacosCallAudioCaptureException>().having(
          (MacosCallAudioCaptureException error) => error.failure,
          'failure',
          MacosCallAudioCaptureFailure.unsupportedPlatform,
        ),
      ),
    );
    expect(invoked, isFalse);
  });

  test('dispose cancels a native start that is still pending', () async {
    final Completer<void> startEntered = Completer<void>();
    final Completer<void> startResult = Completer<void>();
    final List<String> calls = <String>[];
    messenger.setMockMethodCallHandler(methodChannel, (MethodCall call) async {
      calls.add(call.method);
      if (call.method == 'start') {
        startEntered.complete();
        await startResult.future;
      } else if (call.method == 'cancel') {
        startResult.complete();
      }
      return null;
    });
    final MethodChannelMacosCallAudioCaptureClientImpl client =
        MethodChannelMacosCallAudioCaptureClientImpl(
          methodChannel: methodChannel,
          systemAudioChannel: systemChannel,
          microphoneAudioChannel: microphoneChannel,
          isMacOS: () => true,
        );

    final Future<void> starting = expectLater(
      client.start(),
      throwsA(
        isA<MacosCallAudioCaptureException>().having(
          (MacosCallAudioCaptureException error) => error.failure,
          'failure',
          MacosCallAudioCaptureFailure.disposed,
        ),
      ),
    );
    await startEntered.future;
    await client.dispose();

    await starting;
    expect(calls, <String>['start', 'cancel']);
  });
}

Future<void> _emitSuccess(
  TestDefaultBinaryMessenger messenger,
  String channel,
  Uint8List value,
) async {
  final Completer<void> handled = Completer<void>();
  await messenger.handlePlatformMessage(
    channel,
    const StandardMethodCodec().encodeSuccessEnvelope(value),
    (ByteData? response) => handled.complete(),
  );
  await handled.future;
}
