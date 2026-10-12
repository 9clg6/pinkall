import 'package:core_presentation/theme/pinkall_colors.dart';
import 'package:flutter/material.dart';

/// Pinkall's native-first typographic system.
///
/// A null family intentionally delegates to San Francisco on Apple platforms,
/// Roboto on Android, and the host system font elsewhere. This avoids claiming
/// an unbundled brand font and preserves native metrics across devices.
abstract final class PinkallTypography {
  /// No custom family: use the platform default.
  static const String? fontFamily = null;

  /// No forced fallback chain: Flutter resolves the native system stack.
  static const List<String> fontFamilyFallback = <String>[];

  /// Compact workbench hierarchy with native optical metrics.
  static TextTheme get textTheme => TextTheme(
    displayLarge: _style(
      fontSize: 40,
      fontWeight: FontWeight.w600,
      height: 1.05,
      letterSpacing: -1.2,
    ),
    displayMedium: _style(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      height: 1.06,
      letterSpacing: -0.9,
    ),
    displaySmall: _style(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.08,
      letterSpacing: -0.65,
    ),
    headlineLarge: _style(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      height: 1.14,
      letterSpacing: -0.4,
    ),
    headlineMedium: _style(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.16,
      letterSpacing: -0.3,
    ),
    headlineSmall: _style(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.2,
    ),
    titleLarge: _style(
      fontSize: 19,
      fontWeight: FontWeight.w600,
      height: 1.24,
      letterSpacing: -0.15,
    ),
    titleMedium: _style(fontSize: 17, fontWeight: FontWeight.w600, height: 1.3),
    titleSmall: _style(fontSize: 15, fontWeight: FontWeight.w600, height: 1.3),
    bodyLarge: _style(fontSize: 16, fontWeight: FontWeight.w400, height: 1.46),
    bodyMedium: _style(fontSize: 14, fontWeight: FontWeight.w400, height: 1.45),
    bodySmall: _style(fontSize: 13, fontWeight: FontWeight.w400, height: 1.4),
    labelLarge: _style(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.05,
    ),
    labelMedium: _style(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.22,
    ),
    labelSmall: _style(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: 0.08,
    ),
  );

  static TextStyle _style({
    required double fontSize,
    required FontWeight fontWeight,
    required double height,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: PinkallColors.carbon,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
