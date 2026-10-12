import 'dart:async';
import 'dart:convert';

import 'package:core_domain/core_domain.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/config/pinkall_backend_configuration.dart';
import 'package:pinkall/core/providers/core/repositories/call.repository.provider.dart';
import 'package:pinkall/core/providers/core/repositories/workspace_sales_context.repository.provider.dart';
import 'package:pinkall/core/providers/data/endpoint/audio_device.client.provider.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/foundation/routing/app_router.dart';
import 'package:pinkall/presentation/pinkall_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _TestAssetLoader assetLoader;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await EasyLocalization.ensureInitialized();
    assetLoader = _TestAssetLoader(<String, Map<String, dynamic>>{
      'fr':
          jsonDecode(await rootBundle.loadString('assets/translations/fr.json'))
              as Map<String, dynamic>,
      'en':
          jsonDecode(await rootBundle.loadString('assets/translations/en.json'))
              as Map<String, dynamic>,
    });
  });

  setUp(() => SharedPreferences.setMockInitialValues(<String, Object>{}));

  testWidgets(
    'creates the correlated backend session before Telnyx and renders live data',
    (WidgetTester tester) async {
      final List<String> operationOrder = <String>[];
      final _TestCallRepository calls = _TestCallRepository(operationOrder);
      final _TestConversationSessionRepository sessions =
          _TestConversationSessionRepository(operationOrder);
      addTearDown(calls.dispose);
      addTearDown(sessions.dispose);
      await _pumpPinkall(
        tester,
        calls: calls,
        sessions: sessions,
        assetLoader: assetLoader,
      );

      expect(find.byType(Switch), findsNothing);
      expect(find.byKey(const Key('open_contacts_button')), findsOneWidget);
      expect(find.byKey(const Key('open_call_history_button')), findsOneWidget);
      await tester.tap(find.byKey(const Key('open_call_history_button')));
      await tester.pumpAndSettle();
      expect(find.text('Historique'), findsOneWidget);
      expect(find.text('Aucun appel pour l’instant'), findsOneWidget);
      await tester.tap(find.byKey(const Key('history_back_button')));
      await tester.pumpAndSettle();
      await _expectAutoConnected(tester, calls);

      final Finder destinationField = find.byKey(
        const Key('dialer_destination_field'),
      );
      await tester.ensureVisible(destinationField);
      await tester.enterText(destinationField, '+33612345678');
      const String preparationMarkdown =
          '# Objectif\nQualifier le besoin et obtenir un prochain échange.';
      final Finder preparationButton = find.byKey(
        const Key('dialer_preparation_button'),
      );
      await tester.ensureVisible(preparationButton);
      await tester.tap(preparationButton);
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('preparation_markdown_field')),
        preparationMarkdown,
      );
      await tester.tap(find.byKey(const Key('preparation_save_button')));
      await tester.pumpAndSettle();
      final Finder dialButton = find.byKey(const Key('dialer_call_button'));
      await tester.ensureVisible(dialButton);
      await tester.tap(dialButton);
      await tester.pumpAndSettle();

      expect(find.text('Vérifier avant d’appeler'), findsOneWidget);
      final FilledButton verifyButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Vérifier et appeler'),
      );
      expect(verifyButton.onPressed, isNull);

      await tester.tap(find.byType(DropdownButtonFormField<ContactMarket>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B2C · particulier').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Vérifier et appeler'));
      await tester.pumpAndSettle();

      expect(calls.dialAttempts, 0);
      expect(operationOrder, isEmpty);
      expect(
        find.textContaining(
          'consentement ou relation contractuelle B2C manquant',
        ),
        findsOneWidget,
      );

      await tester.ensureVisible(dialButton);
      await tester.tap(dialButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<ContactMarket>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B2B · contact professionnel').last);
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('L’offre est pertinente pour son activité professionnelle'),
      );
      await tester.tap(find.text('Vérifier et appeler'));
      await _pumpAnimatedCallState(tester);

      expect(operationOrder.take(2), <String>['create-session', 'dial-telnyx']);
      final Map<String, dynamic> clientState =
          jsonDecode(calls.lastClientState) as Map<String, dynamic>;
      expect(clientState['pinkall_session_id'], sessions.session.id);
      expect(clientState['correlation_id'], sessions.createdCorrelationId);
      expect(sessions.createdCorrelationId, isNot('test-call'));
      expect(sessions.createdPreparationMarkdown, preparationMarkdown);

      expect(find.text('+33612345678'), findsOneWidget);
      expect(find.text('Transcription en attente'), findsOneWidget);
      expect(find.text('Question live utile'), findsNothing);

      await tester.tap(find.text('Participants informés'));
      await _pumpAnimatedCallState(tester);
      sessions.emitTranscript('Bonjour, je vous appelle pour…');
      sessions.emitSuggestion('Question live utile');
      await _pumpAnimatedCallState(tester);

      expect(find.text('Bonjour, je vous appelle pour…'), findsOneWidget);
      expect(find.text('Question live utile'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.call_end_rounded));
      await _pumpAnimatedCallState(tester);

      expect(find.text('Débrief final disponible.'), findsOneWidget);
      expect(find.text('Transcript final confirmé.'), findsWidgets);
      await tester.tap(find.text('Retour au téléphone'));
      await tester.pumpAndSettle();
      expect(find.text('Prêt à appeler'), findsWidgets);

      await tester.tap(find.byKey(const Key('open_call_history_button')));
      await tester.pumpAndSettle();
      expect(find.text('Historique'), findsOneWidget);
      expect(find.text('+33612345678'), findsOneWidget);
      expect(find.textContaining('Résumé disponible'), findsOneWidget);
      expect(
        find.byKey(const Key('history_session_backend-session')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('history_back_button')));
      await tester.pumpAndSettle();

      operationOrder.clear();
      calls.dialFails = true;
      await tester.ensureVisible(dialButton);
      await tester.tap(dialButton);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<ContactMarket>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('B2B · contact professionnel').last);
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('L’offre est pertinente pour son activité professionnelle'),
      );
      await tester.tap(find.text('Vérifier et appeler'));
      await tester.pumpAndSettle();

      expect(operationOrder, <String>[
        'create-session',
        'dial-telnyx',
        'cancel-session',
      ]);
      expect(sessions.session.status, ConversationSessionStatus.failed);
      expect(await sessions.listActiveSessions(), isEmpty);
      expect(find.text('SUR CET APPAREIL'), findsNothing);
      expect(
        find.textContaining('L’appel n’a pas pu être lancé'),
        findsOneWidget,
      );
    },
  );

  testWidgets('an incoming call link opens a prefilled composer', (
    WidgetTester tester,
  ) async {
    final StreamController<Uri> incomingLinks = StreamController<Uri>();
    final List<String> operationOrder = <String>[];
    final _TestCallRepository calls = _TestCallRepository(operationOrder);
    final _TestConversationSessionRepository sessions =
        _TestConversationSessionRepository(operationOrder);
    addTearDown(incomingLinks.close);
    addTearDown(calls.dispose);
    addTearDown(sessions.dispose);

    await _pumpPinkall(
      tester,
      calls: calls,
      sessions: sessions,
      assetLoader: assetLoader,
      incomingLinks: incomingLinks.stream,
    );

    incomingLinks.add(Uri.parse('pinkall://call?number=%2B33698765432'));
    await tester.pump();
    await tester.pumpAndSettle();

    final TextFormField destinationField = tester.widget<TextFormField>(
      find.byKey(const Key('dialer_destination_field')),
    );
    expect(destinationField.controller?.text, '+33698765432');
    expect(calls.dialAttempts, 0);
  });

  testWidgets('a cold-start call link is applied after the router mounts', (
    WidgetTester tester,
  ) async {
    final List<String> operationOrder = <String>[];
    final _TestCallRepository calls = _TestCallRepository(operationOrder);
    final _TestConversationSessionRepository sessions =
        _TestConversationSessionRepository(operationOrder);
    addTearDown(calls.dispose);
    addTearDown(sessions.dispose);

    await _pumpPinkall(
      tester,
      calls: calls,
      sessions: sessions,
      assetLoader: assetLoader,
      incomingLinks: Stream<Uri>.value(
        Uri.parse('https://www.pinkall.app/call?number=0611223344'),
      ),
    );

    final TextFormField destinationField = tester.widget<TextFormField>(
      find.byKey(const Key('dialer_destination_field')),
    );
    expect(destinationField.controller?.text, '+33611223344');
    expect(calls.dialAttempts, 0);
  });

  testWidgets(
    'a cold-start call link survives onboarding until the workspace is saved',
    (WidgetTester tester) async {
      final List<String> operationOrder = <String>[];
      final _TestCallRepository calls = _TestCallRepository(operationOrder);
      final _TestConversationSessionRepository sessions =
          _TestConversationSessionRepository(operationOrder);
      final _EmptyWorkspaceSalesContextRepository workspace =
          _EmptyWorkspaceSalesContextRepository();
      addTearDown(calls.dispose);
      addTearDown(sessions.dispose);

      await _pumpPinkall(
        tester,
        calls: calls,
        sessions: sessions,
        assetLoader: assetLoader,
        workspaceRepository: workspace,
        incomingLinks: Stream<Uri>.value(
          Uri.parse('pinkall://call?number=0612345678'),
        ),
      );

      expect(find.byKey(const Key('workspace_company_field')), findsOneWidget);
      expect(find.byKey(const Key('dialer_destination_field')), findsNothing);

      await tester.enterText(
        find.byKey(const Key('workspace_company_field')),
        'Pinkall SAS',
      );
      await tester.enterText(
        find.byKey(const Key('workspace_product_field')),
        'Pinkall',
      );
      await tester.enterText(
        find.byKey(const Key('workspace_pitch_field')),
        'Un coach commercial IA pendant et après chaque appel.',
      );
      final Finder saveButton = find.byKey(
        const Key('workspace_context_save_button'),
      );
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      final TextFormField destinationField = tester.widget<TextFormField>(
        find.byKey(const Key('dialer_destination_field')),
      );
      expect(destinationField.controller?.text, '+33612345678');
      expect(workspace.savedContext?.productName, 'Pinkall');
      expect(calls.dialAttempts, 0);
    },
  );

  testWidgets('an incoming call link does not replace an active call', (
    WidgetTester tester,
  ) async {
    final StreamController<Uri> incomingLinks = StreamController<Uri>();
    final List<String> operationOrder = <String>[];
    final _TestCallRepository calls = _TestCallRepository(operationOrder);
    final _TestConversationSessionRepository sessions =
        _TestConversationSessionRepository(operationOrder);
    calls.seedActiveCall(callId: 'active-call', remoteNumber: '+33601020304');
    sessions.seedActiveSession(
      callId: 'active-call',
      destinationNumber: '+33601020304',
    );
    addTearDown(incomingLinks.close);
    addTearDown(calls.dispose);
    addTearDown(sessions.dispose);

    final AppRouter router = await _pumpPinkall(
      tester,
      calls: calls,
      sessions: sessions,
      assetLoader: assetLoader,
      incomingLinks: incomingLinks.stream,
    );
    unawaited(
      router.push<void>(
        ActiveCallRoute(
          callId: 'active-call',
          sessionId: 'backend-session',
          remoteNumber: '+33601020304',
        ),
      ),
    );
    await _pumpAnimatedCallState(tester);
    expect(router.current.name, ActiveCallRoute.name);

    incomingLinks.add(Uri.parse('pinkall://call?number=%2B33698765432'));
    await _pumpAnimatedCallState(tester);

    expect(router.current.name, ActiveCallRoute.name);
    expect(find.byKey(const Key('dialer_destination_field')), findsNothing);
    expect(calls.dialAttempts, 0);

    unawaited(router.replace(CallHomeRoute()));
    await _pumpAnimatedCallState(tester);
    for (int attempt = 0; attempt < 10; attempt += 1) {
      if (find
          .byKey(const Key('dialer_destination_field'))
          .evaluate()
          .isNotEmpty) {
        break;
      }
      await tester.pump(const Duration(milliseconds: 200));
    }

    final TextFormField destinationField = tester.widget<TextFormField>(
      find.byKey(const Key('dialer_destination_field')),
    );
    expect(destinationField.controller?.text, '+33698765432');
  });

  testWidgets(
    'a second call link updates the composer without losing its state',
    (WidgetTester tester) async {
      final StreamController<Uri> incomingLinks = StreamController<Uri>();
      final List<String> operationOrder = <String>[];
      final _TestCallRepository calls = _TestCallRepository(operationOrder);
      final _TestConversationSessionRepository sessions =
          _TestConversationSessionRepository(operationOrder);
      addTearDown(incomingLinks.close);
      addTearDown(calls.dispose);
      addTearDown(sessions.dispose);

      await _pumpPinkall(
        tester,
        calls: calls,
        sessions: sessions,
        assetLoader: assetLoader,
        incomingLinks: incomingLinks.stream,
      );

      await tester.tap(find.byKey(const Key('dialer_preparation_button')));
      await tester.pumpAndSettle();
      const String preparation =
          '# Objectif conservé\nQualifier le prospect avant de proposer une démo.';
      await tester.enterText(
        find.byKey(const Key('preparation_markdown_field')),
        preparation,
      );
      await tester.tap(find.byKey(const Key('preparation_save_button')));
      await tester.pumpAndSettle();

      incomingLinks.add(Uri.parse('pinkall://call?number=%2B33698765432'));
      await tester.pump();
      await tester.pumpAndSettle();

      final TextFormField destinationField = tester.widget<TextFormField>(
        find.byKey(const Key('dialer_destination_field')),
      );
      expect(destinationField.controller?.text, '+33698765432');

      await tester.tap(find.byKey(const Key('dialer_preparation_button')));
      await tester.pumpAndSettle();
      final TextField preparationField = tester.widget<TextField>(
        find.byKey(const Key('preparation_markdown_field')),
      );
      expect(preparationField.controller?.text, preparation);
      expect(calls.dialAttempts, 0);
    },
  );
}

