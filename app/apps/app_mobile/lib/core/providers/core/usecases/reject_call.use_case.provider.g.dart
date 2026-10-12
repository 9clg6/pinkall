// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_call.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the use case that rejects an incoming Telnyx call.

@ProviderFor(rejectCallUseCase)
final rejectCallUseCaseProvider = RejectCallUseCaseProvider._();

/// Provides the use case that rejects an incoming Telnyx call.

final class RejectCallUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<RejectCallUseCase>,
          RejectCallUseCase,
          FutureOr<RejectCallUseCase>
        >
    with
        $FutureModifier<RejectCallUseCase>,
        $FutureProvider<RejectCallUseCase> {
  /// Provides the use case that rejects an incoming Telnyx call.
  RejectCallUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rejectCallUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rejectCallUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<RejectCallUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RejectCallUseCase> create(Ref ref) {
    return rejectCallUseCase(ref);
  }
}

String _$rejectCallUseCaseHash() => r'53871af3fae68c4cf6654acdebecab1c50139f25';
