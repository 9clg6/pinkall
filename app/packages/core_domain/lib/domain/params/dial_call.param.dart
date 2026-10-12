import 'package:freezed_annotation/freezed_annotation.dart';

part 'dial_call.param.freezed.dart';
part 'dial_call.param.g.dart';

/// Parameters used to place an outbound call.
@freezed
abstract class DialCallParam with _$DialCallParam {
  /// Creates outbound call parameters.
  const factory DialCallParam({
    required String destinationNumber,
    @Default('') String clientState,
    @Default(<String, String>{}) Map<String, String> customHeaders,
  }) = _DialCallParam;

  /// Creates outbound call parameters from JSON.
  factory DialCallParam.fromJson(Map<String, dynamic> json) =>
      _$DialCallParamFromJson(json);
}
