import 'package:core_data/model/remote/telnyx_connection.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Maps SDK connection models to domain snapshots.
extension TelnyxConnectionMapper on TelnyxConnectionRemoteModel {
  /// Converts this remote model to a domain entity.
  TelnyxConnectionStateEntity toEntity() {
    return TelnyxConnectionStateEntity(
      status: _connectionStatusFromRemote(status),
      failureReason: failureReason,
    );
  }
}

TelnyxConnectionStatus _connectionStatusFromRemote(String status) {
  return switch (status) {
    'disconnected' => TelnyxConnectionStatus.disconnected,
    'connecting' => TelnyxConnectionStatus.connecting,
    'connected' => TelnyxConnectionStatus.connected,
    'reconnecting' => TelnyxConnectionStatus.reconnecting,
    'ready' => TelnyxConnectionStatus.ready,
    'failure' => TelnyxConnectionStatus.failure,
    _ => throw FormatException('Unknown Telnyx connection status: $status'),
  };
}
