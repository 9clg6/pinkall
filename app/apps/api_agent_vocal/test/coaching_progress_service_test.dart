import 'dart:convert';

import 'package:api_agent_vocal/src/application/coaching_progress_service.dart';
import 'package:api_agent_vocal/src/domain/coaching_progress_models.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/transcript_metrics.dart';
import 'package:api_agent_vocal/src/infrastructure/store/in_memory_poc_store.dart';
import 'package:test/test.dart';

void main() {
  test('returns an explicit empty profile without inventing scores', () {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    addTearDown(store.dispose);

    final CoachingProgressSnapshot snapshot = CoachingProgressService(
      store: store,
    ).build(now: DateTime.utc(2026, 7, 14));

    expect(snapshot.sessionCount, 0);
    expect(snapshot.analyzedCallCount, 0);
    expect(snapshot.axes, isEmpty);
    expect(snapshot.focus, isNull);
    expect(snapshot.strength, isNull);
    expect(snapshot.observedMetrics['seller_talk_ratio']?.current, isNull);
    expect(jsonEncode(snapshot.toJson()), isNot(contains('overall_score')));
  });

  test('compares recent calls with the preceding window axis by axis', () {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    addTearDown(store.dispose);
    for (final (int index, int baseScore) in <(int, int)>[
      (1, 30),
      (2, 40),
      (3, 60),
      (4, 70),
    ]) {
      _addAnalyzedCall(store, index: index, baseScore: baseScore);
    }

    final CoachingProgressSnapshot snapshot = CoachingProgressService(
      store: store,
    ).build(windowSize: 2, recentLimit: 3, now: DateTime.utc(2026, 7, 14));

    expect(snapshot.sessionCount, 4);
    expect(snapshot.analyzedCallCount, 4);
    expect(snapshot.currentWindowSize, 2);
    expect(snapshot.previousWindowSize, 2);
    expect(snapshot.axes, hasLength(8));
    expect(snapshot.axes.first.axis, PostCallPerformanceAxisName.listening);
    expect(snapshot.axes.first.currentScore, 65);
    expect(snapshot.axes.first.previousScore, 35);
    expect(snapshot.axes.first.delta, 30);
    expect(snapshot.axes.first.observation, 'call-4-listening');
    expect(snapshot.focus?.axis, PostCallPerformanceAxisName.listening);
    expect(snapshot.strength?.axis, PostCallPerformanceAxisName.naturalness);
    expect(snapshot.recentCalls, hasLength(3));
    expect(snapshot.recentCalls.first.callId, 'call-4');
    expect(snapshot.recentCalls.first.destinationNumber, '+33100000004');
    expect(snapshot.recentCalls.first.toJson()['call_id'], 'call-4');
    expect(snapshot.observedMetrics['seller_talk_ratio']?.current, 0.5);
    expect(snapshot.observedMetrics['questions_per_minute']?.current, 1);
    expect(snapshot.observedMetrics['hesitations_per_minute']?.current, 1);
  });

  test(
    'excludes incomplete radar artifacts but keeps session coverage honest',
    () {
      final InMemoryPocStore store = InMemoryPocStore(
        maxSessionAudioBytes: 1024,
      );
      addTearDown(store.dispose);
      _addAnalyzedCall(store, index: 1, baseScore: 50);
      final CallSessionSnapshot incomplete = store.createSession(
        callId: 'call-incomplete',
        destinationNumber: '+33100000009',
        contactId: null,
        coachMode: CoachMode.off,
        sellerTrack: MediaTrack.outbound,
      );
      store.replaceFinalTranscript(incomplete.id, <TranscriptSegment>[
        _segment('incomplete-seller', SpeakerRole.seller, 0, 10, 'Bonjour ?'),
      ]);
      store.savePostCallDebrief(
        incomplete.id,
        _debrief(incomplete.id, index: 9, baseScore: 50, axisCount: 1),
      );

      final CoachingProgressSnapshot snapshot = CoachingProgressService(
        store: store,
      ).build();

      expect(snapshot.sessionCount, 2);
      expect(snapshot.analyzedCallCount, 1);
      expect(snapshot.axes, hasLength(8));
    },
  );

  test('derives factual metrics from speaker-labelled transcript timing', () {
    final TranscriptMetrics metrics =
        TranscriptMetricsCalculator.calculate(<TranscriptSegment>[
          _segment('s1', SpeakerRole.seller, 0, 30, 'Euh, pourquoi ?'),
          _segment('p1', SpeakerRole.prospect, 30, 40, 'Parce que.'),
          _segment('s2', SpeakerRole.seller, 40, 50, 'Hum, ensuite ?'),
          _segment('p2', SpeakerRole.prospect, 50, 60, 'On avance.'),
        ]);

    expect(metrics.sellerTalkRatio, 0.667);
    expect(metrics.questionCount, 2);
    expect(metrics.averageSellerTurnSeconds, 20);
    expect(metrics.longestSellerTurnSeconds, 30);
    expect(metrics.hesitationCount, 2);
    expect(metrics.questionsPerMinute, 2);
    expect(metrics.hesitationsPerMinute, 2);
  });

  test('merges adjacent STT fragments into natural seller turns', () {
    final TranscriptMetrics metrics =
        TranscriptMetricsCalculator.calculate(<TranscriptSegment>[
          _segment('s1', SpeakerRole.seller, 0, 2, 'Bonjour,'),
          _segment('s2', SpeakerRole.seller, 2.4, 5, 'comment allez-vous ?'),
          _segment('s3', SpeakerRole.seller, 7, 9, 'Je reprends.'),
          _segment('p1', SpeakerRole.prospect, 9, 11, 'Très bien.'),
          _segment('s4', SpeakerRole.seller, 11, 12, 'Parfait.'),
        ]);

    expect(metrics.averageSellerTurnSeconds, closeTo(2.667, 0.001));
    expect(metrics.longestSellerTurnSeconds, 5);
  });

  test('does not compare calls scored with another rubric version', () {
    final InMemoryPocStore store = InMemoryPocStore(maxSessionAudioBytes: 1024);
    addTearDown(store.dispose);
    final CallSessionSnapshot session = store.createSession(
      callId: 'future-rubric',
      destinationNumber: '+33100000000',
      contactId: null,
      coachMode: CoachMode.off,
      sellerTrack: MediaTrack.outbound,
    );
    store.replaceFinalTranscript(session.id, <TranscriptSegment>[
      _segment('future-seller', SpeakerRole.seller, 0, 5, 'Bonjour.'),
    ]);
    store.savePostCallDebrief(
      session.id,
      _debrief(
        session.id,
        index: 1,
        baseScore: 70,
        performanceRubricVersion: 'performance-v2',
      ),
    );

    final CoachingProgressSnapshot snapshot = CoachingProgressService(
      store: store,
    ).build();

    expect(snapshot.sessionCount, 1);
    expect(snapshot.analyzedCallCount, 0);
  });
}

