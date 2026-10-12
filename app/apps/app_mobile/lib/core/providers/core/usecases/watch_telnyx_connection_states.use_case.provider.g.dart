// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_telnyx_connection_states.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the Telnyx connection-state stream use case.

@ProviderFor(watchTelnyxConnectionStatesUseCase)
final watchTelnyxConnectionStatesUseCaseProvider =
    WatchTelnyxConnectionStatesUseCaseProvider._();

/// Provides the Telnyx connection-state stream use case.

final class WatchTelnyxConnectionStatesUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<WatchTelnyxConnectionStatesUseCase>,
          WatchTelnyxConnectionStatesUseCase,
          FutureOr<WatchTelnyxConnectionStatesUseCase>
        >
    with
        $FutureModifier<WatchTelnyxConnectionStatesUseCase>,
        $FutureProvider<WatchTelnyxConnectionStatesUseCase> {
  /// Provides the Telnyx connection-state stream use case.
  WatchTelnyxConnectionStatesUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchTelnyxConnectionStatesUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$watchTelnyxConnectionStatesUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<WatchTelnyxConnectionStatesUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WatchTelnyxConnectionStatesUseCase> create(Ref ref) {
    return watchTelnyxConnectionStatesUseCase(ref);
  }
}

String _$watchTelnyxConnectionStatesUseCaseHash() =>
    r'cde15c4bb3c77856df63aadc57a8e5c78e3c98fe';
