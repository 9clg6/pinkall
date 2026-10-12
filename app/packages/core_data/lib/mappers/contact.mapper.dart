import 'package:core_data/mappers/enum.mapper.dart';
import 'package:core_data/model/remote/contact.remote.model.dart';
import 'package:core_data/model/remote/contact_import_result.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Mapping extensions for [ContactRemoteModel].
extension ContactRemoteModelX on ContactRemoteModel {
  /// Converts the remote CRM contact to a domain entity.
  ContactEntity toEntity() => ContactEntity(
    id: id,
    phoneNumber: phoneNumber,
    market: enumFromWireName<ContactMarket>(ContactMarket.values, market),
    firstName: firstName,
    lastName: lastName,
    company: company,
    jobTitle: jobTitle,
    email: email,
    hasPriorConsent: hasPriorConsent,
    hasOptedOut: hasOptedOut,
    professionalRelevanceConfirmed: professionalRelevanceConfirmed,
    customFields: customFields,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

/// Mapping extensions for [ContactImportResultRemoteModel].
extension ContactImportResultRemoteModelX on ContactImportResultRemoteModel {
  /// Converts the remote import result to a domain entity.
  ContactImportResultEntity toEntity() => ContactImportResultEntity(
    importId: importId,
    importedCount: importedCount,
    skippedCount: skippedCount,
    errors: errors,
  );
}
