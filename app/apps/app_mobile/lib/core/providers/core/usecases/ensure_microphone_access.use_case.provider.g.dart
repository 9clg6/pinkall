// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ensure_microphone_access.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the microphone preflight required before a real WebRTC call.

@ProviderFor(ensureMicrophoneAccessUseCase)
final ensureMicrophoneAccessUseCaseProvider =
    EnsureMicrophoneAccessUseCaseProvider._();

/// Provides the microphone preflight required before a real WebRTC call.

final class EnsureMicrophoneAccessUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<EnsureMicrophoneAccessUseCase>,
          EnsureMicrophoneAccessUseCase,
          FutureOr<EnsureMicrophoneAccessUseCase>
        >
    with
        $FutureModifier<EnsureMicrophoneAccessUseCase>,
        $FutureProvider<EnsureMicrophoneAccessUseCase> {
  /// Provides the microphone preflight required before a real WebRTC call.
  EnsureMicrophoneAccessUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ensureMicrophoneAccessUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ensureMicrophoneAccessUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<EnsureMicrophoneAccessUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EnsureMicrophoneAccessUseCase> create(Ref ref) {
    return ensureMicrophoneAccessUseCase(ref);
  }
}

String _$ensureMicrophoneAccessUseCaseHash() =>
    r'80828a7cb0bc5d058c7bf0c0c81ba9ca3994894a';
