// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connect_telnyx.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the use case that registers the Telnyx client.

@ProviderFor(connectTelnyxUseCase)
final connectTelnyxUseCaseProvider = ConnectTelnyxUseCaseProvider._();

/// Provides the use case that registers the Telnyx client.

final class ConnectTelnyxUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConnectTelnyxUseCase>,
          ConnectTelnyxUseCase,
          FutureOr<ConnectTelnyxUseCase>
        >
    with
        $FutureModifier<ConnectTelnyxUseCase>,
        $FutureProvider<ConnectTelnyxUseCase> {
  /// Provides the use case that registers the Telnyx client.
  ConnectTelnyxUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'connectTelnyxUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectTelnyxUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<ConnectTelnyxUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ConnectTelnyxUseCase> create(Ref ref) {
    return connectTelnyxUseCase(ref);
  }
}

String _$connectTelnyxUseCaseHash() =>
    r'f608f49b7bf718bc9c801115df59db76744c9b00';
