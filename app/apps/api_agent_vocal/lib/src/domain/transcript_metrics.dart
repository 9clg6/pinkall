import 'package:api_agent_vocal/src/domain/models.dart';

/// Deterministic conversation measurements derived from a final transcript.
final class TranscriptMetrics {
  const TranscriptMetrics({
    required this.sellerTalkRatio,
    required this.questionCount,
    required this.averageSellerTurnSeconds,
    required this.longestSellerTurnSeconds,
    required this.hesitationCount,
    required this.questionsPerMinute,
    required this.hesitationsPerMinute,
  });

  final double sellerTalkRatio;
  final int questionCount;
  final double averageSellerTurnSeconds;
  final double longestSellerTurnSeconds;
  final int hesitationCount;
  final double questionsPerMinute;
  final double hesitationsPerMinute;

  /// Serializes the measurements with the stable backend field names.
  Map<String, Object?> toJson() => <String, Object?>{
    'seller_talk_ratio': sellerTalkRatio,
    'question_count': questionCount,
    'average_seller_turn_seconds': averageSellerTurnSeconds,
    'longest_seller_turn_seconds': longestSellerTurnSeconds,
    'hesitation_count': hesitationCount,
    'questions_per_minute': questionsPerMinute,
    'hesitations_per_minute': hesitationsPerMinute,
  };
}

/// Computes objective statistics without asking a language model to estimate.
abstract final class TranscriptMetricsCalculator {
  // STT providers may finalize one natural turn as several adjacent segments.
  // A longer gap is treated as an intentional pause and starts a new turn.
  static const double _turnSilenceSeconds = 1.5;

  static final RegExp _hesitationPattern = RegExp(
    r'\b(?:euh+|heu+|hum+|hmm+|bah|ben)\b',
    caseSensitive: false,
  );

  /// Derives metrics from speaker-labelled final [transcript] segments.
  static TranscriptMetrics calculate(List<TranscriptSegment> transcript) {
    final List<TranscriptSegment> sellerSegments = transcript
        .where(
          (TranscriptSegment segment) => segment.speaker == SpeakerRole.seller,
        )
        .toList(growable: false);
    final List<double> sellerSpeechDurations = sellerSegments
        .map(_segmentDuration)
        .toList(growable: false);
    final double sellerDuration = sellerSpeechDurations.fold<double>(
      0,
      (double total, double duration) => total + duration,
    );
    final List<double> sellerTurnDurations = _sellerTurnDurations(transcript);
    final double totalDuration = transcript
        .map(_segmentDuration)
        .fold<double>(0, (double total, double duration) => total + duration);
    final int questionCount = sellerSegments.fold<int>(
      0,
      (int total, TranscriptSegment segment) =>
          total + RegExp(r'\?').allMatches(segment.text).length,
    );
    final int hesitationCount = sellerSegments.fold<int>(
      0,
      (int total, TranscriptSegment segment) =>
          total + _hesitationPattern.allMatches(segment.text).length,
    );
    final double averageSellerTurnSeconds = sellerTurnDurations.isEmpty
        ? 0
        : sellerTurnDurations.fold<double>(
                0,
                (double total, double duration) => total + duration,
              ) /
              sellerTurnDurations.length;
    final double longestSellerTurnSeconds = sellerTurnDurations.fold<double>(
      0,
      (double longest, double duration) =>
          duration > longest ? duration : longest,
    );
    final double conversationSeconds = transcript.isEmpty
        ? 0
        : transcript
                  .map((TranscriptSegment segment) => segment.endSeconds)
                  .fold<double>(0, (double a, double b) => a > b ? a : b) -
              transcript
                  .map((TranscriptSegment segment) => segment.startSeconds)
                  .fold<double>(
                    double.infinity,
                    (double a, double b) => a < b ? a : b,
                  );
    final double conversationMinutes = conversationSeconds > 0
        ? conversationSeconds / 60
        : 0;
    return TranscriptMetrics(
      sellerTalkRatio: _rounded(
        totalDuration == 0 ? 0 : sellerDuration / totalDuration,
      ),
      questionCount: questionCount,
      averageSellerTurnSeconds: _rounded(averageSellerTurnSeconds),
      longestSellerTurnSeconds: _rounded(longestSellerTurnSeconds),
      hesitationCount: hesitationCount,
      questionsPerMinute: _rounded(
        conversationMinutes == 0 ? 0 : questionCount / conversationMinutes,
      ),
      hesitationsPerMinute: _rounded(
        conversationMinutes == 0 ? 0 : hesitationCount / conversationMinutes,
      ),
    );
  }

  static double _segmentDuration(TranscriptSegment segment) {
    final double duration = segment.endSeconds - segment.startSeconds;
    return duration > 0 ? duration : 0;
  }

  static List<double> _sellerTurnDurations(List<TranscriptSegment> transcript) {
    final List<TranscriptSegment> chronological =
        transcript.toList(growable: false)..sort(
          (TranscriptSegment left, TranscriptSegment right) =>
              left.startSeconds.compareTo(right.startSeconds),
        );
    final List<double> durations = <double>[];
    double? turnStart;
    double? turnEnd;

    void closeTurn() {
      if (turnStart == null || turnEnd == null) {
        return;
      }
      final double duration = turnEnd! - turnStart!;
      durations.add(duration > 0 ? duration : 0);
      turnStart = null;
      turnEnd = null;
    }

    for (final TranscriptSegment segment in chronological) {
      if (segment.speaker != SpeakerRole.seller) {
        closeTurn();
        continue;
      }
      final double segmentEnd = segment.endSeconds > segment.startSeconds
          ? segment.endSeconds
          : segment.startSeconds;
      final bool continuesTurn =
          turnEnd != null &&
          segment.startSeconds - turnEnd! <= _turnSilenceSeconds;
      if (!continuesTurn) {
        closeTurn();
        turnStart = segment.startSeconds;
        turnEnd = segmentEnd;
        continue;
      }
      if (segmentEnd > turnEnd!) {
        turnEnd = segmentEnd;
      }
    }
    closeTurn();
    return durations;
  }

  static double _rounded(double value) => (value * 1000).round() / 1000;
}
