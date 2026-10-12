// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_call_state.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the replaying state stream for one real Telnyx call.

@ProviderFor(watchCallStateUseCase)
final watchCallStateUseCaseProvider = WatchCallStateUseCaseProvider._();

/// Provides the replaying state stream for one real Telnyx call.

final class WatchCallStateUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<WatchCallStateUseCase>,
          WatchCallStateUseCase,
          FutureOr<WatchCallStateUseCase>
        >
    with
        $FutureModifier<WatchCallStateUseCase>,
        $FutureProvider<WatchCallStateUseCase> {
  /// Provides the replaying state stream for one real Telnyx call.
  WatchCallStateUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchCallStateUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchCallStateUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<WatchCallStateUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WatchCallStateUseCase> create(Ref ref) {
    return watchCallStateUseCase(ref);
  }
}

String _$watchCallStateUseCaseHash() =>
    r'43bdc2b7d647fe5cd8b66e908f248359ccc7c591';
