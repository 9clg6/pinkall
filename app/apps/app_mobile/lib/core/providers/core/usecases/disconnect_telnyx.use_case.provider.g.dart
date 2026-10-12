// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disconnect_telnyx.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the use case that disconnects the Telnyx client.

@ProviderFor(disconnectTelnyxUseCase)
final disconnectTelnyxUseCaseProvider = DisconnectTelnyxUseCaseProvider._();

/// Provides the use case that disconnects the Telnyx client.

final class DisconnectTelnyxUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<DisconnectTelnyxUseCase>,
          DisconnectTelnyxUseCase,
          FutureOr<DisconnectTelnyxUseCase>
        >
    with
        $FutureModifier<DisconnectTelnyxUseCase>,
        $FutureProvider<DisconnectTelnyxUseCase> {
  /// Provides the use case that disconnects the Telnyx client.
  DisconnectTelnyxUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disconnectTelnyxUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disconnectTelnyxUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<DisconnectTelnyxUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DisconnectTelnyxUseCase> create(Ref ref) {
    return disconnectTelnyxUseCase(ref);
  }
}

String _$disconnectTelnyxUseCaseHash() =>
    r'fdbb43d54bf7cbcf479c6282b498c455234231ce';
