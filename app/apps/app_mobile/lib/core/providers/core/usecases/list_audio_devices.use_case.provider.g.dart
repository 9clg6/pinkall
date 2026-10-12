// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_audio_devices.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the native audio-device enumeration use case.

@ProviderFor(listAudioDevicesUseCase)
final listAudioDevicesUseCaseProvider = ListAudioDevicesUseCaseProvider._();

/// Provides the native audio-device enumeration use case.

final class ListAudioDevicesUseCaseProvider
    extends
        $FunctionalProvider<
          ListAudioDevicesUseCase,
          ListAudioDevicesUseCase,
          ListAudioDevicesUseCase
        >
    with $Provider<ListAudioDevicesUseCase> {
  /// Provides the native audio-device enumeration use case.
  ListAudioDevicesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listAudioDevicesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listAudioDevicesUseCaseHash();

  @$internal
  @override
  $ProviderElement<ListAudioDevicesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ListAudioDevicesUseCase create(Ref ref) {
    return listAudioDevicesUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListAudioDevicesUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListAudioDevicesUseCase>(value),
    );
  }
}

String _$listAudioDevicesUseCaseHash() =>
    r'62eee2cc7d8ebf5b651d1f70e420d756508df838';
