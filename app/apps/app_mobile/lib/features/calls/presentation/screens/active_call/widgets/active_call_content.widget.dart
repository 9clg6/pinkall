import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show FontFeature, ImageFilter;

import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:pinkall/features/calls/presentation/screens/active_call/active_call.state.dart';
import 'package:pinkall/features/shared/presentation/formatters/duration.formatter.dart';

/// A focused, immersive surface for a real call and its real processing data.
final class ActiveCallContent extends StatelessWidget {
  /// Creates the active-call surface.
  const ActiveCallContent({
    required this.state,
    required this.onToggleMute,
    required this.onToggleSpeaker,
    required this.onSelectAudioDevice,
    required this.onRefreshAudioDevices,
    required this.onCoachChanged,
    required this.onAcknowledgeTranscription,
    required this.onEndCall,
    required this.onRetryDebrief,
    required this.onReturn,
    super.key,
  });

  /// Current Telnyx and Pinkall backend state.
  final ActiveCallState state;

  /// Changes the WebRTC microphone state.
  final Future<void> Function() onToggleMute;

  /// Changes the WebRTC audio route.
  final Future<void> Function() onToggleSpeaker;

  /// Selects a macOS WebRTC input or output device.
  final Future<void> Function(AudioDeviceKind kind, String deviceId)
  onSelectAudioDevice;

  /// Reloads macOS WebRTC input and output devices.
  final Future<void> Function() onRefreshAudioDevices;

  /// Changes visible coaching for this call only.
  final Future<void> Function(bool enabled) onCoachChanged;

  /// Records the distinct transcription notice acknowledgement.
  final Future<void> Function(TranscriptionConsentMethod method)
  onAcknowledgeTranscription;

  /// Hangs up the real call.
  final Future<bool> Function() onEndCall;

  /// Retries real backend finalization.
  final Future<void> Function() onRetryDebrief;

  /// Returns to the dialer after a terminal event.
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    final bool terminal = _terminalStatuses.contains(state.session.status);
    final bool highContrast = MediaQuery.highContrastOf(context);
    final bool reducedMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context) ||
        highContrast;
    final String remote = state.session.remoteNumber?.trim().isNotEmpty == true
        ? state.session.remoteNumber!
        : 'Numéro masqué';

    return ColoredBox(
      color: PinkallColors.carbon,
      child: Stack(
        children: <Widget>[
          if (!highContrast)
            const Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(child: _Atmosphere()),
              ),
            ),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool desktop = constraints.maxWidth >= 1040;
                final bool compact = constraints.maxWidth < 620;
                final double side = desktop
                    ? 40
                    : compact
                    ? 16
                    : 24;

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    side,
                    14,
                    side,
                    compact ? 12 : 18,
                  ),
                  child: Column(
                    children: <Widget>[
                      _CallChrome(
                        state: state,
                        terminal: terminal,
                        reducedMotion: reducedMotion,
                        onCoachChanged: onCoachChanged,
                      ),
                      SizedBox(height: compact ? 18 : 24),
                      _IdentityStage(
                        remote: remote,
                        status: state.session.status,
                        elapsed: state.elapsed,
                        compact: compact,
                        terminal: terminal,
                        waveformActive:
                            !terminal &&
                            !state.isCompanion &&
                            state.session.status == CallLifecycleStatus.active,
                        reducedMotion: reducedMotion,
                      ),
                      SizedBox(height: compact ? 16 : 22),
                      Expanded(
                        child: terminal
                            ? _DebriefWorkspace(
                                state: state,
                                desktop: desktop,
                                onRetry: onRetryDebrief,
                                onReturn: onReturn,
                              )
                            : desktop
                            ? _DesktopLiveWorkspace(
                                state: state,
                                reducedMotion: reducedMotion,
                                onCoachChanged: onCoachChanged,
                                onAcknowledgeTranscription:
                                    onAcknowledgeTranscription,
                                onReturn: onReturn,
                              )
                            : _MobileLiveWorkspace(
                                state: state,
                                reducedMotion: reducedMotion,
                                onCoachChanged: onCoachChanged,
                                onAcknowledgeTranscription:
                                    onAcknowledgeTranscription,
                                onReturn: onReturn,
                              ),
                      ),
                      if (!terminal && !state.isCompanion) ...<Widget>[
                        SizedBox(height: compact ? 12 : 16),
                        _CallControlIsland(
                          muted: state.session.isMuted,
                          speakerEnabled: state.session.isSpeakerEnabled,
                          supportsAudioDeviceSelection:
                              state.supportsAudioDeviceSelection,
                          audioDevices: state.audioDevices,
                          selectedAudioInputId: state.selectedAudioInputId,
                          selectedAudioOutputId: state.selectedAudioOutputId,
                          isLoadingAudioDevices: state.isLoadingAudioDevices,
                          disabled: state.isOperating,
                          highContrast: highContrast,
                          onToggleMute: onToggleMute,
                          onToggleSpeaker: onToggleSpeaker,
                          onSelectAudioDevice: onSelectAudioDevice,
                          onRefreshAudioDevices: onRefreshAudioDevices,
                          onEndCall: onEndCall,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final class _Atmosphere extends StatelessWidget {
  const _Atmosphere();

  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: const _AtmospherePainter(), size: Size.infinite);
}

final class _AtmospherePainter extends CustomPainter {
  const _AtmospherePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Rect scene = Offset.zero & size;
    canvas.drawRect(
      scene,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[PinkallColors.carbonRaised, PinkallColors.carbon],
          stops: <double>[0, 0.72],
        ).createShader(scene),
    );

    final Rect rose = Rect.fromCircle(
      center: Offset(size.width * 0.53, size.height * 0.19),
      radius: math.max(size.width * 0.38, 260),
    );
    canvas.drawCircle(
      rose.center,
      rose.width / 2,
      Paint()
        ..shader = RadialGradient(
          colors: <Color>[
            PinkallColors.pink.withValues(alpha: 0.15),
            PinkallColors.spectralLilac.withValues(alpha: 0.07),
            Colors.transparent,
          ],
          stops: const <double>[0, 0.36, 1],
        ).createShader(rose),
    );
  }

  @override
  bool shouldRepaint(covariant _AtmospherePainter oldDelegate) => false;
}

final class _CallChrome extends StatelessWidget {
  const _CallChrome({
    required this.state,
    required this.terminal,
    required this.reducedMotion,
    required this.onCoachChanged,
  });

  final ActiveCallState state;
  final bool terminal;
  final bool reducedMotion;
  final Future<void> Function(bool enabled) onCoachChanged;

  @override
  Widget build(BuildContext context) {
    final bool coachEnabled =
        state.processingSession.coachMode == CoachMode.live;
    return Row(
      children: <Widget>[
        _StatusLine(status: state.session.status),
        const Spacer(),
        if (state.isCompanion) ...<Widget>[
          Icon(
            Icons.devices_outlined,
            size: 16,
            color: PinkallColors.onStrong.withValues(alpha: 0.56),
          ),
          const SizedBox(width: 6),
          Text(
            'MODE COMPAGNON',
            style: _darkTextTheme(context).labelSmall?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.58),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.35,
            ),
          ),
          const SizedBox(width: 18),
        ],
        if (!terminal && !state.isCompanion)
          _CoachAction(
            enabled: coachEnabled,
            disabled: state.isOperating,
            reducedMotion: reducedMotion,
            onChanged: onCoachChanged,
          ),
      ],
    );
  }
}

