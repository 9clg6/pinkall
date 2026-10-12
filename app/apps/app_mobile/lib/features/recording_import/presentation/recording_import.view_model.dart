import 'dart:async';

import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/recording_import/presentation/recording_import.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recording_import.view_model.g.dart';

/// Orchestrates import consent, streaming upload, diarization and assignment.
@riverpod
class RecordingImportViewModel extends _$RecordingImportViewModel {
  late RecordingImportRepository _repository;
  late ConversationSessionRepository _sessionRepository;
  late RecordingImportClient _nativeClient;
  Timer? _pollTimer;
  bool _polling = false;
  bool _disposed = false;

  @override
  RecordingImportState build() {
    _repository = ref.watch(recordingImportRepositoryProvider);
    _sessionRepository = ref.watch(conversationSessionRepositoryProvider);
    _nativeClient = ref.watch(recordingImportClientProvider);
    ref.onDispose(() {
      _disposed = true;
      _pollTimer?.cancel();
    });
    return const RecordingImportState();
  }

  /// Uses the app-owned temporary file produced by native open-in/share.
  void selectNativeImport(RecordingAudioImport audio) {
    if (state.isBusy) return;
    final String? previousId = state.nativeImportId;
    if (previousId != null && previousId != audio.id) {
      unawaited(_discardNativeImport(previousId));
    }
    state = state.copyWith(
      stage: RecordingImportStage.selecting,
      fileName: audio.name,
      filePath: audio.path,
      mimeType: audio.mimeType,
      sizeBytes: audio.sizeBytes,
      nativeImportId: audio.id,
      remoteImport: null,
      selectedVoice: null,
      errorMessage: null,
    );
  }

  /// Uses the native streaming picker without loading the recording in Dart.
  Future<void> pickRecording() async {
    if (state.isBusy) return;
    try {
      final RecordingAudioImport? audio = await _nativeClient.pickRecording();
      if (audio != null && !_disposed) selectNativeImport(audio);
    } on RecordingImportException catch (error) {
      if (_disposed) return;
      state = state.copyWith(
        stage: RecordingImportStage.failed,
        errorMessage: error.message,
      );
    }
  }

  /// Initializes, consents and uploads the selected recording.
  Future<void> start({String? title, String? preparationMarkdown}) async {
    if (!state.hasFile || state.isBusy) return;
    state = state.copyWith(
      stage: RecordingImportStage.uploading,
      errorMessage: null,
    );
    try {
      final RecordingImportEntity created = await _repository.createImport(
        CreateRecordingImportParam(
          fileName: state.fileName!,
          mimeType: state.mimeType!,
          sizeBytes: state.sizeBytes!,
          title: _optionalText(title),
          preparationMarkdown: _optionalText(preparationMarkdown),
        ),
      );
      final String? uploadPath = created.uploadPath;
      if (uploadPath == null ||
          (created.maxSizeBytes != null &&
              state.sizeBytes! > created.maxSizeBytes!)) {
        throw const FormatException('invalid_upload_contract');
      }
      state = state.copyWith(remoteImport: created);
      await _sessionRepository.recordTranscriptionConsent(
        RecordTranscriptionConsentParam(
          sessionId: created.sessionId,
          acknowledged: true,
          method: TranscriptionConsentMethod.verbalNotice,
          acknowledgedAt: DateTime.now().toUtc(),
        ),
      );
      final RecordingImportEntity uploaded = await _repository.uploadRecording(
        UploadRecordingImportParam(
          importId: created.id,
          uploadPath: uploadPath,
          filePath: state.filePath!,
          mimeType: state.mimeType!,
          sizeBytes: state.sizeBytes!,
        ),
      );
      if (_disposed) return;
      state = state.copyWith(
        stage: RecordingImportStage.processing,
        remoteImport: _mergeImport(created, uploaded),
      );
      _startPolling();
    } catch (_) {
      if (!_disposed) {
        state = state.copyWith(
          stage: RecordingImportStage.failed,
          errorMessage:
              'L’enregistrement n’a pas pu être envoyé. Vérifie ta connexion '
              'puis réessaie.',
        );
      }
    }
  }

  /// Retries the audio upload without creating a second import.
  Future<void> retryUpload() async {
    final RecordingImportEntity? remote = state.remoteImport;
    final String? uploadPath = remote?.uploadPath;
    if (!state.hasFile ||
        remote == null ||
        uploadPath == null ||
        state.isBusy) {
      await start();
      return;
    }
    state = state.copyWith(
      stage: RecordingImportStage.uploading,
      errorMessage: null,
    );
    try {
      final RecordingImportEntity uploaded = await _repository.uploadRecording(
        UploadRecordingImportParam(
          importId: remote.id,
          uploadPath: uploadPath,
          filePath: state.filePath!,
          mimeType: state.mimeType!,
          sizeBytes: state.sizeBytes!,
        ),
      );
      if (_disposed) return;
      state = state.copyWith(
        stage: RecordingImportStage.processing,
        remoteImport: _mergeImport(remote, uploaded),
      );
      _startPolling();
    } catch (_) {
      if (!_disposed) {
        state = state.copyWith(
          stage: RecordingImportStage.failed,
          errorMessage: 'Le nouvel envoi a échoué. Réessaie dans un instant.',
        );
      }
    }
  }

