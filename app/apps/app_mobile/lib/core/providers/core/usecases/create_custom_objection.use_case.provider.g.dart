// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_custom_objection.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the custom objection command.

@ProviderFor(createCustomObjectionUseCase)
final createCustomObjectionUseCaseProvider =
    CreateCustomObjectionUseCaseProvider._();

/// Provides the custom objection command.

final class CreateCustomObjectionUseCaseProvider
    extends
        $FunctionalProvider<
          CreateCustomObjectionUseCase,
          CreateCustomObjectionUseCase,
          CreateCustomObjectionUseCase
        >
    with $Provider<CreateCustomObjectionUseCase> {
  /// Provides the custom objection command.
  CreateCustomObjectionUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createCustomObjectionUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createCustomObjectionUseCaseHash();

  @$internal
  @override
  $ProviderElement<CreateCustomObjectionUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CreateCustomObjectionUseCase create(Ref ref) {
    return createCustomObjectionUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CreateCustomObjectionUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CreateCustomObjectionUseCase>(value),
    );
  }
}

String _$createCustomObjectionUseCaseHash() =>
    r'f5d9b96ddda1ff9fba6c8dd819f6b01903adeb61';