Future<void> _pumpAnimatedCallState(WidgetTester tester) async {
  // The live call intentionally keeps a slow ambient painter active. Advance
  // route/state transitions without waiting for every decorative frame to stop.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump();
}

Future<AppRouter> _pumpPinkall(
  WidgetTester tester, {
  required _TestCallRepository calls,
  required _TestConversationSessionRepository sessions,
  required AssetLoader assetLoader,
  WorkspaceSalesContextRepository workspaceRepository =
      const _TestWorkspaceSalesContextRepository(),
  Stream<Uri> incomingLinks = const Stream<Uri>.empty(),
}) async {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final AppRouter router = AppRouter();
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        supportsDesktopAudioDeviceSelectionProvider.overrideWithValue(false),
        callRepositoryProvider.overrideWith((Ref ref) async => calls),
        pinkallBackendConfigurationProvider.overrideWithValue(
          PinkallBackendConfiguration(
            apiBaseUri: Uri.parse('https://api.pinkall.test/'),
            webSocketBaseUri: Uri.parse('wss://api.pinkall.test/'),
            apiToken: 'test-token',
          ),
        ),
        callEligibilityRepositoryProvider.overrideWithValue(
          const _TestCallEligibilityRepository(),
        ),
        conversationSessionRepositoryProvider.overrideWithValue(sessions),
        coachingRepositoryProvider.overrideWithValue(_TestCoachingRepository()),
        voiceAccessRepositoryProvider.overrideWithValue(
          const _TestVoiceAccessRepository(),
        ),
        incomingCallRepositoryProvider.overrideWithValue(
          const _TestIncomingCallRepository(),
        ),
        workspaceSalesContextRepositoryProvider.overrideWith(
          (Ref ref) async => workspaceRepository,
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const <Locale>[Locale('fr'), Locale('en')],
        fallbackLocale: const Locale('fr'),
        startLocale: const Locale('fr'),
        saveLocale: false,
        path: 'assets/translations',
        assetLoader: assetLoader,
        child: PinkallApp(appRouter: router, incomingLinks: incomingLinks),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pumpAndSettle();
  return router;
}

final class _TestAssetLoader extends AssetLoader {
  const _TestAssetLoader(this.translations);

  final Map<String, Map<String, dynamic>> translations;

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) {
    return Future<Map<String, dynamic>>.value(
      Map<String, dynamic>.from(translations[locale.languageCode]!),
    );
  }
}

