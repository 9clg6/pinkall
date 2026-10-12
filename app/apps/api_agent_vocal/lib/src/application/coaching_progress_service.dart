import 'package:api_agent_vocal/src/domain/coaching_progress_models.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';
import 'package:api_agent_vocal/src/domain/store_contract.dart';
import 'package:api_agent_vocal/src/domain/transcript_metrics.dart';

/// Builds a workspace-level progress profile from durable call artifacts.
final class CoachingProgressService {
  const CoachingProgressService({required this.store});

  final PinkallStore store;

  /// Compares the latest [windowSize] analyzed calls with the preceding window.
  CoachingProgressSnapshot build({
    int windowSize = 5,
    int recentLimit = 20,
    DateTime? now,
  }) {
    if (windowSize < 1 || windowSize > 20) {
      throw ArgumentError.value(windowSize, 'windowSize', 'must be 1..20');
    }
    if (recentLimit < 1 || recentLimit > 50) {
      throw ArgumentError.value(recentLimit, 'recentLimit', 'must be 1..50');
    }

    final List<CallSessionSnapshot> sessions = store.listSessions();
    final List<_AnalyzedCall> analyzed = <_AnalyzedCall>[];
    for (final CallSessionSnapshot session in sessions) {
      final PostCallDebrief? debrief = store.postCallDebrief(session.id);
      if (debrief == null ||
          debrief.performanceRubricVersion !=
              PostCallDebrief.currentPerformanceRubricVersion ||
          !_hasCompleteAxes(debrief.performanceAxes)) {
        continue;
      }
      final List<TranscriptSegment>? transcript = store.finalTranscript(
        session.id,
      );
      analyzed.add(
        _AnalyzedCall(
          session: session,
          debrief: debrief,
          metrics: transcript == null || transcript.isEmpty
              ? null
              : TranscriptMetricsCalculator.calculate(transcript),
        ),
      );
    }
    analyzed.sort(
      (_AnalyzedCall left, _AnalyzedCall right) =>
          left.occurredAt.compareTo(right.occurredAt),
    );

    final int currentStart = analyzed.length > windowSize
        ? analyzed.length - windowSize
        : 0;
    final List<_AnalyzedCall> current = analyzed.sublist(currentStart);
    final int previousStart = currentStart > windowSize
        ? currentStart - windowSize
        : 0;
    final List<_AnalyzedCall> previous = analyzed.sublist(
      previousStart,
      currentStart,
    );
    final List<CoachingProgressAxis> axes = _aggregateAxes(current, previous);
    final int recentStart = analyzed.length > recentLimit
        ? analyzed.length - recentLimit
        : 0;
    final List<CoachingProgressCall> recentCalls = analyzed
        .sublist(recentStart)
        .reversed
        .map(
          (_AnalyzedCall call) => CoachingProgressCall(
            sessionId: call.session.id,
            callId: call.session.callId,
            occurredAt: call.occurredAt,
            destinationNumber: call.session.destinationNumber,
            outcome: call.session.outcome,
            performanceAxes: call.debrief.performanceAxes,
            observedMetrics: call.metrics,
          ),
        )
        .toList(growable: false);
    final List<CoachingProgressAxis> sortedAxes = axes.toList(growable: false)
      ..sort(
        (CoachingProgressAxis left, CoachingProgressAxis right) =>
            left.currentScore.compareTo(right.currentScore),
      );
    return CoachingProgressSnapshot(
      generatedAt: (now ?? DateTime.now()).toUtc(),
      sessionCount: sessions.length,
      analyzedCallCount: analyzed.length,
      currentWindowSize: current.length,
      previousWindowSize: previous.length,
      axes: axes,
      observedMetrics: _aggregateMetrics(current, previous),
      recentCalls: recentCalls,
      focus: sortedAxes.isEmpty ? null : sortedAxes.first,
      strength: sortedAxes.isEmpty ? null : sortedAxes.last,
    );
  }

  static bool _hasCompleteAxes(List<PostCallPerformanceAxis> axes) {
    final Set<PostCallPerformanceAxisName> names = axes
        .map((PostCallPerformanceAxis axis) => axis.axis)
        .toSet();
    return axes.length == PostCallPerformanceAxisName.values.length &&
        names.length == PostCallPerformanceAxisName.values.length;
  }

  static List<CoachingProgressAxis> _aggregateAxes(
    List<_AnalyzedCall> current,
    List<_AnalyzedCall> previous,
  ) {
    if (current.isEmpty) {
      return const <CoachingProgressAxis>[];
    }
    return PostCallPerformanceAxisName.values
        .map((PostCallPerformanceAxisName name) {
          final List<PostCallPerformanceAxis> currentAxes = current
              .map((_AnalyzedCall call) => _axis(call, name))
              .toList(growable: false);
          final List<PostCallPerformanceAxis> previousAxes = previous
              .map((_AnalyzedCall call) => _axis(call, name))
              .toList(growable: false);
          final int currentScore = _roundedIntAverage(
            currentAxes.map((PostCallPerformanceAxis axis) => axis.score),
          );
          final int? previousScore = previousAxes.isEmpty
              ? null
              : _roundedIntAverage(
                  previousAxes.map(
                    (PostCallPerformanceAxis axis) => axis.score,
                  ),
                );
          return CoachingProgressAxis(
            axis: name,
            currentScore: currentScore,
            previousScore: previousScore,
            delta: previousScore == null ? null : currentScore - previousScore,
            signal: _dominantSignal(currentAxes),
            observation: currentAxes.last.observation,
            sampleCount: currentAxes.length,
          );
        })
        .toList(growable: false);
  }

