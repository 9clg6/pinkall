import 'package:freezed_annotation/freezed_annotation.dart';

part 'telnyx_connection.remote.model.freezed.dart';
part 'telnyx_connection.remote.model.g.dart';

/// Connection state emitted by the Telnyx SDK boundary.
@freezed
abstract class TelnyxConnectionRemoteModel with _$TelnyxConnectionRemoteModel {
  /// Creates a remote connection state.
  const factory TelnyxConnectionRemoteModel({
    required String status,
    String? failureReason,
  }) = _TelnyxConnectionRemoteModel;

  /// Creates a remote connection state from JSON.
  factory TelnyxConnectionRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$TelnyxConnectionRemoteModelFromJson(json);
}
