// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telnyx.remote_data_source.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the Telnyx WebRTC remote data source.

@ProviderFor(telnyxRemoteDataSource)
final telnyxRemoteDataSourceProvider = TelnyxRemoteDataSourceProvider._();

/// Provides the Telnyx WebRTC remote data source.

final class TelnyxRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AsyncValue<TelnyxRemoteDataSource>,
          TelnyxRemoteDataSource,
          FutureOr<TelnyxRemoteDataSource>
        >
    with
        $FutureModifier<TelnyxRemoteDataSource>,
        $FutureProvider<TelnyxRemoteDataSource> {
  /// Provides the Telnyx WebRTC remote data source.
  TelnyxRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telnyxRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telnyxRemoteDataSourceHash();

  @$internal
  @override
  $FutureProviderElement<TelnyxRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TelnyxRemoteDataSource> create(Ref ref) {
    return telnyxRemoteDataSource(ref);
  }
}

String _$telnyxRemoteDataSourceHash() =>
    r'f1ef064b0b76949c5b10bdb33648775896144202';
