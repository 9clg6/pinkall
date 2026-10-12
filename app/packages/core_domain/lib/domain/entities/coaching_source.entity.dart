import 'package:core_domain/domain/enum/coaching_evidence_level.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coaching_source.entity.freezed.dart';

/// Source attribution attached to a coaching recommendation.
@freezed
abstract class CoachingSourceEntity with _$CoachingSourceEntity {
  /// Creates a coaching source attribution.
  const factory CoachingSourceEntity({
    required String id,
    required String title,
    required CoachingEvidenceLevel evidenceLevel,
    String? author,
    String? url,
    String? locator,
  }) = _CoachingSourceEntity;
}
