/// Severity attached to a coaching catalogue audit issue.
enum CoachingAuditSeverity { warning, error }

/// One deterministic catalogue audit finding.
final class CoachingAuditIssue {
  /// Creates an audit finding.
  const CoachingAuditIssue({
    required this.code,
    required this.message,
    required this.severity,
    this.artifactType,
    this.artifactId,
  });

  /// Stable machine-readable issue code.
  final String code;

  /// Human-readable explanation without source content.
  final String message;

  /// Finding severity.
  final CoachingAuditSeverity severity;

  /// Optional catalogue artifact type.
  final String? artifactType;

  /// Optional catalogue artifact identifier.
  final String? artifactId;

  /// Serializes the finding for CLI and CI output.
  Map<String, Object?> toJson() => <String, Object?>{
    'code': code,
    'message': message,
    'severity': severity.name,
    if (artifactType != null) 'artifact_type': artifactType,
    if (artifactId != null) 'artifact_id': artifactId,
  };
}

/// Deterministic result of validating the complete coaching catalogue.
final class CoachingCatalogAuditReport {
  /// Creates an audit report.
  const CoachingCatalogAuditReport({
    required this.catalogVersion,
    required this.sourceCount,
    required this.claimCount,
    required this.recommendationCount,
    required this.reviewCount,
    required this.issues,
  });

  /// Version declared by the immutable catalogue manifest.
  final String catalogVersion;

  /// Number of source records inspected.
  final int sourceCount;

  /// Number of claims inspected.
  final int claimCount;

  /// Number of recommendation cards inspected.
  final int recommendationCount;

  /// Number of human review decisions inspected.
  final int reviewCount;

  /// All deterministic findings.
  final List<CoachingAuditIssue> issues;

  /// Whether no blocking finding was detected.
  bool get isValid => issues.every(
    (CoachingAuditIssue issue) => issue.severity != CoachingAuditSeverity.error,
  );

  /// Number of blocking findings.
  int get errorCount => issues
      .where(
        (CoachingAuditIssue issue) =>
            issue.severity == CoachingAuditSeverity.error,
      )
      .length;

  /// Number of non-blocking findings.
  int get warningCount => issues
      .where(
        (CoachingAuditIssue issue) =>
            issue.severity == CoachingAuditSeverity.warning,
      )
      .length;

  /// Serializes the report for CLI and CI output.
  Map<String, Object?> toJson() => <String, Object?>{
    'catalog_version': catalogVersion,
    'valid': isValid,
    'counts': <String, int>{
      'sources': sourceCount,
      'claims': claimCount,
      'recommendations': recommendationCount,
      'human_reviews': reviewCount,
      'errors': errorCount,
      'warnings': warningCount,
    },
    'issues': issues
        .map((CoachingAuditIssue issue) => issue.toJson())
        .toList(growable: false),
  };
}

/// Human-labelled expectation used by the shadow evaluation harness.
final class CoachingShadowCase {
  /// Creates one labelled case.
  const CoachingShadowCase({
    required this.id,
    required this.shouldSuggest,
    required this.acceptedRecommendationIds,
    required this.labelVersion,
    required this.reviewerIds,
  });

  /// Parses and validates one labelled case.
  factory CoachingShadowCase.fromJson(Map<String, Object?> json) {
    final String id = _requiredText(json, 'id');
    final bool? shouldSuggest = json['should_suggest'] as bool?;
    if (shouldSuggest == null) {
      throw FormatException('Case $id must define should_suggest.');
    }
    final List<String> acceptedRecommendationIds = _stringList(
      json['accepted_recommendation_ids'],
    );
    if (shouldSuggest && acceptedRecommendationIds.isEmpty) {
      throw FormatException(
        'Positive case $id must define accepted_recommendation_ids.',
      );
    }
    if (!shouldSuggest && acceptedRecommendationIds.isNotEmpty) {
      throw FormatException(
        'Negative case $id cannot accept a recommendation.',
      );
    }
    final List<String> reviewerIds = _stringList(json['reviewer_ids']);
    if (reviewerIds.isEmpty) {
      throw FormatException('Case $id must have at least one human reviewer.');
    }
    return CoachingShadowCase(
      id: id,
      shouldSuggest: shouldSuggest,
      acceptedRecommendationIds: acceptedRecommendationIds,
      labelVersion: _positiveInteger(json, 'label_version'),
      reviewerIds: reviewerIds,
    );
  }

