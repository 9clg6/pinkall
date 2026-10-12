// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_custom_objection.param.freezed.dart';
part 'create_custom_objection.param.g.dart';

/// User-authored objection and the response Pinkall should surface.
@freezed
abstract class CreateCustomObjectionParam with _$CreateCustomObjectionParam {
  /// Creates a custom objection request.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CreateCustomObjectionParam({
    required String category,
    required String text,
    required String responseContent,
    @Default('text') String responseSourceType,
    String? responseSourceName,
  }) = _CreateCustomObjectionParam;

  /// Creates a request from JSON.
  factory CreateCustomObjectionParam.fromJson(Map<String, dynamic> json) =>
      _$CreateCustomObjectionParamFromJson(json);
}
