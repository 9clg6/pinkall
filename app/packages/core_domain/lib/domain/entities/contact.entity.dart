import 'package:core_domain/domain/enum/contact_market.enum.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.entity.freezed.dart';

/// Minimal CRM contact stored by Pinkall.
@freezed
abstract class ContactEntity with _$ContactEntity {
  /// Creates a CRM contact.
  const factory ContactEntity({
    required String id,
    required String phoneNumber,
    required ContactMarket market,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? firstName,
    String? lastName,
    String? company,
    String? jobTitle,
    String? email,
    bool? hasPriorConsent,
    bool? hasOptedOut,
    bool? professionalRelevanceConfirmed,
    @Default(<String, String>{}) Map<String, String> customFields,
  }) = _ContactEntity;
}
