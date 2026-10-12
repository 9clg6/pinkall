// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kernel.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Initializes the real Telnyx dependency graph once for the application.

@ProviderFor(kernel)
final kernelProvider = KernelProvider._();

/// Initializes the real Telnyx dependency graph once for the application.

final class KernelProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Initializes the real Telnyx dependency graph once for the application.
  KernelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'kernelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$kernelHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return kernel(ref);
  }
}

String _$kernelHash() => r'09a28df6a5e412ccbbf444db5a4adfe8a99865d1';
