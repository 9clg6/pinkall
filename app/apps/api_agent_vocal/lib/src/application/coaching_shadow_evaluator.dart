import 'dart:math' as math;

import 'package:api_agent_vocal/src/domain/coaching_quality_models.dart';

/// Deterministic evaluator for human-labelled coaching shadow decisions.
final class CoachingShadowEvaluator {
  /// Creates a stateless evaluator.
  const CoachingShadowEvaluator();

  /// Evaluates one observation per labelled case.
  ///
  /// [recommendationSourceIds] is derived from the exact catalogue version
  /// under test. It prevents a model-produced source identifier from being
  /// counted as faithful when that source does not back the selected card.
  CoachingShadowEvaluationReport evaluate({
    required List<CoachingShadowCase> cases,
    required List<CoachingShadowObservation> observations,
    required Map<String, Set<String>> recommendationSourceIds,
    required CoachingShadowPolicy policy,
  }) {
    final Map<String, CoachingShadowCase> casesById =
        <String, CoachingShadowCase>{};
    for (final CoachingShadowCase item in cases) {
      if (casesById.containsKey(item.id)) {
        throw FormatException('Duplicate shadow case id: ${item.id}.');
      }
      casesById[item.id] = item;
    }

    final Map<String, CoachingShadowObservation> observationsByCase =
        <String, CoachingShadowObservation>{};
    int duplicateObservationCount = 0;
    int unknownCaseObservationCount = 0;
    for (final CoachingShadowObservation observation in observations) {
      if (!casesById.containsKey(observation.caseId)) {
        unknownCaseObservationCount += 1;
        continue;
      }
      if (observationsByCase.containsKey(observation.caseId)) {
        duplicateObservationCount += 1;
        continue;
      }
      observationsByCase[observation.caseId] = observation;
    }

    int suggestionCount = 0;
    int correctSuggestionCount = 0;
    int falsePositiveCount = 0;
    int incorrectSelectionCount = 0;
    int sourceFaithfulCount = 0;
    int positiveCaseCount = 0;
    int negativeCaseCount = 0;
    int costedObservationCount = 0;
    int totalInputTokens = 0;
    int totalOutputTokens = 0;
    double totalEstimatedCostUsd = 0;
    final List<int> latencies = <int>[];

    for (final CoachingShadowCase item in cases) {
      if (item.shouldSuggest) {
        positiveCaseCount += 1;
      } else {
        negativeCaseCount += 1;
      }
      final CoachingShadowObservation? observation =
          observationsByCase[item.id];
      if (observation == null) {
        continue;
      }
      latencies.add(observation.latencyMilliseconds);
      totalInputTokens += observation.inputTokens;
      totalOutputTokens += observation.outputTokens;
      if (observation.estimatedCostUsd != null &&
          observation.pricingVersion != null) {
        costedObservationCount += 1;
        totalEstimatedCostUsd += observation.estimatedCostUsd!;
      }
      final String? recommendationId = observation.selectedRecommendationId;
      if (recommendationId == null) {
        continue;
      }
      suggestionCount += 1;
      final bool accepted =
          item.shouldSuggest &&
          item.acceptedRecommendationIds.contains(recommendationId);
      if (accepted) {
        correctSuggestionCount += 1;
      } else if (!item.shouldSuggest) {
        falsePositiveCount += 1;
      } else {
        incorrectSelectionCount += 1;
      }
      final Set<String>? allowedSourceIds =
          recommendationSourceIds[recommendationId];
      if (allowedSourceIds != null &&
          observation.citedSourceIds.isNotEmpty &&
          observation.citedSourceIds.every(allowedSourceIds.contains)) {
        sourceFaithfulCount += 1;
      }
    }

    latencies.sort();
    final int observationCount = observationsByCase.length;
    final double? precision = suggestionCount == 0
        ? null
        : correctSuggestionCount / suggestionCount;
    final double? falsePositiveRate = negativeCaseCount == 0
        ? null
        : falsePositiveCount / negativeCaseCount;
    final double? recall = positiveCaseCount == 0
        ? null
        : correctSuggestionCount / positiveCaseCount;
    final double? sourceFidelity = suggestionCount == 0
        ? null
        : sourceFaithfulCount / suggestionCount;
    final double costCoverage = observationCount == 0
        ? 0
        : costedObservationCount / observationCount;
    final double observationCoverage = cases.isEmpty
        ? 0
        : observationCount / cases.length;
    final double? reportedTotalEstimatedCostUsd = costedObservationCount == 0
        ? null
        : totalEstimatedCostUsd;
    final double? averageEstimatedCostUsd = costedObservationCount == 0
        ? null
        : totalEstimatedCostUsd / costedObservationCount;
    final int? p50 = _nearestRank(latencies, 0.5);
    final int? p95 = _nearestRank(latencies, 0.95);

    final Map<String, String> gates = <String, String>{
      'labelled_cases': cases.length >= policy.minimumLabelledCases
          ? 'pass'
          : 'insufficient_data',
      'precision': _minimumGate(precision, policy.minimumPrecision),
      'false_positive_rate': _maximumGate(
        falsePositiveRate,
        policy.maximumFalsePositiveRate,
      ),
      'source_fidelity': _minimumGate(
        sourceFidelity,
        policy.minimumSourceFidelity,
      ),
      'observation_coverage':
          observationCoverage >= policy.requiredObservationCoverage
          ? 'pass'
          : 'insufficient_data',
      'cost_coverage': costCoverage >= policy.requiredCostCoverage
          ? 'pass'
          : 'insufficient_data',
      'p95_latency': policy.maximumP95LatencyMilliseconds == null
          ? 'not_configured'
          : _maximumGate(
              p95?.toDouble(),
              policy.maximumP95LatencyMilliseconds!.toDouble(),
            ),
      'average_cost': policy.maximumAverageCostUsd == null
          ? 'not_configured'
          : _maximumGate(
              averageEstimatedCostUsd,
              policy.maximumAverageCostUsd!,
            ),
      'data_integrity':
          duplicateObservationCount == 0 && unknownCaseObservationCount == 0
          ? 'pass'
          : 'fail',
    };

    return CoachingShadowEvaluationReport(
      policyVersion: policy.version,
      labelledCaseCount: cases.length,
      observationCount: observationCount,
      suggestionCount: suggestionCount,
      correctSuggestionCount: correctSuggestionCount,
      falsePositiveCount: falsePositiveCount,
      incorrectSelectionCount: incorrectSelectionCount,
      sourceFaithfulCount: sourceFaithfulCount,
      duplicateObservationCount: duplicateObservationCount,
      unknownCaseObservationCount: unknownCaseObservationCount,
      precision: precision,
      falsePositiveRate: falsePositiveRate,
      recall: recall,
      sourceFidelity: sourceFidelity,
      p50LatencyMilliseconds: p50,
      p95LatencyMilliseconds: p95,
      totalInputTokens: totalInputTokens,
      totalOutputTokens: totalOutputTokens,
      totalEstimatedCostUsd: reportedTotalEstimatedCostUsd,
      averageEstimatedCostUsd: averageEstimatedCostUsd,
      observationCoverage: observationCoverage,
      costCoverage: costCoverage,
      gates: Map<String, String>.unmodifiable(gates),
    );
  }

  static int? _nearestRank(List<int> sortedValues, double percentile) {
    if (sortedValues.isEmpty) {
      return null;
    }
    final int rank = math.max(0, (percentile * sortedValues.length).ceil() - 1);
    return sortedValues[rank];
  }

  static String _minimumGate(double? value, double minimum) {
    if (value == null) {
      return 'insufficient_data';
    }
    return value >= minimum ? 'pass' : 'fail';
  }

  static String _maximumGate(double? value, double maximum) {
    if (value == null) {
      return 'insufficient_data';
    }
    return value <= maximum ? 'pass' : 'fail';
  }
}
