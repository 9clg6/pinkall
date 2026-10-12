import 'package:freezed_annotation/freezed_annotation.dart';

part 'telnyx_call.remote.model.freezed.dart';
part 'telnyx_call.remote.model.g.dart';

/// Call state emitted by the Telnyx SDK boundary.
@freezed
abstract class TelnyxCallRemoteModel with _$TelnyxCallRemoteModel {
  /// Creates a remote call state.
  const factory TelnyxCallRemoteModel({
    required String callId,
    required String direction,
    required String status,
    String? remoteName,
    String? remoteNumber,
    @Default(false) bool isMuted,
    @Default(false) bool isSpeakerEnabled,
    String? failureReason,
  }) = _TelnyxCallRemoteModel;

  /// Creates a remote call state from JSON.
  factory TelnyxCallRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$TelnyxCallRemoteModelFromJson(json);
}
