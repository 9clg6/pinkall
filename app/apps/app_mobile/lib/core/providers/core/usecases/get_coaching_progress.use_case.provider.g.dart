// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_coaching_progress.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the workspace-level historical coaching profile.

@ProviderFor(getCoachingProgressUseCase)
final getCoachingProgressUseCaseProvider =
    GetCoachingProgressUseCaseProvider._();

/// Provides the workspace-level historical coaching profile.

final class GetCoachingProgressUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetCoachingProgressUseCase>,
          GetCoachingProgressUseCase,
          FutureOr<GetCoachingProgressUseCase>
        >
    with
        $FutureModifier<GetCoachingProgressUseCase>,
        $FutureProvider<GetCoachingProgressUseCase> {
  /// Provides the workspace-level historical coaching profile.
  GetCoachingProgressUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCoachingProgressUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCoachingProgressUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<GetCoachingProgressUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetCoachingProgressUseCase> create(Ref ref) {
    return getCoachingProgressUseCase(ref);
  }
}

String _$getCoachingProgressUseCaseHash() =>
    r'f952570d701c5b307bae185de18b85f139e10223';
