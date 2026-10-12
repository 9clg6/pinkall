import 'dart:convert';

import 'package:api_agent_vocal/src/domain/coach_contracts.dart';
import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/objection_learning.dart';

/// Adds user-authored objection answers to an already validated catalogue.
///
/// Custom answers are only retrieval candidates. OpenAI may select their ID,
/// but the text ultimately shown to the seller remains the server-stored text.
final class ObjectionAwareCoachCatalog implements CoachCatalog {
  const ObjectionAwareCoachCatalog({
    required CoachCatalog base,
    required ObjectionLibrary objectionLibrary,
  }) : _base = base,
       _objectionLibrary = objectionLibrary;

  final CoachCatalog _base;
  final ObjectionLibrary _objectionLibrary;

  @override
  bool get isAvailable => _base.isAvailable || _objectionLibrary.isAvailable;

  @override
  String? get unavailableReason => isAvailable
      ? null
      : _base.unavailableReason ?? _objectionLibrary.unavailableReason;

  @override
  bool get allowsUnreviewedRecommendations =>
      _base.allowsUnreviewedRecommendations;

  @override
  int get defaultExpirySeconds => _base.defaultExpirySeconds;

  @override
  Duration get globalCooldown => _base.globalCooldown;

  @override
  int get maxEvaluationsPerMinute => _base.maxEvaluationsPerMinute;

  @override
  int get maxSuggestionsPerMinute => _base.maxSuggestionsPerMinute;

  @override
  double get minimumContextMatch => _base.minimumContextMatch;

  @override
  double get minimumLiveConfidence => _base.minimumLiveConfidence;

  @override
  CoachReleaseChannel get releaseChannel => _base.releaseChannel;

  @override
  List<CoachRecommendation> candidatesFor({
    required CoachMode mode,
    required String latestText,
  }) {
    final List<CoachRecommendation> candidates = _base.candidatesFor(
      mode: mode,
      latestText: latestText,
    );
    if (mode == CoachMode.off || !_objectionLibrary.isAvailable) {
      return candidates;
    }
    final List<_ScoredObjection> custom =
        _objectionLibrary
            .listEntries()
            .where(
              (ObjectionKnowledgeEntry entry) =>
                  entry.reviewStatus == 'live' && entry.hasCustomResponse,
            )
            .map(
              (ObjectionKnowledgeEntry entry) => _ScoredObjection(
                entry: entry,
                score: latestText.trim().isEmpty
                    ? 1
                    : _matchScore(entry.text, latestText),
              ),
            )
            .where((_ScoredObjection item) => item.score >= 0.2)
            .toList(growable: false)
          ..sort(
            (_ScoredObjection left, _ScoredObjection right) =>
                right.score.compareTo(left.score),
          );
    return <CoachRecommendation>[
      ...candidates,
      ...custom
          .take(4)
          .map((_ScoredObjection item) => _recommendation(item.entry)),
    ];
  }

  @override
  List<CoachRecommendation> postCallCandidates() => _base.postCallCandidates();

  static CoachRecommendation _recommendation(ObjectionKnowledgeEntry entry) {
    final String response = entry.responseContent!.trim();
    final String sourceId = 'user_objection_source_${entry.id}';
    final CoachSource source = CoachSource(
      id: sourceId,
      title: entry.responseSourceName ?? 'Réponse personnalisée Pinkall',
      evidenceLevel: 'user_instruction',
      author: 'Utilisateur Pinkall',
      url: null,
      locator: entry.responseSourceName,
    );
    return CoachRecommendation(
      id: 'custom_${entry.id}',
      status: 'live',
      message: _compactResponse(response),
      sourceIds: <String>[sourceId],
      sources: <CoachSource>[source],
      triggers: <String>[entry.text],
      raw: <String, Object?>{
        'claim_ids': const <String>[],
        'trigger': <String, Object?>{
          'signal': 'custom_objection',
          'phrases': <String>[entry.text],
        },
        'triggers': <String>[entry.text],
        'contexts': const <String>['objection_handling'],
        'requires': const <String>['prospect_objection'],
        'excluded_when': const <String>['call_end_requested'],
        'observation_template':
            'Le prospect formule une objection personnalisée.',
        'hypothesis': 'La réponse définie par l’utilisateur est applicable.',
        'action': <String, Object?>{'suggestion': _promptReference(response)},
        'confidence': const <String, Object?>{
          'evidence': 1.0,
          'live_minimum': 0.78,
          'context_minimum': 0.76,
        },
        'custom_user_response': true,
      },
    );
  }

  static String _compactResponse(String value) {
    final String compact = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (compact.length <= 420) {
      return compact;
    }
    final String prefix = compact.substring(0, 417);
    final int sentenceEnd = prefix.lastIndexOf(RegExp(r'[.!?]'));
    if (sentenceEnd >= 180) {
      return prefix.substring(0, sentenceEnd + 1);
    }
    return '$prefix...';
  }

  static String _promptReference(String value) {
    final List<int> bytes = utf8.encode(value);
    if (bytes.length <= 8 * 1024) {
      return value;
    }
    return utf8.decode(bytes.take(8 * 1024).toList(), allowMalformed: true);
  }

  static double _matchScore(String objection, String latestText) {
    final Set<String> expected = _tokens(objection);
    final Set<String> actual = _tokens(latestText);
    if (expected.isEmpty || actual.isEmpty) {
      return 0;
    }
    final int intersection = expected.intersection(actual).length;
    if (intersection == 0) {
      return 0;
    }
    return intersection / expected.length;
  }

  static Set<String> _tokens(String value) {
    String normalized = value.toLowerCase();
    const Map<String, String> replacements = <String, String>{
      'à': 'a',
      'â': 'a',
      'ç': 'c',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'î': 'i',
      'ô': 'o',
      'ù': 'u',
      'û': 'u',
    };
    replacements.forEach((String source, String target) {
      normalized = normalized.replaceAll(source, target);
    });
    return normalized
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .split(' ')
        .where((String token) => token.length > 2)
        .toSet();
  }
}

final class _ScoredObjection {
  const _ScoredObjection({required this.entry, required this.score});

  final ObjectionKnowledgeEntry entry;
  final double score;
}
