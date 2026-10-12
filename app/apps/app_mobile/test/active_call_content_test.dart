import 'package:core_domain/core_domain.dart';
import 'package:core_presentation/core_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinkall/features/calls/presentation/screens/active_call/active_call.state.dart';
import 'package:pinkall/features/calls/presentation/screens/active_call/widgets/active_call_content.widget.dart';

void main() {
  testWidgets('never renders a shadow coaching suggestion', (
    WidgetTester tester,
  ) async {
    final DateTime now = DateTime.now().toUtc();
    final ActiveCallState state = ActiveCallState(
      session: const CallStateEntity(
        callId: 'call',
        direction: CallDirection.outgoing,
        status: CallLifecycleStatus.active,
        remoteNumber: '+33123456789',
      ),
      processingSession: ConversationSessionEntity(
        id: 'session',
        callId: 'correlation',
        status: ConversationSessionStatus.active,
        coachMode: CoachMode.shadow,
        createdAt: now,
        transcriptionConsentAcknowledged: true,
      ),
      isCompanion: true,
      elapsed: Duration.zero,
      transcript: const <TranscriptSegmentEntity>[],
      suggestion: CoachingSuggestionEntity(
        id: 'shadow',
        sessionId: 'session',
        kind: CoachingSuggestionKind.nextQuestion,
        text: 'Suggestion shadow interdite à l’écran',
        rationale: 'Only evaluated by the backend.',
        sources: const <CoachingSourceEntity>[],
        confidence: 0.9,
        createdAt: now,
        expiresAt: now.add(const Duration(minutes: 1)),
      ),
      finalTranscript: null,
      debrief: null,
      isOperating: false,
      operationFailure: null,
      realtimeFailure: null,
      finalizationMessage: null,
    );

    await _pumpContent(tester, state);

    expect(find.text('Suggestion shadow interdite à l’écran'), findsNothing);
    expect(find.text('MODE COMPAGNON'), findsOneWidget);
  });

  testWidgets('renders one live suggestion in the desktop coach rail', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final DateTime now = DateTime.now().toUtc();
    final ActiveCallState state = _activeState(
      now: now,
      coachMode: CoachMode.live,
      transcript: <TranscriptSegmentEntity>[
        TranscriptSegmentEntity(
          id: 'seller-1',
          sessionId: 'session',
          sequence: 1,
          speaker: TranscriptSpeaker.seller,
          text: 'Bonjour, je vous appelle pour votre lancement.',
          startedAt: now,
          isFinal: true,
        ),
        TranscriptSegmentEntity(
          id: 'prospect-1',
          sessionId: 'session',
          sequence: 2,
          speaker: TranscriptSpeaker.prospect,
          text: 'Nous voulons surtout clarifier notre acquisition.',
          startedAt: now.add(const Duration(seconds: 3)),
          isFinal: true,
        ),
      ],
      suggestion: CoachingSuggestionEntity(
        id: 'live',
        sessionId: 'session',
        kind: CoachingSuggestionKind.nextQuestion,
        text: 'Demande quel canal bloque la croissance.',
        rationale: 'Une question prioritaire.',
        sources: const <CoachingSourceEntity>[],
        confidence: 0.91,
        createdAt: now,
        expiresAt: now.add(const Duration(minutes: 1)),
      ),
    );

    await _pumpContent(tester, state);

    expect(
      find.text('Demande quel canal bloque la croissance.'),
      findsOneWidget,
    );
    expect(find.text('Vous'), findsOneWidget);
    expect(find.text('Prospect'), findsOneWidget);
    expect(find.byIcon(Icons.call_end_rounded), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('activates and deactivates coaching from the live call action', (
    WidgetTester tester,
  ) async {
    final DateTime now = DateTime.now().toUtc();
    bool? requestedMode;
    Future<void> onCoachChanged(bool enabled) async {
      requestedMode = enabled;
    }

    await _pumpContent(
      tester,
      _activeState(
        now: now,
        coachMode: CoachMode.off,
        transcript: const <TranscriptSegmentEntity>[],
      ),
      onCoachChanged: onCoachChanged,
    );

    expect(find.text('Activer le coach'), findsOneWidget);
    expect(find.byType(Switch), findsNothing);
    await tester.tap(find.byKey(const Key('active_call_coach_action')));
    await tester.pump();
    expect(requestedMode, isTrue);

    requestedMode = null;
    await _pumpContent(
      tester,
      _activeState(
        now: now,
        coachMode: CoachMode.live,
        transcript: const <TranscriptSegmentEntity>[],
      ),
      onCoachChanged: onCoachChanged,
    );

    expect(find.text('Coach actif'), findsOneWidget);
    await tester.tap(find.byKey(const Key('active_call_coach_action')));
    await tester.pump();
    expect(requestedMode, isFalse);
  });

  testWidgets('offers a clear coach activation inside the live workspace', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    bool? requestedMode;

    await _pumpContent(
      tester,
      _activeState(
        now: DateTime.now().toUtc(),
        coachMode: CoachMode.off,
        transcript: const <TranscriptSegmentEntity>[],
      ),
      onCoachChanged: (bool enabled) async {
        requestedMode = enabled;
      },
    );

    expect(find.text('Désactivé pour cet appel.'), findsOneWidget);
    expect(find.text('Activer le coach IA'), findsOneWidget);
    await tester.tap(find.byKey(const Key('active_call_coach_primary_action')));
    await tester.pump();
    expect(requestedMode, isTrue);
  });

  testWidgets('shows real coach analysis then returns to listening', (
    WidgetTester tester,
  ) async {
    final DateTime now = DateTime.now().toUtc();

    await _pumpContent(
      tester,
      _activeState(
        now: now,
        coachMode: CoachMode.live,
        transcript: const <TranscriptSegmentEntity>[],
        coachAnalysisStatus: CoachAnalysisStatus.analyzing,
      ),
    );

    expect(find.text('Analyse du dernier tour…'), findsOneWidget);
    expect(find.textContaining('recommandation apparaîtra'), findsNothing);

    await _pumpContent(
      tester,
      _activeState(
        now: now,
        coachMode: CoachMode.live,
        transcript: const <TranscriptSegmentEntity>[],
        coachAnalysisOutcome: CoachAnalysisOutcome.none,
      ),
    );

    expect(
      find.text(
        'Aucun conseil suffisamment pertinent pour ce tour. Le coach reste à l’écoute.',
      ),
      findsOneWidget,
    );

    await _pumpContent(
      tester,
      _activeState(
        now: now,
        coachMode: CoachMode.live,
        transcript: const <TranscriptSegmentEntity>[],
      ),
    );

    expect(
      find.text(
        'À l’écoute. Une recommandation apparaîtra uniquement lorsqu’elle est utile.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('never renders an expired live suggestion', (
    WidgetTester tester,
  ) async {
    final DateTime now = DateTime.now().toUtc();
    final ActiveCallState state = _activeState(
      now: now,
      coachMode: CoachMode.live,
      transcript: const <TranscriptSegmentEntity>[],
      suggestion: CoachingSuggestionEntity(
        id: 'expired',
        sessionId: 'session',
        kind: CoachingSuggestionKind.nextQuestion,
        text: 'Conseil expiré à ne pas afficher.',
        rationale: 'La fenêtre de pertinence est passée.',
        sources: const <CoachingSourceEntity>[],
        confidence: 0.9,
        createdAt: now.subtract(const Duration(minutes: 2)),
        expiresAt: now.subtract(const Duration(minutes: 1)),
      ),
    );

    await _pumpContent(tester, state);

    expect(find.text('Conseil expiré à ne pas afficher.'), findsNothing);
  });

  testWidgets('builds a long mobile transcript lazily', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final DateTime now = DateTime.now().toUtc();
    final List<TranscriptSegmentEntity> transcript =
        List<TranscriptSegmentEntity>.generate(
          180,
          (int index) => TranscriptSegmentEntity(
            id: 'segment-$index',
            sessionId: 'session',
            sequence: index,
            speaker: index.isEven
                ? TranscriptSpeaker.seller
                : TranscriptSpeaker.prospect,
            text: 'Segment visible $index',
            startedAt: now.add(Duration(seconds: index)),
            isFinal: true,
          ),
        );

    await _pumpContent(
      tester,
      _activeState(now: now, coachMode: CoachMode.live, transcript: transcript),
    );

    expect(find.text('Segment visible 0'), findsOneWidget);
    expect(find.text('Segment visible 179'), findsNothing);
  });

  testWidgets('scrolls a long desktop transcript with an attached controller', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final DateTime now = DateTime.now().toUtc();
    final List<TranscriptSegmentEntity> transcript =
        List<TranscriptSegmentEntity>.generate(
          80,
          (int index) => TranscriptSegmentEntity(
            id: 'desktop-segment-$index',
            sessionId: 'session',
            sequence: index,
            speaker: index.isEven
                ? TranscriptSpeaker.seller
                : TranscriptSpeaker.prospect,
            text: 'Segment desktop $index',
            startedAt: now.add(Duration(seconds: index)),
            isFinal: true,
          ),
        );

    await _pumpContent(
      tester,
      _activeState(now: now, coachMode: CoachMode.live, transcript: transcript),
    );

    final Finder scrollbarFinder = find.byType(Scrollbar);
    final Finder listFinder = find.descendant(
      of: scrollbarFinder,
      matching: find.byType(ListView),
    );
    final Scrollbar scrollbar = tester.widget<Scrollbar>(scrollbarFinder);
    final ListView listView = tester.widget<ListView>(listFinder);

    expect(scrollbar.controller, isNotNull);
    expect(scrollbar.controller!.hasClients, isTrue);
    expect(identical(scrollbar.controller, listView.controller), isTrue);

    await tester.drag(listFinder, const Offset(0, -300));
    await tester.pump(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);
  });

  testWidgets('selects macOS input and output devices from the audio menu', (
    WidgetTester tester,
  ) async {
    final DateTime now = DateTime.now().toUtc();
    AudioDeviceKind? selectedKind;
    String? selectedDeviceId;

    await _pumpContent(
      tester,
      _activeState(
        now: now,
        coachMode: CoachMode.off,
        transcript: const <TranscriptSegmentEntity>[],
      ).copyWith(
        supportsAudioDeviceSelection: true,
        audioDevices: const <AudioDeviceEntity>[
          AudioDeviceEntity(
            id: 'mic-1',
            label: 'Studio Mic',
            kind: AudioDeviceKind.input,
          ),
          AudioDeviceEntity(
            id: 'output-1',
            label: 'Studio Display',
            kind: AudioDeviceKind.output,
          ),
        ],
      ),
      onSelectAudioDevice: (AudioDeviceKind kind, String deviceId) async {
        selectedKind = kind;
        selectedDeviceId = deviceId;
      },
    );

    expect(find.byTooltip('Activer le haut-parleur'), findsNothing);
    await tester.tap(find.byTooltip('Choisir les périphériques audio'));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('MICROPHONE'), findsOneWidget);
    expect(find.text('SORTIE AUDIO'), findsOneWidget);
    expect(find.text('Studio Mic'), findsOneWidget);
    expect(find.text('Studio Display'), findsOneWidget);

    await tester.tap(find.text('Studio Display'));
    await tester.pump();
    expect(selectedKind, AudioDeviceKind.output);
    expect(selectedDeviceId, 'output-1');
  });

  testWidgets('keeps the mobile speaker toggle when device selection is off', (
    WidgetTester tester,
  ) async {
    bool toggled = false;
    await _pumpContent(
      tester,
      _activeState(
        now: DateTime.now().toUtc(),
        coachMode: CoachMode.off,
        transcript: const <TranscriptSegmentEntity>[],
      ),
      onToggleSpeaker: () async {
        toggled = true;
      },
    );

    expect(find.byTooltip('Choisir les périphériques audio'), findsNothing);
    await tester.tap(find.byTooltip('Activer le haut-parleur'));
    await tester.pump();
    expect(toggled, isTrue);
  });

  testWidgets('offers debrief retry when only the transcript is available', (
    WidgetTester tester,
  ) async {
    final DateTime now = DateTime.now().toUtc();
    final TranscriptSegmentEntity segment = TranscriptSegmentEntity(
      id: 'final-only',
      sessionId: 'session',
      sequence: 1,
      speaker: TranscriptSpeaker.prospect,
      text: 'Envoyez-moi les détails demain.',
      startedAt: now,
      isFinal: true,
    );
    final ActiveCallState state =
        _activeState(
          now: now,
          coachMode: CoachMode.off,
          transcript: <TranscriptSegmentEntity>[segment],
        ).copyWith(
          session: const CallStateEntity(
            callId: 'call',
            direction: CallDirection.outgoing,
            status: CallLifecycleStatus.ended,
            remoteNumber: '+33123456789',
          ),
          finalTranscript: ConversationTranscriptEntity(
            sessionId: 'session',
            segments: <TranscriptSegmentEntity>[segment],
            finalizedAt: now,
          ),
          debrief: null,
          finalizationMessage:
              'Transcription disponible. L’analyse n’a pas pu être générée.',
        );

    await _pumpContent(tester, state);

    expect(find.text('Transcription disponible'), findsOneWidget);
    expect(find.text('Relancer le débrief'), findsOneWidget);
  });

  testWidgets('renders the grounded post-call improvement and transcript', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final DateTime now = DateTime.now().toUtc();
    final TranscriptSegmentEntity segment = TranscriptSegmentEntity(
      id: 'final-1',
      sessionId: 'session',
      sequence: 1,
      speaker: TranscriptSpeaker.prospect,
      text: 'Recontactez-moi mardi avec le devis.',
      startedAt: now,
      isFinal: true,
    );
    final ActiveCallState state = ActiveCallState(
      session: const CallStateEntity(
        callId: 'call',
        direction: CallDirection.outgoing,
        status: CallLifecycleStatus.ended,
        remoteNumber: '+33123456789',
      ),
      processingSession: ConversationSessionEntity(
        id: 'session',
        callId: 'correlation',
        status: ConversationSessionStatus.completed,
        coachMode: CoachMode.live,
        createdAt: now,
        transcriptionConsentAcknowledged: true,
      ),
      isCompanion: false,
      elapsed: const Duration(minutes: 4, seconds: 18),
      transcript: <TranscriptSegmentEntity>[segment],
      suggestion: CoachingSuggestionEntity(
        id: 'next-step',
        sessionId: 'session',
        kind: CoachingSuggestionKind.nextStep,
        text: 'Confirme le devis et le créneau de mardi.',
        rationale: 'Le prospect a demandé un suivi daté.',
        sources: const <CoachingSourceEntity>[],
        confidence: 0.93,
        createdAt: now,
        expiresAt: now.add(const Duration(minutes: 1)),
      ),
      finalTranscript: ConversationTranscriptEntity(
        sessionId: 'session',
        segments: <TranscriptSegmentEntity>[segment],
        finalizedAt: now,
      ),
      debrief: CallDebriefEntity(
        sessionId: 'session',
        summary: const GroundedCallTextEntity(
          text: 'Le prospect attend le devis mardi.',
          evidenceSegmentIds: <String>['final-1'],
        ),
        keyPoints: const <GroundedCallTextEntity>[],
        commitments: const <CallCommitmentEntity>[],
        followUp: const CallFollowUpEntity(
          subject: 'Votre devis',
          body: 'Bonjour, voici le devis convenu pendant notre échange.',
          evidenceSegmentIds: <String>['final-1'],
        ),
        improvement: const CallImprovementEntity(
          recommendationId: 'rec-next-step',
          text: 'Confirme le devis et le créneau de mardi.',
          rationale: 'Le prospect a demandé un suivi daté.',
          evidenceSegmentIds: <String>['final-1'],
          sources: <CoachingSourceEntity>[],
          confidence: 0.93,
        ),
        generatedAt: now,
        provider: 'test',
        model: 'test-model',
      ),
      isOperating: false,
      operationFailure: null,
      realtimeFailure: null,
      finalizationMessage: 'Débrief final disponible.',
    );

    await _pumpContent(tester, state);

    expect(find.text('Une amélioration pour le prochain call'), findsOneWidget);
    expect(
      find.text('Confirme le devis et le créneau de mardi.'),
      findsOneWidget,
    );
    expect(find.text('Transcription complète'), findsOneWidget);
    expect(
      find.text('La conversation est conservée. Tu peux revenir au téléphone.'),
      findsNothing,
    );
    expect(find.text('Retour au téléphone'), findsOneWidget);
    expect(find.text('Profil de compétences'), findsNothing);
    expect(find.text('Tes points forts'), findsNothing);
    expect(find.text('Tes phrases, en mieux'), findsNothing);
    expect(find.text('Conseils pour aller plus loin'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the complete coaching overview and accessible radar', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final SemanticsHandle semantics = tester.ensureSemantics();
    final DateTime now = DateTime.now().toUtc();
    final TranscriptSegmentEntity segment = TranscriptSegmentEntity(
      id: 'seller-1',
      sessionId: 'session',
      sequence: 1,
      speaker: TranscriptSpeaker.seller,
      text: 'Je voulais peut-être vous présenter notre plateforme.',
      startedAt: now,
      isFinal: true,
    );
    final ActiveCallState state = ActiveCallState(
      session: const CallStateEntity(
        callId: 'call',
        direction: CallDirection.outgoing,
        status: CallLifecycleStatus.ended,
        remoteNumber: '+33123456789',
      ),
      processingSession: ConversationSessionEntity(
        id: 'session',
        callId: 'correlation',
        status: ConversationSessionStatus.completed,
        coachMode: CoachMode.live,
        createdAt: now,
        transcriptionConsentAcknowledged: true,
      ),
      isCompanion: false,
      elapsed: const Duration(minutes: 6, seconds: 12),
      transcript: <TranscriptSegmentEntity>[segment],
      suggestion: null,
      finalTranscript: ConversationTranscriptEntity(
        sessionId: 'session',
        segments: <TranscriptSegmentEntity>[segment],
        finalizedAt: now,
      ),
      debrief: CallDebriefEntity(
        sessionId: 'session',
        summary: const GroundedCallTextEntity(
          text: 'Le prospect comprend la proposition mais attend une preuve.',
          evidenceSegmentIds: <String>['seller-1'],
        ),
        keyPoints: const <GroundedCallTextEntity>[],
        commitments: const <CallCommitmentEntity>[],
        followUp: const CallFollowUpEntity(
          subject: 'La preuve demandée',
          body: 'Voici le cas client évoqué pendant notre échange.',
          evidenceSegmentIds: <String>['seller-1'],
        ),
        strengths: const <GroundedCallTextEntity>[
          GroundedCallTextEntity(
            text: 'Tu relies clairement la solution au contexte du prospect.',
            evidenceSegmentIds: <String>['seller-1'],
          ),
        ],
        performanceAxes: const <CallPerformanceAxisEntity>[
          CallPerformanceAxisEntity(
            axis: CallPerformanceAxis.listening,
            score: 78,
            signal: CallPerformanceSignal.balanced,
            observation: 'Tu laisses le prospect développer ses réponses.',
            evidenceSegmentIds: <String>['seller-1'],
          ),
          CallPerformanceAxisEntity(
            axis: CallPerformanceAxis.discovery,
            score: 61,
            signal: CallPerformanceSignal.tooLow,
            observation:
                'Une question supplémentaire aurait précisé le besoin.',
            evidenceSegmentIds: <String>['seller-1'],
          ),
          CallPerformanceAxisEntity(
            axis: CallPerformanceAxis.clarity,
            score: 68,
            signal: CallPerformanceSignal.balanced,
            observation: 'Le message reste compréhensible et structuré.',
            evidenceSegmentIds: <String>['seller-1'],
          ),
          CallPerformanceAxisEntity(
            axis: CallPerformanceAxis.confidence,
            score: 49,
            signal: CallPerformanceSignal.tooLow,
            observation: 'Les hésitations affaiblissent l’entrée en matière.',
            evidenceSegmentIds: <String>['seller-1'],
          ),
          CallPerformanceAxisEntity(
            axis: CallPerformanceAxis.value,
            score: 84,
            signal: CallPerformanceSignal.tooHigh,
            observation: 'La valeur arrive avant une exploration suffisante.',
            evidenceSegmentIds: <String>['seller-1'],
          ),
          CallPerformanceAxisEntity(
            axis: CallPerformanceAxis.personalization,
            score: 72,
            signal: CallPerformanceSignal.balanced,
            observation: 'Le contexte du prospect nourrit la formulation.',
            evidenceSegmentIds: <String>['seller-1'],
          ),
          CallPerformanceAxisEntity(
            axis: CallPerformanceAxis.progression,
            score: 65,
            signal: CallPerformanceSignal.balanced,
            observation: 'La conversation avance vers une prochaine étape.',
            evidenceSegmentIds: <String>['seller-1'],
          ),
          CallPerformanceAxisEntity(
            axis: CallPerformanceAxis.naturalness,
            score: 58,
            signal: CallPerformanceSignal.tooLow,
            observation: 'Le pitch pourrait être plus conversationnel.',
            evidenceSegmentIds: <String>['seller-1'],
          ),
        ],
        phraseCoaching: const <PhraseCoachingEntity>[
          PhraseCoachingEntity(
            focus: PhraseCoachingFocus.confidence,
            originalText:
                'Je voulais peut-être vous présenter notre plateforme.',
            improvedText:
                'Je vous appelle pour voir si nous pouvons simplifier votre suivi commercial.',
            rationale:
                'La nouvelle version supprime l’hésitation et commence par le bénéfice.',
            evidenceSegmentIds: <String>['seller-1'],
            sources: <CoachingSourceEntity>[],
            confidence: 0.92,
          ),
        ],
        strategicAdvice: const <StrategicCallAdviceEntity>[
          StrategicCallAdviceEntity(
            category: StrategicAdviceCategory.marketing,
            priority: AdvicePriority.high,
            title: 'Ancre le pitch dans une preuve concrète',
            advice:
                'Prépare un cas client court relié au problème principal du prospect.',
            rationale:
                'Le prospect demande une preuve avant de poursuivre la discussion.',
            evidenceSegmentIds: <String>['seller-1'],
            sources: <CoachingSourceEntity>[],
            confidence: 0.9,
          ),
        ],
        improvement: const CallImprovementEntity(
          recommendationId: 'rec-confidence',
          text: 'Commence directement par le résultat utile au prospect.',
          rationale: 'L’ouverture actuelle contient plusieurs hésitations.',
          evidenceSegmentIds: <String>['seller-1'],
          sources: <CoachingSourceEntity>[],
          confidence: 0.91,
        ),
        generatedAt: now,
        provider: 'test',
        model: 'test-model',
      ),
      isOperating: false,
      operationFailure: null,
      realtimeFailure: null,
      finalizationMessage: 'Débrief final disponible.',
    );

    await _pumpContent(tester, state);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('debrief_performance_radar')), findsOneWidget);
    expect(find.text('Profil de compétences'), findsOneWidget);
    expect(find.text('Tes points forts'), findsOneWidget);
    expect(find.text('Tes phrases, en mieux'), findsOneWidget);
    expect(find.text('Phrase originale'), findsOneWidget);
    expect(find.text('Formulation proposée'), findsOneWidget);
    expect(find.text('Conseils pour aller plus loin'), findsOneWidget);
    expect(
      find.text('Interprétation IA · aucune source du catalogue associée'),
      findsNWidgets(2),
    );
    expect(
      find.text('Ancre le pitch dans une preuve concrète'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(
        RegExp('Profil de compétences commerciales.*Écoute 78 sur 100'),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(390, 844);
    await _pumpContent(tester, state);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('debrief_performance_radar')), findsOneWidget);
    expect(find.text('Formulation proposée'), findsOneWidget);
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });
}