final class _TestWorkspaceSalesContextRepository
    implements WorkspaceSalesContextRepository {
  const _TestWorkspaceSalesContextRepository();

  @override
  Future<WorkspaceSalesContextEntity?> getContext() async {
    return WorkspaceSalesContextEntity(
      companyName: 'Pinkall SAS',
      productName: 'Pinkall',
      pitchMarkdown: '# Offre\nCoach commercial IA',
      revision: 1,
      createdAt: DateTime.utc(2026, 7, 13),
      updatedAt: DateTime.utc(2026, 7, 13),
    );
  }

  @override
  Future<WorkspaceSalesContextEntity> upsertContext(
    UpsertWorkspaceSalesContextParam params,
  ) async {
    return WorkspaceSalesContextEntity(
      companyName: params.companyName,
      productName: params.productName,
      pitchMarkdown: params.pitchMarkdown,
      revision: (params.expectedRevision ?? 0) + 1,
      createdAt: DateTime.utc(2026, 7, 13),
      updatedAt: DateTime.utc(2026, 7, 13),
    );
  }
}

final class _EmptyWorkspaceSalesContextRepository
    implements WorkspaceSalesContextRepository {
  WorkspaceSalesContextEntity? savedContext;

  @override
  Future<WorkspaceSalesContextEntity?> getContext() async => savedContext;

  @override
  Future<WorkspaceSalesContextEntity> upsertContext(
    UpsertWorkspaceSalesContextParam params,
  ) async {
    final WorkspaceSalesContextEntity context = WorkspaceSalesContextEntity(
      companyName: params.companyName,
      productName: params.productName,
      pitchMarkdown: params.pitchMarkdown,
      revision: (params.expectedRevision ?? 0) + 1,
      createdAt: DateTime.utc(2026, 7, 14),
      updatedAt: DateTime.utc(2026, 7, 14),
    );
    savedContext = context;
    return context;
  }
}

