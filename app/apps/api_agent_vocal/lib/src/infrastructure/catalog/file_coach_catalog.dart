import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/coaching_quality_models.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/coaching_catalog_validator.dart';

/// Read-only catalogue backed by the repository's curated JSON artifact.
final class FileCoachCatalog implements CoachCatalog {
  const FileCoachCatalog._({
    required List<CoachRecommendation> recommendations,
    required this.releaseChannel,
    required this.minimumLiveConfidence,
    required this.minimumContextMatch,
    required this.globalCooldown,
    required this.maxSuggestionsPerMinute,
    required this.maxEvaluationsPerMinute,
    required this.defaultExpirySeconds,
    required this.minimumEvidenceConfidence,
    required this.requireSourceLocator,
    required Set<String> claimsWithLocators,
    required Set<String> approvedClaimIds,
    required this.unavailableReason,
  }) : _recommendations = recommendations,
       _claimsWithLocators = claimsWithLocators,
       _approvedClaimIds = approvedClaimIds;

  /// Loads `recommendations.json` without creating any fallback card.
  factory FileCoachCatalog.load(
    String? directory, {
    CoachReleaseChannel releaseChannel = CoachReleaseChannel.strict,
    bool enforceCatalogAudit = true,
  }) {
    if (directory == null || directory.trim().isEmpty) {
      return FileCoachCatalog._(
        recommendations: <CoachRecommendation>[],
        releaseChannel: releaseChannel,
        minimumLiveConfidence: 1,
        minimumContextMatch: 1,
        globalCooldown: Duration.zero,
        maxSuggestionsPerMinute: 0,
        maxEvaluationsPerMinute: 0,
        defaultExpirySeconds: 0,
        minimumEvidenceConfidence: 1,
        requireSourceLocator: true,
        claimsWithLocators: <String>{},
        approvedClaimIds: const <String>{},
        unavailableReason: 'COACH_CATALOG_DIR is not configured.',
      );
    }
    if (enforceCatalogAudit) {
      final CoachingCatalogAuditReport audit = const CoachingCatalogValidator()
          .validateDirectory(directory.trim());
      if (!audit.isValid) {
        final CoachingAuditIssue firstError = audit.issues.firstWhere(
          (CoachingAuditIssue issue) =>
              issue.severity == CoachingAuditSeverity.error,
        );
        return FileCoachCatalog._(
          recommendations: const <CoachRecommendation>[],
          releaseChannel: releaseChannel,
          minimumLiveConfidence: 1,
          minimumContextMatch: 1,
          globalCooldown: Duration.zero,
          maxSuggestionsPerMinute: 0,
          maxEvaluationsPerMinute: 0,
          defaultExpirySeconds: 0,
          minimumEvidenceConfidence: 1,
          requireSourceLocator: true,
          claimsWithLocators: const <String>{},
          approvedClaimIds: const <String>{},
          unavailableReason:
              'Coaching catalogue audit failed: '
              '${firstError.code}.',
        );
      }
    }
    final File file = File('${directory.trim()}/recommendations.json');
    final File policyFile = File('${directory.trim()}/release-policy.json');
    if (!file.existsSync() || !policyFile.existsSync()) {
      return FileCoachCatalog._(
        recommendations: const <CoachRecommendation>[],
        releaseChannel: releaseChannel,
        minimumLiveConfidence: 1,
        minimumContextMatch: 1,
        globalCooldown: Duration.zero,
        maxSuggestionsPerMinute: 0,
        maxEvaluationsPerMinute: 0,
        defaultExpirySeconds: 0,
        minimumEvidenceConfidence: 1,
        requireSourceLocator: true,
        claimsWithLocators: <String>{},
        approvedClaimIds: const <String>{},
        unavailableReason:
            'Missing curated catalogue or release policy in ${directory.trim()}',
      );
    }
    try {
      final Object? decodedPolicy = jsonDecode(policyFile.readAsStringSync());
      if (decodedPolicy is! Map<String, Object?>) {
        throw const FormatException('release-policy.json must be an object.');
      }
      final Map<String, Object?> display = _map(decodedPolicy['display']);
      final Map<String, Object?> eligibility = _map(
        decodedPolicy['eligibility'],
      );
      final double strictMinimumEvidenceConfidence = _number(
        eligibility['minimum_evidence_confidence'],
        fallback: 1,
      );
      final double internalAlphaMinimumEvidenceConfidence = _number(
        eligibility['internal_alpha_minimum_evidence_confidence'],
        fallback: strictMinimumEvidenceConfidence,
      );
      final double minimumEvidenceConfidence =
          releaseChannel == CoachReleaseChannel.internalAlpha
          ? internalAlphaMinimumEvidenceConfidence
          : strictMinimumEvidenceConfidence;
      final double strictMinimumContextMatch = _number(
        eligibility['minimum_context_match'],
        fallback: 1,
      );
      final double internalAlphaMinimumContextMatch = _number(
        eligibility['internal_alpha_minimum_context_match'],
        fallback: strictMinimumContextMatch,
      );
      final double minimumContextMatch =
          releaseChannel == CoachReleaseChannel.internalAlpha
          ? internalAlphaMinimumContextMatch
          : strictMinimumContextMatch;
      final double strictMinimumLiveConfidence = _number(
        eligibility['minimum_overall_live_confidence'],
        fallback: 1,
      );
      final double internalAlphaMinimumLiveConfidence = _number(
        eligibility['internal_alpha_minimum_overall_live_confidence'],
        fallback: strictMinimumLiveConfidence,
      );
      final double minimumLiveConfidence =
          releaseChannel == CoachReleaseChannel.internalAlpha
          ? internalAlphaMinimumLiveConfidence
          : strictMinimumLiveConfidence;
      final double internalAlphaMaximumCardContextMinimum = _number(
        eligibility['internal_alpha_maximum_card_context_minimum'],
        fallback: 1,
      );
      final double internalAlphaMaximumCardLiveMinimum = _number(
        eligibility['internal_alpha_maximum_card_live_minimum'],
        fallback: 1,
      );
      final bool requireSourceLocator =
          eligibility['require_source_locator'] != false;
      final _ClaimIndex claimIndex = _loadClaimIndex(
        directory.trim(),
        requiredByPolicy: requireSourceLocator,
      );
      final Map<String, CoachSource> sources = _loadSources(directory.trim());
      final int maxSuggestionsPerMinute = _integer(
        display['max_suggestions_per_minute'],
        fallback: 1,
      );
      final int maxEvaluationsPerMinute = _integer(
        display['max_evaluations_per_minute'],
        fallback: 12,
      );
      final Duration globalCooldown = Duration(
        seconds: _integer(display['global_cooldown_seconds'], fallback: 60),
      );
      final int defaultExpirySeconds = _integer(
        display['default_expiry_seconds'],
        fallback: 12,
      );
      final Object? decoded = jsonDecode(file.readAsStringSync());
      final List<Object?> rows = switch (decoded) {
        List<Object?> list => list,
        Map<String, Object?> map when map['recommendations'] is List<Object?> =>
          map['recommendations']! as List<Object?>,
        _ => throw const FormatException(
          'recommendations.json must be a list or contain recommendations.',
        ),
      };
      final List<CoachRecommendation> recommendations = <CoachRecommendation>[];
      for (final Object? row in rows) {
        if (row is! Map<String, Object?>) {
          continue;
        }
        final Map<String, Object?> effectiveRow =
            releaseChannel == CoachReleaseChannel.internalAlpha
            ? _withRuntimeThresholdCaps(
                row,
                maximumContextMinimum: internalAlphaMaximumCardContextMinimum,
                maximumLiveMinimum: internalAlphaMaximumCardLiveMinimum,
              )
            : row;
        final String? id = _text(effectiveRow['id']);
        final String? status = _text(effectiveRow['status']);
        final String? message = _recommendationMessage(effectiveRow);
        if (id == null || status == null || message == null) {
          continue;
        }
        final List<String> sourceIds = _stringList(effectiveRow['source_ids']);
        final List<String> claimIds = _stringList(effectiveRow['claim_ids']);
        recommendations.add(
          CoachRecommendation(
            id: id,
            status: status,
            message: message,
            sourceIds: sourceIds,
            sources: sourceIds
                .map((String sourceId) {
                  return sources[sourceId]?.withLocator(
                    claimIndex.locatorFor(claimIds, sourceId),
                  );
                })
                .whereType<CoachSource>()
                .toList(growable: false),
            triggers: _triggers(effectiveRow),
            raw: effectiveRow,
          ),
        );
      }
      return FileCoachCatalog._(
        recommendations: List<CoachRecommendation>.unmodifiable(
          recommendations,
        ),
        releaseChannel: releaseChannel,
        minimumLiveConfidence: minimumLiveConfidence,
        minimumContextMatch: minimumContextMatch,
        globalCooldown: globalCooldown,
        maxSuggestionsPerMinute: maxSuggestionsPerMinute,
        maxEvaluationsPerMinute: maxEvaluationsPerMinute,
        defaultExpirySeconds: defaultExpirySeconds,
        minimumEvidenceConfidence: minimumEvidenceConfidence,
        requireSourceLocator: requireSourceLocator,
        claimsWithLocators: claimIndex.claimIds,
        approvedClaimIds: claimIndex.approvedClaimIds,
        unavailableReason: null,
      );
    } on Object catch (error) {
      return FileCoachCatalog._(
        recommendations: const <CoachRecommendation>[],
        releaseChannel: releaseChannel,
        minimumLiveConfidence: 1,
        minimumContextMatch: 1,
        globalCooldown: Duration.zero,
        maxSuggestionsPerMinute: 0,
        maxEvaluationsPerMinute: 0,
        defaultExpirySeconds: 0,
        minimumEvidenceConfidence: 1,
        requireSourceLocator: true,
        claimsWithLocators: <String>{},
        approvedClaimIds: const <String>{},
        unavailableReason: 'Invalid curated catalogue: $error',
      );
    }
  }

