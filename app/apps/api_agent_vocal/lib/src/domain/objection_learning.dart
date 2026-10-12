import 'package:api_agent_vocal/src/domain/models.dart';
import 'package:api_agent_vocal/src/domain/post_call_models.dart';

/// Where an objection entry came from.
enum ObjectionKnowledgeOrigin {
  detected,
  custom,
  detectedAndCustom;

  static ObjectionKnowledgeOrigin parse(String value) {
    return switch (value) {
      'detected' => detected,
      'custom' => custom,
      'detected_and_custom' => detectedAndCustom,
      _ => throw FormatException('Unknown objection origin: $value'),
    };
  }

  String get wireName => switch (this) {
    detected => 'detected',
    custom => 'custom',
    detectedAndCustom => 'detected_and_custom',
  };
}

/// One reviewable objection in the local coaching knowledge library.
final class ObjectionKnowledgeEntry {
  const ObjectionKnowledgeEntry({
    required this.id,
    required this.category,
    required this.text,
    required this.reviewStatus,
    required this.origin,
    required this.occurrenceCount,
    required this.firstSeenAt,
    required this.lastSeenAt,
    this.responseContent,
    this.responseSourceType,
    this.responseSourceName,
  });

  final String id;
  final String category;
  final String text;
  final String reviewStatus;
  final ObjectionKnowledgeOrigin origin;
  final int occurrenceCount;
  final DateTime firstSeenAt;
  final DateTime lastSeenAt;
  final String? responseContent;
  final String? responseSourceType;
  final String? responseSourceName;

  bool get hasCustomResponse =>
      responseContent != null && responseContent!.trim().isNotEmpty;

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'category': category,
    'text': text,
    'review_status': reviewStatus,
    'origin': origin.wireName,
    'occurrence_count': occurrenceCount,
    'first_seen_at': firstSeenAt.toUtc().toIso8601String(),
    'last_seen_at': lastSeenAt.toUtc().toIso8601String(),
    'response': hasCustomResponse
        ? <String, Object?>{
            'content': responseContent,
            'source_type': responseSourceType,
            'source_name': responseSourceName,
          }
        : null,
  };
}

/// Validated user-authored answer attached to an objection.
final class CreateCustomObjection {
  const CreateCustomObjection({
    required this.category,
    required this.text,
    required this.responseContent,
    required this.responseSourceType,
    this.responseSourceName,
  });

  final String category;
  final String text;
  final String responseContent;
  final String responseSourceType;
  final String? responseSourceName;
}

/// Result of merging one debrief into the local objection knowledge document.
final class ObjectionLearningResult {
  const ObjectionLearningResult({
    required this.detectedCount,
    required this.newCount,
    required this.updatedCount,
  });

  final int detectedCount;
  final int newCount;
  final int updatedCount;
}

/// Boundary for collecting reviewable objections without promoting them live.
abstract interface class ObjectionLearningSink {
  Future<ObjectionLearningResult> learn({
    required String sessionId,
    required List<PostCallObjection> objections,
    required List<TranscriptSegment> transcript,
    required DateTime observedAt,
  });
}

/// Read/write boundary used by the objection management UI and coach.
abstract interface class ObjectionLibrary {
  bool get isAvailable;

  String? get unavailableReason;

  List<ObjectionKnowledgeEntry> listEntries();

  Future<ObjectionKnowledgeEntry> addCustom(CreateCustomObjection command);
}

/// Combined boundary implemented by the local file adapter.
abstract interface class ObjectionKnowledgeStore
    implements ObjectionLearningSink, ObjectionLibrary {}

/// Disabled adapter used when no local coaching catalogue is configured.
final class NoopObjectionKnowledgeStore implements ObjectionKnowledgeStore {
  const NoopObjectionKnowledgeStore([
    this.reason = 'The objection library is not configured.',
  ]);

  final String reason;

  @override
  bool get isAvailable => false;

  @override
  String get unavailableReason => reason;

  @override
  List<ObjectionKnowledgeEntry> listEntries() =>
      const <ObjectionKnowledgeEntry>[];

  @override
  Future<ObjectionKnowledgeEntry> addCustom(CreateCustomObjection command) {
    throw StateError(reason);
  }

  @override
  Future<ObjectionLearningResult> learn({
    required String sessionId,
    required List<PostCallObjection> objections,
    required List<TranscriptSegment> transcript,
    required DateTime observedAt,
  }) async {
    return ObjectionLearningResult(
      detectedCount: objections.length,
      newCount: 0,
      updatedCount: 0,
    );
  }
}

/// Backwards-compatible disabled learning adapter.
typedef NoopObjectionLearningSink = NoopObjectionKnowledgeStore;