final class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.status});

  final CallLifecycleStatus status;

  @override
  Widget build(BuildContext context) {
    final String label = _statusLabel(status);
    final bool active = status == CallLifecycleStatus.active;
    return Semantics(
      liveRegion: true,
      label: 'État de l’appel : $label',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: active
                    ? PinkallColors.pink
                    : PinkallColors.onStrong.withValues(alpha: 0.42),
                shape: BoxShape.circle,
                boxShadow: active
                    ? <BoxShadow>[
                        BoxShadow(
                          color: PinkallColors.pink.withValues(alpha: 0.45),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: _darkTextTheme(context).labelMedium?.copyWith(
                color: PinkallColors.onStrong.withValues(alpha: 0.64),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _CoachAction extends StatelessWidget {
  const _CoachAction({
    required this.enabled,
    required this.disabled,
    required this.reducedMotion,
    required this.onChanged,
  });

  final bool enabled;
  final bool disabled;
  final bool reducedMotion;
  final Future<void> Function(bool enabled) onChanged;

  @override
  Widget build(BuildContext context) {
    final String label = enabled ? 'Coach actif' : 'Activer le coach';
    final String tooltip = enabled
        ? 'Désactiver le coach pour cet appel'
        : 'Activer le coach pour cet appel';
    final BorderRadius radius = BorderRadius.circular(10);

    return Semantics(
      button: true,
      enabled: !disabled,
      toggled: enabled,
      label: tooltip,
      child: ExcludeSemantics(
        child: Tooltip(
          message: tooltip,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: const Key('active_call_coach_action'),
              borderRadius: radius,
              onTap: disabled ? null : () => onChanged(!enabled),
              child: AnimatedContainer(
                duration: reducedMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: enabled
                      ? PinkallColors.pink.withValues(alpha: 0.11)
                      : PinkallColors.onStrong.withValues(
                          alpha: disabled ? 0.035 : 0.065,
                        ),
                  borderRadius: radius,
                  border: Border.all(
                    color: enabled
                        ? PinkallColors.pink.withValues(alpha: 0.34)
                        : PinkallColors.onStrong.withValues(
                            alpha: disabled ? 0.06 : 0.11,
                          ),
                  ),
                ),
                child: AnimatedOpacity(
                  duration: reducedMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 140),
                  opacity: disabled ? 0.42 : 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AnimatedSwitcher(
                        duration: reducedMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 160),
                        child: enabled
                            ? Container(
                                key: const ValueKey<String>('coach-active'),
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: PinkallColors.pink,
                                  shape: BoxShape.circle,
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: PinkallColors.pink.withValues(
                                        alpha: 0.38,
                                      ),
                                      blurRadius: 7,
                                    ),
                                  ],
                                ),
                              )
                            : const Icon(
                                Icons.add_rounded,
                                key: ValueKey<String>('coach-inactive'),
                                size: 16,
                                color: PinkallColors.onStrong,
                              ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedSwitcher(
                        duration: reducedMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 160),
                        child: Text(
                          label,
                          key: ValueKey<String>(label),
                          style: _darkTextTheme(context).labelMedium?.copyWith(
                            color: enabled
                                ? PinkallColors.pinkContainer
                                : PinkallColors.onStrong.withValues(
                                    alpha: 0.86,
                                  ),
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final class _IdentityStage extends StatelessWidget {
  const _IdentityStage({
    required this.remote,
    required this.status,
    required this.elapsed,
    required this.compact,
    required this.terminal,
    required this.waveformActive,
    required this.reducedMotion,
  });

  final String remote;
  final CallLifecycleStatus status;
  final Duration elapsed;
  final bool compact;
  final bool terminal;
  final bool waveformActive;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) {
    final String duration = DurationFormatter.clock(elapsed);
    if (terminal) {
      return Semantics(
        container: true,
        label: '$remote, durée $duration',
        child: ExcludeSemantics(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 4,
            children: <Widget>[
              Text(
                remote,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _darkTextTheme(context).titleLarge?.copyWith(
                  color: PinkallColors.onStrong,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: PinkallColors.onStrong.withValues(alpha: 0.28),
                  shape: BoxShape.circle,
                ),
              ),
              Text(
                duration,
                style: _darkTextTheme(context).bodyMedium?.copyWith(
                  color: PinkallColors.onStrong.withValues(alpha: 0.52),
                  fontFeatures: const <FontFeature>[
                    FontFeature.tabularFigures(),
                  ],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Semantics(
      container: true,
      label: '$remote, durée $duration',
      child: ExcludeSemantics(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              remote,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: _darkTextTheme(context).headlineLarge?.copyWith(
                color: PinkallColors.onStrong,
                fontSize: compact ? 28 : 34,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.7,
                height: 1.08,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              duration,
              style: _darkTextTheme(context).bodyMedium?.copyWith(
                color: PinkallColors.onStrong.withValues(alpha: 0.58),
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
                fontWeight: FontWeight.w500,
                letterSpacing: 0.25,
              ),
            ),
            SizedBox(height: compact ? 10 : 12),
            SizedBox(
              width: compact ? 220 : 360,
              height: compact ? 34 : 42,
              child: RepaintBoundary(
                child: _Waveform(
                  active: waveformActive,
                  reducedMotion: reducedMotion,
                  terminal: _terminalStatuses.contains(status),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _Waveform extends StatefulWidget {
  const _Waveform({
    required this.active,
    required this.reducedMotion,
    required this.terminal,
  });

  final bool active;
  final bool reducedMotion;
  final bool terminal;

  @override
  State<_Waveform> createState() => _WaveformState();
}

final class _WaveformState extends State<_Waveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
      value: 0.34,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant _Waveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active ||
        oldWidget.reducedMotion != widget.reducedMotion ||
        oldWidget.terminal != widget.terminal) {
      _syncMotion();
    }
  }

  void _syncMotion() {
    final bool shouldMove =
        widget.active &&
        !widget.reducedMotion &&
        !widget.terminal &&
        TickerMode.valuesOf(context).enabled;
    if (shouldMove && !_controller.isAnimating) {
      unawaited(_controller.repeat(reverse: true));
    } else if (!shouldMove && _controller.isAnimating) {
      _controller.stop(canceled: false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _WaveformPainter(animation: _controller, active: widget.active),
  );
}

final class _WaveformPainter extends CustomPainter {
  _WaveformPainter({required this.animation, required this.active})
    : super(repaint: animation);

  final Animation<double> animation;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint baseline = Paint()
      ..color = PinkallColors.onStrong.withValues(alpha: 0.07)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      baseline,
    );

    final Path path = Path();
    final double phase = animation.value * math.pi * 2;
    final double amplitude = active ? size.height * 0.28 : size.height * 0.05;
    const int points = 96;
    for (int index = 0; index <= points; index += 1) {
      final double x = size.width * index / points;
      final double normalized = index / points;
      final double envelope = math.sin(normalized * math.pi);
      final double y =
          size.height / 2 +
          math.sin(normalized * math.pi * 7 + phase) *
              amplitude *
              envelope *
              (0.62 + 0.16 * math.sin(phase + normalized * 5));
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final Rect shaderBounds = Offset.zero & size;
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          colors: <Color>[
            Colors.transparent,
            PinkallColors.spectralLilac.withValues(alpha: active ? 0.58 : 0.2),
            PinkallColors.pink.withValues(alpha: active ? 0.9 : 0.28),
            Colors.transparent,
          ],
          stops: const <double>[0, 0.25, 0.68, 1],
        ).createShader(shaderBounds)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.45
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) =>
      oldDelegate.active != active || oldDelegate.animation != animation;
}

final class _DesktopLiveWorkspace extends StatelessWidget {
  const _DesktopLiveWorkspace({
    required this.state,
    required this.reducedMotion,
    required this.onCoachChanged,
    required this.onAcknowledgeTranscription,
    required this.onReturn,
  });

  final ActiveCallState state;
  final bool reducedMotion;
  final Future<void> Function(bool enabled) onCoachChanged;
  final Future<void> Function(TranscriptionConsentMethod method)
  onAcknowledgeTranscription;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1180),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: _TranscriptRegion(
              state: state,
              onAcknowledgeTranscription: onAcknowledgeTranscription,
            ),
          ),
          const SizedBox(width: 30),
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: PinkallColors.onStrong.withValues(alpha: 0.09),
          ),
          const SizedBox(width: 30),
          SizedBox(
            width: 326,
            child: _ContextRail(
              state: state,
              reducedMotion: reducedMotion,
              onCoachChanged: onCoachChanged,
              onReturn: onReturn,
            ),
          ),
        ],
      ),
    ),
  );
}

final class _MobileLiveWorkspace extends StatelessWidget {
  const _MobileLiveWorkspace({
    required this.state,
    required this.reducedMotion,
    required this.onCoachChanged,
    required this.onAcknowledgeTranscription,
    required this.onReturn,
  });

  final ActiveCallState state;
  final bool reducedMotion;
  final Future<void> Function(bool enabled) onCoachChanged;
  final Future<void> Function(TranscriptionConsentMethod method)
  onAcknowledgeTranscription;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    final CoachingSuggestionEntity? suggestion = _visibleSuggestion(state);
    final bool consent =
        state.processingSession.transcriptionConsentAcknowledged;
    return CustomScrollView(
      semanticChildCount: consent ? state.transcript.length : 0,
      slivers: <Widget>[
        if (state.operationFailure != null ||
            state.realtimeFailure != null) ...<Widget>[
          SliverToBoxAdapter(
            child: _FailureList(
              operationFailure: state.operationFailure,
              realtimeFailure: state.realtimeFailure,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
        ],
        if (state.isCompanion) ...<Widget>[
          SliverToBoxAdapter(child: _CompanionNotice(onReturn: onReturn)),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
        ],
        if (suggestion != null) ...<Widget>[
          SliverToBoxAdapter(
            child: _AnimatedCoachSuggestion(
              suggestion: suggestion,
              reducedMotion: reducedMotion,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 18)),
        ] else if (consent && !state.isCompanion) ...<Widget>[
          SliverToBoxAdapter(
            child: _CoachRestingState(
              state: state,
              onCoachChanged: onCoachChanged,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 18)),
        ],
        if (!consent)
          SliverToBoxAdapter(
            child: _ConsentSection(
              disabled: state.isOperating || state.isCompanion,
              companion: state.isCompanion,
              onAcknowledge: onAcknowledgeTranscription,
            ),
          )
        else ...<Widget>[
          SliverToBoxAdapter(
            child: _TranscriptHeading(
              finalTranscript: state.finalTranscript != null,
              segmentCount: state.transcript.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 6)),
          if (state.transcript.isEmpty)
            const SliverToBoxAdapter(child: _EmptyTranscript())
          else
            SliverList.separated(
              itemCount: state.transcript.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                thickness: 1,
                color: PinkallColors.onStrong.withValues(alpha: 0.075),
              ),
              itemBuilder: (BuildContext context, int index) =>
                  _TranscriptLine(segment: state.transcript[index]),
            ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 8)),
      ],
    );
  }
}

final class _TranscriptRegion extends StatelessWidget {
  const _TranscriptRegion({
    required this.state,
    required this.onAcknowledgeTranscription,
  });

  final ActiveCallState state;
  final Future<void> Function(TranscriptionConsentMethod method)
  onAcknowledgeTranscription;

  @override
  Widget build(BuildContext context) {
    final bool consent =
        state.processingSession.transcriptionConsentAcknowledged;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (state.operationFailure != null ||
            state.realtimeFailure != null) ...<Widget>[
          _FailureList(
            operationFailure: state.operationFailure,
            realtimeFailure: state.realtimeFailure,
          ),
          const SizedBox(height: 14),
        ],
        if (!consent)
          Expanded(
            child: SingleChildScrollView(
              child: _ConsentSection(
                disabled: state.isOperating || state.isCompanion,
                companion: state.isCompanion,
                onAcknowledge: onAcknowledgeTranscription,
              ),
            ),
          )
        else ...<Widget>[
          _TranscriptHeading(
            finalTranscript: state.finalTranscript != null,
            segmentCount: state.transcript.length,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: state.transcript.isEmpty
                ? const _EmptyTranscript()
                : _TranscriptList(transcript: state.transcript),
          ),
        ],
      ],
    );
  }
}

final class _TranscriptList extends StatefulWidget {
  const _TranscriptList({required this.transcript});

  final List<TranscriptSegmentEntity> transcript;

  @override
  State<_TranscriptList> createState() => _TranscriptListState();
}

final class _TranscriptListState extends State<_TranscriptList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScrollConfiguration(
    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
    child: Semantics(
      label: 'Conversation transcrite',
      explicitChildNodes: true,
      child: SelectionArea(
        child: Scrollbar(
          controller: _scrollController,
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemCount: widget.transcript.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 1,
              thickness: 1,
              color: PinkallColors.onStrong.withValues(alpha: 0.075),
            ),
            itemBuilder: (BuildContext context, int index) =>
                _TranscriptLine(segment: widget.transcript[index]),
          ),
        ),
      ),
    ),
  );
}

final class _ContextRail extends StatelessWidget {
  const _ContextRail({
    required this.state,
    required this.reducedMotion,
    required this.onCoachChanged,
    required this.onReturn,
  });

  final ActiveCallState state;
  final bool reducedMotion;
  final Future<void> Function(bool enabled) onCoachChanged;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    final CoachingSuggestionEntity? suggestion = _visibleSuggestion(state);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'Coach en direct',
            style: _darkTextTheme(context).titleSmall?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.78),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          if (suggestion != null)
            _AnimatedCoachSuggestion(
              suggestion: suggestion,
              reducedMotion: reducedMotion,
            )
          else
            _CoachRestingState(state: state, onCoachChanged: onCoachChanged),
          if (state.isCompanion) ...<Widget>[
            const SizedBox(height: 28),
            _CompanionNotice(onReturn: onReturn),
          ],
        ],
      ),
    );
  }
}

final class _TranscriptHeading extends StatelessWidget {
  const _TranscriptHeading({
    required this.finalTranscript,
    required this.segmentCount,
  });

  final bool finalTranscript;
  final int segmentCount;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    label: finalTranscript
        ? 'Transcription finale, $segmentCount segments'
        : 'Transcription en direct, $segmentCount segments',
    child: ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                finalTranscript ? 'Transcription finale' : 'Conversation',
                style: _darkTextTheme(context).titleSmall?.copyWith(
                  color: PinkallColors.onStrong.withValues(alpha: 0.78),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              finalTranscript ? 'Finalisée' : 'En direct',
              style: _darkTextTheme(context).labelSmall?.copyWith(
                color: finalTranscript
                    ? PinkallColors.onStrong.withValues(alpha: 0.42)
                    : PinkallColors.pinkContainer.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

final class _TranscriptLine extends StatelessWidget {
  const _TranscriptLine({required this.segment});

  final TranscriptSegmentEntity segment;

  @override
  Widget build(BuildContext context) {
    final bool seller = segment.speaker == TranscriptSpeaker.seller;
    final String speaker = switch (segment.speaker) {
      TranscriptSpeaker.seller => 'Vous',
      TranscriptSpeaker.prospect => 'Prospect',
      TranscriptSpeaker.unknown => 'Intervenant',
    };
    final String time = _clockTime(segment.startedAt);
    final Color speakerColor = seller
        ? PinkallColors.pinkContainer.withValues(alpha: 0.9)
        : PinkallColors.onStrong.withValues(alpha: 0.52);

    return Semantics(
      container: true,
      label: '$speaker : ${segment.text}',
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 84,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      speaker,
                      style: _darkTextTheme(context).labelMedium?.copyWith(
                        color: speakerColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      time,
                      style: _darkTextTheme(context).labelSmall?.copyWith(
                        color: PinkallColors.onStrong.withValues(alpha: 0.28),
                        fontFeatures: const <FontFeature>[
                          FontFeature.tabularFigures(),
                        ],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  segment.text,
                  style: _darkTextTheme(context).bodyMedium?.copyWith(
                    color: PinkallColors.onStrong.withValues(
                      alpha: segment.isFinal ? 0.88 : 0.5,
                    ),
                    fontWeight: FontWeight.w400,
                    height: 1.48,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _EmptyTranscript extends StatelessWidget {
  const _EmptyTranscript();

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Text(
        'La conversation apparaîtra ici dès qu’elle commencera.',
        style: _darkTextTheme(context).bodyMedium?.copyWith(
          color: PinkallColors.onStrong.withValues(alpha: 0.4),
        ),
      ),
    ),
  );
}

final class _ConsentSection extends StatelessWidget {
  const _ConsentSection({
    required this.disabled,
    required this.companion,
    required this.onAcknowledge,
  });

  final bool disabled;
  final bool companion;
  final Future<void> Function(TranscriptionConsentMethod method) onAcknowledge;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 620),
    child: Container(
      padding: const EdgeInsets.only(left: 18),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: companion
                ? PinkallColors.onStrong.withValues(alpha: 0.16)
                : PinkallColors.pink.withValues(alpha: 0.72),
            width: 2,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Transcription en attente',
            style: _darkTextTheme(context).titleMedium?.copyWith(
              color: PinkallColors.onStrong,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            companion
                ? 'L’autorisation doit être donnée depuis l’appareil qui transporte l’audio. Cette vue reste en lecture seule.'
                : 'Informe les participants avant d’activer la transcription.',
            style: _darkTextTheme(context).bodyMedium?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.58),
            ),
          ),
          if (!companion) ...<Widget>[
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: <Widget>[
                FilledButton(
                  onPressed: disabled
                      ? null
                      : () => onAcknowledge(
                          TranscriptionConsentMethod.verbalNotice,
                        ),
                  child: const Text('Participants informés'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: PinkallColors.onStrong.withValues(
                      alpha: 0.72,
                    ),
                  ),
                  onPressed: disabled
                      ? null
                      : () => onAcknowledge(
                          TranscriptionConsentMethod.contractual,
                        ),
                  child: const Text('Information contractuelle déjà fournie'),
                ),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

final class _AnimatedCoachSuggestion extends StatelessWidget {
  const _AnimatedCoachSuggestion({
    required this.suggestion,
    required this.reducedMotion,
  });

  final CoachingSuggestionEntity suggestion;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: reducedMotion ? Duration.zero : const Duration(milliseconds: 240),
    reverseDuration: reducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 140),
    switchInCurve: Curves.easeOutCubic,
    switchOutCurve: Curves.easeInCubic,
    transitionBuilder: (Widget child, Animation<double> animation) {
      final Widget fade = FadeTransition(opacity: animation, child: child);
      if (reducedMotion) {
        return fade;
      }
      return SlideTransition(
        position:
            Tween<Offset>(
              begin: const Offset(0, -0.035),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
        child: fade,
      );
    },
    child: _CoachGlass(
      key: ValueKey<String>('${suggestion.id}:${suggestion.text}'),
      suggestion: suggestion,
    ),
  );
}

final class _CoachGlass extends StatelessWidget {
  const _CoachGlass({required this.suggestion, super.key});

  final CoachingSuggestionEntity suggestion;

  @override
  Widget build(BuildContext context) {
    final bool highContrast = MediaQuery.highContrastOf(context);
    final BorderRadius radius = BorderRadius.circular(16);
    final Widget material = DecoratedBox(
      decoration: BoxDecoration(
        color: highContrast
            ? PinkallColors.carbonElevated
            : PinkallColors.onStrong.withValues(alpha: 0.075),
        gradient: highContrast
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  PinkallColors.onStrong.withValues(alpha: 0.12),
                  PinkallColors.spectralLilac.withValues(alpha: 0.08),
                  PinkallColors.pink.withValues(alpha: 0.1),
                ],
              ),
        borderRadius: radius,
        border: Border.all(
          color: highContrast
              ? PinkallColors.onStrong.withValues(alpha: 0.6)
              : PinkallColors.onStrong.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: PinkallColors.pink,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Coach · maintenant',
                  style: _darkTextTheme(context).labelSmall?.copyWith(
                    color: PinkallColors.pinkContainer.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              suggestion.text,
              style: _darkTextTheme(context).titleMedium?.copyWith(
                color: PinkallColors.onStrong,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.38,
                letterSpacing: -0.12,
              ),
            ),
          ],
        ),
      ),
    );

    return Semantics(
      container: true,
      liveRegion: true,
      label: 'Suggestion du coach : ${suggestion.text}',
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: PinkallColors.pink.withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: highContrast
                ? material
                : BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: material,
                  ),
          ),
        ),
      ),
    );
  }
}

final class _CoachRestingState extends StatelessWidget {
  const _CoachRestingState({required this.state, required this.onCoachChanged});

  final ActiveCallState state;
  final Future<void> Function(bool enabled) onCoachChanged;

  @override
  Widget build(BuildContext context) {
    final bool consent =
        state.processingSession.transcriptionConsentAcknowledged;
    final bool live = state.processingSession.coachMode == CoachMode.live;
    final String text = !consent
        ? 'Disponible après l’activation de la transcription.'
        : !live
        ? 'Désactivé pour cet appel.'
        : state.coachAnalysisStatus == CoachAnalysisStatus.analyzing
        ? 'Analyse du dernier tour…'
        : state.coachAnalysisOutcome == CoachAnalysisOutcome.none
        ? 'Aucun conseil suffisamment pertinent pour ce tour. Le coach reste à l’écoute.'
        : 'À l’écoute. Une recommandation apparaîtra uniquement lorsqu’elle est utile.';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          style: _darkTextTheme(context).bodyMedium?.copyWith(
            color: PinkallColors.onStrong.withValues(alpha: 0.42),
            height: 1.45,
          ),
        ),
        if (consent && !live && !state.isCompanion) ...<Widget>[
          const SizedBox(height: 14),
          Semantics(
            button: true,
            enabled: !state.isOperating,
            label: 'Activer le coach IA pour cet appel',
            child: TextButton.icon(
              key: const Key('active_call_coach_primary_action'),
              style: TextButton.styleFrom(
                foregroundColor: PinkallColors.pink,
                backgroundColor: PinkallColors.pink.withValues(alpha: 0.09),
                disabledForegroundColor: PinkallColors.onStrong.withValues(
                  alpha: 0.28,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: PinkallColors.pink.withValues(alpha: 0.24),
                  ),
                ),
              ),
              onPressed: state.isOperating ? null : () => onCoachChanged(true),
              icon: const Icon(Icons.auto_awesome_rounded, size: 17),
              label: const Text('Activer le coach IA'),
            ),
          ),
        ],
      ],
    );
  }
}

