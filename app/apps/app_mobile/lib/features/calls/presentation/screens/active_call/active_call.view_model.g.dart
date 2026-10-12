// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_call.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives Telnyx controls and the provider-independent Pinkall live session.

@ProviderFor(ActiveCallViewModel)
final activeCallViewModelProvider = ActiveCallViewModelFamily._();

/// Drives Telnyx controls and the provider-independent Pinkall live session.
final class ActiveCallViewModelProvider
    extends $AsyncNotifierProvider<ActiveCallViewModel, ActiveCallState> {
  /// Drives Telnyx controls and the provider-independent Pinkall live session.
  ActiveCallViewModelProvider._({
    required ActiveCallViewModelFamily super.from,
    required (String, String, String?, bool, bool) super.argument,
  }) : super(
         retry: null,
         name: r'activeCallViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$activeCallViewModelHash();

  @override
  String toString() {
    return r'activeCallViewModelProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  ActiveCallViewModel create() => ActiveCallViewModel();

  @override
  bool operator ==(Object other) {
    return other is ActiveCallViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$activeCallViewModelHash() =>
    r'e1a3f66da586b402318de65da2ae67e2615d0ae7';

/// Drives Telnyx controls and the provider-independent Pinkall live session.

final class ActiveCallViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          ActiveCallViewModel,
          AsyncValue<ActiveCallState>,
          ActiveCallState,
          FutureOr<ActiveCallState>,
          (String, String, String?, bool, bool)
        > {
  ActiveCallViewModelFamily._()
    : super(
        retry: null,
        name: r'activeCallViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Drives Telnyx controls and the provider-independent Pinkall live session.

  ActiveCallViewModelProvider call(
    String callId,
    String sessionId,
    String? remoteNumber,
    bool incoming,
    bool companion,
  ) => ActiveCallViewModelProvider._(
    argument: (callId, sessionId, remoteNumber, incoming, companion),
    from: this,
  );

  @override
  String toString() => r'activeCallViewModelProvider';
}

/// Drives Telnyx controls and the provider-independent Pinkall live session.

abstract class _$ActiveCallViewModel extends $AsyncNotifier<ActiveCallState> {
  late final _$args = ref.$arg as (String, String, String?, bool, bool);
  String get callId => _$args.$1;
  String get sessionId => _$args.$2;
  String? get remoteNumber => _$args.$3;
  bool get incoming => _$args.$4;
  bool get companion => _$args.$5;

  FutureOr<ActiveCallState> build(
    String callId,
    String sessionId,
    String? remoteNumber,
    bool incoming,
    bool companion,
  );
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ActiveCallState>, ActiveCallState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ActiveCallState>, ActiveCallState>,
              AsyncValue<ActiveCallState>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(_$args.$1, _$args.$2, _$args.$3, _$args.$4, _$args.$5),
    );
  }
}