Future<void> _pumpContent(
  WidgetTester tester,
  ActiveCallState state, {
  Future<void> Function(bool enabled)? onCoachChanged,
  Future<void> Function()? onToggleSpeaker,
  Future<void> Function(AudioDeviceKind kind, String deviceId)?
  onSelectAudioDevice,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: PinkallTheme.light,
      home: Scaffold(
        body: ActiveCallContent(
          state: state,
          onToggleMute: () async {},
          onToggleSpeaker: onToggleSpeaker ?? () async {},
          onSelectAudioDevice:
              onSelectAudioDevice ??
              (AudioDeviceKind kind, String deviceId) async {},
          onRefreshAudioDevices: () async {},
          onCoachChanged: onCoachChanged ?? (bool enabled) async {},
          onAcknowledgeTranscription:
              (TranscriptionConsentMethod method) async {},
          onEndCall: () async => true,
          onRetryDebrief: () async {},
          onReturn: () async {},
        ),
      ),
    ),
  );
}

ActiveCallState _activeState({
  required DateTime now,
  required CoachMode coachMode,
  required List<TranscriptSegmentEntity> transcript,
  CoachingSuggestionEntity? suggestion,
  CoachAnalysisStatus coachAnalysisStatus = CoachAnalysisStatus.listening,
  CoachAnalysisOutcome? coachAnalysisOutcome,
}) => ActiveCallState(
  session: const CallStateEntity(
    callId: 'call',
    direction: CallDirection.outgoing,
    status: CallLifecycleStatus.active,
    remoteNumber: '+33123456789',
  ),
  processingSession: ConversationSessionEntity(
    id: 'session',
    callId: 'correlation',
    status: ConversationSessionStatus.active,
    coachMode: coachMode,
    createdAt: now,
    transcriptionConsentAcknowledged: true,
  ),
  isCompanion: false,
  elapsed: const Duration(minutes: 4, seconds: 18),
  transcript: transcript,
  suggestion: suggestion,
  coachAnalysisStatus: coachAnalysisStatus,
  coachAnalysisOutcome: coachAnalysisOutcome,
  finalTranscript: null,
  debrief: null,
  isOperating: false,
  operationFailure: null,
  realtimeFailure: null,
  finalizationMessage: null,
);
