import 'package:core_domain/domain/entities/contact.entity.dart';
import 'package:core_domain/domain/entities/contact_import_result.entity.dart';
import 'package:core_domain/domain/params/create_contact.param.dart';
import 'package:core_domain/domain/params/import_contacts.param.dart';
import 'package:core_domain/domain/params/list_contacts.param.dart';

/// Contract for the minimal Pinkall CRM contact store.
abstract interface class ContactRepository {
  /// Lists contacts matching the optional query and cursor.
  Future<List<ContactEntity>> listContacts(ListContactsParam params);

  /// Creates one contact from normalized user input.
  Future<ContactEntity> createContact(CreateContactParam params);

  /// Imports normalized contacts and returns the backend-confirmed result.
  Future<ContactImportResultEntity> importContacts(ImportContactsParam params);
}