  final List<CoachRecommendation> _recommendations;

  @override
  final CoachReleaseChannel releaseChannel;

  @override
  bool get allowsUnreviewedRecommendations =>
      releaseChannel == CoachReleaseChannel.internalAlpha;

  @override
  final double minimumLiveConfidence;

  @override
  final double minimumContextMatch;

  @override
  final Duration globalCooldown;

  @override
  final int maxSuggestionsPerMinute;

  @override
  final int maxEvaluationsPerMinute;

  @override
  final int defaultExpirySeconds;

  final double minimumEvidenceConfidence;
  final bool requireSourceLocator;
  final Set<String> _claimsWithLocators;
  final Set<String> _approvedClaimIds;

  @override
  final String? unavailableReason;

  @override
  bool get isAvailable => unavailableReason == null;

  @override
  List<CoachRecommendation> candidatesFor({
    required CoachMode mode,
    required String latestText,
  }) {
    if (!isAvailable || mode == CoachMode.off) {
      return const <CoachRecommendation>[];
    }
    final List<CoachRecommendation> eligible = _recommendations
        .where(
          (CoachRecommendation recommendation) =>
              _isEligible(recommendation, mode: mode),
        )
        .toList(growable: false);
    if (latestText.trim().isEmpty) {
      return eligible;
    }
    // Semantic trigger labels remain model-selected. Lexical overlap is used
    // only as a stable ordering hint and never hides a semantically valid card.
    eligible.sort(
      (CoachRecommendation left, CoachRecommendation right) =>
          _lexicalTriggerScore(
            right,
            latestText,
          ).compareTo(_lexicalTriggerScore(left, latestText)),
    );
    return eligible;
  }

