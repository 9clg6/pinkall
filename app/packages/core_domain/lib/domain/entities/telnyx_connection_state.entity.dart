import 'package:core_domain/domain/enum/telnyx_connection_status.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'telnyx_connection_state.entity.freezed.dart';

/// Immutable snapshot of the Telnyx signaling connection.
@freezed
abstract class TelnyxConnectionStateEntity with _$TelnyxConnectionStateEntity {
  /// Creates a connection state snapshot.
  const factory TelnyxConnectionStateEntity({
    required TelnyxConnectionStatus status,
    String? failureReason,
  }) = _TelnyxConnectionStateEntity;
}
