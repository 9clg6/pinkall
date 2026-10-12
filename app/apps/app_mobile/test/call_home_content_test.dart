import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/features/calls/presentation/screens/home/call_home.state.dart';
import 'package:pinkall/features/calls/presentation/screens/home/widgets/call_home_content.widget.dart';
import 'package:pinkall/generated/locale_keys.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('ready dialer stays fluid on narrow and short windows', (
    WidgetTester tester,
  ) async {
    int disconnectCount = 0;

    await _pumpReadyDialer(
      tester,
      size: const Size(320, 844),
      onDisconnect: () async => disconnectCount += 1,
    );

    expect(tester.takeException(), isNull);
    expect(find.text(LocaleKeys.telnyx_status_ready), findsOneWidget);
    expect(find.byKey(const Key('dialer_call_button')), findsOneWidget);
    expect(find.byType(Card), findsNothing);
    expect(
      tester.getTopLeft(find.byKey(const Key('dialer_call_button'))).dy,
      greaterThan(
        tester.getBottomLeft(find.byKey(const Key('dialer_keypad'))).dy,
      ),
    );

    await tester.tap(find.byIcon(Icons.power_settings_new_rounded));
    await tester.pump();
    expect(disconnectCount, 1);

    const Size windowSize = Size(800, 632);
    tester.view.physicalSize = windowSize;
    await tester.pumpAndSettle();

    final Rect actionRect = tester.getRect(
      find.byKey(const Key('dialer_call_button')),
    );
    final Rect lastKeyRect = tester.getRect(find.text('#'));

    expect(tester.takeException(), isNull);
    expect(actionRect.top, greaterThanOrEqualTo(0));
    expect(actionRect.top, greaterThan(lastKeyRect.bottom));
    expect(actionRect.bottom, lessThanOrEqualTo(windowSize.height));
    expect(lastKeyRect.bottom, lessThanOrEqualTo(windowSize.height));
  });

  testWidgets('a real selected contact fills the compact dialer', (
    WidgetTester tester,
  ) async {
    int openContactsCount = 0;
    final DateTime now = DateTime(2026, 7, 12);
    final ContactEntity contact = ContactEntity(
      id: 'contact-real-1',
      phoneNumber: '+33611223344',
      market: ContactMarket.b2b,
      createdAt: now,
      updatedAt: now,
      firstName: 'Maya',
      lastName: 'Chen',
      company: 'Northstar',
    );

    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: PinkallTheme.light,
        home: Scaffold(
          body: CallHomeContent(
            state: CallHomeState.initial().copyWith(
              connection: const TelnyxConnectionStateEntity(
                status: TelnyxConnectionStatus.ready,
              ),
            ),
            selectedContact: contact,
            onOpenContacts: () => openContactsCount += 1,
            onConnect: (_) async {},
            onConnectAutomatically: () async {},
            onDisconnect: () async {},
            onDial: (_, _) async {},
            onAnswer: (_) async {},
            onDecline: (_) async {},
            onRefreshIncomingCallCapability: () async {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final TextFormField field = tester.widget<TextFormField>(
      find.byKey(const Key('dialer_destination_field')),
    );
    expect(field.controller?.text, contact.phoneNumber);
    expect(find.text('Maya Chen · Northstar'), findsOneWidget);
    expect(find.byKey(const Key('open_contacts_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('open_contacts_button')));
    await tester.pump();
    expect(openContactsCount, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a deep link prefills the dialer without placing a call', (
    WidgetTester tester,
  ) async {
    int dialCount = 0;

    await _pumpReadyDialer(
      tester,
      size: const Size(390, 844),
      initialPhoneNumber: '06 12 34 56 78',
      onDisconnect: () async {},
      onDial: (_, _) async => dialCount += 1,
    );

    final TextFormField destinationField = tester.widget<TextFormField>(
      find.byKey(const Key('dialer_destination_field')),
    );
    expect(destinationField.controller?.text, '+33612345678');
    expect(dialCount, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an identical deep link is reapplied as a new request', (
    WidgetTester tester,
  ) async {
    await _pumpReadyDialer(
      tester,
      size: const Size(390, 844),
      initialPhoneNumber: '+33612345678',
      deepLinkRequestId: 1,
      onDisconnect: () async {},
    );
    final Finder destinationField = find.byKey(
      const Key('dialer_destination_field'),
    );
    await tester.enterText(destinationField, '+33700000000');

    await _pumpReadyDialer(
      tester,
      size: const Size(390, 844),
      initialPhoneNumber: '+33612345678',
      deepLinkRequestId: 2,
      onDisconnect: () async {},
    );

    expect(
      tester.widget<TextFormField>(destinationField).controller?.text,
      '+33612345678',
    );
  });

  testWidgets('attaches an editable Markdown briefing to the next call', (
    WidgetTester tester,
  ) async {
    String? dialedDestination;
    String? dialedPreparation;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: PinkallTheme.light,
        home: Scaffold(
          body: CallHomeContent(
            state: CallHomeState.initial().copyWith(
              connection: const TelnyxConnectionStateEntity(
                status: TelnyxConnectionStatus.ready,
              ),
            ),
            onConnect: (_) async {},
            onConnectAutomatically: () async {},
            onDisconnect: () async {},
            onDial: (String destination, String? preparationMarkdown) async {
              dialedDestination = destination;
              dialedPreparation = preparationMarkdown;
            },
            onAnswer: (_) async {},
            onDecline: (_) async {},
            onRefreshIncomingCallCapability: () async {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Finder preparationButton = find.byKey(
      const Key('dialer_preparation_button'),
    );
    await tester.ensureVisible(preparationButton);
    await tester.tap(preparationButton);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('call_preparation_sheet')), findsOneWidget);
    const String briefing =
        '# Objectif\nObtenir un rendez-vous de découverte.\n\n'
        '# À explorer\n- Le coût du problème';
    await tester.enterText(
      find.byKey(const Key('preparation_markdown_field')),
      briefing,
    );
    await tester.tap(find.byKey(const Key('preparation_save_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('call_preparation_sheet')), findsNothing);
    final Finder destinationField = find.byKey(
      const Key('dialer_destination_field'),
    );
    await tester.enterText(destinationField, '+33612345678');
    final Finder callButton = find.byKey(const Key('dialer_call_button'));
    await tester.ensureVisible(callButton);
    await tester.tap(callButton);
    await tester.pump();

    expect(dialedDestination, '+33612345678');
    expect(dialedPreparation, briefing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dials a French 06 input as E.164', (WidgetTester tester) async {
    String? dialedDestination;
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: PinkallTheme.light,
        home: Scaffold(
          body: CallHomeContent(
            state: CallHomeState.initial().copyWith(
              connection: const TelnyxConnectionStateEntity(
                status: TelnyxConnectionStatus.ready,
              ),
            ),
            onConnect: (_) async {},
            onConnectAutomatically: () async {},
            onDisconnect: () async {},
            onDial: (String destination, String? preparationMarkdown) async {
              dialedDestination = destination;
            },
            onAnswer: (_) async {},
            onDecline: (_) async {},
            onRefreshIncomingCallCapability: () async {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('dialer_destination_field')),
      '06 49 45 23 25',
    );
    final Finder callButton = find.byKey(const Key('dialer_call_button'));
    await tester.ensureVisible(callButton);
    await tester.tap(callButton);
    await tester.pump();

    expect(dialedDestination, '+33649452325');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Android background delivery never impersonates a finished UI', (
    WidgetTester tester,
  ) async {
    await _pumpReadyDialer(
      tester,
      size: const Size(390, 844),
      onDisconnect: () async {},
      capability: const IncomingCallCapabilityEntity(
        status: IncomingCallCapabilityStatus.configurationRequired,
        platform: IncomingCallPlatform.android,
        transport: IncomingCallTransport.fcm,
        tokenAvailable: true,
        backgroundDeliveryReady: true,
        nativeCallUiReady: false,
        missingRequirements: <String>['android_incoming_call_notification_ui'],
      ),
    );

    final Finder panel = find.byKey(
      const Key('incoming_call_capability_panel'),
    );
    expect(panel, findsOneWidget);
    final List<String> labels = tester
        .widgetList<Text>(
          find.descendant(of: panel, matching: find.byType(Text)),
        )
        .map<String?>((Text text) => text.data)
        .whereType<String>()
        .toList(growable: false);
    expect(
      labels.any(
        (String value) =>
            value == LocaleKeys.incoming_calls_body_android_ui_pending ||
            value.contains(RegExp('Android|android')),
      ),
      isTrue,
      reason: 'Rendered capability labels: $labels',
    );
    expect(labels, isNot(contains('Appels entrants en arrière-plan prêts')));
  });
}

Future<void> _pumpReadyDialer(
  WidgetTester tester, {
  required Size size,
  required Future<void> Function() onDisconnect,
  Future<void> Function(String destination, String? preparationMarkdown)?
  onDial,
  String? initialPhoneNumber,
  int? deepLinkRequestId,
  IncomingCallCapabilityEntity? capability,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: PinkallTheme.light,
      locale: const Locale('fr'),
      home: Scaffold(
        body: CallHomeContent(
          initialPhoneNumber: initialPhoneNumber,
          deepLinkRequestId: deepLinkRequestId,
          state: CallHomeState.initial().copyWith(
            connection: const TelnyxConnectionStateEntity(
              status: TelnyxConnectionStatus.ready,
            ),
            incomingCallCapability:
                capability ??
                const IncomingCallCapabilityEntity(
                  status: IncomingCallCapabilityStatus.disabled,
                  platform: IncomingCallPlatform.macos,
                  transport: IncomingCallTransport.none,
                  tokenAvailable: false,
                  backgroundDeliveryReady: false,
                  nativeCallUiReady: false,
                  missingRequirements: <String>['native_adapter_unavailable'],
                ),
          ),
          onConnect: (_) async {},
          onConnectAutomatically: () async {},
          onDisconnect: onDisconnect,
          onDial: onDial ?? (_, _) async {},
          onAnswer: (_) async {},
          onDecline: (_) async {},
          onRefreshIncomingCallCapability: () async {},
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
