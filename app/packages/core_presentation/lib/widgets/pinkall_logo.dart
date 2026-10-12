import 'package:core_presentation/theme/pinkall_colors.dart';
import 'package:flutter/material.dart';

/// Pinkall's abstract identity mark: two shifted forms around one precise cut.
///
/// The mark deliberately avoids telephony, audio, speech, and literal initials.
final class PinkallMark extends StatelessWidget {
  /// Creates the Pinkall identity mark.
  const PinkallMark({
    this.size = 24,
    this.onDarkSurface = false,
    this.monochrome = false,
    super.key,
  });

  /// Width and height of the square mark.
  final double size;

  /// Uses the reversed porcelain version on carbon surfaces.
  final bool onDarkSurface;

  /// Removes the pink core while preserving its negative-space cut.
  final bool monochrome;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: 'Pinkall',
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _PinkallMarkPainter(
          massColor: onDarkSurface
              ? PinkallColors.onStrong
              : PinkallColors.carbon,
          coreColor: monochrome ? Colors.transparent : PinkallColors.pink,
        ),
      ),
    ),
  );
}

/// The complete Pinkall mark and wordmark lockup.
final class PinkallLockup extends StatelessWidget {
  /// Creates the horizontal identity lockup.
  const PinkallLockup({
    this.markSize = 22,
    this.onDarkSurface = false,
    super.key,
  });

  /// Size of the symbol before the wordmark.
  final double markSize;

  /// Uses the reversed wordmark and symbol.
  final bool onDarkSurface;

  @override
  Widget build(BuildContext context) {
    final Color foreground = onDarkSurface
        ? PinkallColors.onStrong
        : PinkallColors.carbon;
    return Semantics(
      image: true,
      label: 'Pinkall',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            PinkallMark(size: markSize, onDarkSurface: onDarkSurface),
            SizedBox(width: markSize * 0.42),
            Text(
              'pinkall',
              maxLines: 1,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.65,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _PinkallMarkPainter extends CustomPainter {
  const _PinkallMarkPainter({required this.massColor, required this.coreColor});

  final Color massColor;
  final Color coreColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Path core = Path()
      ..moveTo(width * 0.20, height * 0.50)
      ..lineTo(width * 0.80, height * 0.40)
      ..lineTo(width * 0.82, height * 0.49)
      ..lineTo(width * 0.22, height * 0.59)
      ..close();

    final Path upperMass = Path()
      ..moveTo(width * 0.28, height * 0.10)
      ..lineTo(width * 0.76, height * 0.10)
      ..cubicTo(
        width * 0.84,
        height * 0.10,
        width * 0.90,
        height * 0.16,
        width * 0.90,
        height * 0.24,
      )
      ..lineTo(width * 0.90, height * 0.38)
      ..lineTo(width * 0.80, height * 0.40)
      ..lineTo(width * 0.20, height * 0.50)
      ..lineTo(width * 0.20, height * 0.24)
      ..cubicTo(
        width * 0.20,
        height * 0.16,
        width * 0.22,
        height * 0.10,
        width * 0.28,
        height * 0.10,
      )
      ..close();

    final Path lowerMass = Path()
      ..moveTo(width * 0.08, height * 0.64)
      ..lineTo(width * 0.22, height * 0.59)
      ..lineTo(width * 0.82, height * 0.49)
      ..lineTo(width * 0.82, height * 0.76)
      ..cubicTo(
        width * 0.82,
        height * 0.84,
        width * 0.76,
        height * 0.90,
        width * 0.68,
        height * 0.90,
      )
      ..lineTo(width * 0.22, height * 0.90)
      ..cubicTo(
        width * 0.14,
        height * 0.90,
        width * 0.08,
        height * 0.84,
        width * 0.08,
        height * 0.76,
      )
      ..close();

    if (coreColor.a > 0) {
      canvas.drawPath(core, Paint()..color = coreColor);
    }
    final Paint massPaint = Paint()..color = massColor;
    canvas.drawPath(upperMass, massPaint);
    canvas.drawPath(lowerMass, massPaint);
  }

  @override
  bool shouldRepaint(covariant _PinkallMarkPainter oldDelegate) =>
      oldDelegate.massColor != massColor || oldDelegate.coreColor != coreColor;
}
