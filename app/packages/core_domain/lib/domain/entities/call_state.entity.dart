import 'package:core_domain/domain/enum/call_direction.enum.dart';
import 'package:core_domain/domain/enum/call_lifecycle_status.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_state.entity.freezed.dart';

/// Immutable, vendor-independent snapshot of one voice call.
@freezed
abstract class CallStateEntity with _$CallStateEntity {
  /// Creates a call state snapshot.
  const factory CallStateEntity({
    required String callId,
    required CallDirection direction,
    required CallLifecycleStatus status,
    String? remoteName,
    String? remoteNumber,
    @Default(false) bool isMuted,
    @Default(false) bool isSpeakerEnabled,
    String? failureReason,
  }) = _CallStateEntity;
}
