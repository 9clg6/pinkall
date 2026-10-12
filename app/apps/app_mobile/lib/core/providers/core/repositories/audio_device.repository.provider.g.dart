// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_device.repository.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the native WebRTC audio-device repository.

@ProviderFor(audioDeviceRepository)
final audioDeviceRepositoryProvider = AudioDeviceRepositoryProvider._();

/// Provides the native WebRTC audio-device repository.

final class AudioDeviceRepositoryProvider
    extends
        $FunctionalProvider<
          AudioDeviceRepository,
          AudioDeviceRepository,
          AudioDeviceRepository
        >
    with $Provider<AudioDeviceRepository> {
  /// Provides the native WebRTC audio-device repository.
  AudioDeviceRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioDeviceRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioDeviceRepositoryHash();

  @$internal
  @override
  $ProviderElement<AudioDeviceRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AudioDeviceRepository create(Ref ref) {
    return audioDeviceRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioDeviceRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioDeviceRepository>(value),
    );
  }
}

String _$audioDeviceRepositoryHash() =>
    r'78d25a8a5bad4768f9ca8d236b10463acb294ae9';
