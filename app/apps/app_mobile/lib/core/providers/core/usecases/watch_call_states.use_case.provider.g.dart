// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_call_states.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the real Telnyx call-state stream use case.

@ProviderFor(watchCallStatesUseCase)
final watchCallStatesUseCaseProvider = WatchCallStatesUseCaseProvider._();

/// Provides the real Telnyx call-state stream use case.

final class WatchCallStatesUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<WatchCallStatesUseCase>,
          WatchCallStatesUseCase,
          FutureOr<WatchCallStatesUseCase>
        >
    with
        $FutureModifier<WatchCallStatesUseCase>,
        $FutureProvider<WatchCallStatesUseCase> {
  /// Provides the real Telnyx call-state stream use case.
  WatchCallStatesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchCallStatesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchCallStatesUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<WatchCallStatesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WatchCallStatesUseCase> create(Ref ref) {
    return watchCallStatesUseCase(ref);
  }
}

String _$watchCallStatesUseCaseHash() =>
    r'793636e7885ec30bae02f1bae2fb3e1827bda78b';
