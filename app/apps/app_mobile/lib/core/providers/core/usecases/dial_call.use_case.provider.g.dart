// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dial_call.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the use case that places a real Telnyx call.

@ProviderFor(dialCallUseCase)
final dialCallUseCaseProvider = DialCallUseCaseProvider._();

/// Provides the use case that places a real Telnyx call.

final class DialCallUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<DialCallUseCase>,
          DialCallUseCase,
          FutureOr<DialCallUseCase>
        >
    with $FutureModifier<DialCallUseCase>, $FutureProvider<DialCallUseCase> {
  /// Provides the use case that places a real Telnyx call.
  DialCallUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dialCallUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dialCallUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<DialCallUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DialCallUseCase> create(Ref ref) {
    return dialCallUseCase(ref);
  }
}

String _$dialCallUseCaseHash() => r'b00745f442dac6edcf9c2b66cc47d2e2dc5e8337';