  static PostCallPerformanceAxis _axis(
    _AnalyzedCall call,
    PostCallPerformanceAxisName name,
  ) {
    return call.debrief.performanceAxes.firstWhere(
      (PostCallPerformanceAxis axis) => axis.axis == name,
    );
  }

  static PostCallPerformanceSignal _dominantSignal(
    List<PostCallPerformanceAxis> axes,
  ) {
    final Map<PostCallPerformanceSignal, int> counts =
        <PostCallPerformanceSignal, int>{};
    for (final PostCallPerformanceAxis axis in axes) {
      counts.update(axis.signal, (int count) => count + 1, ifAbsent: () => 1);
    }
    final int maximum = counts.values.fold<int>(
      0,
      (int a, int b) => a > b ? a : b,
    );
    for (final PostCallPerformanceAxis axis in axes.reversed) {
      if (counts[axis.signal] == maximum) {
        return axis.signal;
      }
    }
    return PostCallPerformanceSignal.balanced;
  }

  static Map<String, CoachingProgressMetric> _aggregateMetrics(
    List<_AnalyzedCall> current,
    List<_AnalyzedCall> previous,
  ) {
    final List<TranscriptMetrics> currentMetrics = current
        .map((_AnalyzedCall call) => call.metrics)
        .whereType<TranscriptMetrics>()
        .toList(growable: false);
    final List<TranscriptMetrics> previousMetrics = previous
        .map((_AnalyzedCall call) => call.metrics)
        .whereType<TranscriptMetrics>()
        .toList(growable: false);
    return <String, CoachingProgressMetric>{
      'seller_talk_ratio': _metric(
        currentMetrics.map((TranscriptMetrics item) => item.sellerTalkRatio),
        previousMetrics.map((TranscriptMetrics item) => item.sellerTalkRatio),
      ),
      'question_count': _metric(
        currentMetrics.map(
          (TranscriptMetrics item) => item.questionCount.toDouble(),
        ),
        previousMetrics.map(
          (TranscriptMetrics item) => item.questionCount.toDouble(),
        ),
      ),
      'average_seller_turn_seconds': _metric(
        currentMetrics.map(
          (TranscriptMetrics item) => item.averageSellerTurnSeconds,
        ),
        previousMetrics.map(
          (TranscriptMetrics item) => item.averageSellerTurnSeconds,
        ),
      ),
      'longest_seller_turn_seconds': _metric(
        currentMetrics.map(
          (TranscriptMetrics item) => item.longestSellerTurnSeconds,
        ),
        previousMetrics.map(
          (TranscriptMetrics item) => item.longestSellerTurnSeconds,
        ),
      ),
      'hesitation_count': _metric(
        currentMetrics.map(
          (TranscriptMetrics item) => item.hesitationCount.toDouble(),
        ),
        previousMetrics.map(
          (TranscriptMetrics item) => item.hesitationCount.toDouble(),
        ),
      ),
      'questions_per_minute': _metric(
        currentMetrics.map((TranscriptMetrics item) => item.questionsPerMinute),
        previousMetrics.map(
          (TranscriptMetrics item) => item.questionsPerMinute,
        ),
      ),
      'hesitations_per_minute': _metric(
        currentMetrics.map(
          (TranscriptMetrics item) => item.hesitationsPerMinute,
        ),
        previousMetrics.map(
          (TranscriptMetrics item) => item.hesitationsPerMinute,
        ),
      ),
    };
  }

  static CoachingProgressMetric _metric(
    Iterable<double> current,
    Iterable<double> previous,
  ) {
    final List<double> currentValues = current.toList(growable: false);
    final List<double> previousValues = previous.toList(growable: false);
    final double? currentAverage = currentValues.isEmpty
        ? null
        : _roundedAverage(currentValues);
    final double? previousAverage = previousValues.isEmpty
        ? null
        : _roundedAverage(previousValues);
    return CoachingProgressMetric(
      current: currentAverage,
      previous: previousAverage,
      delta: currentAverage == null || previousAverage == null
          ? null
          : _rounded(currentAverage - previousAverage),
      sampleCount: currentValues.length,
    );
  }

  static int _roundedIntAverage(Iterable<int> values) {
    final List<int> items = values.toList(growable: false);
    return (items.fold<int>(0, (int total, int value) => total + value) /
            items.length)
        .round();
  }

  static double _roundedAverage(List<double> values) => _rounded(
    values.fold<double>(0, (double total, double value) => total + value) /
        values.length,
  );

  static double _rounded(double value) => (value * 1000).round() / 1000;
}

final class _AnalyzedCall {
  const _AnalyzedCall({
    required this.session,
    required this.debrief,
    required this.metrics,
  });

  final CallSessionSnapshot session;
  final PostCallDebrief debrief;
  final TranscriptMetrics? metrics;

  DateTime get occurredAt =>
      session.endedAt ?? session.startedAt ?? debrief.generatedAt;
}
