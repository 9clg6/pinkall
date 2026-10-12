// ignore_for_file: invalid_annotation_target

import 'package:core_domain/domain/enum/contact_market.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_contact.param.freezed.dart';
part 'create_contact.param.g.dart';

/// User-provided fields for a minimal CRM contact.
@freezed
abstract class CreateContactParam with _$CreateContactParam {
  /// Creates contact creation parameters.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory CreateContactParam({
    required String phoneNumber,
    @Default(ContactMarket.unknown) ContactMarket market,
    String? firstName,
    String? lastName,
    String? company,
    String? jobTitle,
    String? email,
    bool? hasPriorConsent,
    bool? hasOptedOut,
    bool? professionalRelevanceConfirmed,
    @Default(<String, String>{}) Map<String, String> customFields,
  }) = _CreateContactParam;

  /// Creates contact creation parameters from JSON.
  factory CreateContactParam.fromJson(Map<String, dynamic> json) =>
      _$CreateContactParamFromJson(json);
}
