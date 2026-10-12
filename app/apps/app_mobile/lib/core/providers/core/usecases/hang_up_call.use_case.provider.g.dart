// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hang_up_call.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the use case that hangs up a Telnyx call.

@ProviderFor(hangUpCallUseCase)
final hangUpCallUseCaseProvider = HangUpCallUseCaseProvider._();

/// Provides the use case that hangs up a Telnyx call.

final class HangUpCallUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<HangUpCallUseCase>,
          HangUpCallUseCase,
          FutureOr<HangUpCallUseCase>
        >
    with
        $FutureModifier<HangUpCallUseCase>,
        $FutureProvider<HangUpCallUseCase> {
  /// Provides the use case that hangs up a Telnyx call.
  HangUpCallUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hangUpCallUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hangUpCallUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<HangUpCallUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HangUpCallUseCase> create(Ref ref) {
    return hangUpCallUseCase(ref);
  }
}

String _$hangUpCallUseCaseHash() => r'a63a573012b9f8fe40ab66c9386eecf4104a6015';
