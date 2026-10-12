import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/foundation/routing/app_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    final List<File> candidates = <File>[
      File('assets/translations/fr.json'),
      File('apps/app_mobile/assets/translations/fr.json'),
    ];
    final File source = candidates.firstWhere((File file) => file.existsSync());
    final Map<String, dynamic> translations =
        jsonDecode(source.readAsStringSync()) as Map<String, dynamic>;
    Localization.load(
      const Locale('fr'),
      translations: Translations(translations),
    );
  });

  testWidgets('renders the empty progression state', (
    WidgetTester tester,
  ) async {
    final _ProgressRepository repository = _ProgressRepository(
      (int windowSize) => _emptyProgress(windowSize: windowSize),
    );

    await _pumpProgress(tester, repository: repository);

    expect(
      find.text('Ta progression apparaîtra après tes premiers appels.'),
      findsOneWidget,
    );
    expect(find.text('Préparer un appel'), findsOneWidget);
    expect(find.byKey(const Key('progress_comparison_radar')), findsNothing);
    expect(repository.requests, hasLength(1));
    expect(repository.requests.single.windowSize, 5);
    expect(repository.requests.single.recentLimit, 20);
  });

  testWidgets('lays out the populated dashboard on desktop and mobile', (
    WidgetTester tester,
  ) async {
    final _ProgressRepository repository = _ProgressRepository(
      (int windowSize) => _populatedProgress(windowSize: windowSize),
    );

    await _pumpProgress(
      tester,
      repository: repository,
      size: const Size(1440, 900),
    );

    expect(find.byKey(const Key('progress_radar_card')), findsOneWidget);
    expect(find.byKey(const Key('progress_metrics_section')), findsOneWidget);
    expect(find.byKey(const Key('progress_trend_section')), findsOneWidget);
    expect(find.byKey(const Key('progress_history_section')), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('progress_radar_card')), findsOneWidget);
    expect(find.byKey(const Key('progress_metrics_section')), findsOneWidget);
    expect(find.byKey(const Key('progress_history_section')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('exposes the comparative radar and its semantic profile', (
    WidgetTester tester,
  ) async {
    final _ProgressRepository repository = _ProgressRepository(
      (int windowSize) => _populatedProgress(windowSize: windowSize),
    );
    final SemanticsHandle semantics = tester.ensureSemantics();

    await _pumpProgress(tester, repository: repository);

    expect(find.byKey(const Key('progress_comparison_radar')), findsOneWidget);
    expect(find.text('Période actuelle'), findsOneWidget);
    expect(find.text('Période précédente'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        RegExp('Écoute 78 sur 100.*Découverte 64 sur 100.*Naturel 80 sur 100'),
      ),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('reloads the dashboard when the comparison window changes', (
    WidgetTester tester,
  ) async {
    final _ProgressRepository repository = _ProgressRepository(
      (int windowSize) => _populatedProgress(windowSize: windowSize),
    );

    await _pumpProgress(tester, repository: repository);

    SegmentedButton<int> selector = tester.widget<SegmentedButton<int>>(
      find.byKey(const Key('progress_window_selector')),
    );
    expect(selector.selected, <int>{5});

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('progress_window_selector')),
        matching: find.text('10'),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      repository.requests.map(
        (GetCoachingProgressParam value) => value.windowSize,
      ),
      <int>[5, 10],
    );
    selector = tester.widget<SegmentedButton<int>>(
      find.byKey(const Key('progress_window_selector')),
    );
    expect(selector.selected, <int>{10});
  });

  testWidgets('keeps the latest window when responses finish out of order', (
    WidgetTester tester,
  ) async {
    final Completer<CoachingProgressEntity> ten =
        Completer<CoachingProgressEntity>();
    final Completer<CoachingProgressEntity> twenty =
        Completer<CoachingProgressEntity>();
    final _ProgressRepository repository = _ProgressRepository(
      (int windowSize) => switch (windowSize) {
        10 => ten.future,
        20 => twenty.future,
        _ => _populatedProgress(windowSize: windowSize),
      },
    );

    await _pumpProgress(tester, repository: repository);

    SegmentedButton<int> selector = tester.widget<SegmentedButton<int>>(
      find.byKey(const Key('progress_window_selector')),
    );
    selector.onSelectionChanged!(<int>{10});
    await tester.pump();
    selector = tester.widget<SegmentedButton<int>>(
      find.byKey(const Key('progress_window_selector')),
    );
    selector.onSelectionChanged!(<int>{20});
    await tester.pump();

    twenty.complete(_populatedProgress(windowSize: 20));
    await tester.pumpAndSettle();
    ten.complete(_populatedProgress(windowSize: 10));
    await tester.pumpAndSettle();

    selector = tester.widget<SegmentedButton<int>>(
      find.byKey(const Key('progress_window_selector')),
    );
    expect(selector.selected, <int>{20});
    expect(
      repository.requests.map(
        (GetCoachingProgressParam item) => item.windowSize,
      ),
      <int>[5, 10, 20],
    );
  });

  testWidgets('opens the selected call with its exact route identifiers', (
    WidgetTester tester,
  ) async {
    final _ProgressRepository repository = _ProgressRepository(
      (int windowSize) => _populatedProgress(windowSize: windowSize),
    );
    final AppRouter router = await _pumpProgress(
      tester,
      repository: repository,
    );

    final Finder destination = find.text('+33600000001');
    await tester.ensureVisible(destination);
    await tester.pumpAndSettle();
    await tester.tap(destination);
    await tester.pumpAndSettle();

    expect(router.current.name, ActiveCallRoute.name);
    final ActiveCallRouteArgs args = router.current
        .argsAs<ActiveCallRouteArgs>();
    expect(args.callId, 'call-1');
    expect(args.sessionId, 'session-1');
    expect(args.remoteNumber, '+33600000001');
    expect(args.companion, isTrue);
  });
}

Future<AppRouter> _pumpProgress(
  WidgetTester tester, {
  required _ProgressRepository repository,
  Size size = const Size(1280, 900),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final AppRouter router = AppRouter();
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        conversationSessionRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: PinkallTheme.light,
        routerConfig: router.config(
          deepLinkBuilder: (_) => DeepLink.single(const CallProgressRoute()),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pumpAndSettle();
  return router;
}

final class _ProgressRepository implements ConversationSessionRepository {
  _ProgressRepository(this._builder);

  final FutureOr<CoachingProgressEntity> Function(int windowSize) _builder;
  final List<GetCoachingProgressParam> requests = <GetCoachingProgressParam>[];

  @override
  Future<CoachingProgressEntity> getCoachingProgress(
    GetCoachingProgressParam params,
  ) async {
    requests.add(params);
    return await _builder(params.windowSize);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

CoachingProgressEntity _emptyProgress({required int windowSize}) {
  return CoachingProgressEntity(
    generatedAt: DateTime.utc(2026, 7, 14, 9),
    sessionCount: 0,
    analyzedCallCount: 0,
    currentWindowSize: 0,
    previousWindowSize: 0,
    hasComparison: false,
    rubricVersion: 'sales-v1',
    axes: const <CoachingProgressAxisEntity>[],
    observedMetrics: _emptyMetrics(),
    recentCalls: const <CoachingProgressCallEntity>[],
  );
}

CoachingProgressEntity _populatedProgress({required int windowSize}) {
  final List<CoachingProgressAxisEntity> axes = _progressAxes();
  return CoachingProgressEntity(
    generatedAt: DateTime.utc(2026, 7, 14, 9),
    sessionCount: windowSize * 2,
    analyzedCallCount: windowSize * 2,
    currentWindowSize: windowSize,
    previousWindowSize: windowSize,
    hasComparison: true,
    rubricVersion: 'sales-v1',
    axes: axes,
    observedMetrics: _populatedMetrics(windowSize),
    recentCalls: <CoachingProgressCallEntity>[
      _progressCall(
        callId: 'call-1',
        sessionId: 'session-1',
        destinationNumber: '+33600000001',
        occurredAt: DateTime.utc(2026, 7, 14, 8, 30),
        scoreOffset: 0,
      ),
      _progressCall(
        callId: 'call-2',
        sessionId: 'session-2',
        destinationNumber: '+33600000002',
        occurredAt: DateTime.utc(2026, 7, 13, 15),
        scoreOffset: 4,
      ),
      _progressCall(
        callId: 'call-3',
        sessionId: 'session-3',
        destinationNumber: '+33600000003',
        occurredAt: DateTime.utc(2026, 7, 12, 11),
        scoreOffset: 8,
      ),
    ],
    focus: axes[1],
    strength: axes.first,
  );
}

List<CoachingProgressAxisEntity> _progressAxes() {
  const List<int> current = <int>[78, 64, 72, 68, 75, 70, 66, 80];
  const List<int> previous = <int>[70, 60, 69, 62, 72, 66, 61, 74];
  return <CoachingProgressAxisEntity>[
    for (int index = 0; index < CallPerformanceAxis.values.length; index += 1)
      CoachingProgressAxisEntity(
        axis: CallPerformanceAxis.values[index],
        currentScore: current[index],
        previousScore: previous[index],
        delta: current[index] - previous[index],
        signal: index == 1
            ? CallPerformanceSignal.tooLow
            : CallPerformanceSignal.balanced,
        observation: 'Observation ${CallPerformanceAxis.values[index].name}',
        sampleCount: 5,
      ),
  ];
}

CoachingProgressCallEntity _progressCall({
  required String callId,
  required String sessionId,
  required String destinationNumber,
  required DateTime occurredAt,
  required int scoreOffset,
}) {
  final List<CoachingProgressAxisEntity> aggregate = _progressAxes();
  return CoachingProgressCallEntity(
    callId: callId,
    sessionId: sessionId,
    occurredAt: occurredAt,
    destinationNumber: destinationNumber,
    outcome: 'meeting_booked',
    observedMetrics: const CallObservedMetricsEntity(
      sellerTalkRatio: 0.46,
      questionCount: 7,
      averageSellerTurnSeconds: 14.5,
      longestSellerTurnSeconds: 32,
      hesitationCount: 2,
      questionsPerMinute: 1.4,
      hesitationsPerMinute: 0.4,
    ),
    performanceAxes: <CallPerformanceAxisEntity>[
      for (final CoachingProgressAxisEntity axis in aggregate)
        CallPerformanceAxisEntity(
          axis: axis.axis,
          score: axis.currentScore - scoreOffset,
          signal: axis.signal,
          observation: axis.observation,
          evidenceSegmentIds: <String>['$sessionId-segment'],
        ),
    ],
  );
}

CoachingProgressMetricsEntity _emptyMetrics() {
  const CoachingProgressMetricEntity empty = CoachingProgressMetricEntity(
    current: null,
    previous: null,
    delta: null,
    sampleCount: 0,
  );
  return const CoachingProgressMetricsEntity(
    sellerTalkRatio: empty,
    questionCount: empty,
    averageSellerTurnSeconds: empty,
    longestSellerTurnSeconds: empty,
    hesitationCount: empty,
    questionsPerMinute: empty,
    hesitationsPerMinute: empty,
  );
}

CoachingProgressMetricsEntity _populatedMetrics(int sampleCount) {
  CoachingProgressMetricEntity metric(double current, double previous) =>
      CoachingProgressMetricEntity(
        current: current,
        previous: previous,
        delta: current - previous,
        sampleCount: sampleCount,
      );

  return CoachingProgressMetricsEntity(
    sellerTalkRatio: metric(0.46, 0.53),
    questionCount: metric(7, 5),
    averageSellerTurnSeconds: metric(14.5, 18),
    longestSellerTurnSeconds: metric(32, 44),
    hesitationCount: metric(2, 4),
    questionsPerMinute: metric(1.4, 1),
    hesitationsPerMinute: metric(0.4, 0.8),
  );
}