Future<void> _expectAutoConnected(
  WidgetTester tester,
  _TestCallRepository calls,
) async {
  await tester.pumpAndSettle();
  expect(find.text('Prêt à appeler'), findsWidgets);
  expect(find.widgetWithText(TextFormField, 'Jeton WebRTC'), findsNothing);
  expect(calls.connectCount, 1);
}

final class _TestCallRepository implements CallRepository {
  _TestCallRepository(this.operationOrder);

  final List<String> operationOrder;
  int dialAttempts = 0;
  int connectCount = 0;
  bool dialFails = false;
  String lastClientState = '';
  final StreamController<TelnyxConnectionStateEntity> _connectionController =
      StreamController<TelnyxConnectionStateEntity>.broadcast();
  final StreamController<CallStateEntity> _callController =
      StreamController<CallStateEntity>.broadcast();
  final Map<String, CallStateEntity> _calls = <String, CallStateEntity>{};

  void seedActiveCall({required String callId, required String remoteNumber}) {
    _calls[callId] = CallStateEntity(
      callId: callId,
      direction: CallDirection.outgoing,
      status: CallLifecycleStatus.active,
      remoteNumber: remoteNumber,
    );
  }

  @override
  Stream<TelnyxConnectionStateEntity> watchConnectionStates() =>
      _connectionController.stream;

