import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';

/// Replaceable provider boundary for one grounded final call debrief.
abstract interface class PostCallGateway {
  bool get isConfigured;

  Future<PostCallDebrief> generate({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required List<CoachRecommendation> improvementCandidates,
    String? preparationMarkdown,
  });
}

/// Sanitized provider failure with an explicit retry contract.
///
/// Gateways must use this type only for failures whose transient nature is
/// known. Schema, grounding and other validation failures remain terminal.
final class PostCallGatewayException implements Exception {
  const PostCallGatewayException({
    required this.code,
    required this.retryable,
    this.cause,
  });

  final String code;
  final bool retryable;
  final Object? cause;

  @override
  String toString() => 'PostCallGatewayException($code)';
}

/// Explicit optional-provider state; it never fabricates a local debrief.
final class UnavailablePostCallGateway implements PostCallGateway {
  const UnavailablePostCallGateway(this.reason);

  final String reason;

  @override
  bool get isConfigured => false;

  @override
  Future<PostCallDebrief> generate({
    required String sessionId,
    required List<TranscriptSegment> transcript,
    required List<CoachRecommendation> improvementCandidates,
    String? preparationMarkdown,
  }) {
    throw StateError(reason);
  }
}
