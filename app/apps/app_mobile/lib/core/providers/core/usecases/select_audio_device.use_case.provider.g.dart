// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_audio_device.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the native audio-device selection use case.

@ProviderFor(selectAudioDeviceUseCase)
final selectAudioDeviceUseCaseProvider = SelectAudioDeviceUseCaseProvider._();

/// Provides the native audio-device selection use case.

final class SelectAudioDeviceUseCaseProvider
    extends
        $FunctionalProvider<
          SelectAudioDeviceUseCase,
          SelectAudioDeviceUseCase,
          SelectAudioDeviceUseCase
        >
    with $Provider<SelectAudioDeviceUseCase> {
  /// Provides the native audio-device selection use case.
  SelectAudioDeviceUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectAudioDeviceUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectAudioDeviceUseCaseHash();

  @$internal
  @override
  $ProviderElement<SelectAudioDeviceUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SelectAudioDeviceUseCase create(Ref ref) {
    return selectAudioDeviceUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SelectAudioDeviceUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SelectAudioDeviceUseCase>(value),
    );
  }
}

String _$selectAudioDeviceUseCaseHash() =>
    r'2adcd972c3b32a4ed129d776d37b5508eaf91072';
