// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_call_muted.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the Telnyx microphone-control use case.

@ProviderFor(setCallMutedUseCase)
final setCallMutedUseCaseProvider = SetCallMutedUseCaseProvider._();

/// Provides the Telnyx microphone-control use case.

final class SetCallMutedUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<SetCallMutedUseCase>,
          SetCallMutedUseCase,
          FutureOr<SetCallMutedUseCase>
        >
    with
        $FutureModifier<SetCallMutedUseCase>,
        $FutureProvider<SetCallMutedUseCase> {
  /// Provides the Telnyx microphone-control use case.
  SetCallMutedUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setCallMutedUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setCallMutedUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<SetCallMutedUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SetCallMutedUseCase> create(Ref ref) {
    return setCallMutedUseCase(ref);
  }
}

String _$setCallMutedUseCaseHash() =>
    r'46e07dd5ac8d6cd5114aedf9991623f7f3f9254a';
