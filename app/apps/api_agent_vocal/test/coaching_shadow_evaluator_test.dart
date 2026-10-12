import 'package:api_agent_vocal/src/application/coaching_shadow_evaluator.dart';
import 'package:api_agent_vocal/src/domain/coaching_quality_models.dart';
import 'package:test/test.dart';

void main() {
  const CoachingShadowPolicy policy = CoachingShadowPolicy(
    version: 'test-v1',
    minimumLabelledCases: 4,
    minimumPrecision: 0.8,
    maximumFalsePositiveRate: 0.1,
    minimumSourceFidelity: 1,
    maximumP95LatencyMilliseconds: 350,
    maximumAverageCostUsd: 0.001,
  );

  test('measures quality, grounding, latency and cost without hiding gaps', () {
    final CoachingShadowEvaluationReport report =
        const CoachingShadowEvaluator().evaluate(
          cases: const <CoachingShadowCase>[
            CoachingShadowCase(
              id: 'positive-1',
              shouldSuggest: true,
              acceptedRecommendationIds: <String>['rec-1'],
              labelVersion: 1,
              reviewerIds: <String>['reviewer-a'],
            ),
            CoachingShadowCase(
              id: 'positive-2',
              shouldSuggest: true,
              acceptedRecommendationIds: <String>['rec-2'],
              labelVersion: 1,
              reviewerIds: <String>['reviewer-a'],
            ),
            CoachingShadowCase(
              id: 'negative-1',
              shouldSuggest: false,
              acceptedRecommendationIds: <String>[],
              labelVersion: 1,
              reviewerIds: <String>['reviewer-b'],
            ),
            CoachingShadowCase(
              id: 'negative-2',
              shouldSuggest: false,
              acceptedRecommendationIds: <String>[],
              labelVersion: 1,
              reviewerIds: <String>['reviewer-b'],
            ),
          ],
          observations: const <CoachingShadowObservation>[
            CoachingShadowObservation(
              caseId: 'positive-1',
              selectedRecommendationId: 'rec-1',
              citedSourceIds: <String>['source-1'],
              latencyMilliseconds: 100,
              inputTokens: 10,
              outputTokens: 2,
              estimatedCostUsd: 0.001,
              pricingVersion: 'provider-2026-07-14',
            ),
            CoachingShadowObservation(
              caseId: 'positive-2',
              selectedRecommendationId: 'rec-1',
              citedSourceIds: <String>['source-1'],
              latencyMilliseconds: 200,
              inputTokens: 10,
              outputTokens: 2,
            ),
            CoachingShadowObservation(
              caseId: 'negative-1',
              selectedRecommendationId: 'rec-1',
              citedSourceIds: <String>['invented-source'],
              latencyMilliseconds: 300,
              inputTokens: 10,
              outputTokens: 2,
              estimatedCostUsd: 0.002,
              pricingVersion: 'provider-2026-07-14',
            ),
            CoachingShadowObservation(
              caseId: 'negative-2',
              citedSourceIds: <String>[],
              latencyMilliseconds: 400,
              inputTokens: 10,
              outputTokens: 2,
              estimatedCostUsd: 0.001,
              pricingVersion: 'provider-2026-07-14',
            ),
            CoachingShadowObservation(
              caseId: 'positive-1',
              citedSourceIds: <String>[],
              latencyMilliseconds: 999,
              inputTokens: 999,
              outputTokens: 999,
            ),
            CoachingShadowObservation(
              caseId: 'unknown',
              citedSourceIds: <String>[],
              latencyMilliseconds: 999,
              inputTokens: 999,
              outputTokens: 999,
            ),
          ],
          recommendationSourceIds: const <String, Set<String>>{
            'rec-1': <String>{'source-1'},
            'rec-2': <String>{'source-2'},
          },
          policy: policy,
        );

    expect(report.labelledCaseCount, 4);
    expect(report.observationCount, 4);
    expect(report.suggestionCount, 3);
    expect(report.correctSuggestionCount, 1);
    expect(report.falsePositiveCount, 1);
    expect(report.incorrectSelectionCount, 1);
    expect(report.sourceFaithfulCount, 2);
    expect(report.duplicateObservationCount, 1);
    expect(report.unknownCaseObservationCount, 1);
    expect(report.precision, closeTo(1 / 3, 0.000001));
    expect(report.falsePositiveRate, 0.5);
    expect(report.recall, 0.5);
    expect(report.sourceFidelity, closeTo(2 / 3, 0.000001));
    expect(report.p50LatencyMilliseconds, 200);
    expect(report.p95LatencyMilliseconds, 400);
    expect(report.totalInputTokens, 40);
    expect(report.totalOutputTokens, 8);
    expect(report.totalEstimatedCostUsd, closeTo(0.004, 0.000001));
    expect(report.averageEstimatedCostUsd, closeTo(0.004 / 3, 0.000001));
    expect(report.observationCoverage, 1);
    expect(report.costCoverage, 0.75);
    expect(report.gates['labelled_cases'], 'pass');
    expect(report.gates['precision'], 'fail');
    expect(report.gates['false_positive_rate'], 'fail');
    expect(report.gates['source_fidelity'], 'fail');
    expect(report.gates['observation_coverage'], 'pass');
    expect(report.gates['cost_coverage'], 'insufficient_data');
    expect(report.gates['p95_latency'], 'fail');
    expect(report.gates['average_cost'], 'fail');
    expect(report.gates['data_integrity'], 'fail');
    expect(report.passesConfiguredGates, isFalse);
  });

  test('keeps undefined rates null when no suggestion or label exists', () {
    final CoachingShadowEvaluationReport report =
        const CoachingShadowEvaluator().evaluate(
          cases: const <CoachingShadowCase>[],
          observations: const <CoachingShadowObservation>[],
          recommendationSourceIds: const <String, Set<String>>{},
          policy: policy,
        );

    expect(report.precision, isNull);
    expect(report.falsePositiveRate, isNull);
    expect(report.recall, isNull);
    expect(report.sourceFidelity, isNull);
    expect(report.p50LatencyMilliseconds, isNull);
    expect(report.p95LatencyMilliseconds, isNull);
    expect(report.averageEstimatedCostUsd, isNull);
    expect(report.totalEstimatedCostUsd, isNull);
    expect(report.observationCoverage, 0);
    expect(report.costCoverage, 0);
    expect(report.gates.values, contains('insufficient_data'));
  });

  test('requires human labels and a versioned price for cost coverage', () {
    expect(
      () => CoachingShadowCase.fromJson(<String, Object?>{
        'id': 'positive',
        'should_suggest': true,
        'accepted_recommendation_ids': <String>['rec-1'],
        'label_version': 1,
        'reviewer_ids': <String>[],
      }),
      throwsFormatException,
    );
    final CoachingShadowObservation observation =
        CoachingShadowObservation.fromJson(<String, Object?>{
          'case_id': 'case-1',
          'selected_recommendation_id': null,
          'cited_source_ids': <String>[],
          'latency_ms': 50,
          'input_tokens': 1,
          'output_tokens': 1,
          'estimated_cost_usd': 0.01,
        });
    expect(observation.estimatedCostUsd, 0.01);
    expect(observation.pricingVersion, isNull);
  });
}
