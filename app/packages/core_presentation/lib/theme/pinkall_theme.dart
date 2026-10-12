// Hallmark · pre-emit critique: P5 H4 E4 S5 R5 V5
// Hallmark · modern-minimal workbench · studied-DNA: Amplemarket + Jeton
import 'package:core_presentation/theme/pinkall_colors.dart';
import 'package:core_presentation/theme/pinkall_theme_tokens.dart';
import 'package:core_presentation/theme/pinkall_typography.dart';
import 'package:flutter/material.dart';

/// Application themes supplied by the Pinkall design system.
abstract final class PinkallTheme {
  /// Native-first Material 3 light theme for iOS, Android, and macOS.
  static ThemeData get light => _lightTheme;

  static final ThemeData _lightTheme = _buildLightTheme();

  static ThemeData _buildLightTheme() {
    const ColorScheme colorScheme = PinkallColors.lightColorScheme;
    final TextTheme textTheme = PinkallTypography.textTheme;
    const PinkallThemeTokens tokens = PinkallThemeTokens.light;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      extensions: const <ThemeExtension<dynamic>>[tokens],
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      scaffoldBackgroundColor: PinkallColors.background,
      canvasColor: PinkallColors.background,
      cardColor: PinkallColors.surface,
      dividerColor: PinkallColors.outline,
      disabledColor: PinkallColors.carbon.withValues(alpha: 0.38),
      focusColor: PinkallColors.pink.withValues(alpha: 0.18),
      highlightColor: PinkallColors.pink.withValues(alpha: 0.07),
      hoverColor: PinkallColors.carbon.withValues(alpha: 0.045),
      shadowColor: PinkallColors.shadow.withValues(alpha: 0.1),
      splashColor: PinkallColors.pink.withValues(alpha: 0.1),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarThemeData(
        backgroundColor: PinkallColors.background,
        foregroundColor: PinkallColors.carbon,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 54,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: PinkallColors.surface,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: PinkallColors.surface,
        modalBarrierColor: PinkallColors.modalBarrier,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showDragHandle: true,
      ),
      cardTheme: const CardThemeData(
        color: PinkallColors.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: PinkallColors.shadow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: PinkallColors.outlineVariant),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: PinkallColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shadowColor: PinkallColors.shadow.withValues(alpha: 0.12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyLarge,
      ),
      dividerTheme: const DividerThemeData(
        color: PinkallColors.outline,
        space: 1,
        thickness: 1,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          animationDuration: tokens.durationFast,
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            _primaryButtonBackground,
          ),
          foregroundColor: const WidgetStatePropertyAll<Color>(
            PinkallColors.onPink,
          ),
          overlayColor: WidgetStatePropertyAll<Color>(
            PinkallColors.carbon.withValues(alpha: 0.08),
          ),
          minimumSize: const WidgetStatePropertyAll<Size>(Size(50, 50)),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.labelLarge),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          animationDuration: tokens.durationFast,
          foregroundColor: const WidgetStatePropertyAll<Color>(
            PinkallColors.carbon,
          ),
          overlayColor: WidgetStatePropertyAll<Color>(
            PinkallColors.pink.withValues(alpha: 0.08),
          ),
          minimumSize: const WidgetStatePropertyAll<Size>(Size(50, 50)),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          side: const WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: PinkallColors.outline),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.labelLarge),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          animationDuration: tokens.durationFast,
          foregroundColor: const WidgetStatePropertyAll<Color>(
            PinkallColors.pink,
          ),
          overlayColor: WidgetStatePropertyAll<Color>(
            PinkallColors.pink.withValues(alpha: 0.08),
          ),
          minimumSize: const WidgetStatePropertyAll<Size>(Size(48, 48)),
          padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.labelLarge),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          animationDuration: tokens.durationFast,
          foregroundColor: const WidgetStatePropertyAll<Color>(
            PinkallColors.carbon,
          ),
          overlayColor: WidgetStatePropertyAll<Color>(
            PinkallColors.pink.withValues(alpha: 0.08),
          ),
          minimumSize: const WidgetStatePropertyAll<Size>(Size.square(48)),
          iconSize: const WidgetStatePropertyAll<double>(22),
          shape: const WidgetStatePropertyAll<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: false,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 13),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: PinkallColors.carbonSoft,
        ),
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(
          color: PinkallColors.pink,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: PinkallColors.muted),
        helperStyle: textTheme.bodySmall?.copyWith(color: PinkallColors.muted),
        errorStyle: textTheme.bodySmall?.copyWith(
          color: PinkallColors.pinkDark,
          fontWeight: FontWeight.w600,
        ),
        border: _inputBorder(PinkallColors.outline),
        enabledBorder: _inputBorder(PinkallColors.outline),
        focusedBorder: _inputBorder(PinkallColors.carbon),
        errorBorder: _inputBorder(PinkallColors.pinkDark),
        focusedErrorBorder: _inputBorder(PinkallColors.pinkDark),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          _selectedControlFill,
        ),
        checkColor: const WidgetStatePropertyAll<Color>(PinkallColors.onStrong),
        side: const BorderSide(color: PinkallColors.outline, width: 1.5),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>(
          _selectedControlFill,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>(_switchThumb),
        trackColor: WidgetStateProperty.resolveWith<Color>(_switchTrack),
        trackOutlineColor: const WidgetStatePropertyAll<Color>(
          Colors.transparent,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          animationDuration: tokens.durationStandard,
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            _segmentedBackground,
          ),
          foregroundColor: const WidgetStatePropertyAll<Color>(
            PinkallColors.carbon,
          ),
          overlayColor: WidgetStatePropertyAll<Color>(
            PinkallColors.pink.withValues(alpha: 0.08),
          ),
          minimumSize: const WidgetStatePropertyAll<Size>(Size(48, 48)),
          side: const WidgetStatePropertyAll<BorderSide>(
            BorderSide(color: PinkallColors.outline),
          ),
          textStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.labelLarge),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: PinkallColors.surfaceLow,
        selectedColor: PinkallColors.pinkContainer,
        disabledColor: PinkallColors.surfaceHigh,
        side: const BorderSide(color: PinkallColors.outline),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        showCheckmark: true,
        checkmarkColor: PinkallColors.pink,
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: PinkallColors.outline,
        indicatorColor: PinkallColors.pink,
        labelColor: PinkallColors.carbon,
        unselectedLabelColor: PinkallColors.muted,
        labelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge,
        overlayColor: WidgetStatePropertyAll<Color>(
          PinkallColors.pink.withValues(alpha: 0.08),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PinkallColors.carbon,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: PinkallColors.background,
        ),
        actionTextColor: PinkallColors.pinkContainer,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: PinkallColors.pink,
        linearTrackColor: PinkallColors.surfaceHigh,
        circularTrackColor: PinkallColors.surfaceHigh,
      ),
      scrollbarTheme: const ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll<Color>(PinkallColors.outline),
        trackColor: WidgetStatePropertyAll<Color>(Colors.transparent),
        thickness: WidgetStatePropertyAll<double>(6),
        radius: Radius.circular(3),
        interactive: true,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: PinkallColors.pink,
        selectionColor: PinkallColors.pinkContainer,
        selectionHandleColor: PinkallColors.pink,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: const BoxDecoration(
          color: PinkallColors.carbon,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        textStyle: textTheme.labelMedium?.copyWith(
          color: PinkallColors.background,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        waitDuration: const Duration(milliseconds: 900),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: PinkallColors.background,
        indicatorColor: Colors.transparent,
        useIndicator: false,
        selectedIconTheme: const IconThemeData(
          color: PinkallColors.carbon,
          size: 22,
        ),
        unselectedIconTheme: IconThemeData(
          color: PinkallColors.muted,
          size: 22,
        ),
        selectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: PinkallColors.carbon,
        ),
        unselectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          color: PinkallColors.muted,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 62,
        elevation: 0,
        backgroundColor: PinkallColors.surface,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll<TextStyle?>(
          textTheme.labelSmall,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 1,
        highlightElevation: 0,
        backgroundColor: PinkallColors.carbon,
        foregroundColor: PinkallColors.onStrong,
        shape: CircleBorder(),
      ),
      listTileTheme: const ListTileThemeData(
        iconColor: PinkallColors.carbonSoft,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }

  static Color _primaryButtonBackground(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return PinkallColors.carbon.withValues(alpha: 0.32);
    }
    if (states.contains(WidgetState.pressed) ||
        states.contains(WidgetState.hovered)) {
      return PinkallColors.carbonSoft;
    }
    return PinkallColors.carbon;
  }

  static Color? _selectedControlFill(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return PinkallColors.surfaceHighest;
    }
    if (states.contains(WidgetState.selected)) {
      return PinkallColors.pink;
    }
    return null;
  }

  static Color _switchThumb(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return PinkallColors.onStrong;
    }
    return PinkallColors.carbonSoft;
  }

  static Color _switchTrack(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return PinkallColors.pink;
    }
    return PinkallColors.surfaceHigh;
  }

  static Color _segmentedBackground(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return PinkallColors.pinkContainer;
    }
    return PinkallColors.surface;
  }

  static UnderlineInputBorder _inputBorder(Color color) {
    return UnderlineInputBorder(borderSide: BorderSide(color: color));
  }
}
