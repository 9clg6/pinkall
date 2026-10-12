import 'package:core_data/core_data.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('test.recording_import');
  final MethodChannelRecordingImportClientImpl client =
      MethodChannelRecordingImportClientImpl(channel: channel);

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('decodes a safe app-owned audio import', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          expect(call.method, 'consumePendingAction');
          return <String, Object?>{
            'kind': 'audio_file',
            'id': 'recording_12345678',
            'name': 'appel-acme.m4a',
            'mime_type': 'audio/mp4',
            'path': '/tmp/pinkall/recording_12345678.m4a',
            'size_bytes': 42000,
          };
        });

    final RecordingImportAction? action = await client.consumePendingAction();

    expect(action, isA<RecordingAudioImport>());
    final RecordingAudioImport audio = action! as RecordingAudioImport;
    expect(audio.name, 'appel-acme.m4a');
    expect(audio.mimeType, 'audio/mp4');
    expect(audio.sizeBytes, 42000);
  });

  test(
    'decodes a native picker shortcut without inventing an audio file',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (_) async => <String, Object?>{'kind': 'pick_recording'},
          );

      expect(
        await client.consumePendingAction(),
        isA<RecordingImportPickerRequested>(),
      );
    },
  );

  test('rejects native paths and MIME metadata outside the contract', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (_) async => <String, Object?>{
            'kind': 'audio_file',
            'id': 'recording_12345678',
            'name': '../secret.txt',
            'mime_type': 'text/plain',
            'path': '/private/secret.txt',
            'size_bytes': 42,
          },
        );

    await expectLater(
      client.consumePendingAction(),
      throwsA(
        isA<RecordingImportException>().having(
          (RecordingImportException value) => value.failure,
          'failure',
          RecordingImportFailure.invalidResponse,
        ),
      ),
    );
  });

  test('native picker returns one bounded app-owned audio copy', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          expect(call.method, 'pickRecording');
          return <String, Object?>{
            'kind': 'audio_file',
            'id': 'picked_12345678',
            'name': 'discovery.wav',
            'mime_type': 'audio/wav',
            'path': '/tmp/pinkall/picked_12345678.wav',
            'size_bytes': 84000,
          };
        });

    final RecordingAudioImport? audio = await client.pickRecording();

    expect(audio?.id, 'picked_12345678');
    expect(audio?.path, '/tmp/pinkall/picked_12345678.wav');
  });

  test('discards by opaque id only', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
          expect(call.method, 'discardImport');
          expect(call.arguments, <String, Object?>{'id': 'recording_12345678'});
          return null;
        });

    await client.discardImport('recording_12345678');
  });
}
