import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/coaching_quality_models.dart';
import 'package:crypto/crypto.dart';

/// Offline validator for the versioned coaching knowledge catalogue.
///
/// It never calls the network. URL reachability and source-content review are
/// separate human research tasks; this validator proves only that the checked
/// local artifacts are internally consistent and promotion-gated.
final class CoachingCatalogValidator {
  /// Creates a stateless validator.
  const CoachingCatalogValidator();

  static const List<String> _digestArtifacts = <String>[
    'sources.json',
    'claims.json',
    'recommendations.json',
    'release-policy.json',
    'rights-policies.json',
    'reviews.json',
    'evaluation-policy.json',
  ];

  /// Audits the complete catalogue at [directory].
  CoachingCatalogAuditReport validateDirectory(String directory) {
    final List<CoachingAuditIssue> issues = <CoachingAuditIssue>[];
    final Directory root = Directory(directory);
    if (!root.existsSync()) {
      return CoachingCatalogAuditReport(
        catalogVersion: 'unknown',
        sourceCount: 0,
        claimCount: 0,
        recommendationCount: 0,
        reviewCount: 0,
        issues: const <CoachingAuditIssue>[
          CoachingAuditIssue(
            code: 'catalog_directory_missing',
            message: 'The coaching catalogue directory does not exist.',
            severity: CoachingAuditSeverity.error,
          ),
        ],
      );
    }

    final Map<String, Object?> manifest = _readObject(
      root,
      'catalog-manifest.json',
      issues,
    );
    final String catalogVersion =
        _text(manifest['catalog_version']) ?? 'unknown';
    _validateManifest(root, manifest, issues);

    final List<Map<String, Object?>> sources = _readRows(
      root,
      'sources.json',
      issues,
    );
    final List<Map<String, Object?>> claims = _readRows(
      root,
      'claims.json',
      issues,
    );
    final List<Map<String, Object?>> recommendations = _readRows(
      root,
      'recommendations.json',
      issues,
    );
    final Map<String, Object?> rightsRegistry = _readObject(
      root,
      'rights-policies.json',
      issues,
    );
    final Map<String, Object?> reviewsRegistry = _readObject(
      root,
      'reviews.json',
      issues,
    );
    final Map<String, Object?> releasePolicy = _readObject(
      root,
      'release-policy.json',
      issues,
    );
    final Map<String, Object?> evaluationPolicy = _readObject(
      root,
      'evaluation-policy.json',
      issues,
    );

    final Map<String, Map<String, Object?>> sourcesById = _indexRows(
      sources,
      'source',
      issues,
    );
    final Map<String, Map<String, Object?>> claimsById = _indexRows(
      claims,
      'claim',
      issues,
    );
    _indexRows(recommendations, 'recommendation', issues);

    final _RightsIndex rights = _validateRightsRegistry(
      rightsRegistry,
      sourcesById,
      issues,
    );
    final List<Map<String, Object?>> reviews = _objectRows(
      reviewsRegistry['reviews'],
    );
    final _ReviewIndex reviewIndex = _validateReviews(
      reviews,
      sourcesById,
      claimsById,
      recommendations,
      issues,
    );
    final int minimumReviews = _minimumReviews(releasePolicy, issues);

    _validateSources(sources, rights, issues);
    _validateClaims(
      claims,
      sourcesById,
      rights,
      reviewIndex,
      minimumReviews,
      issues,
    );
    _validateRecommendations(
      recommendations,
      sourcesById,
      claimsById,
      rights,
      reviewIndex,
      minimumReviews,
      issues,
    );
    _validateEvaluationPolicy(evaluationPolicy, issues);
    _addReviewBacklogWarnings(
      sources: sources,
      claims: claims,
      recommendations: recommendations,
      reviews: reviews,
      issues: issues,
    );

    return CoachingCatalogAuditReport(
      catalogVersion: catalogVersion,
      sourceCount: sources.length,
      claimCount: claims.length,
      recommendationCount: recommendations.length,
      reviewCount: reviews.length,
      issues: List<CoachingAuditIssue>.unmodifiable(issues),
    );
  }

