import 'dart:ui' show ImageFilter;

import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A continuous, adaptive product scene shared by the light workspaces.
///
/// Desktop and mobile use a compact brand toolbar. Phone and contacts are now
/// part of the same surface, so the shell deliberately exposes no destination
/// tabs or bottom navigation.
final class PinkallPageFrame extends StatelessWidget {
  /// Creates an adaptive page frame around [child].
  const PinkallPageFrame({
    required this.child,
    this.accessory,
    this.desktopLeadingWidth,
    super.key,
  });

  /// Screen-specific content.
  final Widget child;

  /// Compact contextual controls shown in the native chrome.
  final Widget? accessory;

  /// Optional desktop toolbar column aligned with a leading content rail.
  final double? desktopLeadingWidth;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: PinkallColors.background,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Positioned.fill(child: _WorkbenchGrid()),
          const Positioned.fill(child: _AmbientField()),
          SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool compact = constraints.maxWidth < 720;
                return Column(
                  children: <Widget>[
                    if (compact)
                      _CompactToolbar(accessory: accessory)
                    else
                      _DesktopToolbar(
                        accessory: accessory,
                        leadingWidth:
                            desktopLeadingWidth != null &&
                                constraints.maxWidth >= 1044
                            ? desktopLeadingWidth
                            : null,
                      ),
                    Expanded(child: child),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

final class _WorkbenchGrid extends StatelessWidget {
  const _WorkbenchGrid();

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.highContrastOf(context)) {
      return const SizedBox.shrink();
    }
    return IgnorePointer(
      child: ExcludeSemantics(
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (Rect bounds) => const RadialGradient(
            center: Alignment(0, -0.08),
            radius: 1.05,
            colors: <Color>[Colors.white, Colors.transparent],
            stops: <double>[0, 0.86],
          ).createShader(bounds),
          child: const CustomPaint(
            key: Key('pinkall_workbench_grid'),
            painter: _WorkbenchGridPainter(),
          ),
        ),
      ),
    );
  }
}

final class _WorkbenchGridPainter extends CustomPainter {
  const _WorkbenchGridPainter();

  static const double _step = 72;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint rule = Paint()
      ..color = PinkallColors.carbon.withValues(alpha: 0.026)
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += _step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), rule);
    }
    for (double y = 0; y <= size.height; y += _step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), rule);
    }
  }

  @override
  bool shouldRepaint(covariant _WorkbenchGridPainter oldDelegate) => false;
}

final class _AmbientField extends StatefulWidget {
  const _AmbientField();

  @override
  State<_AmbientField> createState() => _AmbientFieldState();
}

final class _AmbientFieldState extends State<_AmbientField> {
  Offset _drift = Offset.zero;

  void _followPointer(PointerHoverEvent event) {
    if (MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.highContrastOf(context)) {
      return;
    }
    final Size size = MediaQuery.sizeOf(context);
    if (size.isEmpty) {
      return;
    }
    final Offset next = Offset(
      ((event.position.dx / size.width) - 0.5).clamp(-0.5, 0.5),
      ((event.position.dy / size.height) - 0.5).clamp(-0.5, 0.5),
    );
    if ((next - _drift).distance < 0.025) {
      return;
    }
    setState(() => _drift = next);
  }

