import 'dart:math' as math;
import 'dart:ui' show FontFeature, ImageFilter;
import 'dart:ui' as ui show TextDirection;

import 'package:auto_route/auto_route.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:pinkall/features/calls/presentation/screens/progress/call_progress.state.dart';
import 'package:pinkall/features/calls/presentation/screens/progress/call_progress.view_model.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_error_view.widget.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_loading_view.widget.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_page_frame.widget.dart';
import 'package:pinkall/foundation/routing/app_router.dart';
import 'package:pinkall/generated/locale_keys.g.dart';

/// Historical coaching dashboard for the current Pinkall workspace.
@RoutePage()
final class CallProgressScreen extends ConsumerStatefulWidget {
  /// Creates the historical coaching dashboard.
  const CallProgressScreen({super.key});

  @override
  ConsumerState<CallProgressScreen> createState() => _CallProgressScreenState();
}

final class _CallProgressScreenState extends ConsumerState<CallProgressScreen> {
  @override
  Widget build(BuildContext context) {
    final AsyncValue<CallProgressState> asyncState = ref.watch(
      callProgressViewModelProvider,
    );
    final CallProgressState? current = asyncState.value;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PinkallPageFrame(
        accessory: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              key: const Key('progress_back_button'),
              tooltip: LocaleKeys.common_back.tr(),
              onPressed: () => context.router.maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
            ),
            IconButton(
              key: const Key('progress_refresh_button'),
              tooltip: LocaleKeys.progress_refresh.tr(),
              onPressed: current?.isRefreshing ?? false
                  ? null
                  : () => ref
                        .read(callProgressViewModelProvider.notifier)
                        .refresh(),
              icon: current?.isRefreshing ?? false
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 1.8),
                    )
                  : const Icon(Icons.refresh_rounded, size: 20),
            ),
          ],
        ),
        child: asyncState.when(
          loading: () => const PinkallLoadingView(),
          error: (Object error, StackTrace stackTrace) => PinkallErrorView(
            onRetry: () => ref.invalidate(callProgressViewModelProvider),
          ),
          data: (CallProgressState state) => _ProgressContent(
            state: state,
            onSelectWindow: (int value) => ref
                .read(callProgressViewModelProvider.notifier)
                .selectWindow(value),
            onStartCall: () => context.router.replace(CallHomeRoute()),
            onOpenCall: (CoachingProgressCallEntity call) =>
                context.router.push(
                  ActiveCallRoute(
                    callId: call.callId,
                    sessionId: call.sessionId,
                    remoteNumber: call.destinationNumber,
                    companion: true,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

final class _ProgressContent extends StatelessWidget {
  const _ProgressContent({
    required this.state,
    required this.onSelectWindow,
    required this.onStartCall,
    required this.onOpenCall,
  });

  final CallProgressState state;
  final ValueChanged<int> onSelectWindow;
  final VoidCallback onStartCall;
  final ValueChanged<CoachingProgressCallEntity> onOpenCall;

  @override
  Widget build(BuildContext context) {
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 38, 24, 56),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _ProgressHeader(
                      progress: state.progress,
                      selectedWindow: state.selectedWindow,
                      onSelectWindow: onSelectWindow,
                    ),
                    const Gap(28),
                    AnimatedSwitcher(
                      duration: reduceMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 360),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder:
                          (Widget child, Animation<double> value) {
                            return FadeTransition(
                              opacity: value,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.985, end: 1)
                                    .animate(
                                      CurvedAnimation(
                                        parent: value,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                child: child,
                              ),
                            );
                          },
                      child: state.progress.analyzedCallCount == 0
                          ? _EmptyProgress(
                              key: const ValueKey<String>('empty-progress'),
                              onStartCall: onStartCall,
                            )
                          : _LoadedProgress(
                              key: ValueKey<int>(state.selectedWindow),
                              progress: state.progress,
                              onOpenCall: onOpenCall,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.progress,
    required this.selectedWindow,
    required this.onSelectWindow,
  });

  final CoachingProgressEntity progress;
  final int selectedWindow;
  final ValueChanged<int> onSelectWindow;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compact = constraints.maxWidth < 760;
        final Widget copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              LocaleKeys.progress_eyebrow.tr(),
              style: textTheme.labelMedium?.copyWith(
                color: PinkallColors.pink,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
            const Gap(10),
            Text(
              LocaleKeys.progress_title.tr(),
              style: textTheme.displaySmall?.copyWith(
                color: PinkallColors.carbon,
                fontWeight: FontWeight.w600,
                letterSpacing: -1.2,
                height: 1.04,
              ),
            ),
            const Gap(10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 670),
              child: Text(
                LocaleKeys.progress_subtitle.tr(),
                style: textTheme.bodyLarge?.copyWith(
                  color: PinkallColors.carbonSoft,
                  height: 1.5,
                ),
              ),
            ),
            const Gap(12),
            Text(
              LocaleKeys.progress_coverage_count.tr(
                args: <String>[
                  '${progress.analyzedCallCount}',
                  '${progress.sessionCount}',
                ],
              ),
              style: textTheme.labelLarge?.copyWith(color: PinkallColors.muted),
            ),
          ],
        );
        final Widget selector = _WindowSelector(
          selectedWindow: selectedWindow,
          onSelectWindow: onSelectWindow,
        );
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[copy, const Gap(22), selector],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(child: copy),
            const Gap(28),
            selector,
          ],
        );
      },
    );
  }
}