  static void _validateManifest(
    Directory root,
    Map<String, Object?> manifest,
    List<CoachingAuditIssue> issues,
  ) {
    if (_positiveInteger(manifest['schema_version']) == null) {
      _error(
        issues,
        code: 'manifest_schema_version_invalid',
        message: 'catalog-manifest.json needs a positive schema_version.',
      );
    }
    final String? version = _text(manifest['catalog_version']);
    if (version == null || !RegExp(r'^\d+\.\d+\.\d+$').hasMatch(version)) {
      _error(
        issues,
        code: 'catalog_version_invalid',
        message: 'catalog_version must use MAJOR.MINOR.PATCH.',
      );
    }
    final Map<String, Object?> digests = _map(manifest['artifact_digests']);
    for (final String filename in _digestArtifacts) {
      final File file = File('${root.path}/$filename');
      if (!file.existsSync()) {
        _error(
          issues,
          code: 'required_artifact_missing',
          message: '$filename is required by the catalogue manifest.',
          artifactType: 'manifest',
          artifactId: filename,
        );
        continue;
      }
      final String? expected = _text(digests[filename]);
      final String actual = 'sha256:${sha256.convert(file.readAsBytesSync())}';
      if (expected == null || expected != actual) {
        _error(
          issues,
          code: 'artifact_digest_mismatch',
          message: '$filename does not match its immutable manifest digest.',
          artifactType: 'manifest',
          artifactId: filename,
        );
      }
    }
  }

  static _RightsIndex _validateRightsRegistry(
    Map<String, Object?> registry,
    Map<String, Map<String, Object?>> sourcesById,
    List<CoachingAuditIssue> issues,
  ) {
    if (_positiveInteger(registry['schema_version']) == null) {
      _error(
        issues,
        code: 'rights_schema_version_invalid',
        message: 'rights-policies.json needs a positive schema_version.',
      );
    }
    final Map<String, Object?> rawPolicies = _map(registry['policies']);
    final Map<String, _RightsPolicy> policies = <String, _RightsPolicy>{};
    for (final MapEntry<String, Object?> entry in rawPolicies.entries) {
      final Map<String, Object?> row = _map(entry.value);
      final String? licenseId = _text(row['license_id']);
      final String? usageMode = _text(row['usage_mode']);
      final bool? allowShadow = row['allow_shadow'] as bool?;
      final bool? allowLive = row['allow_live'] as bool?;
      if (licenseId == null ||
          usageMode == null ||
          allowShadow == null ||
          allowLive == null) {
        _error(
          issues,
          code: 'rights_policy_incomplete',
          message: 'Rights policy ${entry.key} lacks licence or usage gates.',
          artifactType: 'rights_policy',
          artifactId: entry.key,
        );
        continue;
      }
      policies[entry.key] = _RightsPolicy(
        licenseId: licenseId,
        usageMode: usageMode,
        allowShadow: allowShadow,
        allowLive: allowLive,
      );
    }
    final Map<String, Object?> rawAssignments = _map(
      registry['source_policy_ids'],
    );
    final Map<String, _RightsPolicy> bySourceId = <String, _RightsPolicy>{};
    for (final String sourceId in sourcesById.keys) {
      final String? policyId = _text(rawAssignments[sourceId]);
      final _RightsPolicy? policy = policyId == null
          ? null
          : policies[policyId];
      if (policy == null) {
        _error(
          issues,
          code: 'source_rights_policy_missing',
          message: 'Source $sourceId has no known rights policy.',
          artifactType: 'source',
          artifactId: sourceId,
        );
        continue;
      }
      bySourceId[sourceId] = policy;
    }
    for (final String sourceId in rawAssignments.keys) {
      if (!sourcesById.containsKey(sourceId)) {
        _error(
          issues,
          code: 'rights_assignment_orphaned',
          message: 'Rights assignment references unknown source $sourceId.',
          artifactType: 'source',
          artifactId: sourceId,
        );
      }
    }
    return _RightsIndex(bySourceId);
  }

