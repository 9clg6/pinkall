// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_call_debrief.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides grounded post-call artifacts through the domain use case.

@ProviderFor(getCallDebriefUseCase)
final getCallDebriefUseCaseProvider = GetCallDebriefUseCaseProvider._();

/// Provides grounded post-call artifacts through the domain use case.

final class GetCallDebriefUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<GetCallDebriefUseCase>,
          GetCallDebriefUseCase,
          FutureOr<GetCallDebriefUseCase>
        >
    with
        $FutureModifier<GetCallDebriefUseCase>,
        $FutureProvider<GetCallDebriefUseCase> {
  /// Provides grounded post-call artifacts through the domain use case.
  GetCallDebriefUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCallDebriefUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCallDebriefUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<GetCallDebriefUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GetCallDebriefUseCase> create(Ref ref) {
    return getCallDebriefUseCase(ref);
  }
}

String _$getCallDebriefUseCaseHash() =>
    r'410e5fe948416d6ed409328df5c82f3713c3818b';