  @override
  Stream<CallStateEntity> watchCallStates() => _callController.stream;

  @override
  Stream<CallStateEntity> watchCallState(String callId) {
    return Stream<CallStateEntity>.multi((
      MultiStreamController<CallStateEntity> controller,
    ) {
      final StreamSubscription<CallStateEntity> subscription = _callController
          .stream
          .where((CallStateEntity call) => call.callId == callId)
          .listen(controller.add);
      final CallStateEntity? current = _calls[callId];
      if (current != null) {
        controller.add(current);
      }
      controller.onCancel = subscription.cancel;
    }, isBroadcast: true);
  }

  @override
  Future<void> ensureMicrophoneAccess() async {}

  @override
  Future<void> connect(TelnyxConfigurationEntity configuration) async {
    connectCount += 1;
    _connectionController.add(
      const TelnyxConnectionStateEntity(status: TelnyxConnectionStatus.ready),
    );
  }

  @override
  Future<void> disconnect() async {
    _connectionController.add(
      const TelnyxConnectionStateEntity(
        status: TelnyxConnectionStatus.disconnected,
      ),
    );
  }

  @override
  Future<String> dial({
    required String destinationNumber,
    required String clientState,
    required Map<String, String> customHeaders,
  }) async {
    operationOrder.add('dial-telnyx');
    dialAttempts += 1;
    lastClientState = clientState;
    if (dialFails) {
      throw StateError('dial unavailable');
    }
    const String callId = 'test-call';
    final CallStateEntity call = CallStateEntity(
      callId: callId,
      direction: CallDirection.outgoing,
      status: CallLifecycleStatus.active,
      remoteNumber: destinationNumber,
    );
    _calls[callId] = call;
    _callController.add(call);
    return callId;
  }

