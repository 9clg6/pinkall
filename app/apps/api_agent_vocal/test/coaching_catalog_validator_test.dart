import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/coaching_quality_models.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/coaching_catalog_validator.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/file_coach_catalog.dart';
import 'package:crypto/crypto.dart';
import 'package:test/test.dart';

void main() {
  final String catalogPath = _catalogPath();

  test('audits every current catalogue artifact without approving drafts', () {
    final CoachingCatalogAuditReport report = const CoachingCatalogValidator()
        .validateDirectory(catalogPath);

    expect(report.isValid, isTrue);
    expect(report.catalogVersion, '1.1.0');
    expect(report.sourceCount, 38);
    expect(report.claimCount, 38);
    expect(report.recommendationCount, 50);
    expect(report.reviewCount, 0);
    expect(report.errorCount, 0);
    expect(
      report.issues.map((CoachingAuditIssue issue) => issue.code),
      containsAll(<String>[
        'human_review_backlog',
        'latency_gate_not_configured',
        'cost_gate_not_configured',
      ]),
    );
  });

  test('runtime refuses strict draft cards after the successful audit', () {
    final FileCoachCatalog strict = FileCoachCatalog.load(catalogPath);
    final FileCoachCatalog internalAlpha = FileCoachCatalog.load(
      catalogPath,
      releaseChannel: CoachReleaseChannel.internalAlpha,
    );

    expect(strict.isAvailable, isTrue);
    expect(
      strict.candidatesFor(mode: CoachMode.live, latestText: 'budget'),
      isEmpty,
    );
    expect(internalAlpha.isAvailable, isTrue);
    expect(
      internalAlpha.candidatesFor(mode: CoachMode.live, latestText: 'budget'),
      isNotEmpty,
    );
  });

  test('rejects an artifact changed without a manifest version update', () {
    final Directory copy = _copyCatalog(catalogPath);
    addTearDown(() => copy.deleteSync(recursive: true));
    final File sources = File('${copy.path}/sources.json');
    sources.writeAsStringSync('${sources.readAsStringSync()}\n');

    final CoachingCatalogAuditReport report = const CoachingCatalogValidator()
        .validateDirectory(copy.path);

    expect(report.isValid, isFalse);
    expect(
      report.issues,
      contains(
        isA<CoachingAuditIssue>()
            .having(
              (CoachingAuditIssue issue) => issue.code,
              'code',
              'artifact_digest_mismatch',
            )
            .having(
              (CoachingAuditIssue issue) => issue.artifactId,
              'artifact',
              'sources.json',
            ),
      ),
    );
  });

  test('blocks claim promotion without version-matched human approvals', () {
    final Directory copy = _copyCatalog(catalogPath);
    addTearDown(() => copy.deleteSync(recursive: true));
    final File claimsFile = File('${copy.path}/claims.json');
    final List<Object?> claims =
        jsonDecode(claimsFile.readAsStringSync()) as List<Object?>;
    final Map<String, Object?> first = claims.first! as Map<String, Object?>;
    first['status'] = 'approved';
    claimsFile.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(claims),
    );
    _updateDigest(copy, 'claims.json');

    final CoachingCatalogAuditReport report = const CoachingCatalogValidator()
        .validateDirectory(copy.path);

    expect(report.isValid, isFalse);
    expect(
      report.issues,
      contains(
        isA<CoachingAuditIssue>()
            .having(
              (CoachingAuditIssue issue) => issue.code,
              'code',
              'human_approval_missing',
            )
            .having(
              (CoachingAuditIssue issue) => issue.artifactId,
              'claim',
              first['id'],
            ),
      ),
    );
  });
}

String _catalogPath() {
  Directory cursor = Directory.current.absolute;
  for (int depth = 0; depth < 8; depth += 1) {
    for (final String relative in const <String>[
      'knowledge/coaching',
      'app/knowledge/coaching',
    ]) {
      final Directory candidate = Directory('${cursor.path}/$relative');
      if (File('${candidate.path}/catalog-manifest.json').existsSync()) {
        return candidate.path;
      }
    }
    final Directory parent = cursor.parent;
    if (parent.path == cursor.path) {
      break;
    }
    cursor = parent;
  }
  throw StateError('Pinkall coaching catalogue not found from test cwd.');
}

Directory _copyCatalog(String sourcePath) {
  final Directory destination = Directory.systemTemp.createTempSync(
    'pinkall-coaching-audit-',
  );
  for (final FileSystemEntity entity in Directory(sourcePath).listSync()) {
    if (entity is File) {
      File(
        '${destination.path}/${entity.uri.pathSegments.last}',
      ).writeAsBytesSync(entity.readAsBytesSync());
    }
  }
  return destination;
}

void _updateDigest(Directory directory, String filename) {
  final File manifestFile = File('${directory.path}/catalog-manifest.json');
  final Map<String, Object?> manifest =
      jsonDecode(manifestFile.readAsStringSync()) as Map<String, Object?>;
  final Map<String, Object?> digests =
      manifest['artifact_digests']! as Map<String, Object?>;
  final File artifact = File('${directory.path}/$filename');
  digests[filename] = 'sha256:${sha256.convert(artifact.readAsBytesSync())}';
  manifestFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(manifest),
  );
}
