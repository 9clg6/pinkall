// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accept_call.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the use case that accepts an incoming Telnyx call.

@ProviderFor(acceptCallUseCase)
final acceptCallUseCaseProvider = AcceptCallUseCaseProvider._();

/// Provides the use case that accepts an incoming Telnyx call.

final class AcceptCallUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<AcceptCallUseCase>,
          AcceptCallUseCase,
          FutureOr<AcceptCallUseCase>
        >
    with
        $FutureModifier<AcceptCallUseCase>,
        $FutureProvider<AcceptCallUseCase> {
  /// Provides the use case that accepts an incoming Telnyx call.
  AcceptCallUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceptCallUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceptCallUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<AcceptCallUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AcceptCallUseCase> create(Ref ref) {
    return acceptCallUseCase(ref);
  }
}

String _$acceptCallUseCaseHash() => r'9ef3da3bf84710c8e944abb15580b1335c91a440';
