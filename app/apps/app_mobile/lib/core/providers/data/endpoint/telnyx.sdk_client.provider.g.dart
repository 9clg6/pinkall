// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telnyx.sdk_client.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the official Telnyx WebRTC SDK boundary.
///
/// The transport owns active calls, so it must outlive screen and use-case
/// providers. Disposing it while a route is changing sends BYE for every open
/// call.

@ProviderFor(telnyxSdkClient)
final telnyxSdkClientProvider = TelnyxSdkClientProvider._();

/// Provides the official Telnyx WebRTC SDK boundary.
///
/// The transport owns active calls, so it must outlive screen and use-case
/// providers. Disposing it while a route is changing sends BYE for every open
/// call.

final class TelnyxSdkClientProvider
    extends
        $FunctionalProvider<
          AsyncValue<TelnyxSdkClient>,
          TelnyxSdkClient,
          FutureOr<TelnyxSdkClient>
        >
    with $FutureModifier<TelnyxSdkClient>, $FutureProvider<TelnyxSdkClient> {
  /// Provides the official Telnyx WebRTC SDK boundary.
  ///
  /// The transport owns active calls, so it must outlive screen and use-case
  /// providers. Disposing it while a route is changing sends BYE for every open
  /// call.
  TelnyxSdkClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telnyxSdkClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telnyxSdkClientHash();

  @$internal
  @override
  $FutureProviderElement<TelnyxSdkClient> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TelnyxSdkClient> create(Ref ref) {
    return telnyxSdkClient(ref);
  }
}

String _$telnyxSdkClientHash() => r'07778d2b78fca28ad5dbe7ed1746445b534ff0ea';