final class _CompanionNotice extends StatelessWidget {
  const _CompanionNotice({required this.onReturn});

  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.only(left: 14),
    decoration: BoxDecoration(
      border: Border(
        left: BorderSide(color: PinkallColors.onStrong.withValues(alpha: 0.16)),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Audio sur l’appareil source',
          style: _darkTextTheme(context).labelLarge?.copyWith(
            color: PinkallColors.onStrong.withValues(alpha: 0.76),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Cette vue synchronise la conversation et les conseils en lecture seule.',
          style: _darkTextTheme(context).bodySmall?.copyWith(
            color: PinkallColors.onStrong.withValues(alpha: 0.45),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: PinkallColors.onStrong.withValues(alpha: 0.7),
            padding: EdgeInsets.zero,
          ),
          onPressed: onReturn,
          child: const Text('Fermer cette vue'),
        ),
      ],
    ),
  );
}

final class _FailureList extends StatelessWidget {
  const _FailureList({
    required this.operationFailure,
    required this.realtimeFailure,
  });

  final String? operationFailure;
  final String? realtimeFailure;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      if (operationFailure case final String message)
        _FailureLine(message: message),
      if (operationFailure != null && realtimeFailure != null)
        const SizedBox(height: 8),
      if (realtimeFailure case final String message)
        _FailureLine(message: message),
    ],
  );
}

