import 'package:freezed_annotation/freezed_annotation.dart';

part 'objection_knowledge_entry.entity.freezed.dart';

/// One objection known by Pinkall and its optional user-authored answer.
@freezed
abstract class ObjectionKnowledgeEntryEntity
    with _$ObjectionKnowledgeEntryEntity {
  /// Creates an objection knowledge entry.
  const factory ObjectionKnowledgeEntryEntity({
    required String id,
    required String category,
    required String text,
    required String reviewStatus,
    required String origin,
    required int occurrenceCount,
    required DateTime firstSeenAt,
    required DateTime lastSeenAt,
    String? responseContent,
    String? responseSourceType,
    String? responseSourceName,
  }) = _ObjectionKnowledgeEntryEntity;
}