  static _ReviewIndex _validateReviews(
    List<Map<String, Object?>> reviews,
    Map<String, Map<String, Object?>> sourcesById,
    Map<String, Map<String, Object?>> claimsById,
    List<Map<String, Object?>> recommendations,
    List<CoachingAuditIssue> issues,
  ) {
    final Set<String> recommendationIds = recommendations
        .map((Map<String, Object?> row) => _text(row['id']))
        .whereType<String>()
        .toSet();
    final Set<String> reviewIds = <String>{};
    final Map<String, Set<String>> approvals = <String, Set<String>>{};
    for (final Map<String, Object?> review in reviews) {
      final String? reviewId = _text(review['id']);
      final String? artifactType = _text(review['artifact_type']);
      final String? artifactId = _text(review['artifact_id']);
      final int? artifactVersion = _positiveInteger(review['artifact_version']);
      final String? reviewerId = _text(review['reviewer_id']);
      final String? decision = _text(review['decision']);
      final String? reviewedAt = _text(review['reviewed_at']);
      final bool validDate =
          reviewedAt != null && DateTime.tryParse(reviewedAt) != null;
      final bool knownArtifact = switch (artifactType) {
        'source' => artifactId != null && sourcesById.containsKey(artifactId),
        'claim' => artifactId != null && claimsById.containsKey(artifactId),
        'recommendation' =>
          artifactId != null && recommendationIds.contains(artifactId),
        _ => false,
      };
      if (reviewId == null ||
          artifactType == null ||
          artifactId == null ||
          artifactVersion == null ||
          reviewerId == null ||
          !const <String>{'approve', 'reject'}.contains(decision) ||
          !validDate ||
          !knownArtifact) {
        _error(
          issues,
          code: 'human_review_invalid',
          message:
              'A review entry is incomplete or references an artifact '
              'that does not exist.',
          artifactType: artifactType,
          artifactId: artifactId ?? reviewId,
        );
        continue;
      }
      if (!reviewIds.add(reviewId)) {
        _error(
          issues,
          code: 'human_review_id_duplicate',
          message: 'Duplicate human review id $reviewId.',
          artifactType: artifactType,
          artifactId: artifactId,
        );
      }
      final Map<String, Object?> artifact = switch (artifactType) {
        'source' => sourcesById[artifactId]!,
        'claim' => claimsById[artifactId]!,
        _ => recommendations.firstWhere(
          (Map<String, Object?> row) => _text(row['id']) == artifactId,
        ),
      };
      final int currentVersion = _positiveInteger(artifact['version']) ?? 1;
      if (artifactVersion != currentVersion) {
        _warning(
          issues,
          code: 'human_review_stale',
          message:
              'Review $reviewId targets version $artifactVersion but '
              '$artifactId is version $currentVersion.',
          artifactType: artifactType,
          artifactId: artifactId,
        );
        continue;
      }
      if (decision == 'approve') {
        approvals
            .putIfAbsent(
              '$artifactType:$artifactId:$artifactVersion',
              () => <String>{},
            )
            .add(reviewerId);
      }
    }
    return _ReviewIndex(approvals);
  }

  static int _minimumReviews(
    Map<String, Object?> releasePolicy,
    List<CoachingAuditIssue> issues,
  ) {
    final int? minimum = _positiveInteger(
      _map(releasePolicy['promotion'])['minimum_offline_reviews'],
    );
    if (minimum == null) {
      _error(
        issues,
        code: 'minimum_human_reviews_missing',
        message: 'Promotion policy needs minimum_offline_reviews.',
      );
      return 2;
    }
    return minimum;
  }

  static void _validateSources(
    List<Map<String, Object?>> sources,
    _RightsIndex rights,
    List<CoachingAuditIssue> issues,
  ) {
    for (final Map<String, Object?> source in sources) {
      final String id = _text(source['id']) ?? 'unknown';
      final List<String> authors = _stringList(source['authors']);
      final String? urlText = _text(source['locator_url']);
      final Uri? url = urlText == null ? null : Uri.tryParse(urlText);
      final Map<String, Object?> sourceRights = _map(source['rights']);
      final bool complete =
          _positiveInteger(source['version']) != null &&
          _text(source['title']) != null &&
          authors.isNotEmpty &&
          _text(source['provenance']) != null &&
          _text(source['method']) != null &&
          DateTime.tryParse(_text(source['published_at']) ?? '') != null &&
          url != null &&
          url.scheme == 'https' &&
          url.host.isNotEmpty &&
          _text(sourceRights['status']) != null &&
          _text(sourceRights['basis']) != null &&
          sourceRights['commercial_use'] is bool &&
          DateTime.tryParse(_text(sourceRights['reviewed_at']) ?? '') != null &&
          rights.bySourceId.containsKey(id);
      if (!complete) {
        _error(
          issues,
          code: 'source_provenance_incomplete',
          message:
              'Source $id lacks versioned bibliographic, URL, or rights '
              'metadata.',
          artifactType: 'source',
          artifactId: id,
        );
      }
    }
  }