  @override
  List<CoachRecommendation> postCallCandidates() {
    if (!isAvailable) {
      return const <CoachRecommendation>[];
    }
    return _recommendations
        .where(
          (CoachRecommendation recommendation) =>
              _isEligible(recommendation, mode: CoachMode.live),
        )
        .toList(growable: false);
  }

  bool _isEligible(
    CoachRecommendation recommendation, {
    required CoachMode mode,
  }) {
    final bool statusAllowed = switch (releaseChannel) {
      CoachReleaseChannel.internalAlpha => const <String>{
        'draft',
        'shadow',
        'live',
      }.contains(recommendation.status),
      CoachReleaseChannel.strict when mode == CoachMode.shadow =>
        const <String>{'shadow', 'live'}.contains(recommendation.status),
      CoachReleaseChannel.strict => recommendation.status == 'live',
    };
    if (!statusAllowed) {
      return false;
    }
    final Map<String, Object?> confidence = _map(
      recommendation.raw['confidence'],
    );
    final double evidence = _number(confidence['evidence'], fallback: 0);
    if (evidence < minimumEvidenceConfidence) {
      return false;
    }
    if (requireSourceLocator && recommendation.sourceIds.isEmpty) {
      return false;
    }
    if (requireSourceLocator &&
        (recommendation.sources.length != recommendation.sourceIds.length ||
            recommendation.sources.any(
              (CoachSource source) => source.locator == null,
            ))) {
      return false;
    }
    final List<String> claimIds = _stringList(recommendation.raw['claim_ids']);
    if (requireSourceLocator &&
        (claimIds.isEmpty ||
            claimIds.any(
              (String claimId) => !_claimsWithLocators.contains(claimId),
            ))) {
      return false;
    }
    if (releaseChannel == CoachReleaseChannel.strict &&
        claimIds.any(
          (String claimId) => !_approvedClaimIds.contains(claimId),
        )) {
      return false;
    }
    return true;
  }

