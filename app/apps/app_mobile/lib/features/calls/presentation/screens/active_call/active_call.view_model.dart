import 'dart:async';

import 'package:core_domain/core_domain.dart';
import 'package:core_foundation/core_foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pinkall/core/providers/core/usecases/disconnect_telnyx.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/get_call_debrief.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/hang_up_call.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/list_audio_devices.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/select_audio_device.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/set_call_muted.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/set_speaker_enabled.use_case.provider.dart';
import 'package:pinkall/core/providers/core/usecases/watch_call_state.use_case.provider.dart';
import 'package:pinkall/core/providers/data/endpoint/audio_device.client.provider.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/calls/presentation/screens/active_call/active_call.state.dart';
import 'package:pinkall/generated/locale_keys.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_call.view_model.g.dart';

/// Drives Telnyx controls and the provider-independent Pinkall live session.
@riverpod
class ActiveCallViewModel extends _$ActiveCallViewModel {
  static const List<Duration> _finalizationRetryDelays = <Duration>[
    Duration(seconds: 1),
    Duration(seconds: 2),
    Duration(seconds: 3),
  ];
  static const int _finalizationPollAttempts = 5;

  HangUpCallUseCase? _hangUpCallUseCase;
  DisconnectTelnyxUseCase? _disconnectTelnyxUseCase;
  SetCallMutedUseCase? _setCallMutedUseCase;
  SetSpeakerEnabledUseCase? _setSpeakerEnabledUseCase;
  ListAudioDevicesUseCase? _listAudioDevicesUseCase;
  SelectAudioDeviceUseCase? _selectAudioDeviceUseCase;
  late GetCallDebriefUseCase _getCallDebriefUseCase;
  late ConversationSessionRepository _conversationSessionRepository;
  StreamSubscription<ResultState<CallStateEntity>>? _callSubscription;
  StreamSubscription<SessionRealtimeEventEntity>? _realtimeSubscription;
  Timer? _listenerStartTimer;
  Timer? _realtimeWatchdog;
  Timer? _timer;
  bool _disposed = false;
  bool _isFinalizing = false;
  bool _callBecameActive = false;
  bool _terminalReconciliationStarted = false;
  bool _companion = false;
  bool _supportsAudioDeviceSelection = false;