final class _FailureLine extends StatelessWidget {
  const _FailureLine({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    liveRegion: true,
    label: 'Erreur pendant l’appel : $message',
    child: ExcludeSemantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.error_outline,
              color: PinkallColors.pinkHighlight,
              size: 17,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: _darkTextTheme(context).bodySmall?.copyWith(
                color: PinkallColors.onStrong.withValues(alpha: 0.72),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

final class _CallControlIsland extends StatelessWidget {
  const _CallControlIsland({
    required this.muted,
    required this.speakerEnabled,
    required this.supportsAudioDeviceSelection,
    required this.audioDevices,
    required this.selectedAudioInputId,
    required this.selectedAudioOutputId,
    required this.isLoadingAudioDevices,
    required this.disabled,
    required this.highContrast,
    required this.onToggleMute,
    required this.onToggleSpeaker,
    required this.onSelectAudioDevice,
    required this.onRefreshAudioDevices,
    required this.onEndCall,
  });

  final bool muted;
  final bool speakerEnabled;
  final bool supportsAudioDeviceSelection;
  final List<AudioDeviceEntity> audioDevices;
  final String? selectedAudioInputId;
  final String? selectedAudioOutputId;
  final bool isLoadingAudioDevices;
  final bool disabled;
  final bool highContrast;
  final Future<void> Function() onToggleMute;
  final Future<void> Function() onToggleSpeaker;
  final Future<void> Function(AudioDeviceKind kind, String deviceId)
  onSelectAudioDevice;
  final Future<void> Function() onRefreshAudioDevices;
  final Future<bool> Function() onEndCall;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(18);
    final Widget island = DecoratedBox(
      decoration: BoxDecoration(
        color: highContrast
            ? PinkallColors.carbonElevated
            : PinkallColors.onStrong.withValues(alpha: 0.085),
        borderRadius: radius,
        border: Border.all(
          color: PinkallColors.onStrong.withValues(
            alpha: highContrast ? 0.5 : 0.14,
          ),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _CallControl(
              label: muted ? 'Réactiver' : 'Muet',
              tooltip: muted
                  ? 'Réactiver le microphone'
                  : 'Couper le microphone',
              icon: muted ? Icons.mic_off_outlined : Icons.mic_none_outlined,
              selected: muted,
              disabled: disabled,
              onPressed: onToggleMute,
            ),
            const SizedBox(width: 8),
            _HangUpControl(disabled: disabled, onPressed: onEndCall),
            const SizedBox(width: 8),
            if (supportsAudioDeviceSelection)
              _AudioDeviceControl(
                devices: audioDevices,
                selectedInputId: selectedAudioInputId,
                selectedOutputId: selectedAudioOutputId,
                isLoading: isLoadingAudioDevices,
                disabled: disabled,
                onSelect: onSelectAudioDevice,
                onRefresh: onRefreshAudioDevices,
              )
            else
              _CallControl(
                label: 'Audio',
                tooltip: speakerEnabled
                    ? 'Désactiver le haut-parleur'
                    : 'Activer le haut-parleur',
                icon: speakerEnabled
                    ? Icons.volume_up_outlined
                    : Icons.volume_down_outlined,
                selected: speakerEnabled,
                disabled: disabled,
                onPressed: onToggleSpeaker,
              ),
          ],
        ),
      ),
    );

    return Semantics(
      container: true,
      label: 'Contrôles de l’appel',
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: PinkallColors.shadowStrong,
                blurRadius: 30,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: highContrast
                ? island
                : BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: island,
                  ),
          ),
        ),
      ),
    );
  }
}

final class _AudioDeviceControl extends StatelessWidget {
  const _AudioDeviceControl({
    required this.devices,
    required this.selectedInputId,
    required this.selectedOutputId,
    required this.isLoading,
    required this.disabled,
    required this.onSelect,
    required this.onRefresh,
  });

  final List<AudioDeviceEntity> devices;
  final String? selectedInputId;
  final String? selectedOutputId;
  final bool isLoading;
  final bool disabled;
  final Future<void> Function(AudioDeviceKind kind, String deviceId) onSelect;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final List<AudioDeviceEntity> inputs = devices
        .where(
          (AudioDeviceEntity device) => device.kind == AudioDeviceKind.input,
        )
        .toList(growable: false);
    final List<AudioDeviceEntity> outputs = devices
        .where(
          (AudioDeviceEntity device) => device.kind == AudioDeviceKind.output,
        )
        .toList(growable: false);

