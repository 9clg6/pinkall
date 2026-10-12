// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_home.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Coordinates Telnyx registration, the dialer, and foreground incoming calls.

@ProviderFor(CallHomeViewModel)
final callHomeViewModelProvider = CallHomeViewModelProvider._();

/// Coordinates Telnyx registration, the dialer, and foreground incoming calls.
final class CallHomeViewModelProvider
    extends $AsyncNotifierProvider<CallHomeViewModel, CallHomeState> {
  /// Coordinates Telnyx registration, the dialer, and foreground incoming calls.
  CallHomeViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'callHomeViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$callHomeViewModelHash();

  @$internal
  @override
  CallHomeViewModel create() => CallHomeViewModel();
}

String _$callHomeViewModelHash() => r'f85f1e1dc82ea88d053d57bdf8a29403e9afeda1';

/// Coordinates Telnyx registration, the dialer, and foreground incoming calls.

abstract class _$CallHomeViewModel extends $AsyncNotifier<CallHomeState> {
  FutureOr<CallHomeState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CallHomeState>, CallHomeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CallHomeState>, CallHomeState>,
              AsyncValue<CallHomeState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