  @override
  Future<void> accept(String callId) async {}

  @override
  Future<void> reject(String callId) => hangUp(callId);

  @override
  Future<void> hangUp(String callId) async {
    final CallStateEntity? current = _calls[callId];
    if (current != null) {
      final CallStateEntity ended = current.copyWith(
        status: CallLifecycleStatus.ended,
      );
      _calls[callId] = ended;
      _callController.add(ended);
    }
  }

  @override
  Future<void> setMuted(String callId, {required bool isMuted}) async {}

  @override
  Future<void> setSpeakerEnabled(
    String callId, {
    required bool isEnabled,
  }) async {}

  @override
  Future<void> dispose() async {
    await _connectionController.close();
    await _callController.close();
  }
}

final class _TestCallEligibilityRepository
    implements CallEligibilityRepository {
  const _TestCallEligibilityRepository();

  @override
  Future<CallEligibilityEntity> evaluate(
    EvaluateCallEligibilityParam params,
  ) async {
    final bool eligible =
        !params.hasOptedOut! &&
        ((params.market == ContactMarket.b2b &&
                params.professionalRelevanceConfirmed == true) ||
            (params.market == ContactMarket.b2c &&
                params.hasPriorConsent == true));
    return CallEligibilityEntity(
      status: eligible
          ? CallEligibilityStatus.eligible
          : CallEligibilityStatus.ineligible,
      reasons: eligible
          ? const <CallEligibilityReason>[]
          : <CallEligibilityReason>[
              if (params.market == ContactMarket.b2c)
                CallEligibilityReason.b2cConsentMissing
              else
                CallEligibilityReason.professionalRelevanceMissing,
            ],
      checkedAt: DateTime.now().toUtc(),
      policyVersion: 'test-policy',
    );
  }
}