    return MenuAnchor(
      style: MenuStyle(
        backgroundColor: const WidgetStatePropertyAll<Color>(
          PinkallColors.carbonElevated,
        ),
        elevation: const WidgetStatePropertyAll<double>(18),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(vertical: 8),
        ),
        shape: WidgetStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        side: WidgetStatePropertyAll<BorderSide>(
          BorderSide(color: PinkallColors.onStrong.withValues(alpha: 0.12)),
        ),
      ),
      menuChildren: <Widget>[
        const _AudioDeviceMenuLabel(label: 'Microphone'),
        ..._deviceItems(
          inputs,
          AudioDeviceKind.input,
          selectedInputId,
          Icons.mic_none_outlined,
        ),
        Divider(
          height: 17,
          color: PinkallColors.onStrong.withValues(alpha: 0.1),
        ),
        const _AudioDeviceMenuLabel(label: 'Sortie audio'),
        ..._deviceItems(
          outputs,
          AudioDeviceKind.output,
          selectedOutputId,
          Icons.headphones_outlined,
        ),
        Divider(
          height: 17,
          color: PinkallColors.onStrong.withValues(alpha: 0.1),
        ),
        MenuItemButton(
          onPressed: disabled || isLoading
              ? null
              : () => unawaited(onRefresh()),
          leadingIcon: isLoading
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 1.7),
                )
              : const Icon(Icons.refresh_rounded, size: 18),
          child: Text(isLoading ? 'Actualisation…' : 'Actualiser la liste'),
        ),
      ],
      builder:
          (BuildContext context, MenuController controller, Widget? child) =>
              _CallControl(
                label: 'Audio',
                tooltip: 'Choisir les périphériques audio',
                icon: Icons.tune_rounded,
                selected: selectedInputId != null || selectedOutputId != null,
                disabled: disabled,
                onPressed: () async {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
              ),
    );
  }

  List<Widget> _deviceItems(
    List<AudioDeviceEntity> matchingDevices,
    AudioDeviceKind kind,
    String? selectedId,
    IconData icon,
  ) {
    if (matchingDevices.isEmpty) {
      return const <Widget>[
        _AudioDeviceMenuEmpty(label: 'Aucun périphérique détecté'),
      ];
    }
    return matchingDevices
        .map(
          (AudioDeviceEntity device) => MenuItemButton(
            key: ValueKey<String>('audio_device_${kind.name}_${device.id}'),
            onPressed: disabled
                ? null
                : () => unawaited(onSelect(kind, device.id)),
            leadingIcon: Icon(icon, size: 18),
            trailingIcon: selectedId == device.id
                ? const Icon(Icons.check_rounded, size: 18)
                : const SizedBox.square(dimension: 18),
            child: SizedBox(
              width: 220,
              child: Text(
                device.label.isEmpty ? 'Périphérique sans nom' : device.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        )
        .toList(growable: false);
  }
}

final class _AudioDeviceMenuLabel extends StatelessWidget {
  const _AudioDeviceMenuLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 7, 16, 5),
    child: Text(
      label.toUpperCase(),
      style: _darkTextTheme(context).labelSmall?.copyWith(
        color: PinkallColors.onStrong.withValues(alpha: 0.44),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    ),
  );
}

final class _AudioDeviceMenuEmpty extends StatelessWidget {
  const _AudioDeviceMenuEmpty({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
    child: Text(
      label,
      style: _darkTextTheme(context).bodySmall?.copyWith(
        color: PinkallColors.onStrong.withValues(alpha: 0.42),
      ),
    ),
  );
}

final class _CallControl extends StatelessWidget {
  const _CallControl({
    required this.label,
    required this.tooltip,
    required this.icon,
    required this.selected,
    required this.disabled,
    required this.onPressed,
  });

  final String label;
  final String tooltip;
  final IconData icon;
  final bool selected;
  final bool disabled;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: !disabled,
    toggled: selected,
    label: tooltip,
    child: ExcludeSemantics(
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              tooltip: tooltip,
              onPressed: disabled ? null : onPressed,
              style: IconButton.styleFrom(
                minimumSize: const Size(42, 42),
                maximumSize: const Size(42, 42),
                backgroundColor: selected
                    ? PinkallColors.onStrong.withValues(alpha: 0.16)
                    : Colors.transparent,
                foregroundColor: selected
                    ? PinkallColors.onStrong
                    : PinkallColors.onStrong.withValues(alpha: 0.76),
                disabledForegroundColor: PinkallColors.onStrong.withValues(
                  alpha: 0.26,
                ),
                side: selected
                    ? BorderSide(
                        color: PinkallColors.onStrong.withValues(alpha: 0.14),
                      )
                    : BorderSide.none,
              ),
              icon: Icon(icon, size: 20),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _darkTextTheme(context).labelSmall?.copyWith(
                color: PinkallColors.onStrong.withValues(alpha: 0.48),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

final class _HangUpControl extends StatelessWidget {
  const _HangUpControl({required this.disabled, required this.onPressed});

  final bool disabled;
  final Future<bool> Function() onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: !disabled,
    label: 'Raccrocher',
    child: ExcludeSemantics(
      child: SizedBox(
        width: 68,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton.filled(
              tooltip: 'Raccrocher',
              onPressed: disabled
                  ? null
                  : () {
                      unawaited(onPressed());
                    },
              style: IconButton.styleFrom(
                minimumSize: const Size(48, 48),
                maximumSize: const Size(48, 48),
                backgroundColor: PinkallColors.callEnd,
                foregroundColor: PinkallColors.onStrong,
                disabledBackgroundColor: PinkallColors.callEnd.withValues(
                  alpha: 0.28,
                ),
                disabledForegroundColor: PinkallColors.onStrong.withValues(
                  alpha: 0.4,
                ),
              ),
              icon: const Icon(Icons.call_end_rounded, size: 23),
            ),
            const SizedBox(height: 2),
            Text(
              'Fin',
              style: _darkTextTheme(context).labelSmall?.copyWith(
                color: PinkallColors.pinkHighlight,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

final class _DebriefWorkspace extends StatelessWidget {
  const _DebriefWorkspace({
    required this.state,
    required this.desktop,
    required this.onRetry,
    required this.onReturn,
  });

  final ActiveCallState state;
  final bool desktop;
  final Future<void> Function() onRetry;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    final bool transcriptAvailable = state.finalTranscript != null;
    final List<TranscriptSegmentEntity> evidence =
        state.finalTranscript?.segments ?? state.transcript;
    final CallDebriefEntity? debrief = state.debrief;
    final bool debriefAvailable = debrief != null;
    final Widget body = CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _DebriefHeader(
                transcriptAvailable: transcriptAvailable,
                debriefAvailable: debriefAvailable,
                desktop: desktop,
                finalizationMessage: state.finalizationMessage,
                onRetry: onRetry,
                onReturn: onReturn,
              ),
              if (debrief != null) ...<Widget>[
                const SizedBox(height: 30),
                _DebriefAnalysis(debrief: debrief),
              ],
              if (evidence.isNotEmpty) ...<Widget>[
                const SizedBox(height: 36),
                Text(
                  transcriptAvailable
                      ? 'Transcription complète'
                      : 'Transcription capturée',
                  style: _darkTextTheme(context).titleSmall?.copyWith(
                    color: PinkallColors.onStrong.withValues(alpha: 0.78),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${evidence.length} ${evidence.length > 1 ? 'prises de parole' : 'prise de parole'}',
                  style: _darkTextTheme(context).bodySmall?.copyWith(
                    color: PinkallColors.onStrong.withValues(alpha: 0.4),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
        if (evidence.isNotEmpty)
          SliverList.separated(
            itemCount: evidence.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              height: 1,
              thickness: 1,
              color: PinkallColors.onStrong.withValues(alpha: 0.075),
            ),
            itemBuilder: (BuildContext context, int index) =>
                _TranscriptLine(segment: evidence[index]),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
      ],
    );

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: desktop ? 1180 : 820),
        child: body,
      ),
    );
  }
}

final class _DebriefHeader extends StatelessWidget {
  const _DebriefHeader({
    required this.transcriptAvailable,
    required this.debriefAvailable,
    required this.desktop,
    required this.finalizationMessage,
    required this.onRetry,
    required this.onReturn,
  });

  final bool transcriptAvailable;
  final bool debriefAvailable;
  final bool desktop;
  final String? finalizationMessage;
  final Future<void> Function() onRetry;
  final Future<void> Function() onReturn;

  @override
  Widget build(BuildContext context) {
    final Widget copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Après l’appel',
          style: _darkTextTheme(context).labelMedium?.copyWith(
            color: PinkallColors.pinkContainer.withValues(alpha: 0.72),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.18,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          debriefAvailable
              ? 'Débrief final disponible'
              : transcriptAvailable
              ? 'Transcription disponible'
              : 'Débrief en préparation',
          style: _darkTextTheme(context).headlineSmall?.copyWith(
            color: PinkallColors.onStrong,
            fontSize: desktop ? 26 : 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.35,
          ),
        ),
        if (finalizationMessage?.trim().isNotEmpty == true) ...<Widget>[
          const SizedBox(height: 9),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                debriefAvailable
                    ? Icons.check_circle_outline_rounded
                    : transcriptAvailable
                    ? Icons.description_outlined
                    : Icons.schedule_rounded,
                size: 15,
                color: debriefAvailable
                    ? PinkallColors.pinkContainer.withValues(alpha: 0.68)
                    : PinkallColors.onStrong.withValues(alpha: 0.42),
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  finalizationMessage!.trim(),
                  style: _darkTextTheme(context).bodyMedium?.copyWith(
                    color: PinkallColors.onStrong.withValues(alpha: 0.52),
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
    final Widget actions = Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        if (!debriefAvailable)
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: PinkallColors.onStrong.withValues(alpha: 0.72),
            ),
            onPressed: onRetry,
            child: const Text('Relancer le débrief'),
          ),
        FilledButton(
          onPressed: onReturn,
          child: const Text('Retour au téléphone'),
        ),
      ],
    );

    if (!desktop) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[copy, const SizedBox(height: 18), actions],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: copy),
        const SizedBox(width: 24),
        actions,
      ],
    );
  }
}

final class _DebriefAnalysis extends StatelessWidget {
  const _DebriefAnalysis({required this.debrief});

  final CallDebriefEntity debrief;

  @override
  Widget build(BuildContext context) {
    final bool reducedMotion =
        MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    final bool hasPerformance = debrief.performanceAxes.isNotEmpty;
    final bool hasHighlights =
        debrief.strengths.isNotEmpty || debrief.improvement != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _DebriefSection(
          eyebrow: 'En bref',
          child: Text(
            debrief.summary.text,
            style: _darkTextTheme(context).bodyLarge?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ),
        if (hasPerformance || hasHighlights)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final Widget? performance = hasPerformance
                    ? _PerformanceRadarCard(
                        axes: debrief.performanceAxes,
                        reducedMotion: reducedMotion,
                      )
                    : null;
                final Widget? highlights = hasHighlights
                    ? _DebriefHighlights(
                        strengths: debrief.strengths,
                        improvement: debrief.improvement,
                      )
                    : null;
                if (performance != null &&
                    highlights != null &&
                    constraints.maxWidth >= 860) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(flex: 6, child: performance),
                      const SizedBox(width: 14),
                      Expanded(flex: 5, child: highlights),
                    ],
                  );
                }
                return Column(
                  children: <Widget>[
                    if (performance != null) performance,
                    if (performance != null && highlights != null)
                      const SizedBox(height: 14),
                    if (highlights != null) highlights,
                  ],
                );
              },
            ),
          ),
        if (debrief.phraseCoaching.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _PhraseCoachingSection(items: debrief.phraseCoaching),
          ),
        if (debrief.strategicAdvice.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _StrategicAdviceSection(items: debrief.strategicAdvice),
          ),
        if (debrief.keyPoints.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _DebriefSection(
              eyebrow: 'Points clés',
              child: Column(
                children: debrief.keyPoints
                    .map(
                      (GroundedCallTextEntity point) => _DebriefListRow(
                        icon: Icons.subdirectory_arrow_right_rounded,
                        text: point.text,
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        if (debrief.commitments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: _DebriefSection(
              eyebrow: 'Engagements',
              child: Column(
                children: debrief.commitments
                    .map(
                      (CallCommitmentEntity commitment) => _DebriefListRow(
                        icon: Icons.check_rounded,
                        text:
                            '${_commitmentOwnerLabel(commitment.owner)} · ${commitment.text}',
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: _DebriefSection(
            eyebrow: 'Follow-up prêt à relire',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  debrief.followUp.subject,
                  style: _darkTextTheme(context).titleSmall?.copyWith(
                    color: PinkallColors.onStrong,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SelectableText(
                  debrief.followUp.body,
                  style: _darkTextTheme(context).bodyMedium?.copyWith(
                    color: PinkallColors.onStrong.withValues(alpha: 0.68),
                    height: 1.5,
                  ),
                ),
                if (debrief.followUp.nextAction?.trim().isNotEmpty ==
                    true) ...<Widget>[
                  const SizedBox(height: 12),
                  _DebriefListRow(
                    icon: Icons.arrow_forward_rounded,
                    text: debrief.followUp.nextAction!.trim(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final class _DebriefHighlights extends StatelessWidget {
  const _DebriefHighlights({required this.strengths, this.improvement});

  final List<GroundedCallTextEntity> strengths;
  final CallImprovementEntity? improvement;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      if (strengths.isNotEmpty)
        _DebriefSection(
          eyebrow: 'Tes points forts',
          child: Column(
            children: strengths
                .map(
                  (GroundedCallTextEntity strength) => _DebriefListRow(
                    icon: Icons.auto_awesome_rounded,
                    text: strength.text,
                  ),
                )
                .toList(growable: false),
          ),
        ),
      if (strengths.isNotEmpty && improvement != null)
        const SizedBox(height: 14),
      if (improvement case final CallImprovementEntity value)
        _DebriefImprovement(improvement: value),
    ],
  );
}

final class _PerformanceRadarCard extends StatelessWidget {
  const _PerformanceRadarCard({
    required this.axes,
    required this.reducedMotion,
  });

  final List<CallPerformanceAxisEntity> axes;
  final bool reducedMotion;

  @override
  Widget build(BuildContext context) {
    final Map<CallPerformanceAxis, CallPerformanceAxisEntity> byAxis =
        <CallPerformanceAxis, CallPerformanceAxisEntity>{
          for (final CallPerformanceAxisEntity item in axes) item.axis: item,
        };
    final List<CallPerformanceAxisEntity> ordered = CallPerformanceAxis.values
        .where(byAxis.containsKey)
        .map((CallPerformanceAxis axis) => byAxis[axis]!)
        .toList(growable: false);
    final String semanticsLabel = <String>[
      'Profil de compétences commerciales.',
      ...ordered.map(
        (CallPerformanceAxisEntity item) =>
            '${_performanceAxisLabel(item.axis)} ${item.score} sur 100, '
            '${_performanceSignalLabel(item.signal).toLowerCase()}.',
      ),
    ].join(' ');

    return _DebriefSection(
      eyebrow: 'Profil de compétences',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Le score mesure l’efficacité et le bon dosage : 50 est '
            'irrégulier, 75 solide, 90+ excellent. Le signal montre si tu en '
            'faisais trop peu, juste assez ou trop dans cet appel.',
            style: _darkTextTheme(context).bodySmall?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.54),
              height: 1.45,
            ),
          ),
          if (ordered.length >= 3) ...<Widget>[
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double dimension = math.min(
                  340,
                  math.max(248, constraints.maxWidth),
                );
                return Center(
                  child: Semantics(
                    label: semanticsLabel,
                    image: true,
                    child: ExcludeSemantics(
                      child: SizedBox.square(
                        key: const Key('debrief_performance_radar'),
                        dimension: dimension,
                        child: RepaintBoundary(
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: reducedMotion
                                ? Duration.zero
                                : const Duration(milliseconds: 360),
                            curve: Curves.easeOutCubic,
                            builder:
                                (
                                  BuildContext context,
                                  double progress,
                                  Widget? child,
                                ) => CustomPaint(
                                  painter: _PerformanceRadarPainter(
                                    axes: ordered,
                                    progress: progress,
                                    textDirection: Directionality.of(context),
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool twoColumns = constraints.maxWidth >= 500;
              final double width = twoColumns
                  ? (constraints.maxWidth - 10) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ordered
                    .map(
                      (CallPerformanceAxisEntity item) => SizedBox(
                        width: width,
                        child: _PerformanceAxisTile(item: item),
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

final class _PerformanceAxisTile extends StatelessWidget {
  const _PerformanceAxisTile({required this.item});

  final CallPerformanceAxisEntity item;

  @override
  Widget build(BuildContext context) {
    final String axis = _performanceAxisLabel(item.axis);
    final String signal = _performanceSignalLabel(item.signal);
    return Semantics(
      label:
          '$axis, ${item.score} sur 100, $signal. ${item.observation.trim()}',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: PinkallColors.onStrong.withValues(alpha: 0.035),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: PinkallColors.onStrong.withValues(alpha: 0.065),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      axis,
                      style: _darkTextTheme(context).labelMedium?.copyWith(
                        color: PinkallColors.onStrong.withValues(alpha: 0.78),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${item.score}/100',
                    style: _darkTextTheme(context).labelSmall?.copyWith(
                      color: PinkallColors.pinkContainer,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    _performanceSignalIcon(item.signal),
                    size: 14,
                    color: item.signal == CallPerformanceSignal.balanced
                        ? PinkallColors.pinkHighlight
                        : PinkallColors.onStrong.withValues(alpha: 0.52),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    signal,
                    style: _darkTextTheme(context).labelSmall?.copyWith(
                      color: item.signal == CallPerformanceSignal.balanced
                          ? PinkallColors.pinkContainer
                          : PinkallColors.onStrong.withValues(alpha: 0.58),
                    ),
                  ),
                ],
              ),
              if (item.observation.trim().isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Text(
                  item.observation.trim(),
                  style: _darkTextTheme(context).bodySmall?.copyWith(
                    color: PinkallColors.onStrong.withValues(alpha: 0.52),
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

final class _PerformanceRadarPainter extends CustomPainter {
  const _PerformanceRadarPainter({
    required this.axes,
    required this.progress,
    required this.textDirection,
  });

  final List<CallPerformanceAxisEntity> axes;
  final double progress;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = math.min(size.width, size.height) * 0.3;
    final Paint gridPaint = Paint()
      ..color = PinkallColors.onStrong.withValues(alpha: 0.095)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final Paint spokePaint = Paint()
      ..color = PinkallColors.onStrong.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int ring = 1; ring <= 4; ring += 1) {
      canvas.drawPath(
        _polygonPath(center, radius * ring / 4, axes.length),
        gridPaint,
      );
    }
    for (int index = 0; index < axes.length; index += 1) {
      canvas.drawLine(
        center,
        _point(center, radius, index, axes.length),
        spokePaint,
      );
    }

    final Path valuePath = Path();
    for (int index = 0; index < axes.length; index += 1) {
      final double score = axes[index].score.clamp(0, 100) / 100;
      final Offset point = _point(
        center,
        radius * score * progress,
        index,
        axes.length,
      );
      if (index == 0) {
        valuePath.moveTo(point.dx, point.dy);
      } else {
        valuePath.lineTo(point.dx, point.dy);
      }
    }
    valuePath.close();
    canvas.drawPath(
      valuePath,
      Paint()
        ..color = PinkallColors.pink.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      valuePath,
      Paint()
        ..color = PinkallColors.pinkHighlight.withValues(alpha: 0.92)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.1
        ..strokeJoin = StrokeJoin.round,
    );

    for (int index = 0; index < axes.length; index += 1) {
      final double score = axes[index].score.clamp(0, 100) / 100;
      canvas.drawCircle(
        _point(center, radius * score * progress, index, axes.length),
        3.2,
        Paint()..color = PinkallColors.pinkContainer,
      );
      _paintLabel(
        canvas,
        center,
        radius + 31,
        index,
        _performanceAxisShortLabel(axes[index].axis),
      );
    }
  }

  void _paintLabel(
    Canvas canvas,
    Offset center,
    double radius,
    int index,
    String label,
  ) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: PinkallColors.onStrong.withValues(alpha: 0.68),
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          height: 1.15,
        ),
      ),
      maxLines: 2,
      textAlign: TextAlign.center,
      textDirection: textDirection,
    )..layout(maxWidth: 76);
    final Offset point = _point(center, radius, index, axes.length);
    painter.paint(
      canvas,
      Offset(point.dx - painter.width / 2, point.dy - painter.height / 2),
    );
  }

  static Path _polygonPath(Offset center, double radius, int count) {
    final Path path = Path();
    for (int index = 0; index < count; index += 1) {
      final Offset point = _point(center, radius, index, count);
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    return path..close();
  }

  static Offset _point(Offset center, double radius, int index, int count) {
    final double angle = -math.pi / 2 + (math.pi * 2 * index / count);
    return center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
  }

  @override
  bool shouldRepaint(covariant _PerformanceRadarPainter oldDelegate) {
    if (oldDelegate.progress != progress ||
        oldDelegate.axes.length != axes.length) {
      return true;
    }
    for (int index = 0; index < axes.length; index += 1) {
      if (oldDelegate.axes[index].axis != axes[index].axis ||
          oldDelegate.axes[index].score != axes[index].score) {
        return true;
      }
    }
    return oldDelegate.textDirection != textDirection;
  }
}

final class _PhraseCoachingSection extends StatelessWidget {
  const _PhraseCoachingSection({required this.items});

  final List<PhraseCoachingEntity> items;

  @override
  Widget build(BuildContext context) => _DebriefSection(
    eyebrow: 'Tes phrases, en mieux',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Des reformulations plus claires, humaines et convaincantes, '
          'ancrées dans ce que tu as réellement dit.',
          style: _darkTextTheme(context).bodySmall?.copyWith(
            color: PinkallColors.onStrong.withValues(alpha: 0.54),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 12),
        ...items.indexed.map(((int, PhraseCoachingEntity) entry) {
          return Padding(
            padding: EdgeInsets.only(top: entry.$1 == 0 ? 0 : 10),
            child: _PhraseCoachingCard(item: entry.$2),
          );
        }),
      ],
    ),
  );
}

final class _PhraseCoachingCard extends StatelessWidget {
  const _PhraseCoachingCard({required this.item});

  final PhraseCoachingEntity item;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: PinkallColors.onStrong.withValues(alpha: 0.035),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: PinkallColors.onStrong.withValues(alpha: 0.07)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _DebriefTag(label: _phraseFocusLabel(item.focus)),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget original = _PhraseVersion(
              label: 'Phrase originale',
              text: item.originalText,
              improved: false,
            );
            final Widget improved = _PhraseVersion(
              label: 'Formulation proposée',
              text: item.improvedText,
              improved: true,
            );
            if (constraints.maxWidth >= 620) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: original),
                  const SizedBox(width: 10),
                  Expanded(child: improved),
                ],
              );
            }
            return Column(
              children: <Widget>[
                original,
                const SizedBox(height: 10),
                improved,
              ],
            );
          },
        ),
        if (item.rationale.trim().isNotEmpty) ...<Widget>[
          const SizedBox(height: 11),
          Text(
            item.rationale.trim(),
            style: _darkTextTheme(context).bodySmall?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.58),
              height: 1.45,
            ),
          ),
        ],
        const SizedBox(height: 9),
        _DebriefSources(sources: item.sources),
      ],
    ),
  );
}

final class _PhraseVersion extends StatelessWidget {
  const _PhraseVersion({
    required this.label,
    required this.text,
    required this.improved,
  });

  final String label;
  final String text;
  final bool improved;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: improved
          ? PinkallColors.pink.withValues(alpha: 0.105)
          : PinkallColors.onStrong.withValues(alpha: 0.035),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(
        color: improved
            ? PinkallColors.pink.withValues(alpha: 0.22)
            : PinkallColors.onStrong.withValues(alpha: 0.055),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: _darkTextTheme(context).labelSmall?.copyWith(
            color: improved
                ? PinkallColors.pinkContainer
                : PinkallColors.onStrong.withValues(alpha: 0.46),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        SelectableText(
          text,
          style: _darkTextTheme(context).bodyMedium?.copyWith(
            color: PinkallColors.onStrong.withValues(
              alpha: improved ? 0.92 : 0.62,
            ),
            fontWeight: improved ? FontWeight.w600 : FontWeight.w400,
            height: 1.48,
          ),
        ),
      ],
    ),
  );
}

final class _StrategicAdviceSection extends StatelessWidget {
  const _StrategicAdviceSection({required this.items});

  final List<StrategicCallAdviceEntity> items;

  @override
  Widget build(BuildContext context) {
    final List<StrategicCallAdviceEntity> ordered =
        List<StrategicCallAdviceEntity>.of(items)..sort(
          (StrategicCallAdviceEntity a, StrategicCallAdviceEntity b) =>
              _priorityRank(a.priority).compareTo(_priorityRank(b.priority)),
        );
    return _DebriefSection(
      eyebrow: 'Conseils pour aller plus loin',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Vente, marketing, produit et stratégie : des leviers plus larges '
            'que le seul traitement des objections.',
            style: _darkTextTheme(context).bodySmall?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.54),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool twoColumns = constraints.maxWidth >= 680;
              final double width = twoColumns
                  ? (constraints.maxWidth - 10) / 2
                  : constraints.maxWidth;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: ordered
                    .map(
                      (StrategicCallAdviceEntity item) => SizedBox(
                        width: width,
                        child: _StrategicAdviceCard(item: item),
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

final class _StrategicAdviceCard extends StatelessWidget {
  const _StrategicAdviceCard({required this.item});

  final StrategicCallAdviceEntity item;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: item.priority == AdvicePriority.high
          ? PinkallColors.pink.withValues(alpha: 0.09)
          : PinkallColors.onStrong.withValues(alpha: 0.035),
      borderRadius: BorderRadius.circular(15),
      border: Border.all(
        color: item.priority == AdvicePriority.high
            ? PinkallColors.pink.withValues(alpha: 0.2)
            : PinkallColors.onStrong.withValues(alpha: 0.065),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: <Widget>[
            _DebriefTag(label: _strategicCategoryLabel(item.category)),
            _DebriefTag(
              label: _advicePriorityLabel(item.priority),
              emphasized: item.priority == AdvicePriority.high,
            ),
          ],
        ),
        const SizedBox(height: 11),
        Text(
          item.title,
          style: _darkTextTheme(context).titleSmall?.copyWith(
            color: PinkallColors.onStrong,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          item.advice,
          style: _darkTextTheme(context).bodyMedium?.copyWith(
            color: PinkallColors.onStrong.withValues(alpha: 0.76),
            height: 1.46,
          ),
        ),
        if (item.rationale.trim().isNotEmpty) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            item.rationale.trim(),
            style: _darkTextTheme(context).bodySmall?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.5),
              height: 1.42,
            ),
          ),
        ],
        const SizedBox(height: 10),
        _DebriefSources(sources: item.sources),
      ],
    ),
  );
}

final class _DebriefTag extends StatelessWidget {
  const _DebriefTag({required this.label, this.emphasized = false});

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: emphasized
          ? PinkallColors.pink.withValues(alpha: 0.16)
          : PinkallColors.onStrong.withValues(alpha: 0.055),
      borderRadius: BorderRadius.circular(999),
      border: Border.all(
        color: emphasized
            ? PinkallColors.pink.withValues(alpha: 0.24)
            : PinkallColors.onStrong.withValues(alpha: 0.07),
      ),
    ),
    child: Text(
      label,
      style: _darkTextTheme(context).labelSmall?.copyWith(
        color: emphasized
            ? PinkallColors.pinkContainer
            : PinkallColors.onStrong.withValues(alpha: 0.62),
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

final class _DebriefSources extends StatelessWidget {
  const _DebriefSources({required this.sources});

  final List<CoachingSourceEntity> sources;

  @override
  Widget build(BuildContext context) => Text(
    sources.isEmpty
        ? 'Interprétation IA · aucune source du catalogue associée'
        : 'Méthode · ${sources.map((CoachingSourceEntity source) => source.title).join(' · ')}',
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    style: _darkTextTheme(context).labelSmall?.copyWith(
      color: PinkallColors.onStrong.withValues(alpha: 0.4),
    ),
  );
}

final class _DebriefSection extends StatelessWidget {
  const _DebriefSection({required this.eyebrow, required this.child});

  final String eyebrow;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: PinkallColors.onStrong.withValues(alpha: 0.045),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: PinkallColors.onStrong.withValues(alpha: 0.075),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          eyebrow,
          style: _darkTextTheme(context).labelMedium?.copyWith(
            color: PinkallColors.pinkContainer.withValues(alpha: 0.78),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    ),
  );
}

final class _DebriefImprovement extends StatelessWidget {
  const _DebriefImprovement({required this.improvement});

  final CallImprovementEntity improvement;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(19, 18, 18, 18),
    decoration: BoxDecoration(
      color: PinkallColors.pink.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: PinkallColors.pink.withValues(alpha: 0.28)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Une amélioration pour le prochain call',
          style: _darkTextTheme(context).labelMedium?.copyWith(
            color: PinkallColors.pinkContainer,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 9),
        Text(
          improvement.text,
          style: _darkTextTheme(context).bodyLarge?.copyWith(
            color: PinkallColors.onStrong,
            fontWeight: FontWeight.w600,
            height: 1.42,
          ),
        ),
        if (improvement.rationale.trim().isNotEmpty) ...<Widget>[
          const SizedBox(height: 8),
          Text(
            improvement.rationale.trim(),
            style: _darkTextTheme(context).bodySmall?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.58),
              height: 1.45,
            ),
          ),
        ],
        if (improvement.sources.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          Text(
            'Source · ${improvement.sources.map((CoachingSourceEntity source) => source.title).join(' · ')}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: _darkTextTheme(context).labelSmall?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.42),
            ),
          ),
        ],
      ],
    ),
  );
}

final class _DebriefListRow extends StatelessWidget {
  const _DebriefListRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 16,
            color: PinkallColors.pinkContainer.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: _darkTextTheme(context).bodyMedium?.copyWith(
              color: PinkallColors.onStrong.withValues(alpha: 0.72),
              height: 1.45,
            ),
          ),
        ),
      ],
    ),
  );
}