  @override
  Future<ActiveCallState> build(
    String callId,
    String sessionId,
    String? remoteNumber,
    bool incoming,
    bool companion,
  ) async {
    ref.onDispose(() {
      _disposed = true;
      _listenerStartTimer?.cancel();
      _realtimeWatchdog?.cancel();
      _timer?.cancel();
      unawaited(_callSubscription?.cancel());
      unawaited(_realtimeSubscription?.cancel());
    });
    _companion = companion;
    _supportsAudioDeviceSelection =
        !companion && ref.watch(supportsDesktopAudioDeviceSelectionProvider);
    if (!companion) {
      _hangUpCallUseCase = await ref.watch(hangUpCallUseCaseProvider.future);
      _disconnectTelnyxUseCase = await ref.watch(
        disconnectTelnyxUseCaseProvider.future,
      );
      _setCallMutedUseCase = await ref.watch(
        setCallMutedUseCaseProvider.future,
      );
      _setSpeakerEnabledUseCase = await ref.watch(
        setSpeakerEnabledUseCaseProvider.future,
      );
      if (_supportsAudioDeviceSelection) {
        _listAudioDevicesUseCase = ref.watch(listAudioDevicesUseCaseProvider);
        _selectAudioDeviceUseCase = ref.watch(selectAudioDeviceUseCaseProvider);
      }
    }
    _conversationSessionRepository = ref.watch(
      conversationSessionRepositoryProvider,
    );
    _getCallDebriefUseCase = await ref.watch(
      getCallDebriefUseCaseProvider.future,
    );
    final ConversationSessionEntity processingSession =
        await _conversationSessionRepository.getSession(sessionId);
    final WatchCallStateUseCase? watchCall = companion
        ? null
        : await ref.watch(watchCallStateUseCaseProvider.future);
    _listenerStartTimer = Timer(Duration.zero, () {
      if (_disposed) {
        return;
      }
      if (watchCall != null) {
        _callSubscription = watchCall
            .execute(CallActionParam(callId: callId))
            .listen(
              (ResultState<CallStateEntity> result) =>
                  _onCallResult(callId, result),
            );
      } else {
        _startTimer();
      }
      if (companion &&
          processingSession.status == ConversationSessionStatus.completed) {
        unawaited(_refreshCompanionSession(sessionId));
      }
      if (processingSession.transcriptionConsentAcknowledged) {
        _startRealtime(sessionId);
      }
      if (_supportsAudioDeviceSelection) {
        unawaited(refreshAudioDevices());
      }
    });

    final ActiveCallState initial = ActiveCallState.initial(
      CallStateEntity(
        callId: callId,
        direction: incoming ? CallDirection.incoming : CallDirection.outgoing,
        status: companion
            ? switch (processingSession.status) {
                ConversationSessionStatus.completed =>
                  CallLifecycleStatus.ended,
                ConversationSessionStatus.failed => CallLifecycleStatus.error,
                _ => CallLifecycleStatus.active,
              }
            : incoming
            ? CallLifecycleStatus.connecting
            : CallLifecycleStatus.newCall,
        remoteNumber: remoteNumber,
      ),
      processingSession,
      isCompanion: companion,
      supportsAudioDeviceSelection: _supportsAudioDeviceSelection,
    );
    final DateTime? durationStart = processingSession.startedAt;
    final DateTime? durationEnd = processingSession.endedAt;
    return initial.copyWith(
      elapsed: durationStart != null && durationEnd != null
          ? durationEnd.difference(durationStart)
          : Duration.zero,
    );
  }

  /// Records the distinct transcription notice acknowledgement.
  Future<void> acknowledgeTranscription(
    TranscriptionConsentMethod method,
  ) async {
    final ActiveCallState? current = _currentState;
    if (_companion ||
        current == null ||
        current.processingSession.transcriptionConsentAcknowledged) {
      return;
    }
    _setOperation(isOperating: true);
    try {
      final TranscriptionConsentEntity consent =
          await _conversationSessionRepository.recordTranscriptionConsent(
            RecordTranscriptionConsentParam(
              sessionId: current.processingSession.id,
              acknowledged: true,
              method: method,
              acknowledgedAt: DateTime.now().toUtc(),
            ),
          );
      final ActiveCallState? latest = _currentState;
      if (latest == null) {
        return;
      }
      _emit(
        latest.copyWith(
          processingSession: latest.processingSession.copyWith(
            transcriptionConsentAcknowledged: consent.acknowledged,
          ),
          isOperating: false,
          operationFailure: null,
          realtimeFailure: null,
        ),
      );
      _startRealtime(current.processingSession.id);
    } catch (error) {
      _setOperation(
        isOperating: false,
        operationFailure: 'La transcription ne peut pas démarrer. Réessaie.',
      );
    }
  }

  /// Enables or disables visible coaching for this call only.
  Future<void> setCoachEnabled({required bool enabled}) async {
    final ActiveCallState? current = _currentState;
    if (_companion || current == null) {
      return;
    }
    _setOperation(isOperating: true);
    try {
      final ConversationSessionEntity updated =
          await _conversationSessionRepository.updateCoachMode(
            UpdateSessionCoachModeParam(
              sessionId: current.processingSession.id,
              mode: enabled ? CoachMode.live : CoachMode.off,
            ),
          );
      final ActiveCallState? latest = _currentState;
      if (latest == null) {
        return;
      }
      _emit(
        latest.copyWith(
          processingSession: updated,
          suggestion: updated.coachMode == CoachMode.live
              ? latest.suggestion
              : null,
          coachAnalysisStatus: CoachAnalysisStatus.listening,
          coachAnalysisOutcome: null,
          isOperating: false,
          operationFailure: null,
        ),
      );
    } catch (error) {
      _setOperation(
        isOperating: false,
        operationFailure: 'Le coach n’a pas pu être modifié. Réessaie.',
      );
    }
  }

