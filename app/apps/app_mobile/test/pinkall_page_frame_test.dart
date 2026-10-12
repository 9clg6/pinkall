import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/features/shared/presentation/widgets/pinkall_page_frame.widget.dart';

void main() {
  testWidgets('compact shell keeps phone and contacts in one workspace', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: PinkallTheme.light,
        home: Scaffold(
          body: PinkallPageFrame(child: const Center(child: Text('Téléphone'))),
        ),
      ),
    );

    expect(find.byKey(const Key('pinkall_compact_toolbar')), findsOneWidget);
    expect(find.byKey(const Key('pinkall_workbench_grid')), findsOneWidget);
    expect(find.text('Appeler'), findsNothing);
    expect(find.text('Contacts'), findsNothing);
    expect(find.text('Téléphone'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide shell uses one continuous toolbar without destinations', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 820);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: PinkallTheme.light,
        home: const Scaffold(
          body: PinkallPageFrame(child: Center(child: Text('CRM'))),
        ),
      ),
    );

    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byKey(const Key('pinkall_desktop_toolbar')), findsOneWidget);
    expect(find.byKey(const Key('pinkall_workbench_grid')), findsOneWidget);
    expect(find.text('Appeler'), findsNothing);
    expect(find.text('Contacts'), findsNothing);
    expect(find.text('CRM'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop toolbar follows the leading workspace rail', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 820);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: PinkallTheme.light,
        home: const Scaffold(
          body: PinkallPageFrame(
            desktopLeadingWidth: 304,
            accessory: SizedBox(
              key: Key('toolbar_accessory'),
              width: 120,
              height: 32,
            ),
            child: SizedBox.expand(),
          ),
        ),
      ),
    );

    final Rect divider = tester.getRect(
      find.byKey(const Key('pinkall_desktop_toolbar_divider')),
    );
    final Rect accessory = tester.getRect(
      find.byKey(const Key('toolbar_accessory')),
    );

    expect(divider.left, 304);
    expect(accessory.left, greaterThanOrEqualTo(337));
    expect(tester.takeException(), isNull);
  });
}