  /// Selects one real provisional voice; no semantic role is inferred here.
  void selectVoice(String voice) {
    final RecordingImportEntity? remote = state.remoteImport;
    if (remote == null || !remote.voices.contains(voice)) return;
    state = state.copyWith(selectedVoice: voice, errorMessage: null);
  }

  /// Finalizes role attribution and retrieves the normal conversation session.
  Future<ConversationSessionEntity?> confirmUserVoice() async {
    final RecordingImportEntity? remote = state.remoteImport;
    final String? voice = state.selectedVoice;
    if (remote == null || voice == null || state.isBusy) return null;
    state = state.copyWith(
      stage: RecordingImportStage.finalizing,
      errorMessage: null,
    );
    try {
      final RecordingImportEntity finalized = await _repository.assignUserVoice(
        AssignRecordingSpeakerParam(importId: remote.id, userVoice: voice),
      );
      final ConversationSessionEntity session = await _sessionRepository
          .getSession(finalized.sessionId);
      await _discardNativeTemporaryFile();
      return session;
    } catch (_) {
      if (!_disposed) {
        state = state.copyWith(
          stage: RecordingImportStage.assigningVoice,
          errorMessage:
              'L’attribution des voix n’a pas pu être finalisée. Réessaie.',
        );
      }
      return null;
    }
  }

  /// Discards a native temporary selection before leaving the picker.
  Future<void> discardSelection() async {
    if (state.isBusy) return;
    await _discardNativeTemporaryFile();
    if (_disposed) return;
    state = const RecordingImportState();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    unawaited(_pollOnce());
    _pollTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => unawaited(_pollOnce()),
    );
  }

  Future<void> _pollOnce() async {
    final RecordingImportEntity? current = state.remoteImport;
    if (_disposed || _polling || current == null) return;
    _polling = true;
    try {
      final RecordingImportEntity refreshed = await _repository.getImport(
        current.id,
      );
      if (_disposed) return;
      final RecordingImportEntity merged = _mergeImport(current, refreshed);
      switch (merged.status) {
        case RecordingImportStatus.awaitingSpeakerAssignment:
          _pollTimer?.cancel();
          state = state.copyWith(
            stage: RecordingImportStage.assigningVoice,
            remoteImport: merged,
            selectedVoice: merged.voices.length == 1
                ? merged.voices.single
                : state.selectedVoice,
            errorMessage: null,
          );
        case RecordingImportStatus.finalized:
          _pollTimer?.cancel();
          state = state.copyWith(
            stage: RecordingImportStage.assigningVoice,
            remoteImport: merged,
            errorMessage:
                'L’analyse est terminée. Confirme ta voix pour ouvrir le débrief.',
          );
        case RecordingImportStatus.failed:
          _pollTimer?.cancel();
          state = state.copyWith(
            stage: RecordingImportStage.failed,
            remoteImport: merged,
            errorMessage:
                merged.failureReason ??
                'La transcription a échoué. Le fichier est encore disponible '
                    'pour une nouvelle tentative.',
          );
        case RecordingImportStatus.awaitingConsent ||
            RecordingImportStatus.awaitingUpload ||
            RecordingImportStatus.uploading ||
            RecordingImportStatus.transcribing:
          state = state.copyWith(
            stage: RecordingImportStage.processing,
            remoteImport: merged,
          );
        case RecordingImportStatus.finalizing:
          state = state.copyWith(
            stage: RecordingImportStage.finalizing,
            remoteImport: merged,
          );
      }
    } catch (_) {
      if (!_disposed) {
        state = state.copyWith(
          errorMessage:
              'La progression est momentanément indisponible. Pinkall réessaie.',
        );
      }
    } finally {
      _polling = false;
    }
  }

  Future<void> _discardNativeTemporaryFile() async {
    final String? id = state.nativeImportId;
    if (id == null) return;
    await _discardNativeImport(id);
  }

  Future<void> _discardNativeImport(String id) async {
    try {
      await _nativeClient.discardImport(id);
    } catch (_) {
      // OS temporary storage remains bounded and is cleaned independently.
    }
  }
}

RecordingImportEntity _mergeImport(
  RecordingImportEntity previous,
  RecordingImportEntity next,
) => next.copyWith(
  uploadPath: next.uploadPath ?? previous.uploadPath,
  maxSizeBytes: next.maxSizeBytes ?? previous.maxSizeBytes,
  maxDurationSeconds: next.maxDurationSeconds ?? previous.maxDurationSeconds,
  acceptedMimeTypes: next.acceptedMimeTypes.isEmpty
      ? previous.acceptedMimeTypes
      : next.acceptedMimeTypes,
);

String? _optionalText(String? value) {
  final String normalized = value?.trim() ?? '';
  return normalized.isEmpty ? null : normalized;
}
