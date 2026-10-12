// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_workspace_sales_context.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the workspace sales-context read use case.

@ProviderFor(getWorkspaceSalesContextUseCase)
final getWorkspaceSalesContextUseCaseProvider =
    GetWorkspaceSalesContextUseCaseProvider._();

/// Provides the workspace sales-context read use case.

final class GetWorkspaceSalesContextUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetWorkspaceSalesContextUseCase>,
          GetWorkspaceSalesContextUseCase,
          FutureOr<GetWorkspaceSalesContextUseCase>
        >
    with
        $FutureModifier<GetWorkspaceSalesContextUseCase>,
        $FutureProvider<GetWorkspaceSalesContextUseCase> {
  /// Provides the workspace sales-context read use case.
  GetWorkspaceSalesContextUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getWorkspaceSalesContextUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getWorkspaceSalesContextUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<GetWorkspaceSalesContextUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetWorkspaceSalesContextUseCase> create(Ref ref) {
    return getWorkspaceSalesContextUseCase(ref);
  }
}

String _$getWorkspaceSalesContextUseCaseHash() =>
    r'8b11036b1930aff5524a115b80275c22b79075b1';
