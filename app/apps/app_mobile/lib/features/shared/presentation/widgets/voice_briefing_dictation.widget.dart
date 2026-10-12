import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:core_data/core_data.dart';
import 'package:core_domain/core_domain.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinkall/core/providers/briefing_dictation.providers.dart';
import 'package:pinkall/generated/locale_keys.g.dart';

/// Premium voice-to-text entry point shared by project and call briefings.
final class VoiceBriefingDictation extends ConsumerStatefulWidget {
  /// Creates an editable dictation control attached to [controller].
  const VoiceBriefingDictation({
    required this.controller,
    required this.idleTitle,
    required this.idleDescription,
    required this.maxTextBytes,
    this.onTranscriptApplied,
    this.maxDuration = const Duration(minutes: 5),
    this.enabled = true,
    super.key,
  });

  /// Text field that receives the completed transcript.
  final TextEditingController controller;

  /// Contextual primary copy shown before recording.
  final String idleTitle;

  /// Contextual explanation shown before recording.
  final String idleDescription;

  /// Maximum UTF-8 size accepted by the destination briefing field.
  final int maxTextBytes;

  /// Notifies the owning form so counters and validation refresh immediately.
  final VoidCallback? onTranscriptApplied;

  /// Automatic stop guard for short-form dictation.
  final Duration maxDuration;

  /// Whether the control can start a new recording.
  final bool enabled;

  @override
  ConsumerState<VoiceBriefingDictation> createState() =>
      _VoiceBriefingDictationState();
}

enum _VoiceBriefingPhase { idle, starting, recording, transcribing }

