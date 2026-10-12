import 'package:api_agent_vocal/src/domain/models.dart';

/// Replaceable gateway that may select, but never invent, a coaching card.
abstract interface class CoachGateway {
  bool get isConfigured;

  Future<CoachSelection> select({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required TranscriptSegment triggeringSegment,
    required List<CoachRecommendation> candidates,
    String? preparationMarkdown,
  });
}

/// Explicitly unavailable optional coach.
final class UnavailableCoachGateway implements CoachGateway {
  const UnavailableCoachGateway(this.reason);

  final String reason;

  @override
  bool get isConfigured => false;

  @override
  Future<CoachSelection> select({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required TranscriptSegment triggeringSegment,
    required List<CoachRecommendation> candidates,
    String? preparationMarkdown,
  }) {
    throw StateError(reason);
  }
}

/// Curated catalogue boundary. It returns no synthetic fallback.
abstract interface class CoachCatalog {
  bool get isAvailable;

  String? get unavailableReason;

  double get minimumLiveConfidence;

  double get minimumContextMatch;

  Duration get globalCooldown;

  int get maxSuggestionsPerMinute;

  int get maxEvaluationsPerMinute;

  int get defaultExpirySeconds;

  CoachReleaseChannel get releaseChannel;

  bool get allowsUnreviewedRecommendations;

  List<CoachRecommendation> candidatesFor({
    required CoachMode mode,
    required String latestText,
  });

  /// Returns source-backed cards eligible for post-call improvement selection.
  List<CoachRecommendation> postCallCandidates();
}
