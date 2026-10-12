// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_sales_context.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and updates the workspace's durable commercial context.

@ProviderFor(WorkspaceSalesContextViewModel)
final workspaceSalesContextViewModelProvider =
    WorkspaceSalesContextViewModelProvider._();

/// Loads and updates the workspace's durable commercial context.
final class WorkspaceSalesContextViewModelProvider
    extends
        $AsyncNotifierProvider<
          WorkspaceSalesContextViewModel,
          WorkspaceSalesContextState
        > {
  /// Loads and updates the workspace's durable commercial context.
  WorkspaceSalesContextViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workspaceSalesContextViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workspaceSalesContextViewModelHash();

  @$internal
  @override
  WorkspaceSalesContextViewModel create() => WorkspaceSalesContextViewModel();
}

String _$workspaceSalesContextViewModelHash() =>
    r'38b9046b39c01e5908a5f62dfc4498015116a667';

/// Loads and updates the workspace's durable commercial context.

abstract class _$WorkspaceSalesContextViewModel
    extends $AsyncNotifier<WorkspaceSalesContextState> {
  FutureOr<WorkspaceSalesContextState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<WorkspaceSalesContextState>,
              WorkspaceSalesContextState
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<WorkspaceSalesContextState>,
                WorkspaceSalesContextState
              >,
              AsyncValue<WorkspaceSalesContextState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
