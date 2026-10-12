import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light theme exposes the accessible Pinkall design system', () {
    final ThemeData theme = PinkallTheme.light;
    final PinkallThemeTokens? tokens = theme.extension<PinkallThemeTokens>();

    expect(theme.useMaterial3, isTrue);
    expect(theme.brightness, Brightness.light);
    expect(theme.colorScheme, PinkallColors.lightColorScheme);
    expect(theme.scaffoldBackgroundColor, PinkallColors.background);
    expect(PinkallColors.background, const Color(0xFFFFFFFF));
    expect(PinkallColors.carbon, const Color(0xFF0B0B0D));
    expect(PinkallColors.pink, const Color(0xFFD3136C));
    expect(theme.textTheme.bodyLarge?.fontFamily, isNot('Onest'));
    expect(tokens, isNotNull);
    expect(tokens?.minimumInteractiveDimension, 48);
    expect(tokens?.controlRadius, 10);
    expect(theme.inputDecorationTheme.filled, isFalse);
    expect(
      theme.filledButtonTheme.style?.backgroundColor?.resolve(
        const <WidgetState>{},
      ),
      PinkallColors.carbon,
    );
    expect(
      _contrastRatio(theme.colorScheme.primary, theme.colorScheme.onPrimary),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      _contrastRatio(
        theme.colorScheme.onSurface,
        theme.scaffoldBackgroundColor,
      ),
      greaterThanOrEqualTo(4.5),
    );
  });

  testWidgets('filled buttons inherit an accessible interaction target', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PinkallTheme.light,
        home: Scaffold(
          body: Center(
            child: FilledButton(onPressed: () {}, child: const Text('Call')),
          ),
        ),
      ),
    );

    final Size buttonSize = tester.getSize(find.byType(FilledButton));
    expect(buttonSize.height, greaterThanOrEqualTo(48));
    expect(buttonSize.width, greaterThanOrEqualTo(48));
  });
}

double _contrastRatio(Color foreground, Color background) {
  final double foregroundLuminance = foreground.computeLuminance();
  final double backgroundLuminance = background.computeLuminance();
  final double lighter = foregroundLuminance > backgroundLuminance
      ? foregroundLuminance
      : backgroundLuminance;
  final double darker = foregroundLuminance > backgroundLuminance
      ? backgroundLuminance
      : foregroundLuminance;

  return (lighter + 0.05) / (darker + 0.05);
}