  /// Ends the real Telnyx call and starts the real post-call reconciliation.
  Future<bool> hangUp() async {
    final ActiveCallState? current = _currentState;
    final HangUpCallUseCase? useCase = _hangUpCallUseCase;
    if (_companion || current == null || useCase == null) {
      return false;
    }
    _setOperation(isOperating: true);
    final ResultState<void> result = await useCase.execute(
      CallActionParam(callId: current.session.callId),
    );
    return result.when<bool>(
      success: (_) {
        final ActiveCallState? latest = _currentState;
        if (latest != null) {
          _callBecameActive =
              _callBecameActive ||
              latest.session.status == CallLifecycleStatus.active;
          final ActiveCallState endedState = latest.copyWith(
            session: latest.session.copyWith(status: CallLifecycleStatus.ended),
            isOperating: false,
            operationFailure: null,
          );
          _emit(endedState);
          _reconcileTerminalCall(endedState);
        }
        _timer?.cancel();
        return true;
      },
      failure: (Exception exception) {
        _setOperation(
          isOperating: false,
          operationFailure: _localizedCallFailure(exception),
        );
        return false;
      },
    );
  }

  /// Requests or retries backend finalization and fetches real artifacts.
  Future<void> finalizeDebrief() async {
    final ActiveCallState? current = _currentState;
    if (current == null || _isFinalizing) {
      return;
    }
    if (_companion) {
      await _refreshCompanionSession(current.processingSession.id);
      return;
    }
    _isFinalizing = true;
    _emit(
      current.copyWith(
        finalizationMessage: 'Débrief en préparation…',
        operationFailure: null,
      ),
    );
    try {
      ConversationSessionEntity processingSession =
          await _finalizeSessionWithRetry(current.processingSession.id);
      if (!_isMounted) {
        return;
      }
      processingSession = await _waitForFinalSession(processingSession);
      if (!_isMounted) {
        return;
      }
      ConversationTranscriptEntity? finalTranscript;
      CallDebriefEntity? debrief;
      if (processingSession.status == ConversationSessionStatus.completed) {
        finalTranscript = await _conversationSessionRepository
            .getFinalTranscript(processingSession.id);
        if (!_isMounted) {
          return;
        }
      }
      if (processingSession.status == ConversationSessionStatus.completed) {
        try {
          debrief = await _getCallDebriefUseCase.invoke(
            SessionActionParam(sessionId: processingSession.id),
          );
          if (!_isMounted) {
            return;
          }
        } catch (_) {
          // A provider outage must not hide a valid final transcript.
          debrief = null;
        }
      }
      final ActiveCallState? latest = _currentState;
      if (latest == null) {
        return;
      }
      final String message = switch (processingSession.status) {
        ConversationSessionStatus.completed when debrief != null =>
          'Débrief final disponible.',
        ConversationSessionStatus.completed =>
          'Transcription disponible. L’analyse n’a pas pu être générée.',
        ConversationSessionStatus.failed =>
          'Le débrief n’a pas pu être généré. Réessaie.',
        _ => 'Le débrief est encore en préparation. Réessaie dans un instant.',
      };
      _emit(
        latest.copyWith(
          processingSession: processingSession,
          finalTranscript: finalTranscript,
          debrief: debrief,
          transcript: finalTranscript?.segments ?? latest.transcript,
          finalizationMessage: message,
          realtimeFailure:
              processingSession.status == ConversationSessionStatus.failed
              ? 'La transcription est momentanément indisponible.'
              : latest.realtimeFailure,
        ),
      );
    } catch (error) {
      final ActiveCallState? latest = _currentState;
      if (latest != null) {
        _emit(
          latest.copyWith(
            finalizationMessage: 'Le débrief n’a pas pu être généré. Réessaie.',
          ),
        );
      }
    } finally {
      _isFinalizing = false;
    }
  }

