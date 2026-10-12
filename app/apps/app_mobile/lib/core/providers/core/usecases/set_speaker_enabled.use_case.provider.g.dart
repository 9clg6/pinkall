// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_speaker_enabled.use_case.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the Telnyx speaker-routing use case.

@ProviderFor(setSpeakerEnabledUseCase)
final setSpeakerEnabledUseCaseProvider = SetSpeakerEnabledUseCaseProvider._();

/// Provides the Telnyx speaker-routing use case.

final class SetSpeakerEnabledUseCaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<SetSpeakerEnabledUseCase>,
          SetSpeakerEnabledUseCase,
          FutureOr<SetSpeakerEnabledUseCase>
        >
    with
        $FutureModifier<SetSpeakerEnabledUseCase>,
        $FutureProvider<SetSpeakerEnabledUseCase> {
  /// Provides the Telnyx speaker-routing use case.
  SetSpeakerEnabledUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setSpeakerEnabledUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setSpeakerEnabledUseCaseHash();

  @$internal
  @override
  $FutureProviderElement<SetSpeakerEnabledUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SetSpeakerEnabledUseCase> create(Ref ref) {
    return setSpeakerEnabledUseCase(ref);
  }
}

String _$setSpeakerEnabledUseCaseHash() =>
    r'57862a43fee073ab6f4635e695b297b684401142';
