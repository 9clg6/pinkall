// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_workspace_sales_context.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the workspace sales-context write use case.

@ProviderFor(upsertWorkspaceSalesContextUseCase)
final upsertWorkspaceSalesContextUseCaseProvider =
    UpsertWorkspaceSalesContextUseCaseProvider._();

/// Provides the workspace sales-context write use case.

final class UpsertWorkspaceSalesContextUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<UpsertWorkspaceSalesContextUseCase>,
          UpsertWorkspaceSalesContextUseCase,
          FutureOr<UpsertWorkspaceSalesContextUseCase>
        >
    with
        $FutureModifier<UpsertWorkspaceSalesContextUseCase>,
        $FutureProvider<UpsertWorkspaceSalesContextUseCase> {
  /// Provides the workspace sales-context write use case.
  UpsertWorkspaceSalesContextUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upsertWorkspaceSalesContextUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$upsertWorkspaceSalesContextUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<UpsertWorkspaceSalesContextUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<UpsertWorkspaceSalesContextUseCase> create(Ref ref) {
    return upsertWorkspaceSalesContextUseCase(ref);
  }
}

String _$upsertWorkspaceSalesContextUseCaseHash() =>
    r'82375e6230f6ae4fbc1d355e5418e946452ddd14';