  /// Stable case identifier.
  final String id;

  /// Whether a suggestion is useful and safe for this labelled moment.
  final bool shouldSuggest;

  /// Accepted catalogue cards. An empty list means silence is expected.
  final List<String> acceptedRecommendationIds;

  /// Version of the human label.
  final int labelVersion;

  /// Pseudonymous identifiers of human reviewers.
  final List<String> reviewerIds;
}

/// One model decision captured in shadow mode.
final class CoachingShadowObservation {
  /// Creates one shadow observation.
  const CoachingShadowObservation({
    required this.caseId,
    required this.latencyMilliseconds,
    required this.inputTokens,
    required this.outputTokens,
    required this.citedSourceIds,
    this.selectedRecommendationId,
    this.estimatedCostUsd,
    this.pricingVersion,
  });

  /// Parses and validates one shadow observation.
  factory CoachingShadowObservation.fromJson(Map<String, Object?> json) {
    final String caseId = _requiredText(json, 'case_id');
    final int latencyMilliseconds = _nonNegativeInteger(json, 'latency_ms');
    final int inputTokens = _nonNegativeInteger(json, 'input_tokens');
    final int outputTokens = _nonNegativeInteger(json, 'output_tokens');
    final Object? rawCost = json['estimated_cost_usd'];
    final double? estimatedCostUsd = rawCost == null
        ? null
        : _nonNegativeNumber(rawCost, 'estimated_cost_usd');
    final String? selectedRecommendationId = _optionalText(
      json['selected_recommendation_id'],
    );
    final List<String> citedSourceIds = _stringList(json['cited_source_ids']);
    if (selectedRecommendationId == null && citedSourceIds.isNotEmpty) {
      throw FormatException(
        'Observation $caseId cannot cite sources without a recommendation.',
      );
    }
    return CoachingShadowObservation(
      caseId: caseId,
      selectedRecommendationId: selectedRecommendationId,
      citedSourceIds: citedSourceIds,
      latencyMilliseconds: latencyMilliseconds,
      inputTokens: inputTokens,
      outputTokens: outputTokens,
      estimatedCostUsd: estimatedCostUsd,
      pricingVersion: _optionalText(json['pricing_version']),
    );
  }

  /// Labelled case identifier.
  final String caseId;

  /// Selected catalogue card, or null when the model stayed silent.
  final String? selectedRecommendationId;

  /// Source identifiers returned with the selected catalogue card.
  final List<String> citedSourceIds;

  /// End-to-end decision latency.
  final int latencyMilliseconds;

  /// Provider-reported input tokens.
  final int inputTokens;

  /// Provider-reported output tokens.
  final int outputTokens;

  /// Cost computed outside the harness from a versioned provider price sheet.
  final double? estimatedCostUsd;

  /// Identifier of the external price sheet used for cost estimation.
  final String? pricingVersion;
}

/// Versioned internal gates applied to a shadow evaluation report.
final class CoachingShadowPolicy {
  /// Creates an evaluation policy.
  const CoachingShadowPolicy({
    required this.version,
    required this.minimumLabelledCases,
    required this.minimumPrecision,
    required this.maximumFalsePositiveRate,
    required this.minimumSourceFidelity,
    this.maximumP95LatencyMilliseconds,
    this.maximumAverageCostUsd,
    this.requiredObservationCoverage = 1,
    this.requiredCostCoverage = 1,
  });

