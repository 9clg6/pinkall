// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_device.client.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the native WebRTC audio-device boundary.

@ProviderFor(audioDeviceClient)
final audioDeviceClientProvider = AudioDeviceClientProvider._();

/// Provides the native WebRTC audio-device boundary.

final class AudioDeviceClientProvider
    extends
        $FunctionalProvider<
          AudioDeviceClient,
          AudioDeviceClient,
          AudioDeviceClient
        >
    with $Provider<AudioDeviceClient> {
  /// Provides the native WebRTC audio-device boundary.
  AudioDeviceClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'audioDeviceClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$audioDeviceClientHash();

  @$internal
  @override
  $ProviderElement<AudioDeviceClient> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AudioDeviceClient create(Ref ref) {
    return audioDeviceClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AudioDeviceClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AudioDeviceClient>(value),
    );
  }
}

String _$audioDeviceClientHash() => r'6567e2fd87d672c5155a501f089b1132f3725928';

/// Whether this runtime exposes desktop WebRTC audio-device routing.
///
/// Kept injectable so widget tests and unsupported embedders never invoke the
/// native desktop plugin merely because their host machine runs macOS.

@ProviderFor(supportsDesktopAudioDeviceSelection)
final supportsDesktopAudioDeviceSelectionProvider =
    SupportsDesktopAudioDeviceSelectionProvider._();

/// Whether this runtime exposes desktop WebRTC audio-device routing.
///
/// Kept injectable so widget tests and unsupported embedders never invoke the
/// native desktop plugin merely because their host machine runs macOS.

final class SupportsDesktopAudioDeviceSelectionProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether this runtime exposes desktop WebRTC audio-device routing.
  ///
  /// Kept injectable so widget tests and unsupported embedders never invoke the
  /// native desktop plugin merely because their host machine runs macOS.
  SupportsDesktopAudioDeviceSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportsDesktopAudioDeviceSelectionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$supportsDesktopAudioDeviceSelectionHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return supportsDesktopAudioDeviceSelection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$supportsDesktopAudioDeviceSelectionHash() =>
    r'b52d0359f950c16d1183d6fd4b6a27eba3b04234';
