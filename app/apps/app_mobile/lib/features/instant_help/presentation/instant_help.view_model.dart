import 'dart:async';
import 'dart:typed_data';

import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/instant_help/presentation/instant_help.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'instant_help.view_model.g.dart';

/// Coordinates consent-gated native capture, uploads and live intelligence.
@riverpod
class InstantHelpViewModel extends _$InstantHelpViewModel {
  ConversationSessionRepository? _sessionRepository;
  MacosCallAudioCaptureClient? _captureClient;
  PinkallBinaryRealtimeClient? _binaryClient;
  PinkallBinaryRealtimeConnection? _sellerConnection;
  PinkallBinaryRealtimeConnection? _prospectConnection;
  StreamSubscription<Uint8List>? _microphoneSubscription;
  StreamSubscription<Uint8List>? _systemAudioSubscription;
  StreamSubscription<SessionRealtimeEventEntity>? _eventSubscription;
  Timer? _elapsedTimer;
  bool _disposed = false;
  bool _handlingMediaFailure = false;

  @override
  InstantHelpState build() {
    _sessionRepository = ref.watch(conversationSessionRepositoryProvider);
    _captureClient = ref.watch(macosCallAudioCaptureClientProvider);
    _binaryClient = ref.watch(pinkallBinaryRealtimeClientProvider);
    ref.onDispose(() {
      _disposed = true;
      _elapsedTimer?.cancel();
      unawaited(_microphoneSubscription?.cancel());
      unawaited(_systemAudioSubscription?.cancel());
      unawaited(_eventSubscription?.cancel());
      unawaited(_disposeMediaSafely());
    });
    return const InstantHelpState();
  }

  /// Starts a real system-audio and microphone session after explicit notice.
  Future<bool> start({String? title, String? preparationMarkdown}) async {
    if (state.stage != InstantHelpStage.preparing &&
        state.stage != InstantHelpStage.failed) {
      return false;
    }
    final ConversationSessionRepository repository = _requireRepository();
    final MacosCallAudioCaptureClient capture = _requireCaptureClient();
    final PinkallBinaryRealtimeClient binary = _requireBinaryClient();
    state = state.copyWith(
      stage: InstantHelpStage.starting,
      errorMessage: null,
      transcript: const <TranscriptSegmentEntity>[],
      suggestion: null,
      elapsed: Duration.zero,
      microphoneDetected: false,
      systemAudioDetected: false,
    );

    ExternalConversationSessionEntity? launch;
    try {
      launch = await repository.createExternalSession(
        CreateExternalConversationSessionParam(
          title: _optionalText(title),
          preparationMarkdown: _optionalText(preparationMarkdown),
          coachModeOverride: CoachMode.off,
        ),
      );
      _validateMediaContract(launch.media);
      await repository.recordTranscriptionConsent(
        RecordTranscriptionConsentParam(
          sessionId: launch.session.id,
          acknowledged: true,
          method: TranscriptionConsentMethod.verbalNotice,
          acknowledgedAt: DateTime.now().toUtc(),
        ),
      );
      _sellerConnection = await binary.connect(launch.media.sellerWebSocketUri);
      _prospectConnection = await binary.connect(
        launch.media.prospectWebSocketUri,
      );
      _microphoneSubscription = capture.microphoneAudio.listen(
        (Uint8List bytes) => _onMicrophoneFrame(bytes),
        onError: _onAudioStreamError,
        cancelOnError: false,
      );
      _systemAudioSubscription = capture.systemAudio.listen(
        (Uint8List bytes) => _onSystemAudioFrame(bytes),
        onError: _onAudioStreamError,
        cancelOnError: false,
      );
      _eventSubscription = repository
          .watchSessionEvents(launch.session.id)
          .listen(
            _onRealtimeEvent,
            onError: (Object error, StackTrace stackTrace) {
              if (_disposed) return;
              state = state.copyWith(
                errorMessage:
                    'La transcription en direct a été interrompue. '
                    'L’audio continue et sera réconcilié à la fin.',
              );
            },
          );
      await capture.start(sampleRate: launch.media.sampleRate);
      if (_disposed) return false;
      state = state.copyWith(
        stage: InstantHelpStage.live,
        externalSession: launch.copyWith(
          session: launch.session.copyWith(
            transcriptionConsentAcknowledged: true,
          ),
        ),
      );
      _startElapsedTimer();
      return true;
    } catch (error) {
      await _cleanupCapture(cancelNative: true);
      if (launch != null) {
        try {
          await repository.cancelSession(launch.session.id);
        } catch (_) {
          // The startup error remains the useful diagnostic.
        }
      }
      if (!_disposed) {
        state = state.copyWith(
          stage: InstantHelpStage.failed,
          externalSession: null,
          errorMessage: _startFailureMessage(error),
        );
      }
      return false;
    }
  }