final class _VoiceBriefingDictationState
    extends ConsumerState<VoiceBriefingDictation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;
  _VoiceBriefingPhase _phase = _VoiceBriefingPhase.idle;
  VoiceDictationRecorderClient? _activeRecorder;
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  String? _failure;
  bool _applied = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 980),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveController.dispose();
    final VoiceDictationRecorderClient? recorder = _activeRecorder;
    if (recorder != null) {
      unawaited(recorder.cancel());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool recording = _phase == _VoiceBriefingPhase.recording;
    final bool busy =
        _phase == _VoiceBriefingPhase.starting ||
        _phase == _VoiceBriefingPhase.transcribing;
    final String title = switch (_phase) {
      _VoiceBriefingPhase.idle => widget.idleTitle,
      _VoiceBriefingPhase.starting => LocaleKeys.voice_dictation_starting.tr(),
      _VoiceBriefingPhase.recording =>
        LocaleKeys.voice_dictation_listening.tr(),
      _VoiceBriefingPhase.transcribing =>
        LocaleKeys.voice_dictation_processing.tr(),
    };
    final String description = switch (_phase) {
      _VoiceBriefingPhase.idle => widget.idleDescription,
      _VoiceBriefingPhase.starting =>
        LocaleKeys.voice_dictation_starting_hint.tr(),
      _VoiceBriefingPhase.recording =>
        LocaleKeys.voice_dictation_stop_hint.tr(),
      _VoiceBriefingPhase.transcribing =>
        LocaleKeys.voice_dictation_processing_hint.tr(),
    };
    final Color accent = recording ? colors.primary : colors.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Semantics(
          button: !busy,
          label: recording
              ? LocaleKeys.voice_dictation_stop.tr()
              : widget.idleTitle,
          child: AnimatedContainer(
            key: const Key('voice_dictation_control'),
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: recording
                  ? colors.primaryContainer.withValues(alpha: 0.34)
                  : colors.surfaceContainerHighest.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: recording
                    ? colors.primary.withValues(alpha: 0.5)
                    : colors.outlineVariant.withValues(alpha: 0.72),
              ),
              boxShadow: recording
                  ? <BoxShadow>[
                      BoxShadow(
                        color: colors.primary.withValues(alpha: 0.13),
                        blurRadius: 28,
                        spreadRadius: 1,
                      ),
                    ]
                  : const <BoxShadow>[],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: !widget.enabled || busy
                    ? null
                    : recording
                    ? _finish
                    : _start,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  child: Row(
                    children: <Widget>[
                      _VoiceOrb(phase: _phase, animation: _waveController),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(
                                          color: accent,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ),
                                if (recording) ...<Widget>[
                                  const SizedBox(width: 10),
                                  Text(
                                    _formatDuration(_elapsed),
                                    key: const Key('voice_dictation_elapsed'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: colors.primary,
                                          fontFeatures: const <FontFeature>[
                                            FontFeature.tabularFigures(),
                                          ],
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colors.onSurfaceVariant,
                                    height: 1.35,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: busy
                            ? SizedBox(
                                key: const ValueKey<String>('busy'),
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: colors.primary,
                                ),
                              )
                            : Icon(
                                recording
                                    ? Icons.stop_rounded
                                    : Icons.arrow_forward_rounded,
                                key: ValueKey<bool>(recording),
                                color: recording
                                    ? colors.primary
                                    : colors.onSurfaceVariant,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (recording) ...<Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: const Key('voice_dictation_cancel'),
              onPressed: _cancel,
              child: Text(LocaleKeys.common_cancel.tr()),
            ),
          ),
        ] else if (_failure != null) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            _failure!,
            key: const Key('voice_dictation_error'),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.error, height: 1.35),
          ),
        ] else if (_applied) ...<Widget>[
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Icon(Icons.check_circle_rounded, size: 16, color: colors.primary),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  LocaleKeys.voice_dictation_added.tr(),
                  key: const Key('voice_dictation_success'),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _start() async {
    if (_phase != _VoiceBriefingPhase.idle) {
      return;
    }
    setState(() {
      _phase = _VoiceBriefingPhase.starting;
      _failure = null;
      _applied = false;
      _elapsed = Duration.zero;
    });
    final VoiceDictationRecorderClient recorder = ref.read(
      voiceDictationRecorderClientProvider,
    );
    _activeRecorder = recorder;
    try {
      await recorder.start();
      if (!mounted) {
        await recorder.cancel();
        return;
      }
      unawaited(HapticFeedback.mediumImpact());
      _waveController.repeat();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted || _phase != _VoiceBriefingPhase.recording) {
          return;
        }
        setState(() => _elapsed += const Duration(seconds: 1));
        if (_elapsed >= widget.maxDuration) {
          unawaited(_finish());
        }
      });
      setState(() => _phase = _VoiceBriefingPhase.recording);
    } on Object catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _phase = _VoiceBriefingPhase.idle;
        _failure = _recordingFailure(error);
      });
    }
  }

  Future<void> _finish() async {
    if (_phase != _VoiceBriefingPhase.recording) {
      return;
    }
    _timer?.cancel();
    _waveController
      ..stop()
      ..reset();
    setState(() {
      _phase = _VoiceBriefingPhase.transcribing;
      _failure = null;
    });
    unawaited(HapticFeedback.lightImpact());
    try {
      final VoiceDictationRecording recording = await _activeRecorder!.stop();
      if (recording.duration < const Duration(milliseconds: 300)) {
        throw const VoiceDictationRecordingException(
          VoiceDictationRecordingFailure.noAudio,
          'The voice dictation was too short.',
        );
      }
      final BriefingTranscriptionEntity transcript = await ref
          .read(transcribeBriefingAudioUseCaseProvider)
          .invoke(
            TranscribeBriefingAudioParam(
              pcmBytes: recording.pcmBytes,
              sampleRate: recording.sampleRate,
            ),
          );
      if (!mounted) {
        return;
      }
      final String nextText = _appendTranscript(
        widget.controller.text,
        transcript.text,
      );
      if (utf8.encode(nextText).length > widget.maxTextBytes) {
        throw const FormatException('briefing_text_too_large');
      }
      widget.controller.value = TextEditingValue(
        text: nextText,
        selection: TextSelection.collapsed(offset: nextText.length),
      );
      widget.onTranscriptApplied?.call();
      setState(() {
        _phase = _VoiceBriefingPhase.idle;
        _applied = true;
      });
    } on Object catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _phase = _VoiceBriefingPhase.idle;
        _failure = _transcriptionFailure(error);
      });
    } finally {
      _activeRecorder = null;
    }
  }

  Future<void> _cancel() async {
    if (_phase != _VoiceBriefingPhase.recording) {
      return;
    }
    _timer?.cancel();
    _waveController
      ..stop()
      ..reset();
    await _activeRecorder?.cancel();
    _activeRecorder = null;
    if (!mounted) {
      return;
    }
    setState(() {
      _phase = _VoiceBriefingPhase.idle;
      _elapsed = Duration.zero;
      _failure = null;
    });
  }

  String _recordingFailure(Object error) {
    if (error is VoiceDictationRecordingException) {
      return switch (error.code) {
        VoiceDictationRecordingFailure.permissionDenied =>
          LocaleKeys.voice_dictation_permission.tr(),
        VoiceDictationRecordingFailure.tooLarge =>
          LocaleKeys.voice_dictation_too_long.tr(),
        VoiceDictationRecordingFailure.noAudio =>
          LocaleKeys.voice_dictation_no_audio.tr(),
        _ => LocaleKeys.voice_dictation_unavailable.tr(),
      };
    }
    return LocaleKeys.voice_dictation_unavailable.tr();
  }

  String _transcriptionFailure(Object error) {
    if (error is FormatException &&
        error.message == 'briefing_text_too_large') {
      return LocaleKeys.voice_dictation_text_too_large.tr();
    }
    if (error is VoiceDictationRecordingException) {
      return _recordingFailure(error);
    }
    return LocaleKeys.voice_dictation_transcription_failed.tr();
  }
}

final class _VoiceOrb extends StatelessWidget {
  const _VoiceOrb({required this.phase, required this.animation});

  final _VoiceBriefingPhase phase;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool recording = phase == _VoiceBriefingPhase.recording;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: recording
              ? <Color>[colors.primary, colors.primary.withValues(alpha: 0.72)]
              : <Color>[
                  colors.primary.withValues(alpha: 0.94),
                  colors.tertiary.withValues(alpha: 0.88),
                ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colors.primary.withValues(alpha: recording ? 0.26 : 0.16),
            blurRadius: recording ? 20 : 14,
          ),
        ],
      ),
      child: recording
          ? AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(3, (int index) {
                  final double wave =
                      (math.sin((animation.value * math.pi * 2) + index) + 1) /
                      2;
                  return Container(
                    width: 3,
                    height: 8 + wave * 14,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      color: colors.onPrimary,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  );
                }),
              ),
            )
          : Icon(Icons.mic_rounded, color: colors.onPrimary, size: 23),
    );
  }
}

String _appendTranscript(String existing, String transcript) {
  final String cleanTranscript = transcript.trim();
  if (cleanTranscript.isEmpty) {
    return existing;
  }
  final String cleanExisting = existing.trimRight();
  if (cleanExisting.isEmpty) {
    return cleanTranscript;
  }
  return '$cleanExisting\n\n$cleanTranscript';
}

String _formatDuration(Duration duration) {
  final int minutes = duration.inMinutes;
  final int seconds = duration.inSeconds.remainder(60);
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}
