import 'package:flutter/material.dart';

/// Canonical Pinkall color palette.
///
/// The palette deliberately stays close to native porcelain surfaces. Brand
/// color is reserved for actions, focus, and live coaching rather than used as
/// decoration on every surface.
abstract final class PinkallColors {
  /// Site-aligned paper application background.
  static const Color background = Color(0xFFFFFFFF);

  /// Quiet raised paper used for primary surfaces.
  static const Color surface = Color(0xFFFAFAFA);

  /// Subtle grouped surface.
  static const Color surfaceLow = Color(0xFFF4F4F4);

  /// Selected or elevated neutral surface.
  static const Color surfaceHigh = Color(0xFFEAEAEA);

  /// Strong neutral surface used for disabled controls.
  static const Color surfaceHighest = Color(0xFFDCDCDC);

  /// Main carbon foreground.
  static const Color carbon = Color(0xFF0B0B0D);

  /// Raised carbon used to give dark call scenes subtle depth.
  static const Color carbonRaised = Color(0xFF0C0D12);

  /// Elevated carbon surface used by controls inside the call scene.
  static const Color carbonElevated = Color(0xFF11131A);

  /// Softer carbon foreground.
  static const Color carbonSoft = Color(0xFF45454B);

  /// Low-emphasis foreground that remains legible on porcelain.
  static const Color muted = Color(0xFF6F6F73);

  /// Hairline used around interactive surfaces.
  static const Color outline = Color(0x170B0B0D);

  /// Decorative separator.
  static const Color outlineVariant = Color(0x100B0B0D);

  /// Pinkall's deep site-aligned magenta.
  static const Color pink = Color(0xFFD3136C);

  /// Darker magenta for pressed states and links.
  static const Color pinkDark = Color(0xFFC31369);

  /// Pale blush used for selected and coaching surfaces.
  static const Color pinkContainer = Color(0xFFF9DCEB);

  /// Very light blush used for restrained ambient emphasis.
  static const Color pinkWash = Color(0xFFFFF2F8);

  /// Foreground placed on carbon surfaces.
  static const Color onStrong = Color(0xFFFAFAFA);

  /// Low-contrast lilac reserved for environmental light.
  static const Color spectralLilac = Color(0xFFD9C9FF);

  /// Warm peach reserved for environmental light.
  static const Color spectralPeach = Color(0xFFFFB369);

  /// Foreground placed on the magenta action color.
  static const Color onPink = onStrong;

  /// Soft pink foreground reserved for coaching details on carbon.
  static const Color pinkHighlight = Color(0xFFF199B6);

  /// Destructive call-control surface.
  static const Color callEnd = Color(0xFFCF315C);

  /// Semantic success green.
  static const Color success = Color(0xFF237A55);

  /// Semantic warning amber.
  static const Color warning = Color(0xFF9A5A13);

  /// Semantic destructive red.
  static const Color error = Color(0xFFB4234A);

  /// Background for destructive inline feedback.
  static const Color errorContainer = Color(0xFFF8DDE4);

  /// Foreground for destructive inline feedback.
  static const Color onErrorContainer = Color(0xFF4E1526);

  /// Shadow color used with low opacity by component themes.
  static const Color shadow = carbon;

  /// Compact control shadow on light and dark surfaces.
  static const Color shadowSoft = Color(0x40171519);

  /// Floating call-control shadow.
  static const Color shadowStrong = Color(0x60171519);

  /// Scrim color used behind modal surfaces.
  static const Color scrim = carbon;

  /// Translucent scrim used behind modal sheets and dialogs.
  static const Color modalBarrier = Color(0x5C29252A);

  /// Material 3 light color scheme derived from the Pinkall palette.
  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: pink,
    onPrimary: onPink,
    primaryContainer: pinkContainer,
    onPrimaryContainer: carbon,
    primaryFixed: pinkContainer,
    primaryFixedDim: pink,
    onPrimaryFixed: carbon,
    onPrimaryFixedVariant: carbonSoft,
    secondary: carbon,
    onSecondary: onStrong,
    secondaryContainer: surfaceHigh,
    onSecondaryContainer: carbon,
    secondaryFixed: surfaceHigh,
    secondaryFixedDim: outline,
    onSecondaryFixed: carbon,
    onSecondaryFixedVariant: carbonSoft,
    tertiary: carbonSoft,
    onTertiary: onStrong,
    tertiaryContainer: surfaceHigh,
    onTertiaryContainer: carbon,
    tertiaryFixed: surfaceHigh,
    tertiaryFixedDim: outline,
    onTertiaryFixed: carbon,
    onTertiaryFixedVariant: carbonSoft,
    error: error,
    onError: onStrong,
    errorContainer: errorContainer,
    onErrorContainer: onErrorContainer,
    surface: surface,
    onSurface: carbon,
    surfaceDim: surfaceHigh,
    surfaceBright: surface,
    surfaceContainerLowest: surface,
    surfaceContainerLow: background,
    surfaceContainer: surfaceLow,
    surfaceContainerHigh: surfaceHigh,
    surfaceContainerHighest: surfaceHighest,
    onSurfaceVariant: carbonSoft,
    outline: outline,
    outlineVariant: outlineVariant,
    shadow: shadow,
    scrim: scrim,
    inverseSurface: carbon,
    onInverseSurface: onStrong,
    inversePrimary: pinkContainer,
    surfaceTint: Colors.transparent,
  );
}