final class _WindowSelector extends StatelessWidget {
  const _WindowSelector({
    required this.selectedWindow,
    required this.onSelectWindow,
  });

  final int selectedWindow;
  final ValueChanged<int> onSelectWindow;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: LocaleKeys.progress_window_label.tr(),
      child: SegmentedButton<int>(
        key: const Key('progress_window_selector'),
        segments: <ButtonSegment<int>>[
          for (final int value in <int>[5, 10, 20])
            ButtonSegment<int>(
              value: value,
              label: Text('$value'),
              tooltip: LocaleKeys.progress_window_calls.tr(
                args: <String>['$value'],
              ),
            ),
        ],
        selected: <int>{selectedWindow},
        showSelectedIcon: false,
        onSelectionChanged: (Set<int> values) => onSelectWindow(values.single),
      ),
    );
  }
}

final class _EmptyProgress extends StatelessWidget {
  const _EmptyProgress({required this.onStartCall, super.key});

  final VoidCallback onStartCall;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 52),
        child: Column(
          children: <Widget>[
            DecoratedBox(
              decoration: const BoxDecoration(
                color: PinkallColors.pinkContainer,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Icon(
                  Icons.insights_rounded,
                  color: PinkallColors.pink,
                  size: 30,
                ),
              ),
            ),
            const Gap(22),
            Text(
              LocaleKeys.progress_empty_title.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
              ),
            ),
            const Gap(10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Text(
                LocaleKeys.progress_empty_body.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: PinkallColors.carbonSoft,
                  height: 1.5,
                ),
              ),
            ),
            const Gap(22),
            FilledButton.icon(
              onPressed: onStartCall,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: Text(LocaleKeys.progress_empty_action.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

final class _LoadedProgress extends StatelessWidget {
  const _LoadedProgress({
    required this.progress,
    required this.onOpenCall,
    super.key,
  });

  final CoachingProgressEntity progress;
  final ValueChanged<CoachingProgressCallEntity> onOpenCall;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final Widget radar = _ProgressRadarCard(progress: progress);
            final Widget focus = _FocusCard(progress: progress);
            if (constraints.maxWidth < 900) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[radar, const Gap(18), focus],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 7, child: radar),
                const Gap(18),
                Expanded(flex: 5, child: focus),
              ],
            );
          },
        ),
        const Gap(18),
        _MetricsSection(metrics: progress.observedMetrics),
        const Gap(18),
        _TrendSection(progress: progress),
        const Gap(18),
        _HistorySection(progress: progress, onOpenCall: onOpenCall),
      ],
    );
  }
}

final class _ProgressRadarCard extends StatelessWidget {
  const _ProgressRadarCard({required this.progress});

  final CoachingProgressEntity progress;

