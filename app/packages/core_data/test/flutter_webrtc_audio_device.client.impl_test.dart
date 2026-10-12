import 'package:core_data/clients/audio_device.client.dart';
import 'package:core_data/clients/impl/flutter_webrtc_audio_device.client.impl.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:test/test.dart';

void main() {
  group('FlutterWebRtcAudioDeviceClient', () {
    test('enumerates and maps macOS input and output devices', () async {
      final List<String> requestedKinds = <String>[];
      final FlutterWebRtcAudioDeviceClient client =
          FlutterWebRtcAudioDeviceClient(
            deviceEnumerator: (String kind) async {
              requestedKinds.add(kind);
              return switch (kind) {
                'audioinput' => <MediaDeviceInfo>[
                  MediaDeviceInfo(
                    kind: kind,
                    label: ' Studio Mic ',
                    groupId: ' studio ',
                    deviceId: ' input-1 ',
                  ),
                  MediaDeviceInfo(kind: kind, label: 'Invalid', deviceId: ' '),
                ],
                'audiooutput' => <MediaDeviceInfo>[
                  MediaDeviceInfo(
                    kind: kind,
                    label: 'Studio Display',
                    groupId: '',
                    deviceId: 'output-1',
                  ),
                ],
                _ => <MediaDeviceInfo>[],
              };
            },
          );

      expect(await client.listInputs(), const <AudioDeviceDescriptor>[
        AudioDeviceDescriptor(
          id: 'input-1',
          label: 'Studio Mic',
          kind: AudioDeviceKind.input,
          groupId: 'studio',
        ),
      ]);
      expect(await client.listOutputs(), const <AudioDeviceDescriptor>[
        AudioDeviceDescriptor(
          id: 'output-1',
          label: 'Studio Display',
          kind: AudioDeviceKind.output,
        ),
      ]);
      expect(requestedKinds, <String>['audioinput', 'audiooutput']);
    });

    test('delegates trimmed input and output device identifiers', () async {
      String? selectedInput;
      String? selectedOutput;
      final FlutterWebRtcAudioDeviceClient client =
          FlutterWebRtcAudioDeviceClient(
            inputSelector: (String deviceId) async {
              selectedInput = deviceId;
            },
            outputSelector: (String deviceId) async {
              selectedOutput = deviceId;
            },
          );

      await client.selectInput(' input-1 ');
      await client.selectOutput(' output-1 ');

      expect(selectedInput, 'input-1');
      expect(selectedOutput, 'output-1');
    });

    test('rejects an empty device identifier before native selection', () {
      final FlutterWebRtcAudioDeviceClient client =
          FlutterWebRtcAudioDeviceClient(
            inputSelector: (String _) async {
              fail('The native selector must not be called');
            },
          );

      expect(() => client.selectInput('  '), throwsArgumentError);
    });
  });
}