  void _releasePointer(PointerExitEvent event) {
    if (_drift != Offset.zero && mounted) {
      setState(() => _drift = Offset.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool highContrast = MediaQuery.highContrastOf(context);
    final bool reduceMotion = MediaQuery.disableAnimationsOf(context);
    if (highContrast) {
      return const SizedBox.shrink();
    }
    return MouseRegion(
      opaque: false,
      onHover: _followPointer,
      onExit: _releasePointer,
      child: IgnorePointer(
        child: ExcludeSemantics(
          child: TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(end: reduceMotion ? Offset.zero : _drift),
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 1100),
            curve: Curves.easeOutCubic,
            builder: (BuildContext context, Offset drift, Widget? child) {
              return Stack(
                children: <Widget>[
                  Positioned(
                    bottom: -220 + drift.dy * 28,
                    right: -120 + drift.dx * 34,
                    child: Transform.rotate(
                      angle: -0.16 + drift.dx * 0.04,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 78, sigmaY: 78),
                        child: Container(
                          width: 540,
                          height: 390,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(240),
                              topRight: Radius.circular(170),
                              bottomLeft: Radius.circular(200),
                              bottomRight: Radius.circular(260),
                            ),
                            gradient: RadialGradient(
                              center: Alignment(-0.18, 0.12),
                              radius: 0.82,
                              colors: <Color>[
                                PinkallColors.pinkContainer.withValues(
                                  alpha: 0.34,
                                ),
                                PinkallColors.spectralLilac.withValues(
                                  alpha: 0.1,
                                ),
                                Colors.transparent,
                              ],
                              stops: <double>[0, 0.55, 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -250 - drift.dx * 26,
                    bottom: -270 - drift.dy * 20,
                    child: Transform.rotate(
                      angle: 0.24 - drift.dy * 0.03,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 96, sigmaY: 96),
                        child: Container(
                          width: 590,
                          height: 420,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(290),
                              topRight: Radius.circular(210),
                              bottomLeft: Radius.circular(180),
                              bottomRight: Radius.circular(260),
                            ),
                            gradient: RadialGradient(
                              center: Alignment(0.2, -0.18),
                              colors: <Color>[
                                PinkallColors.spectralPeach.withValues(
                                  alpha: 0.18,
                                ),
                                PinkallColors.pinkContainer.withValues(
                                  alpha: 0.08,
                                ),
                                Colors.transparent,
                              ],
                              stops: <double>[0, 0.62, 1],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

final class _DesktopToolbar extends StatelessWidget {
  const _DesktopToolbar({required this.accessory, this.leadingWidth});

  final Widget? accessory;
  final double? leadingWidth;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool highContrast = MediaQuery.highContrastOf(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: highContrast ? 0 : 18,
          sigmaY: highContrast ? 0 : 18,
        ),
        child: Container(
          key: const Key('pinkall_desktop_toolbar'),
          height: 56,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: highContrast ? 1 : 0.72),
            border: Border(
              bottom: BorderSide(
                color: highContrast
                    ? colors.outline
                    : colors.onSurface.withValues(alpha: 0.07),
              ),
            ),
          ),
          child: leadingWidth == null
              ? Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1280),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: <Widget>[
                          const _BrandWordmark(),
                          if (accessory != null) ...<Widget>[
                            const SizedBox(width: 16),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: accessory,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                )
              : Row(
                  children: <Widget>[
                    SizedBox(
                      width: leadingWidth,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _BrandWordmark(),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      key: const Key('pinkall_desktop_toolbar_divider'),
                      width: 1,
                      thickness: 1,
                      color: colors.outlineVariant,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: accessory ?? const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

final class _CompactToolbar extends StatelessWidget {
  const _CompactToolbar({required this.accessory});

  final Widget? accessory;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool highContrast = MediaQuery.highContrastOf(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: highContrast ? 0 : 20,
          sigmaY: highContrast ? 0 : 20,
        ),
        child: Container(
          key: const Key('pinkall_compact_toolbar'),
          height: 52,
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: highContrast ? 1 : 0.86),
            border: Border(
              bottom: BorderSide(
                color: highContrast
                    ? colors.outline
                    : colors.onSurface.withValues(alpha: 0.07),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: <Widget>[
                const _BrandWordmark(),
                if (accessory != null) ...<Widget>[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: accessory,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final class _BrandWordmark extends StatelessWidget {
  const _BrandWordmark();

  @override
  Widget build(BuildContext context) => const PinkallLockup(markSize: 20);
}