  @override
  Widget build(BuildContext context) {
    final List<String> labels = progress.axes
        .map((CoachingProgressAxisEntity axis) => _axisLabel(axis.axis))
        .toList(growable: false);
    final List<double> current = progress.axes
        .map((CoachingProgressAxisEntity axis) => axis.currentScore / 100)
        .toList(growable: false);
    final List<double>? previous = progress.hasComparison
        ? progress.axes
              .map(
                (CoachingProgressAxisEntity axis) =>
                    (axis.previousScore ?? axis.currentScore) / 100,
              )
              .toList(growable: false)
        : null;
    final String semantics = progress.axes
        .map(
          (CoachingProgressAxisEntity axis) =>
              LocaleKeys.progress_radar_axis_semantics.tr(
                namedArgs: <String, String>{
                  'axis': _axisLabel(axis.axis),
                  'score': '${axis.currentScore}',
                },
              ),
        )
        .join(', ');
    return _GlassPanel(
      key: const Key('progress_radar_card'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              LocaleKeys.progress_radar_title.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            const Gap(6),
            Text(
              LocaleKeys.progress_radar_subtitle.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: PinkallColors.carbonSoft,
                height: 1.45,
              ),
            ),
            const Gap(18),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: <Widget>[
                _LegendItem(
                  color: PinkallColors.pink,
                  label: LocaleKeys.progress_current_period.tr(),
                ),
                if (previous != null)
                  _LegendItem(
                    color: PinkallColors.spectralLilac,
                    label: LocaleKeys.progress_previous_period.tr(),
                  ),
              ],
            ),
            const Gap(4),
            Semantics(
              label: semantics,
              image: true,
              child: ExcludeSemantics(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 330,
                    maxHeight: 390,
                  ),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final bool reduceMotion =
                              MediaQuery.disableAnimationsOf(context);
                          return TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: reduceMotion
                                ? Duration.zero
                                : const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            builder:
                                (
                                  BuildContext context,
                                  double reveal,
                                  Widget? child,
                                ) {
                                  return CustomPaint(
                                    key: const Key('progress_comparison_radar'),
                                    size: Size(
                                      constraints.maxWidth,
                                      constraints.maxHeight,
                                    ),
                                    painter: _HistoricalRadarPainter(
                                      labels: labels,
                                      current: current,
                                      previous: previous,
                                      reveal: reveal,
                                      highContrast: MediaQuery.highContrastOf(
                                        context,
                                      ),
                                    ),
                                  );
                                },
                          );
                        },
                  ),
                ),
              ),
            ),
            if (!progress.hasComparison)
              Text(
                LocaleKeys.progress_baseline.tr(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: PinkallColors.muted),
              ),
          ],
        ),
      ),
    );
  }
}

final class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: const SizedBox.square(dimension: 8),
        ),
        const Gap(7),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}

final class _FocusCard extends StatelessWidget {
  const _FocusCard({required this.progress});

  final CoachingProgressEntity progress;

  @override
  Widget build(BuildContext context) {
    final CoachingProgressAxisEntity? focus = progress.focus;
    final CoachingProgressAxisEntity? strength = progress.strength;
    return _GlassPanel(
      key: const Key('progress_focus_card'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (focus != null)
              _AxisSpotlight(
                icon: Icons.north_east_rounded,
                title: LocaleKeys.progress_focus_title.tr(),
                body: LocaleKeys.progress_focus_body.tr(),
                axis: focus,
                emphasized: true,
              ),
            if (focus != null && strength != null) ...<Widget>[
              const Gap(22),
              Divider(color: Theme.of(context).colorScheme.outlineVariant),
              const Gap(18),
            ],
            if (strength != null)
              _AxisSpotlight(
                icon: Icons.auto_awesome_rounded,
                title: LocaleKeys.progress_strength_title.tr(),
                body: LocaleKeys.progress_strength_body.tr(),
                axis: strength,
                emphasized: false,
              ),
          ],
        ),
      ),
    );
  }
}

final class _AxisSpotlight extends StatelessWidget {
  const _AxisSpotlight({
    required this.icon,
    required this.title,
    required this.body,
    required this.axis,
    required this.emphasized,
  });

