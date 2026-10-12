import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart' as domain;
import 'package:test/test.dart';

void main() {
  group('AudioDeviceRepositoryImpl', () {
    test('maps input and output descriptors in native order', () async {
      final _FakeAudioDeviceClient client = _FakeAudioDeviceClient();
      final AudioDeviceRepositoryImpl repository = AudioDeviceRepositoryImpl(
        audioDeviceClient: client,
      );

      expect(await repository.listDevices(), const <domain.AudioDeviceEntity>[
        domain.AudioDeviceEntity(
          id: 'mic-1',
          label: 'Studio Mic',
          kind: domain.AudioDeviceKind.input,
          groupId: 'studio',
        ),
        domain.AudioDeviceEntity(
          id: 'output-1',
          label: 'Studio Display',
          kind: domain.AudioDeviceKind.output,
        ),
      ]);
    });

    test(
      'routes input and output selection to the matching SDK method',
      () async {
        final _FakeAudioDeviceClient client = _FakeAudioDeviceClient();
        final AudioDeviceRepositoryImpl repository = AudioDeviceRepositoryImpl(
          audioDeviceClient: client,
        );

        await repository.selectDevice(
          'mic-1',
          kind: domain.AudioDeviceKind.input,
        );
        await repository.selectDevice(
          'output-1',
          kind: domain.AudioDeviceKind.output,
        );

        expect(client.selectedInputId, 'mic-1');
        expect(client.selectedOutputId, 'output-1');
      },
    );
  });
}

final class _FakeAudioDeviceClient implements AudioDeviceClient {
  String? selectedInputId;
  String? selectedOutputId;

  @override
  Future<List<AudioDeviceDescriptor>> listInputs() async {
    return const <AudioDeviceDescriptor>[
      AudioDeviceDescriptor(
        id: 'mic-1',
        label: 'Studio Mic',
        kind: AudioDeviceKind.input,
        groupId: 'studio',
      ),
    ];
  }

  @override
  Future<List<AudioDeviceDescriptor>> listOutputs() async {
    return const <AudioDeviceDescriptor>[
      AudioDeviceDescriptor(
        id: 'output-1',
        label: 'Studio Display',
        kind: AudioDeviceKind.output,
      ),
    ];
  }

  @override
  Future<void> selectInput(String deviceId) async {
    selectedInputId = deviceId;
  }

  @override
  Future<void> selectOutput(String deviceId) async {
    selectedOutputId = deviceId;
  }
}