  static void _validateClaims(
    List<Map<String, Object?>> claims,
    Map<String, Map<String, Object?>> sourcesById,
    _RightsIndex rights,
    _ReviewIndex reviews,
    int minimumReviews,
    List<CoachingAuditIssue> issues,
  ) {
    for (final Map<String, Object?> claim in claims) {
      final String id = _text(claim['id']) ?? 'unknown';
      final String status = _text(claim['status']) ?? 'unknown';
      final int? version = _positiveInteger(claim['version']);
      final List<String> sourceIds = _stringList(claim['source_ids']);
      final List<String> locators = _stringList(claim['source_locators']);
      final bool referencesValid =
          sourceIds.isNotEmpty &&
          sourceIds.length == locators.length &&
          sourceIds.every(sourcesById.containsKey);
      if (version == null ||
          _text(claim['statement']) == null ||
          _text(claim['evidence_grade']) == null ||
          _stringList(claim['limitations']).isEmpty ||
          !referencesValid ||
          !const <String>{
            'draft',
            'review',
            'approved',
            'shadow',
            'live',
            'retired',
          }.contains(status)) {
        _error(
          issues,
          code: 'claim_invalid',
          message: 'Claim $id is incomplete or has invalid source links.',
          artifactType: 'claim',
          artifactId: id,
        );
        continue;
      }
      if (const <String>{'approved', 'shadow', 'live'}.contains(status)) {
        _requireHumanApprovals(
          artifactType: 'claim',
          artifactId: id,
          version: version,
          minimumReviews: minimumReviews,
          reviews: reviews,
          issues: issues,
        );
        _requireSourceRights(
          sourceIds: sourceIds,
          mode: status == 'live' ? 'live' : 'shadow',
          rights: rights,
          artifactType: 'claim',
          artifactId: id,
          issues: issues,
        );
      }
    }
  }

  static void _validateRecommendations(
    List<Map<String, Object?>> recommendations,
    Map<String, Map<String, Object?>> sourcesById,
    Map<String, Map<String, Object?>> claimsById,
    _RightsIndex rights,
    _ReviewIndex reviews,
    int minimumReviews,
    List<CoachingAuditIssue> issues,
  ) {
    for (final Map<String, Object?> recommendation in recommendations) {
      final String id = _text(recommendation['id']) ?? 'unknown';
      final String status = _text(recommendation['status']) ?? 'unknown';
      final int? version = _positiveInteger(recommendation['version']);
      final List<String> claimIds = _stringList(recommendation['claim_ids']);
      final List<String> sourceIds = _stringList(recommendation['source_ids']);
      final Set<String> claimSourceIds = claimIds
          .map((String claimId) => claimsById[claimId])
          .whereType<Map<String, Object?>>()
          .expand(
            (Map<String, Object?> claim) => _stringList(claim['source_ids']),
          )
          .toSet();
      final Map<String, Object?> confidence = _map(
        recommendation['confidence'],
      );
      final bool confidenceValid = const <String>{
        'evidence',
        'context_minimum',
        'live_minimum',
      }.every((String key) => _unitInterval(confidence[key]) != null);
      final bool referencesValid =
          claimIds.isNotEmpty &&
          sourceIds.isNotEmpty &&
          claimIds.every(claimsById.containsKey) &&
          sourceIds.every(sourcesById.containsKey) &&
          sourceIds.every(claimSourceIds.contains);
      if (version == null ||
          _text(_map(recommendation['action'])['suggestion']) == null ||
          _text(_map(recommendation['trigger'])['signal']) == null ||
          !confidenceValid ||
          !referencesValid ||
          !const <String>{
            'draft',
            'review',
            'shadow',
            'live',
            'retired',
          }.contains(status)) {
        _error(
          issues,
          code: 'recommendation_invalid',
          message:
              'Recommendation $id is incomplete or not grounded in its '
              'declared claims and sources.',
          artifactType: 'recommendation',
          artifactId: id,
        );
        continue;
      }
      if (const <String>{'shadow', 'live'}.contains(status)) {
        final bool allClaimsApproved = claimIds.every((String claimId) {
          final String claimStatus =
              _text(claimsById[claimId]?['status']) ?? '';
          return const <String>{
            'approved',
            'shadow',
            'live',
          }.contains(claimStatus);
        });
        if (!allClaimsApproved) {
          _error(
            issues,
            code: 'recommendation_claim_not_approved',
            message:
                'Recommendation $id cannot be promoted before every '
                'claim is approved.',
            artifactType: 'recommendation',
            artifactId: id,
          );
        }
        _requireHumanApprovals(
          artifactType: 'recommendation',
          artifactId: id,
          version: version,
          minimumReviews: minimumReviews,
          reviews: reviews,
          issues: issues,
        );
        _requireSourceRights(
          sourceIds: sourceIds,
          mode: status,
          rights: rights,
          artifactType: 'recommendation',
          artifactId: id,
          issues: issues,
        );
      }
    }
  }

