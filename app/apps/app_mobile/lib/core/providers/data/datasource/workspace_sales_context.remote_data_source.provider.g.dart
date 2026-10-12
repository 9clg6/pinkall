// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_sales_context.remote_data_source.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the authenticated workspace-context remote source.

@ProviderFor(workspaceSalesContextRemoteDataSource)
final workspaceSalesContextRemoteDataSourceProvider =
    WorkspaceSalesContextRemoteDataSourceProvider._();

/// Provides the authenticated workspace-context remote source.

final class WorkspaceSalesContextRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkspaceSalesContextRemoteDataSource>,
          WorkspaceSalesContextRemoteDataSource,
          FutureOr<WorkspaceSalesContextRemoteDataSource>
        >
    with
        $FutureModifier<WorkspaceSalesContextRemoteDataSource>,
        $FutureProvider<WorkspaceSalesContextRemoteDataSource> {
  /// Provides the authenticated workspace-context remote source.
  WorkspaceSalesContextRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workspaceSalesContextRemoteDataSourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$workspaceSalesContextRemoteDataSourceHash();

  @$internal
  @override
  $FutureProviderElement<WorkspaceSalesContextRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkspaceSalesContextRemoteDataSource> create(Ref ref) {
    return workspaceSalesContextRemoteDataSource(ref);
  }
}

String _$workspaceSalesContextRemoteDataSourceHash() =>
    r'a697df8a8a827fbbc3871aea372c84517cba1104';
