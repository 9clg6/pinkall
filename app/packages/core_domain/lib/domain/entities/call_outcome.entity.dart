import 'package:core_domain/domain/enum/call_outcome_type.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_outcome.entity.freezed.dart';

/// Server-confirmed commercial outcome linked to one call session.
@freezed
abstract class CallOutcomeEntity with _$CallOutcomeEntity {
  /// Creates a call outcome.
  const factory CallOutcomeEntity({
    required String sessionId,
    required CallOutcomeType type,
    required DateTime recordedAt,
    String? note,
  }) = _CallOutcomeEntity;
}