  Future<ConversationSessionEntity> _finalizeSessionWithRetry(
    String sessionId,
  ) async {
    for (int attempt = 0; ; attempt++) {
      try {
        return await _conversationSessionRepository.finalizeSession(sessionId);
      } catch (error, stackTrace) {
        if (attempt >= _finalizationRetryDelays.length) {
          Error.throwWithStackTrace(error, stackTrace);
        }
        _setFinalizationProgress(
          'Finalisation de l’audio… nouvelle tentative automatique.',
        );
        await Future<void>.delayed(_finalizationRetryDelays[attempt]);
      }
    }
  }

  Future<ConversationSessionEntity> _waitForFinalSession(
    ConversationSessionEntity processingSession,
  ) async {
    ConversationSessionEntity latest = processingSession;
    for (
      int attempt = 0;
      attempt < _finalizationPollAttempts &&
          latest.status != ConversationSessionStatus.completed &&
          latest.status != ConversationSessionStatus.failed;
      attempt++
    ) {
      if (!_isMounted) {
        return latest;
      }
      _setFinalizationProgress('Transcription finale en préparation…');
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!_isMounted) {
        return latest;
      }
      latest = await _conversationSessionRepository.getSession(latest.id);
    }
    return latest;
  }

  void _setFinalizationProgress(String message) {
    final ActiveCallState? latest = _currentState;
    if (latest == null) {
      return;
    }
    _emit(latest.copyWith(finalizationMessage: message));
  }

  void _reconcileTerminalCall(ActiveCallState current) {
    if (_terminalReconciliationStarted) {
      return;
    }
    _terminalReconciliationStarted = true;
    final bool mediaNeverStarted =
        !_callBecameActive &&
        current.processingSession.status == ConversationSessionStatus.created;
    if (mediaNeverStarted) {
      unawaited(_cancelUnstartedSession(current.processingSession.id));
      return;
    }
    unawaited(finalizeDebrief());
  }

  Future<void> _cancelUnstartedSession(String sessionId) async {
    _realtimeWatchdog?.cancel();
    try {
      await _realtimeSubscription?.cancel();
    } catch (_) {
      // The backend cancellation below is still required if stream cleanup
      // races with provider disposal.
    }
    _realtimeSubscription = null;
    final ActiveCallState? current = _currentState;
    if (current != null) {
      _emit(
        current.copyWith(
          finalizationMessage: 'Appel non établi. Aucun débrief à générer.',
        ),
      );
    }
    try {
      final ConversationSessionEntity cancelled =
          await _conversationSessionRepository.cancelSession(sessionId);
      final ActiveCallState? latest = _currentState;
      if (latest == null) {
        return;
      }
      _emit(latest.copyWith(processingSession: cancelled));
    } catch (_) {
      // The call already failed; cancellation is best-effort and must never
      // turn into a misleading finalization attempt or a disposed-ref crash.
    }
  }

  /// Disconnects the complete Telnyx session as a last-resort escape hatch.
  Future<void> disconnectSession() async {
    final DisconnectTelnyxUseCase? useCase = _disconnectTelnyxUseCase;
    if (useCase == null) {
      return;
    }
    await useCase.execute();
  }

  /// Mutes or unmutes the real WebRTC microphone.
  Future<void> toggleMute() async {
    final ActiveCallState? current = _currentState;
    final SetCallMutedUseCase? useCase = _setCallMutedUseCase;
    if (_companion || current == null || useCase == null) {
      return;
    }
    final bool nextMuted = !current.session.isMuted;
    _setOperation(isOperating: true);
    final ResultState<void> result = await useCase.execute(
      SetCallMutedParam(callId: current.session.callId, isMuted: nextMuted),
    );
    _finishControl(
      result,
      onSuccess: (ActiveCallState value) =>
          value.copyWith(session: value.session.copyWith(isMuted: nextMuted)),
    );
  }

  /// Changes the real WebRTC audio route.
  Future<void> toggleSpeaker() async {
    final ActiveCallState? current = _currentState;
    final SetSpeakerEnabledUseCase? useCase = _setSpeakerEnabledUseCase;
    if (_companion ||
        current == null ||
        current.supportsAudioDeviceSelection ||
        useCase == null) {
      return;
    }
    final bool nextEnabled = !current.session.isSpeakerEnabled;
    _setOperation(isOperating: true);
    final ResultState<void> result = await useCase.execute(
      SetSpeakerEnabledParam(
        callId: current.session.callId,
        isEnabled: nextEnabled,
      ),
    );
    _finishControl(
      result,
      onSuccess: (ActiveCallState value) => value.copyWith(
        session: value.session.copyWith(isSpeakerEnabled: nextEnabled),
      ),
    );
  }

  /// Reloads the input and output devices exposed by macOS WebRTC.
  Future<void> refreshAudioDevices() async {
    final ActiveCallState? current = _currentState;
    final ListAudioDevicesUseCase? useCase = _listAudioDevicesUseCase;
    if (_companion ||
        current == null ||
        !current.supportsAudioDeviceSelection ||
        useCase == null) {
      return;
    }
    _emit(current.copyWith(isLoadingAudioDevices: true));
    final ResultState<List<AudioDeviceEntity>> result = await useCase.execute();
    result.when<void>(
      success: (List<AudioDeviceEntity> devices) {
        final ActiveCallState? latest = _currentState;
        if (latest == null) {
          return;
        }
        _emit(
          latest.copyWith(
            audioDevices: List<AudioDeviceEntity>.unmodifiable(devices),
            selectedAudioInputId: _availableSelection(
              devices,
              latest.selectedAudioInputId,
              AudioDeviceKind.input,
            ),
            selectedAudioOutputId: _availableSelection(
              devices,
              latest.selectedAudioOutputId,
              AudioDeviceKind.output,
            ),
            isLoadingAudioDevices: false,
            operationFailure: null,
          ),
        );
      },
      failure: (Exception exception) {
        final ActiveCallState? latest = _currentState;
        if (latest == null) {
          return;
        }
        _emit(
          latest.copyWith(
            isLoadingAudioDevices: false,
            operationFailure:
                'Les périphériques audio ne sont pas disponibles. Réessaie.',
          ),
        );
      },
    );
  }

  /// Selects the macOS microphone or playback device used by WebRTC.
  Future<void> selectAudioDevice(AudioDeviceKind kind, String deviceId) async {
    final ActiveCallState? current = _currentState;
    final SelectAudioDeviceUseCase? useCase = _selectAudioDeviceUseCase;
    final String normalizedId = deviceId.trim();
    if (_companion ||
        current == null ||
        !current.supportsAudioDeviceSelection ||
        useCase == null) {
      return;
    }
    final bool isAvailable = current.audioDevices.any(
      (AudioDeviceEntity device) =>
          device.id == normalizedId && device.kind == kind,
    );
    if (normalizedId.isEmpty || !isAvailable) {
      _setOperation(
        isOperating: false,
        operationFailure: 'Ce périphérique audio n’est plus disponible.',
      );
      return;
    }
    _setOperation(isOperating: true);
    final ResultState<void> result = await useCase.execute(
      SelectAudioDeviceParam(deviceId: normalizedId, kind: kind),
    );
    result.when<void>(
      success: (_) {
        final ActiveCallState? latest = _currentState;
        if (latest == null) {
          return;
        }
        _emit(
          latest.copyWith(
            selectedAudioInputId: kind == AudioDeviceKind.input
                ? normalizedId
                : latest.selectedAudioInputId,
            selectedAudioOutputId: kind == AudioDeviceKind.output
                ? normalizedId
                : latest.selectedAudioOutputId,
            isOperating: false,
            operationFailure: null,
          ),
        );
      },
      failure: (Exception exception) => _setOperation(
        isOperating: false,
        operationFailure:
            'Le périphérique audio n’a pas pu être sélectionné. Réessaie.',
      ),
    );
  }

  void _startRealtime(String sessionId) {
    if (_disposed || _realtimeSubscription != null) {
      return;
    }
    _realtimeSubscription = _conversationSessionRepository
        .watchSessionEvents(sessionId)
        .listen(
          _onRealtimeEvent,
          onError: (Object error, StackTrace stackTrace) {
            _realtimeWatchdog?.cancel();
            final ActiveCallState? current = _currentState;
            if (current == null) {
              return;
            }
            _emit(
              current.copyWith(
                realtimeFailure:
                    'La transcription est momentanément indisponible.',
              ),
            );
          },
        );
    _realtimeWatchdog?.cancel();
    _realtimeWatchdog = Timer(const Duration(seconds: 10), () {
      final ActiveCallState? current = _currentState;
      if (current == null || current.transcript.isNotEmpty) {
        return;
      }
      _emit(
        current.copyWith(
          realtimeFailure:
              'La transcription tarde à démarrer. Tu peux poursuivre l’appel.',
        ),
      );
    });
  }

  void _onRealtimeEvent(SessionRealtimeEventEntity event) {
    final ActiveCallState? current = _currentState;
    if (current == null) {
      return;
    }
    switch (event) {
      case SessionTranscriptSegmentEventEntity(
        segment: final TranscriptSegmentEntity segment,
      ):
        _realtimeWatchdog?.cancel();
        _emit(
          current.copyWith(
            transcript: _upsertSegment(current.transcript, segment),
            realtimeFailure: null,
          ),
        );
      case SessionCoachingSuggestionEventEntity(
        suggestion: final CoachingSuggestionEntity suggestion,
      ):
        if (current.processingSession.coachMode != CoachMode.live ||
            suggestion.isExpiredAt(DateTime.now().toUtc())) {
          return;
        }
        _emit(
          current.copyWith(
            suggestion: suggestion,
            coachAnalysisStatus: CoachAnalysisStatus.listening,
            coachAnalysisOutcome: CoachAnalysisOutcome.suggestion,
          ),
        );
      case SessionCoachStatusEventEntity(
        coachStatus: final CoachStatusEntity coachStatus,
      ):
        if (current.processingSession.coachMode != CoachMode.live) {
          return;
        }
        _emit(
          current.copyWith(
            coachAnalysisStatus: coachStatus.status,
            coachAnalysisOutcome: coachStatus.outcome,
          ),
        );
      case SessionStateEventEntity(
        session: final ConversationSessionEntity session,
      ):
        final bool processingFinished = <ConversationSessionStatus>{
          ConversationSessionStatus.completed,
          ConversationSessionStatus.failed,
        }.contains(session.status);
        _emit(
          current.copyWith(
            session: _companion && processingFinished
                ? current.session.copyWith(status: CallLifecycleStatus.ended)
                : current.session,
            processingSession: session,
            suggestion: session.coachMode == CoachMode.live
                ? current.suggestion
                : null,
            coachAnalysisStatus: session.coachMode == CoachMode.live
                ? current.coachAnalysisStatus
                : CoachAnalysisStatus.listening,
            coachAnalysisOutcome: session.coachMode == CoachMode.live
                ? current.coachAnalysisOutcome
                : null,
            realtimeFailure: session.status == ConversationSessionStatus.failed
                ? 'La transcription est momentanément indisponible.'
                : null,
          ),
        );
        if (_companion &&
            session.status == ConversationSessionStatus.completed) {
          unawaited(_loadCompanionArtifacts(session.id));
        }
      case SessionUnknownEventEntity():
        // Forward-compatible events must never interrupt transcription.
        return;
    }
  }

  Future<void> _refreshCompanionSession(String sessionId) async {
    try {
      final ConversationSessionEntity processingSession =
          await _conversationSessionRepository.getSession(sessionId);
      final ActiveCallState? current = _currentState;
      if (current == null) {
        return;
      }
      _emit(
        current.copyWith(
          processingSession: processingSession,
          session:
              processingSession.status == ConversationSessionStatus.completed ||
                  processingSession.status == ConversationSessionStatus.failed
              ? current.session.copyWith(status: CallLifecycleStatus.ended)
              : current.session,
          finalizationMessage:
              processingSession.status == ConversationSessionStatus.completed
              ? 'Débrief final disponible.'
              : 'La session de l’appareil source est toujours active.',
        ),
      );
      if (processingSession.status == ConversationSessionStatus.completed) {
        await _loadCompanionArtifacts(sessionId);
      }
    } catch (error) {
      final ActiveCallState? current = _currentState;
      if (current != null) {
        _emit(
          current.copyWith(
            finalizationMessage:
                'La synchronisation avec l’autre appareil est indisponible.',
          ),
        );
      }
    }
  }

  Future<void> _loadFinalTranscript(String sessionId) async {
    try {
      final ConversationTranscriptEntity transcript =
          await _conversationSessionRepository.getFinalTranscript(sessionId);
      final ActiveCallState? current = _currentState;
      if (current == null) {
        return;
      }
      _emit(
        current.copyWith(
          finalTranscript: transcript,
          transcript: transcript.segments,
          finalizationMessage: 'Transcription finale disponible.',
        ),
      );
    } catch (error) {
      final ActiveCallState? current = _currentState;
      if (current != null) {
        _emit(
          current.copyWith(
            finalizationMessage:
                'La transcription finale est indisponible. Réessaie.',
          ),
        );
      }
    }
  }

  Future<void> _loadCompanionArtifacts(String sessionId) async {
    await _loadFinalTranscript(sessionId);
    await _loadCompanionDebrief(sessionId);
  }

  Future<void> _loadCompanionDebrief(String sessionId) async {
    try {
      final CallDebriefEntity debrief = await _getCallDebriefUseCase.invoke(
        SessionActionParam(sessionId: sessionId),
      );
      final ActiveCallState? current = _currentState;
      if (current == null) {
        return;
      }
      _emit(
        current.copyWith(
          debrief: debrief,
          finalizationMessage: 'Débrief final disponible.',
        ),
      );
    } catch (error) {
      final ActiveCallState? current = _currentState;
      if (current != null && current.finalTranscript != null) {
        _emit(
          current.copyWith(
            debrief: null,
            finalizationMessage:
                'Transcription disponible. L’analyse n’a pas pu être générée.',
          ),
        );
      }
    }
  }

  void _onCallResult(
    String expectedCallId,
    ResultState<CallStateEntity> result,
  ) {
    if (!_isMounted) {
      return;
    }
    result.when<void>(
      success: (CallStateEntity call) {
        if (call.callId != expectedCallId) {
          return;
        }
        final ActiveCallState? current = _currentState;
        if (current == null) {
          return;
        }
        if (call.status == CallLifecycleStatus.active) {
          _callBecameActive = true;
        }
        final ActiveCallState next = current.copyWith(
          session: call,
          operationFailure: _callFailureMessage(call),
        );
        _emit(next);
        if (call.status == CallLifecycleStatus.active) {
          _startTimer();
        } else if (_isTerminal(call.status)) {
          _timer?.cancel();
          _reconcileTerminalCall(next);
        }
      },
      failure: (Exception exception) => _setOperation(
        isOperating: false,
        operationFailure: _localizedCallFailure(exception),
      ),
    );
  }

  void _startTimer() {
    if (!_isMounted || _timer?.isActive == true) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final ActiveCallState? current = _currentState;
      if (current == null ||
          current.session.status != CallLifecycleStatus.active) {
        return;
      }
      final CoachingSuggestionEntity? suggestion = current.suggestion;
      _emit(
        current.copyWith(
          elapsed: current.elapsed + const Duration(seconds: 1),
          suggestion:
              suggestion != null &&
                  suggestion.isExpiredAt(DateTime.now().toUtc())
              ? null
              : suggestion,
        ),
      );
    });
  }

  void _finishControl(
    ResultState<void> result, {
    required ActiveCallState Function(ActiveCallState value) onSuccess,
  }) {
    result.when<void>(
      success: (_) {
        final ActiveCallState? current = _currentState;
        if (current == null) {
          return;
        }
        _emit(
          onSuccess(
            current,
          ).copyWith(isOperating: false, operationFailure: null),
        );
      },
      failure: (Exception exception) => _setOperation(
        isOperating: false,
        operationFailure: _localizedCallFailure(exception),
      ),
    );
  }

  void _setOperation({required bool isOperating, String? operationFailure}) {
    final ActiveCallState? current = _currentState;
    if (current == null) {
      return;
    }
    _emit(
      current.copyWith(
        isOperating: isOperating,
        operationFailure: operationFailure,
      ),
    );
  }

  bool get _isMounted => !_disposed && ref.mounted;

  ActiveCallState? get _currentState => _isMounted ? state.value : null;

  void _emit(ActiveCallState value) {
    if (!_isMounted) {
      return;
    }
    state = AsyncData<ActiveCallState>(value);
  }
}