String _performanceAxisLabel(CallPerformanceAxis axis) => switch (axis) {
  CallPerformanceAxis.listening => 'Écoute',
  CallPerformanceAxis.discovery => 'Découverte',
  CallPerformanceAxis.clarity => 'Clarté',
  CallPerformanceAxis.confidence => 'Assurance',
  CallPerformanceAxis.value => 'Valeur',
  CallPerformanceAxis.personalization => 'Personnalisation',
  CallPerformanceAxis.progression => 'Progression',
  CallPerformanceAxis.naturalness => 'Naturel',
};

String _performanceAxisShortLabel(CallPerformanceAxis axis) => switch (axis) {
  CallPerformanceAxis.personalization => 'Personna-\nlisation',
  CallPerformanceAxis.listening => 'Écoute',
  CallPerformanceAxis.discovery => 'Découverte',
  CallPerformanceAxis.clarity => 'Clarté',
  CallPerformanceAxis.confidence => 'Assurance',
  CallPerformanceAxis.value => 'Valeur',
  CallPerformanceAxis.progression => 'Progression',
  CallPerformanceAxis.naturalness => 'Naturel',
};

String _performanceSignalLabel(CallPerformanceSignal signal) =>
    switch (signal) {
      CallPerformanceSignal.tooLow => 'Trop faible',
      CallPerformanceSignal.balanced => 'Équilibré',
      CallPerformanceSignal.tooHigh => 'Trop élevé',
    };

