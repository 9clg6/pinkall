// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_objections.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the objection library query.

@ProviderFor(listObjectionsUseCase)
final listObjectionsUseCaseProvider = ListObjectionsUseCaseProvider._();

/// Provides the objection library query.

final class ListObjectionsUseCaseProvider
    extends
        $FunctionalProvider<
          ListObjectionsUseCase,
          ListObjectionsUseCase,
          ListObjectionsUseCase
        >
    with $Provider<ListObjectionsUseCase> {
  /// Provides the objection library query.
  ListObjectionsUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listObjectionsUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listObjectionsUseCaseHash();

  @$internal
  @override
  $ProviderElement<ListObjectionsUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ListObjectionsUseCase create(Ref ref) {
    return listObjectionsUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListObjectionsUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListObjectionsUseCase>(value),
    );
  }
}

String _$listObjectionsUseCaseHash() =>
    r'872dfb74678f8be3703761d6e3ec8a2fa1e30886';
