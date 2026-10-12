// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinkall_auth.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Coordinates restored sessions, invite-only sign-in, refresh, and logout.

@ProviderFor(PinkallAuthViewModel)
final pinkallAuthViewModelProvider = PinkallAuthViewModelProvider._();

/// Coordinates restored sessions, invite-only sign-in, refresh, and logout.
final class PinkallAuthViewModelProvider
    extends $NotifierProvider<PinkallAuthViewModel, PinkallAuthState> {
  /// Coordinates restored sessions, invite-only sign-in, refresh, and logout.
  PinkallAuthViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pinkallAuthViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pinkallAuthViewModelHash();

  @$internal
  @override
  PinkallAuthViewModel create() => PinkallAuthViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PinkallAuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PinkallAuthState>(value),
    );
  }
}

String _$pinkallAuthViewModelHash() =>
    r'dd70d6cd8bd722ba0d81d4768f358a0ed3811fd6';

/// Coordinates restored sessions, invite-only sign-in, refresh, and logout.

abstract class _$PinkallAuthViewModel extends $Notifier<PinkallAuthState> {
  PinkallAuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PinkallAuthState, PinkallAuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PinkallAuthState, PinkallAuthState>,
              PinkallAuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