  final IconData icon;
  final String title;
  final String body;
  final CoachingProgressAxisEntity axis;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(
              icon,
              size: 18,
              color: emphasized ? PinkallColors.pink : PinkallColors.carbonSoft,
            ),
            const Gap(8),
            Expanded(
              child: Text(
                title,
                style: textTheme.labelLarge?.copyWith(
                  color: emphasized
                      ? PinkallColors.pink
                      : PinkallColors.carbonSoft,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const Gap(14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(
                _axisLabel(axis.axis),
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.7,
                ),
              ),
            ),
            Text(
              '${axis.currentScore}',
              style: textTheme.headlineMedium?.copyWith(
                color: emphasized ? PinkallColors.pink : PinkallColors.carbon,
                fontWeight: FontWeight.w600,
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const Gap(8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            _SignalChip(signal: axis.signal),
            if (axis.delta case final int delta)
              _DeltaChip(delta: delta.toDouble()),
          ],
        ),
        const Gap(14),
        Text(
          axis.observation,
          style: textTheme.bodyLarge?.copyWith(
            color: PinkallColors.carbon,
            height: 1.48,
          ),
        ),
        const Gap(10),
        Text(
          body,
          style: textTheme.bodySmall?.copyWith(
            color: PinkallColors.muted,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

final class _SignalChip extends StatelessWidget {
  const _SignalChip({required this.signal});

  final CallPerformanceSignal signal;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (signal) {
      CallPerformanceSignal.balanced => PinkallColors.success,
      CallPerformanceSignal.tooLow => PinkallColors.warning,
      CallPerformanceSignal.tooHigh => PinkallColors.pinkDark,
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          _signalLabel(signal),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

final class _DeltaChip extends StatelessWidget {
  const _DeltaChip({required this.delta});

  final double delta;

  @override
  Widget build(BuildContext context) {
    final String value = '${delta > 0 ? '+' : ''}${_trimNumber(delta)}';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PinkallColors.surfaceLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          LocaleKeys.progress_delta_previous.tr(args: <String>[value]),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: PinkallColors.carbonSoft,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

final class _MetricsSection extends StatelessWidget {
  const _MetricsSection({required this.metrics});

  final CoachingProgressMetricsEntity metrics;

  @override
  Widget build(BuildContext context) {
    final List<_MetricPresentation> items = <_MetricPresentation>[
      _MetricPresentation(
        icon: Icons.pie_chart_outline_rounded,
        label: LocaleKeys.progress_metric_talk_ratio.tr(),
        value: _percentage(metrics.sellerTalkRatio.current),
        delta: metrics.sellerTalkRatio.delta == null
            ? null
            : _percentage(metrics.sellerTalkRatio.delta),
      ),
      _MetricPresentation(
        icon: Icons.help_outline_rounded,
        label: LocaleKeys.progress_metric_questions_rate.tr(),
        value: _decimal(metrics.questionsPerMinute.current),
        delta: _signedDecimal(metrics.questionsPerMinute.delta),
      ),
      _MetricPresentation(
        icon: Icons.graphic_eq_rounded,
        label: LocaleKeys.progress_metric_average_turn.tr(),
        value: _seconds(metrics.averageSellerTurnSeconds.current),
        delta: _signedSeconds(metrics.averageSellerTurnSeconds.delta),
      ),
      _MetricPresentation(
        icon: Icons.straighten_rounded,
        label: LocaleKeys.progress_metric_longest_turn.tr(),
        value: _seconds(metrics.longestSellerTurnSeconds.current),
        delta: _signedSeconds(metrics.longestSellerTurnSeconds.delta),
      ),
      _MetricPresentation(
        icon: Icons.more_horiz_rounded,
        label: LocaleKeys.progress_metric_hesitations_rate.tr(),
        value: _decimal(metrics.hesitationsPerMinute.current),
        delta: _signedDecimal(metrics.hesitationsPerMinute.delta),
      ),
    ];
    return _GlassPanel(
      key: const Key('progress_metrics_section'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              LocaleKeys.progress_metrics_title.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            const Gap(6),
            Text(
              LocaleKeys.progress_metrics_subtitle.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: PinkallColors.carbonSoft,
                height: 1.45,
              ),
            ),
            const Gap(20),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final int columns = constraints.maxWidth >= 1040
                    ? 5
                    : constraints.maxWidth >= 640
                    ? 3
                    : 2;
                final double spacing = 12;
                final double width =
                    (constraints.maxWidth - spacing * (columns - 1)) / columns;
                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: items
                      .map(
                        (_MetricPresentation item) => SizedBox(
                          width: width,
                          child: _MetricCard(item: item),
                        ),
                      )
                      .toList(growable: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

final class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.item});

  final _MetricPresentation item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: PinkallColors.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PinkallColors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(item.icon, size: 19, color: PinkallColors.pink),
            const Gap(14),
            Text(
              item.value ?? LocaleKeys.progress_metric_no_data.tr(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
              ),
            ),
            const Gap(4),
            Text(
              item.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: PinkallColors.carbonSoft,
                height: 1.3,
              ),
            ),
            if (item.delta != null) ...<Widget>[
              const Gap(8),
              Text(
                LocaleKeys.progress_delta_previous.tr(
                  args: <String>[item.delta!],
                ),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: PinkallColors.muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _TrendSection extends StatelessWidget {
  const _TrendSection({required this.progress});

  final CoachingProgressEntity progress;

  @override
  Widget build(BuildContext context) {
    final CoachingProgressAxisEntity? focus = progress.focus;
    final List<CoachingProgressCallEntity> calls = progress.recentCalls.reversed
        .toList(growable: false);
    final List<double> scores = focus == null
        ? const <double>[]
        : calls
              .map(
                (CoachingProgressCallEntity call) =>
                    _callAxis(call, focus.axis)?.score.toDouble(),
              )
              .whereType<double>()
              .toList(growable: false);
    return _GlassPanel(
      key: const Key('progress_trend_section'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        LocaleKeys.progress_trend_title.tr(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Gap(5),
                      Text(
                        LocaleKeys.progress_trend_subtitle.tr(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: PinkallColors.carbonSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                if (focus != null)
                  Text(
                    _axisLabel(focus.axis),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: PinkallColors.pink,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
            const Gap(22),
            if (scores.length < 2)
              Text(
                LocaleKeys.progress_baseline.tr(),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: PinkallColors.muted),
              )
            else
              Semantics(
                label: scores
                    .map((double score) => '${score.round()}')
                    .join(', '),
                image: true,
                child: ExcludeSemantics(
                  child: SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: CustomPaint(
                      key: const Key('progress_focus_trend_chart'),
                      painter: _TrendPainter(
                        scores: scores,
                        highContrast: MediaQuery.highContrastOf(context),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.progress, required this.onOpenCall});

  final CoachingProgressEntity progress;
  final ValueChanged<CoachingProgressCallEntity> onOpenCall;

  @override
  Widget build(BuildContext context) {
    return _GlassPanel(
      key: const Key('progress_history_section'),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              LocaleKeys.progress_history_title.tr(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            const Gap(10),
            for (final CoachingProgressCallEntity call in progress.recentCalls)
              _HistoryRow(
                call: call,
                focusAxis: progress.focus?.axis,
                onTap: () => onOpenCall(call),
              ),
          ],
        ),
      ),
    );
  }
}

final class _HistoryRow extends StatelessWidget {
  const _HistoryRow({
    required this.call,
    required this.focusAxis,
    required this.onTap,
  });

  final CoachingProgressCallEntity call;
  final CallPerformanceAxis? focusAxis;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final DateTime localDate = call.occurredAt.toLocal();
    final String date = localizations.formatShortDate(localDate);
    final String time = localizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(localDate),
    );
    final CallPerformanceAxisEntity? axis = focusAxis == null
        ? null
        : _callAxis(call, focusAxis!);
    return Column(
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: Row(
              children: <Widget>[
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: PinkallColors.pinkContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.call_outlined,
                      color: PinkallColors.pink,
                      size: 18,
                    ),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        call.destinationNumber,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(3),
                      Text(
                        '$date · $time',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: PinkallColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (axis != null) ...<Widget>[
                  Text(
                    '${axis.score}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                    ),
                  ),
                  const Gap(12),
                ],
                Tooltip(
                  message: LocaleKeys.progress_open_call.tr(),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: PinkallColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: Theme.of(context).colorScheme.outlineVariant),
      ],
    );
  }
}

final class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool highContrast = MediaQuery.highContrastOf(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: PinkallColors.shadow.withValues(alpha: 0.055),
            blurRadius: 34,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: highContrast ? 0 : 22,
            sigmaY: highContrast ? 0 : 22,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: PinkallColors.surface.withValues(
                alpha: highContrast ? 1 : 0.78,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: highContrast
                    ? PinkallColors.carbon
                    : Colors.white.withValues(alpha: 0.64),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

final class _HistoricalRadarPainter extends CustomPainter {
  const _HistoricalRadarPainter({
    required this.labels,
    required this.current,
    required this.previous,
    required this.reveal,
    required this.highContrast,
  });

  final List<String> labels;
  final List<double> current;
  final List<double>? previous;
  final double reveal;
  final bool highContrast;

  @override
  void paint(Canvas canvas, Size size) {
    if (current.length < 3 || labels.length != current.length) {
      return;
    }
    final Offset center = Offset(size.width / 2, size.height / 2 + 5);
    final double radius = math.min(size.width * 0.31, size.height * 0.35);
    final int count = current.length;
    final Paint grid = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = highContrast ? 1.2 : 0.8
      ..color = PinkallColors.carbon.withValues(
        alpha: highContrast ? 0.45 : 0.12,
      );
    for (final double scale in <double>[0.25, 0.5, 0.75, 1]) {
      canvas.drawPath(_polygon(count, center, radius * scale), grid);
    }
    for (int index = 0; index < count; index += 1) {
      canvas.drawLine(center, _point(index, count, center, radius), grid);
    }
    if (previous case final List<double> previousValues) {
      final Path previousPath = _valuePath(
        previousValues,
        count,
        center,
        radius,
        reveal,
      );
      canvas.drawPath(
        previousPath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = highContrast ? 2.8 : 2.2
          ..color = PinkallColors.spectralLilac.withValues(alpha: 0.95),
      );
    }
    final Path currentPath = _valuePath(current, count, center, radius, reveal);
    canvas.drawPath(
      currentPath,
      Paint()
        ..style = PaintingStyle.fill
        ..color = PinkallColors.pink.withValues(alpha: 0.13),
    );
    canvas.drawPath(
      currentPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = highContrast ? 3.2 : 2.5
        ..strokeJoin = StrokeJoin.round
        ..color = PinkallColors.pink,
    );
    for (int index = 0; index < count; index += 1) {
      final Offset point = _point(
        index,
        count,
        center,
        radius * current[index].clamp(0, 1) * reveal,
      );
      canvas.drawCircle(
        point,
        highContrast ? 4.5 : 3.5,
        Paint()..color = PinkallColors.pink,
      );
    }
    for (int index = 0; index < count; index += 1) {
      final double angle = -math.pi / 2 + (math.pi * 2 * index / count);
      final Offset anchor = _point(index, count, center, radius + 28);
      final TextPainter painter = TextPainter(
        text: TextSpan(
          text: labels[index],
          style: const TextStyle(
            color: PinkallColors.carbonSoft,
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            height: 1.15,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
        textAlign: math.cos(angle).abs() < 0.2
            ? TextAlign.center
            : math.cos(angle) > 0
            ? TextAlign.left
            : TextAlign.right,
        maxLines: 2,
      )..layout(maxWidth: 90);
      final double dx = math.cos(angle).abs() < 0.2
          ? anchor.dx - painter.width / 2
          : math.cos(angle) > 0
          ? anchor.dx
          : anchor.dx - painter.width;
      painter.paint(canvas, Offset(dx, anchor.dy - painter.height / 2));
    }
  }

  static Path _polygon(int count, Offset center, double radius) {
    final Path path = Path();
    for (int index = 0; index < count; index += 1) {
      final Offset point = _point(index, count, center, radius);
      index == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  static Path _valuePath(
    List<double> values,
    int count,
    Offset center,
    double radius,
    double reveal,
  ) {
    final Path path = Path();
    for (int index = 0; index < count; index += 1) {
      final Offset point = _point(
        index,
        count,
        center,
        radius * values[index].clamp(0, 1) * reveal,
      );
      index == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  static Offset _point(int index, int count, Offset center, double radius) {
    final double angle = -math.pi / 2 + (math.pi * 2 * index / count);
    return Offset(
      center.dx + math.cos(angle) * radius,
      center.dy + math.sin(angle) * radius,
    );
  }

  @override
  bool shouldRepaint(covariant _HistoricalRadarPainter oldDelegate) {
    return oldDelegate.current != current ||
        oldDelegate.previous != previous ||
        oldDelegate.reveal != reveal ||
        oldDelegate.highContrast != highContrast;
  }
}

final class _TrendPainter extends CustomPainter {
  const _TrendPainter({required this.scores, required this.highContrast});

  final List<double> scores;
  final bool highContrast;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect bounds = Rect.fromLTWH(8, 10, size.width - 16, size.height - 24);
    final Paint grid = Paint()
      ..color = PinkallColors.carbon.withValues(
        alpha: highContrast ? 0.32 : 0.08,
      )
      ..strokeWidth = 1;
    for (final double fraction in <double>[0, 0.5, 1]) {
      final double y = bounds.bottom - bounds.height * fraction;
      canvas.drawLine(Offset(bounds.left, y), Offset(bounds.right, y), grid);
    }
    final Path line = Path();
    for (int index = 0; index < scores.length; index += 1) {
      final double x = scores.length == 1
          ? bounds.center.dx
          : bounds.left + bounds.width * index / (scores.length - 1);
      final double y = bounds.bottom - bounds.height * (scores[index] / 100);
      index == 0 ? line.moveTo(x, y) : line.lineTo(x, y);
    }
    canvas.drawPath(
      line,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = highContrast ? 3.2 : 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = PinkallColors.pink,
    );
    for (int index = 0; index < scores.length; index += 1) {
      final double x = scores.length == 1
          ? bounds.center.dx
          : bounds.left + bounds.width * index / (scores.length - 1);
      final double y = bounds.bottom - bounds.height * (scores[index] / 100);
      canvas.drawCircle(Offset(x, y), 4, Paint()..color = PinkallColors.pink);
      canvas.drawCircle(
        Offset(x, y),
        2,
        Paint()..color = PinkallColors.surface,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.scores != scores || oldDelegate.highContrast != highContrast;
}

final class _MetricPresentation {
  const _MetricPresentation({
    required this.icon,
    required this.label,
    required this.value,
    required this.delta,
  });

  final IconData icon;
  final String label;
  final String? value;
  final String? delta;
}

String _axisLabel(CallPerformanceAxis axis) => switch (axis) {
  CallPerformanceAxis.listening => LocaleKeys.progress_axis_listening.tr(),
  CallPerformanceAxis.discovery => LocaleKeys.progress_axis_discovery.tr(),
  CallPerformanceAxis.clarity => LocaleKeys.progress_axis_clarity.tr(),
  CallPerformanceAxis.confidence => LocaleKeys.progress_axis_confidence.tr(),
  CallPerformanceAxis.value => LocaleKeys.progress_axis_value.tr(),
  CallPerformanceAxis.personalization =>
    LocaleKeys.progress_axis_personalization.tr(),
  CallPerformanceAxis.progression => LocaleKeys.progress_axis_progression.tr(),
  CallPerformanceAxis.naturalness => LocaleKeys.progress_axis_naturalness.tr(),
};

String _signalLabel(CallPerformanceSignal signal) => switch (signal) {
  CallPerformanceSignal.tooLow => LocaleKeys.progress_signal_too_low.tr(),
  CallPerformanceSignal.balanced => LocaleKeys.progress_signal_balanced.tr(),
  CallPerformanceSignal.tooHigh => LocaleKeys.progress_signal_too_high.tr(),
};

CallPerformanceAxisEntity? _callAxis(
  CoachingProgressCallEntity call,
  CallPerformanceAxis axis,
) {
  for (final CallPerformanceAxisEntity item in call.performanceAxes) {
    if (item.axis == axis) {
      return item;
    }
  }
  return null;
}

String? _percentage(double? value) =>
    value == null ? null : '${(value * 100).round()} %';

String? _decimal(double? value) => value == null ? null : _trimNumber(value);

String? _seconds(double? value) => value == null
    ? null
    : LocaleKeys.progress_metric_seconds.tr(args: <String>[_trimNumber(value)]);

String? _signedDecimal(double? value) =>
    value == null ? null : '${value > 0 ? '+' : ''}${_trimNumber(value)}';

String? _signedSeconds(double? value) =>
    value == null ? null : '${value > 0 ? '+' : ''}${_trimNumber(value)} s';

String _trimNumber(double value) {
  final String fixed = value.toStringAsFixed(1);
  return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
}