IconData _performanceSignalIcon(CallPerformanceSignal signal) =>
    switch (signal) {
      CallPerformanceSignal.tooLow => Icons.south_rounded,
      CallPerformanceSignal.balanced => Icons.check_rounded,
      CallPerformanceSignal.tooHigh => Icons.north_rounded,
    };

String _phraseFocusLabel(PhraseCoachingFocus focus) => switch (focus) {
  PhraseCoachingFocus.clarity => 'Plus clair',
  PhraseCoachingFocus.confidence => 'Plus assuré',
  PhraseCoachingFocus.humanity => 'Plus humain',
  PhraseCoachingFocus.persuasion => 'Plus vendeur',
  PhraseCoachingFocus.positioning => 'Positionnement',
};

String _strategicCategoryLabel(StrategicAdviceCategory category) =>
    switch (category) {
      StrategicAdviceCategory.sales => 'Vente',
      StrategicAdviceCategory.marketing => 'Marketing',
      StrategicAdviceCategory.product => 'Produit',
      StrategicAdviceCategory.strategy => 'Stratégie',
      StrategicAdviceCategory.communication => 'Communication',
    };

String _advicePriorityLabel(AdvicePriority priority) => switch (priority) {
  AdvicePriority.high => 'Prioritaire',
  AdvicePriority.medium => 'À renforcer',
  AdvicePriority.low => 'À explorer',
};

