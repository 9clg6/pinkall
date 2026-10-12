// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_import.view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Orchestrates import consent, streaming upload, diarization and assignment.

@ProviderFor(RecordingImportViewModel)
final recordingImportViewModelProvider = RecordingImportViewModelProvider._();

/// Orchestrates import consent, streaming upload, diarization and assignment.
final class RecordingImportViewModelProvider
    extends $NotifierProvider<RecordingImportViewModel, RecordingImportState> {
  /// Orchestrates import consent, streaming upload, diarization and assignment.
  RecordingImportViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recordingImportViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recordingImportViewModelHash();

  @$internal
  @override
  RecordingImportViewModel create() => RecordingImportViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecordingImportState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecordingImportState>(value),
    );
  }
}

String _$recordingImportViewModelHash() =>
    r'0bcb91cbb9d0bc812a789f876dabe3828a3c3ec7';

/// Orchestrates import consent, streaming upload, diarization and assignment.

abstract class _$RecordingImportViewModel
    extends $Notifier<RecordingImportState> {
  RecordingImportState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RecordingImportState, RecordingImportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecordingImportState, RecordingImportState>,
              RecordingImportState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