  /// Activates or pauses the live coach without interrupting transcription.
  Future<void> setCoachEnabled({required bool enabled}) async {
    final ExternalConversationSessionEntity? launch = state.externalSession;
    if (launch == null || state.stage != InstantHelpStage.live) return;
    try {
      final ConversationSessionEntity updated = await _requireRepository()
          .updateCoachMode(
            UpdateSessionCoachModeParam(
              sessionId: launch.session.id,
              mode: enabled ? CoachMode.live : CoachMode.off,
            ),
          );
      if (_disposed) return;
      state = state.copyWith(
        externalSession: launch.copyWith(session: updated),
        suggestion: enabled ? state.suggestion : null,
        coachAnalysisStatus: CoachAnalysisStatus.listening,
        coachAnalysisOutcome: null,
        errorMessage: null,
      );
    } catch (_) {
      if (!_disposed) {
        state = state.copyWith(
          errorMessage: 'Le coach n’a pas pu être modifié. Réessaie.',
        );
      }
    }
  }

  /// Stops capture, closes both tracks, and starts the normal final debrief.
  Future<ConversationSessionEntity?> stopAndFinalize() async {
    final ExternalConversationSessionEntity? launch = state.externalSession;
    if (launch == null || state.stage != InstantHelpStage.live) return null;
    _elapsedTimer?.cancel();
    state = state.copyWith(
      stage: InstantHelpStage.stopping,
      errorMessage: null,
    );
    try {
      await _captureClient?.stop();
      await _cleanupCapture(cancelNative: false);
      final ConversationSessionEntity finalized = await _requireRepository()
          .finalizeSession(launch.session.id);
      if (!_disposed) {
        state = state.copyWith(
          externalSession: launch.copyWith(session: finalized),
        );
      }
      return finalized;
    } catch (error) {
      await _cleanupCapture(cancelNative: true);
      if (!_disposed) {
        state = state.copyWith(
          stage: InstantHelpStage.failed,
          errorMessage:
              'La capture est arrêtée, mais le débrief n’a pas pu démarrer. '
              'Tu peux réessayer depuis l’historique.',
        );
      }
      return null;
    }
  }

  void _onMicrophoneFrame(Uint8List bytes) {
    if (!state.microphoneDetected) {
      state = state.copyWith(microphoneDetected: true);
    }
    unawaited(_sendFrame(_sellerConnection, bytes));
  }

  void _onSystemAudioFrame(Uint8List bytes) {
    if (!state.systemAudioDetected) {
      state = state.copyWith(systemAudioDetected: true);
    }
    unawaited(_sendFrame(_prospectConnection, bytes));
  }

  Future<void> _sendFrame(
    PinkallBinaryRealtimeConnection? connection,
    Uint8List bytes,
  ) async {
    if (connection == null ||
        bytes.isEmpty ||
        (state.stage != InstantHelpStage.starting &&
            state.stage != InstantHelpStage.live)) {
      return;
    }
    try {
      const int maxFrameBytes = 64 * 1024;
      for (int offset = 0; offset < bytes.length; offset += maxFrameBytes) {
        final int candidateEnd = offset + maxFrameBytes;
        int end = candidateEnd < bytes.length ? candidateEnd : bytes.length;
        if ((end - offset).isOdd) end--;
        if (end <= offset) continue;
        await connection.send(Uint8List.sublistView(bytes, offset, end));
      }
    } catch (error) {
      await _handleMediaFailure();
    }
  }

  void _onAudioStreamError(Object error, StackTrace stackTrace) {
    unawaited(_handleMediaFailure());
  }

  Future<void> _handleMediaFailure() async {
    if (_handlingMediaFailure || _disposed) return;
    _handlingMediaFailure = true;
    _elapsedTimer?.cancel();
    await _cleanupCapture(cancelNative: true);
    final String? sessionId = state.externalSession?.session.id;
    if (sessionId != null) {
      try {
        await _requireRepository().cancelSession(sessionId);
      } catch (_) {
        // Media has already stopped; backend cancellation is best-effort.
      }
    }
    if (!_disposed) {
      state = state.copyWith(
        stage: InstantHelpStage.failed,
        externalSession: null,
        errorMessage:
            'Le flux audio a été interrompu. Vérifie les autorisations '
            'Microphone et Enregistrement de l’écran, puis réessaie.',
      );
    }
    _handlingMediaFailure = false;
  }

  void _onRealtimeEvent(SessionRealtimeEventEntity event) {
    if (_disposed) return;
    switch (event) {
      case SessionTranscriptSegmentEventEntity(
        segment: final TranscriptSegmentEntity segment,
      ):
        state = state.copyWith(
          transcript: _upsertSegment(state.transcript, segment),
        );
      case SessionCoachingSuggestionEventEntity(
        suggestion: final CoachingSuggestionEntity suggestion,
      ):
        if (!state.isCoachEnabled ||
            suggestion.isExpiredAt(DateTime.now().toUtc())) {
          return;
        }
        state = state.copyWith(
          suggestion: suggestion,
          coachAnalysisStatus: CoachAnalysisStatus.listening,
          coachAnalysisOutcome: CoachAnalysisOutcome.suggestion,
        );
      case SessionCoachStatusEventEntity(
        coachStatus: final CoachStatusEntity coachStatus,
      ):
        if (!state.isCoachEnabled) return;
        state = state.copyWith(
          coachAnalysisStatus: coachStatus.status,
          coachAnalysisOutcome: coachStatus.outcome,
        );
      case SessionStateEventEntity(
        session: final ConversationSessionEntity session,
      ):
        final ExternalConversationSessionEntity? launch = state.externalSession;
        if (launch != null) {
          state = state.copyWith(
            externalSession: launch.copyWith(session: session),
            suggestion: session.coachMode == CoachMode.live
                ? state.suggestion
                : null,
          );
        }
      case SessionUnknownEventEntity():
        return;
    }
  }

