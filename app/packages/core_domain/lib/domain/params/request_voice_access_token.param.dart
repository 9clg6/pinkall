// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_voice_access_token.param.freezed.dart';
part 'request_voice_access_token.param.g.dart';

/// Identifies the authenticated device requesting a short-lived voice token.
@freezed
abstract class RequestVoiceAccessTokenParam
    with _$RequestVoiceAccessTokenParam {
  /// Creates a voice-token request.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RequestVoiceAccessTokenParam({required String deviceId}) =
      _RequestVoiceAccessTokenParam;

  /// Creates request parameters from JSON.
  factory RequestVoiceAccessTokenParam.fromJson(Map<String, dynamic> json) =>
      _$RequestVoiceAccessTokenParamFromJson(json);
}