  /// Parses an explicitly versioned internal policy.
  factory CoachingShadowPolicy.fromJson(Map<String, Object?> json) {
    final Map<String, Object?> thresholds = _objectMap(json['thresholds']);
    return CoachingShadowPolicy(
      version: _requiredText(json, 'policy_version'),
      minimumLabelledCases: _positiveInteger(
        thresholds,
        'minimum_labelled_cases',
      ),
      minimumPrecision: _unitInterval(thresholds, 'minimum_precision'),
      maximumFalsePositiveRate: _unitInterval(
        thresholds,
        'maximum_false_positive_rate',
      ),
      minimumSourceFidelity: _unitInterval(
        thresholds,
        'minimum_source_fidelity',
      ),
      maximumP95LatencyMilliseconds: _optionalPositiveInteger(
        thresholds,
        'maximum_p95_latency_ms',
      ),
      maximumAverageCostUsd: _optionalPositiveNumber(
        thresholds,
        'maximum_average_cost_usd',
      ),
      requiredObservationCoverage: _unitInterval(
        thresholds,
        'required_observation_coverage',
      ),
      requiredCostCoverage: _unitInterval(thresholds, 'required_cost_coverage'),
    );
  }

  /// Stable policy version.
  final String version;

  /// Minimum number of human-labelled cases required for promotion.
  final int minimumLabelledCases;

  /// Minimum correct-card precision.
  final double minimumPrecision;

  /// Maximum suggestion rate on negative cases.
  final double maximumFalsePositiveRate;

  /// Minimum rate of suggestions citing only the selected card's sources.
  final double minimumSourceFidelity;

  /// Optional product latency budget. Null means the owner has not set it.
  final int? maximumP95LatencyMilliseconds;

  /// Optional unit-economics budget. Null means the owner has not set it.
  final double? maximumAverageCostUsd;

  /// Required fraction of labelled cases with one shadow observation.
  final double requiredObservationCoverage;

  /// Required fraction of observations with versioned cost estimates.
  final double requiredCostCoverage;
}

/// Result of evaluating shadow observations against human labels.
final class CoachingShadowEvaluationReport {
  /// Creates a shadow evaluation report.
  const CoachingShadowEvaluationReport({
    required this.policyVersion,
    required this.labelledCaseCount,
    required this.observationCount,
    required this.suggestionCount,
    required this.correctSuggestionCount,
    required this.falsePositiveCount,
    required this.incorrectSelectionCount,
    required this.sourceFaithfulCount,
    required this.duplicateObservationCount,
    required this.unknownCaseObservationCount,
    required this.precision,
    required this.falsePositiveRate,
    required this.recall,
    required this.sourceFidelity,
    required this.p50LatencyMilliseconds,
    required this.p95LatencyMilliseconds,
    required this.totalInputTokens,
    required this.totalOutputTokens,
    required this.totalEstimatedCostUsd,
    required this.averageEstimatedCostUsd,
    required this.observationCoverage,
    required this.costCoverage,
    required this.gates,
  });

  /// Policy version used by the report.
  final String policyVersion;

  /// Number of human-labelled cases.
  final int labelledCaseCount;

  /// Number of unique observations matched to labelled cases.
  final int observationCount;

  /// Number of non-null model selections.
  final int suggestionCount;

  /// Suggestions matching one accepted human label.
  final int correctSuggestionCount;

  /// Suggestions emitted on negative cases.
  final int falsePositiveCount;

  /// Suggestions emitted on positive cases but selecting the wrong card.
  final int incorrectSelectionCount;

  /// Suggestions citing a non-empty subset of the selected card's sources.
  final int sourceFaithfulCount;

  /// Duplicate observations ignored by the deterministic evaluator.
  final int duplicateObservationCount;

  /// Observations ignored because their case identifier was not labelled.
  final int unknownCaseObservationCount;

  /// Correct-card precision, or null when no suggestion was emitted.
  final double? precision;

  /// Suggestion rate on negative cases, or null without negative cases.
  final double? falsePositiveRate;

  /// Positive cases receiving an accepted card, or null without positives.
  final double? recall;

  /// Grounded suggestion ratio, or null when no suggestion was emitted.
  final double? sourceFidelity;

  /// Median observed latency, or null without observations.
  final int? p50LatencyMilliseconds;

  /// Nearest-rank 95th percentile latency, or null without observations.
  final int? p95LatencyMilliseconds;

  /// Total provider-reported input tokens.
  final int totalInputTokens;

  /// Total provider-reported output tokens.
  final int totalOutputTokens;

