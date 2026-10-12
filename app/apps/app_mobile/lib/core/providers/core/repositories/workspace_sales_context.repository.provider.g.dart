// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_sales_context.repository.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the durable workspace sales-context repository.

@ProviderFor(workspaceSalesContextRepository)
final workspaceSalesContextRepositoryProvider =
    WorkspaceSalesContextRepositoryProvider._();

/// Provides the durable workspace sales-context repository.

final class WorkspaceSalesContextRepositoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkspaceSalesContextRepository>,
          WorkspaceSalesContextRepository,
          FutureOr<WorkspaceSalesContextRepository>
        >
    with
        $FutureModifier<WorkspaceSalesContextRepository>,
        $FutureProvider<WorkspaceSalesContextRepository> {
  /// Provides the durable workspace sales-context repository.
  WorkspaceSalesContextRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workspaceSalesContextRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workspaceSalesContextRepositoryHash();

  @$internal
  @override
  $FutureProviderElement<WorkspaceSalesContextRepository> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkspaceSalesContextRepository> create(Ref ref) {
    return workspaceSalesContextRepository(ref);
  }
}

String _$workspaceSalesContextRepositoryHash() =>
    r'3d1f5a19bb566e17ee1ee111af363b80c3ddb392';