int _priorityRank(AdvicePriority priority) => switch (priority) {
  AdvicePriority.high => 0,
  AdvicePriority.medium => 1,
  AdvicePriority.low => 2,
};

String _commitmentOwnerLabel(CallCommitmentOwner owner) => switch (owner) {
  CallCommitmentOwner.seller => 'Toi',
  CallCommitmentOwner.prospect => 'Prospect',
  CallCommitmentOwner.mutual => 'Vous deux',
};

CoachingSuggestionEntity? _visibleSuggestion(ActiveCallState state) {
  if (!state.processingSession.transcriptionConsentAcknowledged ||
      state.processingSession.coachMode != CoachMode.live) {
    return null;
  }
  final CoachingSuggestionEntity? suggestion = state.suggestion;
  if (suggestion == null || suggestion.isExpiredAt(DateTime.now().toUtc())) {
    return null;
  }
  return suggestion;
}

TextTheme _darkTextTheme(BuildContext context) =>
    Theme.of(context).textTheme.apply(
      bodyColor: PinkallColors.onStrong,
      displayColor: PinkallColors.onStrong,
    );

String _clockTime(DateTime value) {
  final DateTime local = value.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

const Set<CallLifecycleStatus> _terminalStatuses = <CallLifecycleStatus>{
  CallLifecycleStatus.ended,
  CallLifecycleStatus.error,
};

String _statusLabel(CallLifecycleStatus status) => switch (status) {
  CallLifecycleStatus.newCall => 'Initialisation',
  CallLifecycleStatus.connecting => 'Connexion',
  CallLifecycleStatus.ringing => 'Sonnerie',
  CallLifecycleStatus.active => 'En ligne',
  CallLifecycleStatus.held => 'En attente',
  CallLifecycleStatus.reconnecting => 'Reconnexion',
  CallLifecycleStatus.renegotiating => 'Ajustement audio',
  CallLifecycleStatus.dropped => 'Appel interrompu',
  CallLifecycleStatus.ended => 'Appel terminé',
  CallLifecycleStatus.error => 'Erreur d’appel',
};
