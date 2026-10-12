import 'dart:ui' show lerpDouble;

import 'package:core_presentation/theme/pinkall_colors.dart';
import 'package:flutter/material.dart';

/// Pinkall tokens that are not represented directly by [ColorScheme].
///
/// Retrieve the values through
/// `Theme.of(context).extension<PinkallThemeTokens>()` so widgets stay aligned
/// with the active theme.
@immutable
final class PinkallThemeTokens extends ThemeExtension<PinkallThemeTokens> {
  /// Creates a complete set of Pinkall design tokens.
  const PinkallThemeTokens({
    required this.primaryHover,
    required this.primaryWash,
    required this.mutedText,
    required this.spaceExtraSmall,
    required this.spaceSmall,
    required this.spaceMedium,
    required this.spaceLarge,
    required this.spaceExtraLarge,
    required this.space2ExtraLarge,
    required this.space3ExtraLarge,
    required this.controlRadius,
    required this.panelRadius,
    required this.dialogRadius,
    required this.minimumInteractiveDimension,
    required this.durationFast,
    required this.durationStandard,
    required this.durationEmphasis,
  });

  /// Tokens for the Pinkall light theme.
  static const PinkallThemeTokens light = PinkallThemeTokens(
    primaryHover: PinkallColors.pinkDark,
    primaryWash: PinkallColors.pinkWash,
    mutedText: PinkallColors.muted,
    spaceExtraSmall: 4,
    spaceSmall: 8,
    spaceMedium: 16,
    spaceLarge: 24,
    spaceExtraLarge: 32,
    space2ExtraLarge: 48,
    space3ExtraLarge: 64,
    controlRadius: 10,
    panelRadius: 16,
    dialogRadius: 18,
    minimumInteractiveDimension: 48,
    durationFast: Duration(milliseconds: 140),
    durationStandard: Duration(milliseconds: 240),
    durationEmphasis: Duration(milliseconds: 360),
  );

  /// Pink used when a primary control is hovered or pressed.
  final Color primaryHover;

  /// Restrained pink surface used for ambient brand emphasis.
  final Color primaryWash;

  /// Accessible low-emphasis text color.
  final Color mutedText;

  /// Four logical pixels of spacing.
  final double spaceExtraSmall;

  /// Eight logical pixels of spacing.
  final double spaceSmall;

  /// Sixteen logical pixels of spacing.
  final double spaceMedium;

  /// Twenty-four logical pixels of spacing.
  final double spaceLarge;

  /// Thirty-two logical pixels of spacing.
  final double spaceExtraLarge;

  /// Forty-eight logical pixels of spacing.
  final double space2ExtraLarge;

  /// Sixty-four logical pixels of spacing.
  final double space3ExtraLarge;

  /// Corner radius for inputs and controls.
  final double controlRadius;

  /// Corner radius for cards and content panels.
  final double panelRadius;

  /// Corner radius for dialogs and emphasis panels.
  final double dialogRadius;

  /// Minimum mobile interaction target in logical pixels.
  final double minimumInteractiveDimension;

  /// Duration for direct hover, focus, and pressed feedback.
  final Duration durationFast;

  /// Duration for ordinary state changes.
  final Duration durationStandard;

  /// Duration for route-level or dialog emphasis.
  final Duration durationEmphasis;

  @override
  PinkallThemeTokens copyWith({
    Color? primaryHover,
    Color? primaryWash,
    Color? mutedText,
    double? spaceExtraSmall,
    double? spaceSmall,
    double? spaceMedium,
    double? spaceLarge,
    double? spaceExtraLarge,
    double? space2ExtraLarge,
    double? space3ExtraLarge,
    double? controlRadius,
    double? panelRadius,
    double? dialogRadius,
    double? minimumInteractiveDimension,
    Duration? durationFast,
    Duration? durationStandard,
    Duration? durationEmphasis,
  }) {
    return PinkallThemeTokens(
      primaryHover: primaryHover ?? this.primaryHover,
      primaryWash: primaryWash ?? this.primaryWash,
      mutedText: mutedText ?? this.mutedText,
      spaceExtraSmall: spaceExtraSmall ?? this.spaceExtraSmall,
      spaceSmall: spaceSmall ?? this.spaceSmall,
      spaceMedium: spaceMedium ?? this.spaceMedium,
      spaceLarge: spaceLarge ?? this.spaceLarge,
      spaceExtraLarge: spaceExtraLarge ?? this.spaceExtraLarge,
      space2ExtraLarge: space2ExtraLarge ?? this.space2ExtraLarge,
      space3ExtraLarge: space3ExtraLarge ?? this.space3ExtraLarge,
      controlRadius: controlRadius ?? this.controlRadius,
      panelRadius: panelRadius ?? this.panelRadius,
      dialogRadius: dialogRadius ?? this.dialogRadius,
      minimumInteractiveDimension:
          minimumInteractiveDimension ?? this.minimumInteractiveDimension,
      durationFast: durationFast ?? this.durationFast,
      durationStandard: durationStandard ?? this.durationStandard,
      durationEmphasis: durationEmphasis ?? this.durationEmphasis,
    );
  }

  @override
  PinkallThemeTokens lerp(
    covariant ThemeExtension<PinkallThemeTokens>? other,
    double t,
  ) {
    if (other is! PinkallThemeTokens) {
      return this;
    }

    return PinkallThemeTokens(
      primaryHover: Color.lerp(primaryHover, other.primaryHover, t)!,
      primaryWash: Color.lerp(primaryWash, other.primaryWash, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      spaceExtraSmall: lerpDouble(spaceExtraSmall, other.spaceExtraSmall, t)!,
      spaceSmall: lerpDouble(spaceSmall, other.spaceSmall, t)!,
      spaceMedium: lerpDouble(spaceMedium, other.spaceMedium, t)!,
      spaceLarge: lerpDouble(spaceLarge, other.spaceLarge, t)!,
      spaceExtraLarge: lerpDouble(spaceExtraLarge, other.spaceExtraLarge, t)!,
      space2ExtraLarge: lerpDouble(
        space2ExtraLarge,
        other.space2ExtraLarge,
        t,
      )!,
      space3ExtraLarge: lerpDouble(
        space3ExtraLarge,
        other.space3ExtraLarge,
        t,
      )!,
      controlRadius: lerpDouble(controlRadius, other.controlRadius, t)!,
      panelRadius: lerpDouble(panelRadius, other.panelRadius, t)!,
      dialogRadius: lerpDouble(dialogRadius, other.dialogRadius, t)!,
      minimumInteractiveDimension: lerpDouble(
        minimumInteractiveDimension,
        other.minimumInteractiveDimension,
        t,
      )!,
      durationFast: _lerpDuration(durationFast, other.durationFast, t),
      durationStandard: _lerpDuration(
        durationStandard,
        other.durationStandard,
        t,
      ),
      durationEmphasis: _lerpDuration(
        durationEmphasis,
        other.durationEmphasis,
        t,
      ),
    );
  }

  static Duration _lerpDuration(Duration start, Duration end, double t) {
    return Duration(
      microseconds: lerpDouble(
        start.inMicroseconds,
        end.inMicroseconds,
        t,
      )!.round(),
    );
  }
}