List<TranscriptSegmentEntity> _upsertSegment(
  List<TranscriptSegmentEntity> current,
  TranscriptSegmentEntity segment,
) {
  final List<TranscriptSegmentEntity> updated = <TranscriptSegmentEntity>[
    ...current,
  ];
  final int existingIndex = updated.indexWhere(
    (TranscriptSegmentEntity value) =>
        value.id == segment.id || value.sequence == segment.sequence,
  );
  if (existingIndex == -1) {
    updated.add(segment);
  } else {
    updated[existingIndex] = segment;
  }
  updated.sort(
    (TranscriptSegmentEntity left, TranscriptSegmentEntity right) =>
        left.sequence.compareTo(right.sequence),
  );
  return List<TranscriptSegmentEntity>.unmodifiable(updated);
}

bool _isTerminal(CallLifecycleStatus status) => <CallLifecycleStatus>{
  CallLifecycleStatus.ended,
  CallLifecycleStatus.error,
}.contains(status);

String _localizedCallFailure(Exception exception) {
  if (exception is CallOperationException &&
      exception.code == CallFailureCode.microphoneAccessDenied) {
    return LocaleKeys.error_microphone.tr();
  }
  return LocaleKeys.error_body.tr();
}

String? _callFailureMessage(CallStateEntity call) {
  final String reason = call.failureReason?.trim() ?? '';
  if (reason.isEmpty) {
    return call.status == CallLifecycleStatus.error
        ? LocaleKeys.error_body.tr()
        : null;
  }
  final bool accountRejected = RegExp(
    r'\bD17\b',
    caseSensitive: false,
  ).hasMatch(reason);
  if (accountRejected) {
    return 'Le compte téléphonique est bloqué par le fournisseur. '
        'Vérifie l’e-mail reçu ou contacte son support avant de réessayer.';
  }
  if (reason == 'media_connection_failed') {
    return 'La connexion audio n’a pas pu s’établir. Vérifie ton réseau puis '
        'réessaie.';
  }
  if (_isTerminal(call.status)) {
    return 'Le fournisseur téléphonique a refusé l’appel. Réessaie dans un '
        'instant ou vérifie la configuration voix.';
  }
  return null;
}

String? _availableSelection(
  List<AudioDeviceEntity> devices,
  String? selectedId,
  AudioDeviceKind kind,
) {
  if (selectedId == null) {
    return null;
  }
  return devices.any(
        (AudioDeviceEntity device) =>
            device.id == selectedId && device.kind == kind,
      )
      ? selectedId
      : null;
}
