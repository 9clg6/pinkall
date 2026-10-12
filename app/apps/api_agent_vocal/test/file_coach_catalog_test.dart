import 'dart:convert';
import 'dart:io';

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/file_coach_catalog.dart';
import 'package:test/test.dart';

void main() {
  test('enforces release status, evidence and action.suggestion', () {
    final Directory directory = Directory.systemTemp.createTempSync(
      'pinkall-catalog-',
    );
    addTearDown(() => directory.deleteSync(recursive: true));
    File('${directory.path}/release-policy.json').writeAsStringSync(
      jsonEncode(<String, Object?>{
        'display': <String, Object?>{
          'max_suggestions_per_minute': 2,
          'max_evaluations_per_minute': 12,
          'global_cooldown_seconds': 24,
          'default_expiry_seconds': 12,
        },
        'eligibility': <String, Object?>{
          'minimum_evidence_confidence': 0.7,
          'minimum_context_match': 0.82,
          'minimum_overall_live_confidence': 0.84,
          'require_source_locator': true,
        },
      }),
    );
    File('${directory.path}/recommendations.json').writeAsStringSync(
      jsonEncode(<Map<String, Object?>>[
        _card('draft-card', 'draft', 1),
        _card('shadow-card', 'shadow', 0.8),
        _card('live-card', 'live', 0.9),
        _card('weak-live-card', 'live', 0.2),
      ]),
    );
    File('${directory.path}/claims.json').writeAsStringSync(
      jsonEncode(<Map<String, Object?>>[
        <String, Object?>{
          'id': 'claim-1',
          'status': 'approved',
          'source_ids': <String>['source-1'],
          'source_locators': <String>['Journal, p. 1'],
        },
      ]),
    );
    File('${directory.path}/sources.json').writeAsStringSync(
      jsonEncode(<Map<String, Object?>>[
        <String, Object?>{
          'id': 'source-1',
          'title': 'Controlled sales experiment',
          'authors': <String>['Researcher'],
          'method': 'controlled_experiment',
          'locator_url': 'https://example.test/paper',
        },
      ]),
    );

    final FileCoachCatalog catalog = FileCoachCatalog.load(
      directory.path,
      enforceCatalogAudit: false,
    );

    expect(catalog.isAvailable, isTrue);
    expect(catalog.maxEvaluationsPerMinute, 12);
    expect(
      catalog
          .candidatesFor(mode: CoachMode.shadow, latestText: 'budget')
          .map((CoachRecommendation item) => item.id),
      <String>['shadow-card', 'live-card'],
    );
    final List<CoachRecommendation> live = catalog.candidatesFor(
      mode: CoachMode.live,
      latestText: 'budget',
    );
    expect(live.map((CoachRecommendation item) => item.id), <String>[
      'live-card',
    ]);
    expect(live.single.message, 'Pose la prochaine question utile.');
    expect(live.single.sources.single.toClientJson(), <String, Object?>{
      'id': 'source-1',
      'title': 'Controlled sales experiment',
      'evidence_level': 'experimental',
      'author': 'Researcher',
      'url': 'https://example.test/paper',
      'locator': 'Journal, p. 1',
    });
  });

  test(
    'internal alpha exposes grounded draft cards without labelling them approved',
    () {
      final Directory directory = Directory.systemTemp.createTempSync(
        'pinkall-alpha-catalog-',
      );
      addTearDown(() => directory.deleteSync(recursive: true));
      File('${directory.path}/release-policy.json').writeAsStringSync(
        jsonEncode(<String, Object?>{
          'display': <String, Object?>{
            'max_suggestions_per_minute': 2,
            'global_cooldown_seconds': 24,
            'default_expiry_seconds': 12,
          },
          'eligibility': <String, Object?>{
            'minimum_evidence_confidence': 0.7,
            'minimum_context_match': 0.82,
            'minimum_overall_live_confidence': 0.84,
            'require_source_locator': true,
          },
        }),
      );
      File('${directory.path}/recommendations.json').writeAsStringSync(
        jsonEncode(
          List<Map<String, Object?>>.generate(
            25,
            (int index) => _card('draft-$index', 'draft', 0.8),
          ),
        ),
      );
      File('${directory.path}/claims.json').writeAsStringSync(
        jsonEncode(<Map<String, Object?>>[
          <String, Object?>{
            'id': 'claim-1',
            'status': 'draft',
            'source_ids': <String>['source-1'],
            'source_locators': <String>['Journal, p. 1'],
          },
        ]),
      );
      File('${directory.path}/sources.json').writeAsStringSync(
        jsonEncode(<Map<String, Object?>>[
          <String, Object?>{
            'id': 'source-1',
            'title': 'Controlled sales experiment',
            'method': 'controlled_experiment',
          },
        ]),
      );

      final FileCoachCatalog strict = FileCoachCatalog.load(
        directory.path,
        enforceCatalogAudit: false,
      );
      final FileCoachCatalog alpha = FileCoachCatalog.load(
        directory.path,
        releaseChannel: CoachReleaseChannel.internalAlpha,
        enforceCatalogAudit: false,
      );

      expect(
        strict.candidatesFor(mode: CoachMode.live, latestText: ''),
        isEmpty,
      );
      expect(strict.allowsUnreviewedRecommendations, isFalse);
      expect(alpha.allowsUnreviewedRecommendations, isTrue);
      expect(
        alpha.candidatesFor(mode: CoachMode.live, latestText: 'budget'),
        hasLength(25),
      );
      expect(alpha.postCallCandidates(), hasLength(25));
    },
  );

  test('internal alpha evidence override does not weaken strict releases', () {
    final Directory directory = Directory.systemTemp.createTempSync(
      'pinkall-alpha-evidence-',
    );
    addTearDown(() => directory.deleteSync(recursive: true));
    File('${directory.path}/release-policy.json').writeAsStringSync(
      jsonEncode(<String, Object?>{
        'display': <String, Object?>{},
        'eligibility': <String, Object?>{
          'minimum_evidence_confidence': 0.7,
          'internal_alpha_minimum_evidence_confidence': 0.48,
          'minimum_context_match': 0.82,
          'internal_alpha_minimum_context_match': 0.8,
          'minimum_overall_live_confidence': 0.84,
          'internal_alpha_minimum_overall_live_confidence': 0.84,
          'internal_alpha_maximum_card_context_minimum': 0.8,
          'internal_alpha_maximum_card_live_minimum': 0.88,
          'require_source_locator': true,
        },
      }),
    );
    File('${directory.path}/recommendations.json').writeAsStringSync(
      jsonEncode(<Map<String, Object?>>[
        _card(
          'price-card',
          'live',
          0.48,
          contextMinimum: 0.91,
          liveMinimum: 0.95,
        ),
        _card(
          'strong-card',
          'live',
          0.8,
          contextMinimum: 0.93,
          liveMinimum: 0.97,
        ),
      ]),
    );
    File('${directory.path}/claims.json').writeAsStringSync(
      jsonEncode(<Map<String, Object?>>[
        <String, Object?>{
          'id': 'claim-1',
          'status': 'approved',
          'source_ids': <String>['source-1'],
          'source_locators': <String>['Journal, p. 1'],
        },
      ]),
    );
    File('${directory.path}/sources.json').writeAsStringSync(
      jsonEncode(<Map<String, Object?>>[
        <String, Object?>{
          'id': 'source-1',
          'title': 'Controlled sales experiment',
          'method': 'controlled_experiment',
          'locator_url': 'https://example.test/paper',
        },
      ]),
    );

    final FileCoachCatalog strict = FileCoachCatalog.load(
      directory.path,
      enforceCatalogAudit: false,
    );
    final FileCoachCatalog alpha = FileCoachCatalog.load(
      directory.path,
      releaseChannel: CoachReleaseChannel.internalAlpha,
      enforceCatalogAudit: false,
    );

    final List<CoachRecommendation> strictCandidates = strict.candidatesFor(
      mode: CoachMode.live,
      latestText: 'trop cher',
    );
    expect(
      strictCandidates.map((CoachRecommendation item) => item.id),
      <String>['strong-card'],
    );
    expect(strictCandidates.single.raw['confidence'], <String, Object?>{
      'evidence': 0.8,
      'context_minimum': 0.93,
      'live_minimum': 0.97,
    });
    final List<CoachRecommendation> alphaCandidates = alpha.candidatesFor(
      mode: CoachMode.live,
      latestText: 'trop cher',
    );
    expect(
      alphaCandidates.map((CoachRecommendation item) => item.id).toSet(),
      <String>{'price-card', 'strong-card'},
    );
    for (final CoachRecommendation candidate in alphaCandidates) {
      final Map<String, Object?> confidence =
          candidate.raw['confidence']! as Map<String, Object?>;
      expect(confidence['context_minimum'], 0.8);
      expect(confidence['live_minimum'], 0.88);
    }
    expect(alpha.minimumContextMatch, 0.8);
    expect(alpha.minimumLiveConfidence, 0.84);
  });
}

Map<String, Object?> _card(
  String id,
  String status,
  double evidence, {
  double? contextMinimum,
  double? liveMinimum,
}) {
  return <String, Object?>{
    'id': id,
    'status': status,
    'source_ids': <String>['source-1'],
    'claim_ids': <String>['claim-1'],
    'trigger': <String, Object?>{'signal': 'budget'},
    'action': <String, Object?>{
      'suggestion': 'Pose la prochaine question utile.',
    },
    'confidence': <String, Object?>{
      'evidence': evidence,
      if (contextMinimum != null) 'context_minimum': contextMinimum,
      if (liveMinimum != null) 'live_minimum': liveMinimum,
    },
  };
}