  static void _validateEvaluationPolicy(
    Map<String, Object?> policy,
    List<CoachingAuditIssue> issues,
  ) {
    try {
      final CoachingShadowPolicy parsed = CoachingShadowPolicy.fromJson(policy);
      if (parsed.maximumP95LatencyMilliseconds == null) {
        _warning(
          issues,
          code: 'latency_gate_not_configured',
          message:
              'Shadow evaluation reports latency, but the product owner '
              'has not yet versioned a p95 budget.',
        );
      }
      if (parsed.maximumAverageCostUsd == null) {
        _warning(
          issues,
          code: 'cost_gate_not_configured',
          message:
              'Shadow evaluation reports cost, but unit economics have '
              'not yet produced a versioned average-cost budget.',
        );
      }
    } on FormatException catch (error) {
      _error(issues, code: 'evaluation_policy_invalid', message: error.message);
    }
  }

  static void _addReviewBacklogWarnings({
    required List<Map<String, Object?>> sources,
    required List<Map<String, Object?>> claims,
    required List<Map<String, Object?>> recommendations,
    required List<Map<String, Object?>> reviews,
    required List<CoachingAuditIssue> issues,
  }) {
    if (reviews.isNotEmpty) {
      return;
    }
    _warning(
      issues,
      code: 'human_review_backlog',
      message:
          'No human review is recorded yet for ${sources.length} sources, '
          '${claims.length} claims, and ${recommendations.length} '
          'recommendations. Draft artifacts remain blocked from strict live '
          'use.',
    );
  }

  static void _requireHumanApprovals({
    required String artifactType,
    required String artifactId,
    required int version,
    required int minimumReviews,
    required _ReviewIndex reviews,
    required List<CoachingAuditIssue> issues,
  }) {
    final int approvals = reviews.approvalsFor(
      artifactType,
      artifactId,
      version,
    );
    if (approvals < minimumReviews) {
      _error(
        issues,
        code: 'human_approval_missing',
        message:
            '$artifactType $artifactId version $version has $approvals '
            'distinct approval(s); $minimumReviews are required.',
        artifactType: artifactType,
        artifactId: artifactId,
      );
    }
  }

  static void _requireSourceRights({
    required List<String> sourceIds,
    required String mode,
    required _RightsIndex rights,
    required String artifactType,
    required String artifactId,
    required List<CoachingAuditIssue> issues,
  }) {
    for (final String sourceId in sourceIds) {
      final _RightsPolicy? policy = rights.bySourceId[sourceId];
      final bool allowed = switch (mode) {
        'live' => policy?.allowLive ?? false,
        _ => policy?.allowShadow ?? false,
      };
      if (!allowed) {
        _error(
          issues,
          code: 'source_rights_block_promotion',
          message:
              '$artifactType $artifactId cannot enter $mode because '
              '$sourceId is restricted to ${policy?.usageMode ?? 'unknown'}.',
          artifactType: artifactType,
          artifactId: artifactId,
        );
      }
    }
  }

