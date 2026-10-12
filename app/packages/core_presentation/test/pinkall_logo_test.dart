import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the abstract mark and wordmark accessibly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PinkallTheme.light,
        home: const Scaffold(body: PinkallLockup()),
      ),
    );

    expect(find.byType(PinkallMark), findsOneWidget);
    expect(find.text('pinkall'), findsOneWidget);
    expect(find.bySemanticsLabel('Pinkall'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('supports a monochrome reversed mark', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ColoredBox(
          color: PinkallColors.carbon,
          child: PinkallMark(size: 32, onDarkSurface: true, monochrome: true),
        ),
      ),
    );

    final SizedBox box = tester.widget<SizedBox>(find.byType(SizedBox).last);
    expect(box.width, 32);
    expect(box.height, 32);
  });
}
