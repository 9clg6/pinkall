// ignore_for_file: invalid_annotation_target

import 'package:core_domain/domain/enum/contact_market.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_contacts.param.freezed.dart';
part 'import_contacts.param.g.dart';

/// One normalized CRM row sent to the Pinkall backend import endpoint.
@freezed
abstract class ContactImportRowParam with _$ContactImportRowParam {
  /// Creates a normalized contact import row.
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ContactImportRowParam({
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
  }) = _ContactImportRowParam;

  /// Creates a normalized contact import row from JSON.
  factory ContactImportRowParam.fromJson(Map<String, dynamic> json) =>
      _$ContactImportRowParamFromJson(json);
}

/// Batch of normalized CRM contacts imported from CSV or another source.
@freezed
abstract class ImportContactsParam with _$ImportContactsParam {
  /// Creates a contact import batch.
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ImportContactsParam({
    required String sourceName,
    required List<ContactImportRowParam> rows,
  }) = _ImportContactsParam;

  /// Creates a contact import batch from JSON.
  factory ImportContactsParam.fromJson(Map<String, dynamic> json) =>
      _$ImportContactsParamFromJson(json);
}
