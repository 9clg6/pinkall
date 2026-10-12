// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instant_help.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Coordinates consent-gated native capture, uploads and live intelligence.

@ProviderFor(InstantHelpViewModel)
final instantHelpViewModelProvider = InstantHelpViewModelProvider._();

/// Coordinates consent-gated native capture, uploads and live intelligence.
final class InstantHelpViewModelProvider
    extends $NotifierProvider<InstantHelpViewModel, InstantHelpState> {
  /// Coordinates consent-gated native capture, uploads and live intelligence.
  InstantHelpViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instantHelpViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instantHelpViewModelHash();

  @$internal
  @override
  InstantHelpViewModel create() => InstantHelpViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InstantHelpState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InstantHelpState>(value),
    );
  }
}

String _$instantHelpViewModelHash() =>
    r'fdb43271bbf3f163c3aaa507b60ba4b2fcc9724f';

/// Coordinates consent-gated native capture, uploads and live intelligence.

abstract class _$InstantHelpViewModel extends $Notifier<InstantHelpState> {
  InstantHelpState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<InstantHelpState, InstantHelpState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<InstantHelpState, InstantHelpState>,
              InstantHelpState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
