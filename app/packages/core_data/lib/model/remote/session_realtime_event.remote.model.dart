import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_realtime_event.remote.model.freezed.dart';
part 'session_realtime_event.remote.model.g.dart';

/// JSON envelope delivered by the authenticated Pinkall WebSocket stream.
@freezed
abstract class SessionRealtimeEventRemoteModel
    with _$SessionRealtimeEventRemoteModel {
  /// Creates a remote realtime event envelope.
  const factory SessionRealtimeEventRemoteModel({
    required String type,
    required Map<String, dynamic> payload,
  }) = _SessionRealtimeEventRemoteModel;

  /// Creates a remote realtime event envelope from JSON.
  factory SessionRealtimeEventRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$SessionRealtimeEventRemoteModelFromJson(json);
}
