import 'dart:io';
import 'dart:math' as math;

import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/infrastructure/catalog/file_coach_catalog.dart';
import 'package:api_agent_vocal/src/infrastructure/coach/openai_coach_gateway.dart';
import 'package:test/test.dart';

void main() {
  final String? apiKey = Platform.environment['OPENAI_API_KEY'];

  test('internal alpha catalog exposes the grounded price card', () {
    final FileCoachCatalog catalog = FileCoachCatalog.load(
      _coachCatalogDirectory(),
      releaseChannel: CoachReleaseChannel.internalAlpha,
    );
    final List<CoachRecommendation> candidates = catalog.candidatesFor(
      mode: CoachMode.live,
      latestText: _priceObjection,
    );
    final CoachRecommendation priceCard = candidates.singleWhere(
      (CoachRecommendation item) =>
          item.id == 'rec_pricing_too_expensive_diagnose',
    );
    final Map<String, Object?> confidence =
        priceCard.raw['confidence']! as Map<String, Object?>;

    expect(catalog.isAvailable, isTrue);
    expect(priceCard.sources, isNotEmpty);
    expect(
      priceCard.sources.every((CoachSource source) => source.locator != null),
      isTrue,
    );
    expect(confidence['live_minimum'], 0.88);
    expect(confidence['context_minimum'], 0.8);
  });

  test(
    'OpenAI live API accepts the strict Pinkall coaching contract',
    () async {
      final OpenAiCoachGateway gateway = OpenAiCoachGateway(
        apiKey: apiKey!,
        baseUrl:
            Platform.environment['OPENAI_BASE_URL'] ??
            'https://api.openai.com/v1',
        model: Platform.environment['OPENAI_COACH_MODEL'] ?? 'gpt-5.4-mini',
        reasoningEffort:
            Platform.environment['OPENAI_COACH_REASONING_EFFORT'] ?? 'none',
        requestDeadline: const Duration(seconds: 20),
      );
      final TranscriptSegment triggeringSegment = TranscriptSegment(
        id: 'segment-prospect-1',
        track: MediaTrack.inbound,
        speaker: SpeakerRole.prospect,
        text: 'Ce sujet est intéressant, mais ce n’est pas prioritaire.',
        startSeconds: 0,
        endSeconds: 3,
        isFinal: true,
        provider: 'contract-smoke',
        createdAt: DateTime.utc(2026, 7, 13),
      );
      final CoachSelection selection = await gateway.select(
        sessionId: 'external-contract-smoke',
        transcript: <TranscriptSegment>[triggeringSegment],
        triggeringSegment: triggeringSegment,
        candidates: const <CoachRecommendation>[
          CoachRecommendation(
            id: 'rec-priority-question',
            status: 'internal_alpha',
            message: 'Demande quel événement rendrait le sujet prioritaire.',
            sourceIds: <String>['source-smoke'],
            sources: <CoachSource>[
              CoachSource(
                id: 'source-smoke',
                title: 'Contract smoke source',
                evidenceLevel: 'expert',
                author: null,
                url: null,
                locator: null,
              ),
            ],
            triggers: <String>['pas prioritaire', 'plus tard'],
            raw: <String, Object?>{
              'claim_ids': <String>['claim-smoke'],
              'trigger': 'Le prospect reporte le sujet sans critère précis.',
              'triggers': <String>['pas prioritaire', 'plus tard'],
              'contexts': <String>['cold_call'],
              'observation_template': 'Le prospect reporte le sujet.',
              'hypothesis': 'La priorité dépend peut-être d’un déclencheur.',
              'action': 'Faire préciser le déclencheur de priorité.',
              'confidence': <String, Object?>{'evidence': 0.9},
            },
          ),
        ],
      );

      expect(selection.reasonCode, isNotEmpty);
      if (selection.recommendationId != null) {
        expect(selection.recommendationId, 'rec-priority-question');
        expect(selection.evidenceSegmentIds, contains('segment-prospect-1'));
      }
    },
    skip: apiKey == null || apiKey.isEmpty
        ? 'Set OPENAI_API_KEY to run the external contract smoke.'
        : false,
    timeout: const Timeout(Duration(seconds: 30)),
  );

  test(
    'OpenAI selects a grounded card for the complete live price objection',
    () async {
      final OpenAiCoachGateway gateway = OpenAiCoachGateway(
        apiKey: apiKey!,
        baseUrl:
            Platform.environment['OPENAI_BASE_URL'] ??
            'https://api.openai.com/v1',
        model: Platform.environment['OPENAI_COACH_MODEL'] ?? 'gpt-5.4-mini',
        reasoningEffort:
            Platform.environment['OPENAI_COACH_REASONING_EFFORT'] ?? 'none',
        requestDeadline: const Duration(seconds: 20),
      );
      final FileCoachCatalog catalog = FileCoachCatalog.load(
        _coachCatalogDirectory(),
        releaseChannel: CoachReleaseChannel.internalAlpha,
      );
      final List<CoachRecommendation> candidates = catalog.candidatesFor(
        mode: CoachMode.live,
        latestText: _priceObjection,
      );
      expect(candidates, isNotEmpty);
      const String expectedRecommendationId =
          'rec_pricing_too_expensive_diagnose';
      expect(
        candidates.map((CoachRecommendation item) => item.id),
        contains(expectedRecommendationId),
      );
      final CoachRecommendation priceCard = candidates.singleWhere(
        (CoachRecommendation item) => item.id == expectedRecommendationId,
      );
      final TranscriptSegment sellerOpening = TranscriptSegment(
        id: 'segment-seller-opening',
        track: MediaTrack.outbound,
        speaker: SpeakerRole.seller,
        text: 'Pourquoi vous êtes-vous inscrit et de quoi avez-vous besoin ?',
        startSeconds: 0,
        endSeconds: 4,
        isFinal: true,
        provider: 'contract-smoke',
        createdAt: DateTime.utc(2026, 7, 13),
      );
      final TranscriptSegment triggeringSegment = TranscriptSegment(
        id: 'segment-prospect-price-objection',
        track: MediaTrack.inbound,
        speaker: SpeakerRole.prospect,
        text: _priceObjection,
        startSeconds: 5,
        endSeconds: 11,
        isFinal: true,
        provider: 'contract-smoke',
        createdAt: DateTime.utc(2026, 7, 13),
      );

      final Stopwatch requestLatency = Stopwatch()..start();
      final CoachSelection selection = await gateway.select(
        sessionId: 'external-price-objection-smoke',
        transcript: <TranscriptSegment>[sellerOpening, triggeringSegment],
        triggeringSegment: triggeringSegment,
        candidates: candidates,
      );
      requestLatency.stop();

      expect(selection.recommendationId, expectedRecommendationId);
      expect(
        selection.evidenceSegmentIds,
        contains('segment-prospect-price-objection'),
      );
      final Map<String, Object?> confidencePolicy = Map<String, Object?>.from(
        priceCard.raw['confidence']! as Map<Object?, Object?>,
      );
      final double minimumConfidence = math.max(
        double.tryParse(Platform.environment['COACH_MIN_CONFIDENCE'] ?? '') ??
            0.75,
        math.max(
          catalog.minimumLiveConfidence,
          (confidencePolicy['live_minimum']! as num).toDouble(),
        ),
      );
      final double minimumContextMatch = math.max(
        catalog.minimumContextMatch,
        (confidencePolicy['context_minimum']! as num).toDouble(),
      );
      stdout.writeln(
        'pinkall.openai.price_smoke '
        'recommendation_id=${selection.recommendationId} '
        'candidate_count=${candidates.length} '
        'latency_ms=${requestLatency.elapsedMilliseconds} '
        'confidence=${selection.confidence} '
        'minimum_confidence=$minimumConfidence '
        'context_match=${selection.contextMatch} '
        'minimum_context_match=$minimumContextMatch',
      );
      expect(selection.confidence, greaterThanOrEqualTo(minimumConfidence));
      expect(selection.contextMatch, greaterThanOrEqualTo(minimumContextMatch));
      expect(
        selection.reasonCode,
        matches(RegExp(r'^[a-z0-9][a-z0-9_]{0,63}$')),
      );
    },
    skip: apiKey == null || apiKey.isEmpty
        ? 'Set OPENAI_API_KEY to run the external contract smoke.'
        : false,
    timeout: const Timeout(Duration(seconds: 30)),
  );
}

const String _priceObjection =
    "Alors, je n'ai eu aucune demande et, du coup, 29,99 euros par mois, "
    "c'est un peu trop élevé.";

String _coachCatalogDirectory() {
  final String? configured = Platform.environment['COACH_CATALOG_DIR'];
  if (configured != null &&
      configured.trim().isNotEmpty &&
      Directory(configured.trim()).existsSync()) {
    return configured.trim();
  }
  for (final String candidate in const <String>[
    'knowledge/coaching',
    '../../knowledge/coaching',
  ]) {
    if (Directory(candidate).existsSync()) {
      return candidate;
    }
  }
  throw StateError('Pinkall coaching catalogue was not found.');
}
