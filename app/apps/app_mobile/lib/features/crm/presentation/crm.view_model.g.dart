// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crm.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives the minimal CRM exclusively through the Pinkall backend.

@ProviderFor(CrmViewModel)
final crmViewModelProvider = CrmViewModelProvider._();

/// Drives the minimal CRM exclusively through the Pinkall backend.
final class CrmViewModelProvider
    extends $AsyncNotifierProvider<CrmViewModel, CrmState> {
  /// Drives the minimal CRM exclusively through the Pinkall backend.
  CrmViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'crmViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$crmViewModelHash();

  @$internal
  @override
  CrmViewModel create() => CrmViewModel();
}

String _$crmViewModelHash() => r'd591e5033b49032043fbf2c653569e33303f93d4';

/// Drives the minimal CRM exclusively through the Pinkall backend.

abstract class _$CrmViewModel extends $AsyncNotifier<CrmState> {
  FutureOr<CrmState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CrmState>, CrmState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CrmState>, CrmState>,
              AsyncValue<CrmState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