  static int _lexicalTriggerScore(
    CoachRecommendation recommendation,
    String latestText,
  ) {
    final Set<String> transcriptTokens = _tokens(latestText);
    if (transcriptTokens.isEmpty) {
      return 0;
    }
    final String triggerText = <String>[
      ...recommendation.triggers,
      jsonEncode(recommendation.raw['trigger']),
      jsonEncode(recommendation.raw['hypothesis']),
    ].join(' ');
    return _tokens(triggerText).where(transcriptTokens.contains).length;
  }

  static Map<String, Object?> _withRuntimeThresholdCaps(
    Map<String, Object?> row, {
    required double maximumContextMinimum,
    required double maximumLiveMinimum,
  }) {
    final Map<String, Object?> confidence = _map(row['confidence']);
    if (confidence.isEmpty) {
      return row;
    }
    final Map<String, Object?> effectiveConfidence = <String, Object?>{
      ...confidence,
    };
    bool changed = false;
    final Object? rawContextMinimum = confidence['context_minimum'];
    if (rawContextMinimum is num &&
        rawContextMinimum.toDouble() > maximumContextMinimum) {
      effectiveConfidence['context_minimum'] = maximumContextMinimum;
      changed = true;
    }
    final Object? rawLiveMinimum = confidence['live_minimum'];
    if (rawLiveMinimum is num &&
        rawLiveMinimum.toDouble() > maximumLiveMinimum) {
      effectiveConfidence['live_minimum'] = maximumLiveMinimum;
      changed = true;
    }
    if (!changed) {
      return row;
    }
    return <String, Object?>{
      ...row,
      'confidence': Map<String, Object?>.unmodifiable(effectiveConfidence),
    };
  }