  void _startElapsedTimer() {
    _elapsedTimer?.cancel();
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_disposed || state.stage != InstantHelpStage.live) return;
      final CoachingSuggestionEntity? suggestion = state.suggestion;
      state = state.copyWith(
        elapsed: state.elapsed + const Duration(seconds: 1),
        suggestion:
            suggestion != null && suggestion.isExpiredAt(DateTime.now().toUtc())
            ? null
            : suggestion,
      );
    });
  }

  Future<void> _cleanupCapture({required bool cancelNative}) async {
    await _microphoneSubscription?.cancel();
    await _systemAudioSubscription?.cancel();
    _microphoneSubscription = null;
    _systemAudioSubscription = null;
    await _eventSubscription?.cancel();
    _eventSubscription = null;
    if (cancelNative) {
      try {
        await _captureClient?.cancel();
      } catch (_) {
        // Track closure below is still mandatory.
      }
    }
    for (final PinkallBinaryRealtimeConnection? connection
        in <PinkallBinaryRealtimeConnection?>[
          _sellerConnection,
          _prospectConnection,
        ]) {
      try {
        await connection?.close();
      } catch (_) {
        // Closing the other track remains mandatory.
      }
    }
    _sellerConnection = null;
    _prospectConnection = null;
  }

  Future<void> _disposeMediaSafely() async {
    try {
      await _captureClient?.cancel();
    } catch (_) {
      // Native capture may already be stopped.
    }
    for (final PinkallBinaryRealtimeConnection? connection
        in <PinkallBinaryRealtimeConnection?>[
          _sellerConnection,
          _prospectConnection,
        ]) {
      try {
        await connection?.close();
      } catch (_) {
        // Provider disposal is best-effort.
      }
    }
  }

  ConversationSessionRepository _requireRepository() =>
      _sessionRepository ??
      (throw StateError('Conversation session repository is unavailable.'));

  MacosCallAudioCaptureClient _requireCaptureClient() =>
      _captureClient ??
      (throw StateError('macOS capture client is unavailable.'));

  PinkallBinaryRealtimeClient _requireBinaryClient() =>
      _binaryClient ??
      (throw StateError('Binary media client is unavailable.'));
}

void _validateMediaContract(ExternalMediaConfigurationEntity media) {
  if (media.encoding != 'pcm_s16le' ||
      media.sampleRate != 16000 ||
      media.channels != 1) {
    throw const FormatException('Unsupported external media format.');
  }
}

String? _optionalText(String? value) {
  final String normalized = value?.trim() ?? '';
  return normalized.isEmpty ? null : normalized;
}

String _startFailureMessage(Object error) {
  if (error is MacosCallAudioCaptureException) {
    return switch (error.failure) {
      MacosCallAudioCaptureFailure.screenCapturePermissionDenied =>
        'Autorise Pinkall dans Réglages Système > Confidentialité et sécurité '
            '> Enregistrement de l’écran et de l’audio système.',
      MacosCallAudioCaptureFailure.microphonePermissionDenied =>
        'Autorise Pinkall dans Réglages Système > Confidentialité et sécurité '
            '> Microphone.',
      MacosCallAudioCaptureFailure.unsupportedOperatingSystem =>
        'Instant Help nécessite une version récente de macOS.',
      _ =>
        'Instant Help n’a pas pu démarrer. Vérifie les autorisations puis réessaie.',
    };
  }
  return 'Instant Help n’a pas pu démarrer. Vérifie ta connexion puis réessaie.';
}

List<TranscriptSegmentEntity> _upsertSegment(
  List<TranscriptSegmentEntity> current,
  TranscriptSegmentEntity segment,
) {
  final List<TranscriptSegmentEntity> updated = <TranscriptSegmentEntity>[
    ...current,
  ];
  final int index = updated.indexWhere(
    (TranscriptSegmentEntity value) =>
        value.id == segment.id || value.sequence == segment.sequence,
  );
  if (index == -1) {
    updated.add(segment);
  } else {
    updated[index] = segment;
  }
  updated.sort(
    (TranscriptSegmentEntity left, TranscriptSegmentEntity right) =>
        left.sequence.compareTo(right.sequence),
  );
  return List<TranscriptSegmentEntity>.unmodifiable(updated);
}
