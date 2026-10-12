import 'package:core_domain/core_domain.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:test/test.dart';

void main() {
  group('audio-device use cases', () {
    test('lists native devices without exposing platform SDK types', () async {
      final _FakeAudioDeviceRepository repository =
          _FakeAudioDeviceRepository();

      final ResultState<List<AudioDeviceEntity>> result =
          await ListAudioDevicesUseCase(
            audioDeviceRepository: repository,
          ).execute();

      expect(
        result,
        const ResultState<List<AudioDeviceEntity>>.success(<AudioDeviceEntity>[
          AudioDeviceEntity(
            id: 'mic-1',
            label: 'Studio Mic',
            kind: AudioDeviceKind.input,
          ),
        ]),
      );
    });

    test('selects the requested input or output device', () async {
      final _FakeAudioDeviceRepository repository =
          _FakeAudioDeviceRepository();
      const SelectAudioDeviceParam params = SelectAudioDeviceParam(
        deviceId: 'output-1',
        kind: AudioDeviceKind.output,
      );

      final ResultState<void> result = await SelectAudioDeviceUseCase(
        audioDeviceRepository: repository,
      ).execute(params);

      expect(result, const ResultState<void>.success(null));
      expect(repository.selectedDeviceId, 'output-1');
      expect(repository.selectedKind, AudioDeviceKind.output);
      expect(SelectAudioDeviceParam.fromJson(params.toJson()), params);
    });
  });
}

final class _FakeAudioDeviceRepository implements AudioDeviceRepository {
  String? selectedDeviceId;
  AudioDeviceKind? selectedKind;

  @override
  Future<List<AudioDeviceEntity>> listDevices() async {
    return const <AudioDeviceEntity>[
      AudioDeviceEntity(
        id: 'mic-1',
        label: 'Studio Mic',
        kind: AudioDeviceKind.input,
      ),
    ];
  }

  @override
  Future<void> selectDevice(
    String deviceId, {
    required AudioDeviceKind kind,
  }) async {
    selectedDeviceId = deviceId;
    selectedKind = kind;
  }
}
