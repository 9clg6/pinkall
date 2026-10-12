// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objection_library.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads and mutates the objection library.

@ProviderFor(ObjectionLibraryViewModel)
final objectionLibraryViewModelProvider = ObjectionLibraryViewModelProvider._();

/// Loads and mutates the objection library.
final class ObjectionLibraryViewModelProvider
    extends
        $AsyncNotifierProvider<
          ObjectionLibraryViewModel,
          ObjectionLibraryState
        > {
  /// Loads and mutates the objection library.
  ObjectionLibraryViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'objectionLibraryViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$objectionLibraryViewModelHash();

  @$internal
  @override
  ObjectionLibraryViewModel create() => ObjectionLibraryViewModel();
}

String _$objectionLibraryViewModelHash() =>
    r'b6e17bd47642746d929ecc0609962ccaebd4cd22';

/// Loads and mutates the objection library.

abstract class _$ObjectionLibraryViewModel
    extends $AsyncNotifier<ObjectionLibraryState> {
  FutureOr<ObjectionLibraryState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<ObjectionLibraryState>, ObjectionLibraryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<ObjectionLibraryState>,
                ObjectionLibraryState
              >,
              AsyncValue<ObjectionLibraryState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
