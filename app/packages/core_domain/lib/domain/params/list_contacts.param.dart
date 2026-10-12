// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_contacts.param.freezed.dart';
part 'list_contacts.param.g.dart';

/// Parameters for a minimal paginated CRM contact query.
@freezed
abstract class ListContactsParam with _$ListContactsParam {
  /// Creates contact query parameters.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ListContactsParam({
    String? query,
    String? cursor,
    @Default(50) int limit,
  }) = _ListContactsParam;

  /// Creates contact query parameters from JSON.
  factory ListContactsParam.fromJson(Map<String, dynamic> json) =>
      _$ListContactsParamFromJson(json);
}