  static Map<String, Map<String, Object?>> _indexRows(
    List<Map<String, Object?>> rows,
    String artifactType,
    List<CoachingAuditIssue> issues,
  ) {
    final Map<String, Map<String, Object?>> result =
        <String, Map<String, Object?>>{};
    for (final Map<String, Object?> row in rows) {
      final String? id = _text(row['id']);
      if (id == null) {
        _error(
          issues,
          code: '${artifactType}_id_missing',
          message: 'A $artifactType record has no id.',
          artifactType: artifactType,
        );
        continue;
      }
      if (result.containsKey(id)) {
        _error(
          issues,
          code: '${artifactType}_id_duplicate',
          message: 'Duplicate $artifactType id $id.',
          artifactType: artifactType,
          artifactId: id,
        );
        continue;
      }
      result[id] = row;
    }
    return result;
  }

  static Map<String, Object?> _readObject(
    Directory root,
    String filename,
    List<CoachingAuditIssue> issues,
  ) {
    final Object? decoded = _readJson(root, filename, issues);
    if (decoded is Map<String, Object?>) {
      return decoded;
    }
    _error(
      issues,
      code: 'artifact_shape_invalid',
      message: '$filename must contain a JSON object.',
      artifactType: 'file',
      artifactId: filename,
    );
    return const <String, Object?>{};
  }

  static List<Map<String, Object?>> _readRows(
    Directory root,
    String filename,
    List<CoachingAuditIssue> issues,
  ) {
    final Object? decoded = _readJson(root, filename, issues);
    if (decoded is List<Object?>) {
      return _objectRows(decoded);
    }
    _error(
      issues,
      code: 'artifact_shape_invalid',
      message: '$filename must contain a JSON array.',
      artifactType: 'file',
      artifactId: filename,
    );
    return const <Map<String, Object?>>[];
  }

  static Object? _readJson(
    Directory root,
    String filename,
    List<CoachingAuditIssue> issues,
  ) {
    final File file = File('${root.path}/$filename');
    if (!file.existsSync()) {
      _error(
        issues,
        code: 'artifact_missing',
        message: '$filename is missing.',
        artifactType: 'file',
        artifactId: filename,
      );
      return null;
    }
    try {
      return jsonDecode(file.readAsStringSync());
    } on FormatException catch (error) {
      _error(
        issues,
        code: 'artifact_json_invalid',
        message: '$filename is not valid JSON: ${error.message}.',
        artifactType: 'file',
        artifactId: filename,
      );
      return null;
    }
  }

  static List<Map<String, Object?>> _objectRows(Object? value) {
    if (value is! List<Object?>) {
      return const <Map<String, Object?>>[];
    }
    return value.whereType<Map<String, Object?>>().toList(growable: false);
  }

  static Map<String, Object?> _map(Object? value) =>
      value is Map<String, Object?> ? value : const <String, Object?>{};

  static String? _text(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }
    return value.trim();
  }

  static int? _positiveInteger(Object? value) =>
      value is int && value > 0 ? value : null;

  static double? _unitInterval(Object? value) =>
      value is num && value.isFinite && value >= 0 && value <= 1
      ? value.toDouble()
      : null;

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

  static void _error(
    List<CoachingAuditIssue> issues, {
    required String code,
    required String message,
    String? artifactType,
    String? artifactId,
  }) {
    issues.add(
      CoachingAuditIssue(
        code: code,
        message: message,
        severity: CoachingAuditSeverity.error,
        artifactType: artifactType,
        artifactId: artifactId,
      ),
    );
  }

  static void _warning(
    List<CoachingAuditIssue> issues, {
    required String code,
    required String message,
    String? artifactType,
    String? artifactId,
  }) {
    issues.add(
      CoachingAuditIssue(
        code: code,
        message: message,
        severity: CoachingAuditSeverity.warning,
        artifactType: artifactType,
        artifactId: artifactId,
      ),
    );
  }
}

final class _RightsIndex {
  const _RightsIndex(this.bySourceId);

  final Map<String, _RightsPolicy> bySourceId;
}

final class _RightsPolicy {
  const _RightsPolicy({
    required this.licenseId,
    required this.usageMode,
    required this.allowShadow,
    required this.allowLive,
  });

  final String licenseId;
  final String usageMode;
  final bool allowShadow;
  final bool allowLive;
}

final class _ReviewIndex {
  const _ReviewIndex(this._approvals);

  final Map<String, Set<String>> _approvals;

  int approvalsFor(String artifactType, String artifactId, int version) =>
      _approvals['$artifactType:$artifactId:$version']?.length ?? 0;
}