  /// Sum of available versioned cost estimates.
  final double? totalEstimatedCostUsd;

  /// Average cost across costed observations, or null without cost data.
  final double? averageEstimatedCostUsd;

  /// Fraction of labelled cases with one unique model observation.
  final double observationCoverage;

  /// Fraction of observations carrying a cost and price-sheet version.
  final double costCoverage;

  /// Gate result: `pass`, `fail`, `insufficient_data`, or `not_configured`.
  final Map<String, String> gates;

  /// Whether every configured promotion gate passes.
  bool get passesConfiguredGates =>
      gates.values.every((String state) => state == 'pass');

  /// Serializes all metrics without converting unknown values to zero.
  Map<String, Object?> toJson() => <String, Object?>{
    'policy_version': policyVersion,
    'passes_configured_gates': passesConfiguredGates,
    'counts': <String, int>{
      'labelled_cases': labelledCaseCount,
      'observations': observationCount,
      'suggestions': suggestionCount,
      'correct_suggestions': correctSuggestionCount,
      'false_positives': falsePositiveCount,
      'incorrect_selections': incorrectSelectionCount,
      'source_faithful_suggestions': sourceFaithfulCount,
      'duplicate_observations': duplicateObservationCount,
      'unknown_case_observations': unknownCaseObservationCount,
    },
    'quality': <String, Object?>{
      'precision': precision,
      'false_positive_rate': falsePositiveRate,
      'recall': recall,
      'source_fidelity': sourceFidelity,
    },
    'performance': <String, Object?>{
      'p50_latency_ms': p50LatencyMilliseconds,
      'p95_latency_ms': p95LatencyMilliseconds,
      'input_tokens': totalInputTokens,
      'output_tokens': totalOutputTokens,
      'total_estimated_cost_usd': totalEstimatedCostUsd,
      'average_estimated_cost_usd': averageEstimatedCostUsd,
      'observation_coverage': observationCoverage,
      'cost_coverage': costCoverage,
    },
    'gates': gates,
  };
}

String _requiredText(Map<String, Object?> json, String key) {
  final String? value = _optionalText(json[key]);
  if (value == null) {
    throw FormatException('$key must be a non-empty string.');
  }
  return value;
}

String? _optionalText(Object? value) {
  if (value is! String || value.trim().isEmpty) {
    return null;
  }
  return value.trim();
}

List<String> _stringList(Object? value) {
  if (value is! List<Object?>) {
    return const <String>[];
  }
  return value
      .whereType<String>()
      .map((String item) => item.trim())
      .where((String item) => item.isNotEmpty)
      .toList(growable: false);
}

Map<String, Object?> _objectMap(Object? value) =>
    value is Map<String, Object?> ? value : const <String, Object?>{};

int _positiveInteger(Map<String, Object?> json, String key) {
  final Object? value = json[key];
  if (value is! int || value < 1) {
    throw FormatException('$key must be a positive integer.');
  }
  return value;
}

int _nonNegativeInteger(Map<String, Object?> json, String key) {
  final Object? value = json[key];
  if (value is! int || value < 0) {
    throw FormatException('$key must be a non-negative integer.');
  }
  return value;
}

int? _optionalPositiveInteger(Map<String, Object?> json, String key) {
  if (json[key] == null) {
    return null;
  }
  return _positiveInteger(json, key);
}

double _unitInterval(Map<String, Object?> json, String key) {
  final Object? value = json[key];
  if (value is! num || !value.isFinite || value < 0 || value > 1) {
    throw FormatException('$key must be between 0 and 1.');
  }
  return value.toDouble();
}

double _nonNegativeNumber(Object value, String key) {
  if (value is! num || !value.isFinite || value < 0) {
    throw FormatException('$key must be a non-negative number.');
  }
  return value.toDouble();
}

double? _optionalPositiveNumber(Map<String, Object?> json, String key) {
  final Object? value = json[key];
  if (value == null) {
    return null;
  }
  final double result = _nonNegativeNumber(value, key);
  if (result == 0) {
    throw FormatException('$key must be positive when configured.');
  }
  return result;
}
