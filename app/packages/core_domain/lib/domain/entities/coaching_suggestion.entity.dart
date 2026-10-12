import 'package:core_domain/domain/entities/coaching_source.entity.dart';
import 'package:core_domain/domain/enum/coaching_suggestion_kind.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coaching_suggestion.entity.freezed.dart';

/// Short, expiring, source-backed recommendation generated during a call.
@freezed
abstract class CoachingSuggestionEntity with _$CoachingSuggestionEntity {
  /// Creates a coaching suggestion.
  const factory CoachingSuggestionEntity({
    required String id,
    required String sessionId,
    required CoachingSuggestionKind kind,
    required String text,
    required String rationale,
    required List<CoachingSourceEntity> sources,
    required double confidence,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _CoachingSuggestionEntity;
}

/// Time-related helpers for a [CoachingSuggestionEntity].
extension CoachingSuggestionEntityX on CoachingSuggestionEntity {
  /// Returns whether this suggestion is no longer actionable at [at].
  bool isExpiredAt(DateTime at) => !expiresAt.isAfter(at);
}