final class _TestConversationSessionRepository
    implements ConversationSessionRepository {
  _TestConversationSessionRepository(this.operationOrder);

  final List<String> operationOrder;
  final StreamController<SessionRealtimeEventEntity> _events =
      StreamController<SessionRealtimeEventEntity>.broadcast();
  late ConversationSessionEntity session;
  bool hasCreatedSession = false;
  String createdCorrelationId = '';
  String? createdPreparationMarkdown;

  void seedActiveSession({
    required String callId,
    required String destinationNumber,
  }) {
    hasCreatedSession = true;
    session = ConversationSessionEntity(
      id: 'backend-session',
      callId: callId,
      destinationNumber: destinationNumber,
      status: ConversationSessionStatus.active,
      coachMode: CoachMode.off,
      createdAt: DateTime.utc(2026, 7, 14),
      startedAt: DateTime.utc(2026, 7, 14),
    );
  }

  @override
  Future<ConversationSessionEntity> createSession(
    CreateConversationSessionParam params,
  ) async {
    operationOrder.add('create-session');
    hasCreatedSession = true;
    createdCorrelationId = params.callId;
    createdPreparationMarkdown = params.preparationMarkdown;
    session = ConversationSessionEntity(
      id: 'backend-session',
      callId: params.callId,
      destinationNumber: params.destinationNumber,
      status: ConversationSessionStatus.created,
      coachMode: params.coachModeOverride ?? CoachMode.off,
      createdAt: DateTime.now().toUtc(),
      startedAt: DateTime.now().toUtc(),
    );
    return session;
  }

  @override
  Future<ExternalConversationSessionEntity> createExternalSession(
    CreateExternalConversationSessionParam params,
  ) => throw UnimplementedError();

  @override
  Future<ConversationSessionEntity> getSession(String sessionId) async =>
      session;

  @override
  Future<ConversationSessionEntity> cancelSession(String sessionId) async {
    operationOrder.add('cancel-session');
    session = session.copyWith(
      status: ConversationSessionStatus.failed,
      failureReason: 'client_dial_failed',
      endedAt: DateTime.now().toUtc(),
    );
    return session;
  }

  @override
  Future<List<ConversationSessionEntity>> listActiveSessions() async =>
      hasCreatedSession &&
          (session.status == ConversationSessionStatus.created ||
              session.status == ConversationSessionStatus.active)
      ? <ConversationSessionEntity>[session]
      : const <ConversationSessionEntity>[];

  @override
  Future<List<ConversationSessionEntity>> listSessions() async =>
      hasCreatedSession
      ? <ConversationSessionEntity>[session]
      : const <ConversationSessionEntity>[];

  @override
  Future<CoachingProgressEntity> getCoachingProgress(
    GetCoachingProgressParam params,
  ) => throw UnimplementedError();

  @override
  Stream<SessionRealtimeEventEntity> watchSessionEvents(String sessionId) =>
      _events.stream;

  @override
  Future<ConversationSessionEntity> finalizeSession(String sessionId) async {
    session = session.copyWith(
      status: ConversationSessionStatus.completed,
      endedAt: DateTime.now().toUtc(),
    );
    return session;
  }

  @override
  Future<ConversationTranscriptEntity> getFinalTranscript(
    String sessionId,
  ) async {
    return ConversationTranscriptEntity(
      sessionId: sessionId,
      finalizedAt: DateTime.now().toUtc(),
      segments: <TranscriptSegmentEntity>[
        TranscriptSegmentEntity(
          id: 'final-segment',
          sessionId: sessionId,
          sequence: 1,
          speaker: TranscriptSpeaker.seller,
          text: 'Transcript final confirmé.',
          startedAt: DateTime.now().toUtc(),
          isFinal: true,
        ),
      ],
    );
  }

  @override
  Future<CallDebriefEntity> getDebrief(String sessionId) async {
    return CallDebriefEntity(
      sessionId: sessionId,
      summary: const GroundedCallTextEntity(
        text: 'Transcript final confirmé.',
        evidenceSegmentIds: <String>['final-segment'],
      ),
      keyPoints: const <GroundedCallTextEntity>[],
      commitments: const <CallCommitmentEntity>[],
      followUp: const CallFollowUpEntity(
        subject: 'Suite à notre échange',
        body: 'Voici le suivi convenu.',
        evidenceSegmentIds: <String>['final-segment'],
      ),
      generatedAt: DateTime.now().toUtc(),
      provider: 'test',
      model: 'test-model',
    );
  }

  @override
  Future<ConversationSessionEntity> updateCoachMode(
    UpdateSessionCoachModeParam params,
  ) async {
    session = session.copyWith(coachMode: params.mode);
    return session;
  }

  @override
  Future<TranscriptionConsentEntity> recordTranscriptionConsent(
    RecordTranscriptionConsentParam params,
  ) async {
    session = session.copyWith(transcriptionConsentAcknowledged: true);
    return TranscriptionConsentEntity(
      sessionId: params.sessionId,
      acknowledged: true,
      method: params.method,
      acknowledgedAt: params.acknowledgedAt,
    );
  }

  void emitTranscript(String text) {
    _events.add(
      SessionRealtimeEventEntity.transcriptSegment(
        TranscriptSegmentEntity(
          id: 'live-segment',
          sessionId: session.id,
          sequence: 0,
          speaker: TranscriptSpeaker.seller,
          text: text,
          startedAt: DateTime.now().toUtc(),
          isFinal: true,
        ),
      ),
    );
  }

  void emitSuggestion(String text) {
    final DateTime now = DateTime.now().toUtc();
    _events.add(
      SessionRealtimeEventEntity.coachingSuggestion(
        CoachingSuggestionEntity(
          id: 'suggestion',
          sessionId: session.id,
          kind: CoachingSuggestionKind.nextQuestion,
          text: text,
          rationale: 'Test source-backed suggestion.',
          sources: const <CoachingSourceEntity>[],
          confidence: 0.91,
          createdAt: now,
          expiresAt: now.add(const Duration(seconds: 30)),
        ),
      ),
    );
  }

  Future<void> dispose() => _events.close();
}