  static Set<String> _tokens(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-zà-ÿ0-9]+'), ' ')
        .split(' ')
        .where((String token) => token.length >= 3)
        .toSet();
  }

  static String? _recommendationMessage(Map<String, Object?> row) {
    final Object? action = row['action'];
    if (action is Map<String, Object?>) {
      final String? suggestion = _text(action['suggestion']);
      if (suggestion != null) {
        return suggestion;
      }
    }
    return _text(row['message']) ??
        _text(row['recommendation']) ??
        _text(row['title']);
  }

  static List<String> _triggers(Map<String, Object?> row) {
    final List<String> triggers = <String>[..._stringList(row['triggers'])];
    final Object? structuredTriggers = row['triggers'];
    if (structuredTriggers is List<Object?>) {
      for (final Map<String, Object?> item
          in structuredTriggers.whereType<Map<String, Object?>>()) {
        final String? match = _text(item['match']);
        if (match != null) {
          triggers.add(match);
        }
      }
    }
    final Object? trigger = row['trigger'];
    if (trigger is Map<String, Object?>) {
      final String? signal = _text(trigger['signal']);
      if (signal != null) {
        triggers.add(signal);
      }
    }
    return List<String>.unmodifiable(triggers.toSet());
  }

  static List<String> _stringList(Object? value) {
    if (value is! List<Object?>) {
      return const <String>[];
    }
    return value
        .whereType<String>()
        .map((String item) => item.trim())
        .where((String item) => item.isNotEmpty)
        .toList(growable: false);
  }

  static String? _text(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }

  static Map<String, Object?> _map(Object? value) {
    return value is Map<String, Object?> ? value : const <String, Object?>{};
  }

  static double _number(Object? value, {required double fallback}) {
    return value is num ? value.toDouble() : fallback;
  }

  static int _integer(Object? value, {required int fallback}) {
    return value is num ? value.toInt() : fallback;
  }

  static _ClaimIndex _loadClaimIndex(
    String directory, {
    required bool requiredByPolicy,
  }) {
    final File claimsFile = File('$directory/claims.json');
    if (!claimsFile.existsSync()) {
      if (requiredByPolicy) {
        throw const FormatException(
          'claims.json is required when source locators are required.',
        );
      }
      return const _ClaimIndex(
        claimIds: <String>{},
        approvedClaimIds: <String>{},
        locatorsByClaimAndSource: <String, Map<String, String>>{},
      );
    }
    final Object? decoded = jsonDecode(claimsFile.readAsStringSync());
    if (decoded is! List<Object?>) {
      throw const FormatException('claims.json must be a list.');
    }
    final Set<String> claimIds = <String>{};
    final Set<String> approvedClaimIds = <String>{};
    final Map<String, Map<String, String>> locators =
        <String, Map<String, String>>{};
    for (final Map<String, Object?> claim
        in decoded.whereType<Map<String, Object?>>()) {
      final String? claimId = _text(claim['id']);
      final List<String> sourceIds = _stringList(claim['source_ids']);
      final List<String> sourceLocators = _stringList(claim['source_locators']);
      if (claimId == null || sourceIds.isEmpty || sourceLocators.isEmpty) {
        continue;
      }
      claimIds.add(claimId);
      if (const <String>{
        'approved',
        'live',
      }.contains(_text(claim['status'])?.toLowerCase())) {
        approvedClaimIds.add(claimId);
      }
      final Map<String, String> bySource = <String, String>{};
      for (int index = 0; index < sourceIds.length; index += 1) {
        bySource[sourceIds[index]] = sourceLocators.length == sourceIds.length
            ? sourceLocators[index]
            : sourceLocators.join(' · ');
      }
      locators[claimId] = Map<String, String>.unmodifiable(bySource);
    }
    return _ClaimIndex(
      claimIds: Set<String>.unmodifiable(claimIds),
      approvedClaimIds: Set<String>.unmodifiable(approvedClaimIds),
      locatorsByClaimAndSource: Map<String, Map<String, String>>.unmodifiable(
        locators,
      ),
    );
  }

  static Map<String, CoachSource> _loadSources(String directory) {
    final File sourceFile = File('$directory/sources.json');
    if (!sourceFile.existsSync()) {
      throw const FormatException('sources.json is required.');
    }
    final Object? decoded = jsonDecode(sourceFile.readAsStringSync());
    if (decoded is! List<Object?>) {
      throw const FormatException('sources.json must be a list.');
    }
    final Map<String, CoachSource> result = <String, CoachSource>{};
    for (final Map<String, Object?> source
        in decoded.whereType<Map<String, Object?>>()) {
      final String? id = _text(source['id']);
      final String? title = _text(source['title']);
      if (id == null || title == null) {
        continue;
      }
      final List<String> authors = _stringList(source['authors']);
      result[id] = CoachSource(
        id: id,
        title: title,
        evidenceLevel: _evidenceLevel(source),
        author: authors.isEmpty ? null : authors.join(', '),
        url: _text(source['locator_url']),
        locator: null,
      );
    }
    return result;
  }

  static String _evidenceLevel(Map<String, Object?> source) {
    final String method = _text(source['method'])?.toLowerCase() ?? '';
    if (method.contains('meta_analysis') || method.contains('systematic')) {
      return 'systematic_review';
    }
    if (method.contains('experiment')) {
      return 'experimental';
    }
    if (method.contains('empirical') || method.contains('scale_development')) {
      return 'empirical';
    }
    if (method.contains('observational') || method.contains('field_data')) {
      return 'observational';
    }
    if (method.contains('course') ||
        method.contains('book') ||
        method.contains('practitioner')) {
      return 'practitioner';
    }
    return 'anecdotal';
  }
}

final class _ClaimIndex {
  const _ClaimIndex({
    required this.claimIds,
    required this.approvedClaimIds,
    required this.locatorsByClaimAndSource,
  });

  final Set<String> claimIds;
  final Set<String> approvedClaimIds;
  final Map<String, Map<String, String>> locatorsByClaimAndSource;

  String? locatorFor(List<String> recommendationClaimIds, String sourceId) {
    final List<String> locators = recommendationClaimIds
        .map((String claimId) => locatorsByClaimAndSource[claimId]?[sourceId])
        .whereType<String>()
        .toSet()
        .toList(growable: false);
    return locators.isEmpty ? null : locators.join(' · ');
  }
}
