// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_progress.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and refreshes the workspace coaching progression.

@ProviderFor(CallProgressViewModel)
final callProgressViewModelProvider = CallProgressViewModelProvider._();

/// Loads and refreshes the workspace coaching progression.
final class CallProgressViewModelProvider
    extends $AsyncNotifierProvider<CallProgressViewModel, CallProgressState> {
  /// Loads and refreshes the workspace coaching progression.
  CallProgressViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'callProgressViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$callProgressViewModelHash();

  @$internal
  @override
  CallProgressViewModel create() => CallProgressViewModel();
}

String _$callProgressViewModelHash() =>
    r'd8da30ec47c8c2bd12e3e24135e2c71f974497ed';

/// Loads and refreshes the workspace coaching progression.

abstract class _$CallProgressViewModel
    extends $AsyncNotifier<CallProgressState> {
  FutureOr<CallProgressState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CallProgressState>, CallProgressState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CallProgressState>, CallProgressState>,
              AsyncValue<CallProgressState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