final class _TestCoachingRepository implements CoachingRepository {
  CoachMode mode = CoachMode.live;

  @override
  Future<List<ObjectionKnowledgeEntryEntity>> listObjections() async =>
      const <ObjectionKnowledgeEntryEntity>[];

  @override
  Future<ObjectionKnowledgeEntryEntity> createCustomObjection(
    CreateCustomObjectionParam params,
  ) => throw UnimplementedError();

  @override
  Future<CoachPreferenceEntity> getPreference() async => CoachPreferenceEntity(
    defaultMode: mode,
    updatedAt: DateTime.now().toUtc(),
  );

  @override
  Future<CoachPreferenceEntity> updatePreference(
    UpdateCoachPreferenceParam params,
  ) async {
    mode = params.defaultMode;
    return CoachPreferenceEntity(
      defaultMode: mode,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<CoachingFeedbackEntity> submitFeedback(
    SubmitCoachingFeedbackParam params,
  ) => throw UnimplementedError();

  @override
  Future<CallOutcomeEntity> recordOutcome(RecordCallOutcomeParam params) =>
      throw UnimplementedError();
}

final class _TestVoiceAccessRepository implements VoiceAccessRepository {
  const _TestVoiceAccessRepository();

  @override
  Future<VoiceAccessTokenEntity> requestToken(
    RequestVoiceAccessTokenParam params,
  ) async {
    return VoiceAccessTokenEntity(
      token: 'ephemeral-test-token',
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      callerName: 'Pinkall Test',
      callerNumber: '+33123456789',
    );
  }
}

final class _TestIncomingCallRepository implements IncomingCallRepository {
  const _TestIncomingCallRepository();

  static const IncomingCallCapabilityEntity _capability =
      IncomingCallCapabilityEntity(
        status: IncomingCallCapabilityStatus.disabled,
        platform: IncomingCallPlatform.other,
        transport: IncomingCallTransport.none,
        tokenAvailable: false,
        backgroundDeliveryReady: false,
        nativeCallUiReady: false,
        missingRequirements: <String>['feature_disabled'],
      );

  @override
  Future<IncomingCallCapabilityEntity> initialize() async => _capability;

  @override
  Future<IncomingCallCapabilityEntity> inspectCapability() async => _capability;

  @override
  Future<String?> getNotificationToken() async => null;

  @override
  Stream<IncomingCallNativeEventEntity> watchNativeEvents() =>
      const Stream<IncomingCallNativeEventEntity>.empty();

  @override
  Future<void> dispose() async {}
}
