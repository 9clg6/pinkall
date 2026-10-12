// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call.repository.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the Telnyx-backed domain call repository.

@ProviderFor(callRepository)
final callRepositoryProvider = CallRepositoryProvider._();

/// Provides the Telnyx-backed domain call repository.

final class CallRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<CallRepository>,
          CallRepository,
          FutureOr<CallRepository>
        >
    with $FutureModifier<CallRepository>, $FutureProvider<CallRepository> {
  /// Provides the Telnyx-backed domain call repository.
  CallRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'callRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$callRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<CallRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CallRepository> create(Ref ref) {
    return callRepository(ref);
  }
}

String _$callRepositoryHash() => r'8c5348e51cbbf94d89b1fde9a200b39d4141c354';