void _addAnalyzedCall(
  InMemoryPocStore store, {
  required int index,
  required int baseScore,
}) {
  final CallSessionSnapshot session = store.createSession(
    callId: 'call-$index',
    destinationNumber: '+3310000000$index',
    contactId: null,
    coachMode: CoachMode.off,
    sellerTrack: MediaTrack.outbound,
  );
  store.replaceFinalTranscript(session.id, <TranscriptSegment>[
    _segment('seller-$index', SpeakerRole.seller, 0, 30, 'Euh, pourquoi ?'),
    _segment('prospect-$index', SpeakerRole.prospect, 30, 60, 'Parce que.'),
  ]);
  store.savePostCallDebrief(
    session.id,
    _debrief(session.id, index: index, baseScore: baseScore),
  );
}

PostCallDebrief _debrief(
  String sessionId, {
  required int index,
  required int baseScore,
  int axisCount = 8,
  String performanceRubricVersion =
      PostCallDebrief.currentPerformanceRubricVersion,
}) {
  return PostCallDebrief(
    sessionId: sessionId,
    summary: const PostCallGroundedText(
      text: 'Résumé',
      evidenceSegmentIds: <String>[],
    ),
    keyPoints: const <PostCallGroundedText>[],
    commitments: const <PostCallCommitment>[],
    followUp: const PostCallFollowUp(
      subject: 'Suite',
      body: 'Merci',
      nextAction: null,
      dueAt: null,
      evidenceSegmentIds: <String>[],
    ),
    improvement: null,
    generatedAt: DateTime.utc(2026, 7, index),
    provider: 'test',
    model: 'test',
    performanceRubricVersion: performanceRubricVersion,
    performanceAxes: PostCallPerformanceAxisName.values
        .take(axisCount)
        .indexed
        .map(
          ((int, PostCallPerformanceAxisName) item) => PostCallPerformanceAxis(
            axis: item.$2,
            score: baseScore + item.$1,
            signal: PostCallPerformanceSignal.balanced,
            observation: 'call-$index-${item.$2.name}',
            evidenceSegmentIds: const <String>[],
          ),
        )
        .toList(growable: false),
  );
}

TranscriptSegment _segment(
  String id,
  SpeakerRole speaker,
  double start,
  double end,
  String text,
) {
  return TranscriptSegment(
    id: id,
    track: speaker == SpeakerRole.seller
        ? MediaTrack.outbound
        : MediaTrack.inbound,
    speaker: speaker,
    text: text,
    startSeconds: start,
    endSeconds: end,
    isFinal: true,
    provider: 'test',
    createdAt: DateTime.utc(2026, 7, 14),
  );
}
