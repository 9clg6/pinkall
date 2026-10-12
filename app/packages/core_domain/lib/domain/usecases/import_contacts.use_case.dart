import 'package:core_domain/domain/entities/contact_import_result.entity.dart';
import 'package:core_domain/domain/params/import_contacts.param.dart';
import 'package:core_domain/domain/repositories/contact.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Imports normalized contacts into the minimal Pinkall CRM.
final class ImportContactsUseCase
    extends
        FutureUseCaseWithParams<
          ContactImportResultEntity,
          ImportContactsParam
        > {
  /// Creates the use case with its [contactRepository].
  ImportContactsUseCase({required ContactRepository contactRepository})
    : _repository = contactRepository;

  final ContactRepository _repository;

  @override
  Future<ContactImportResultEntity> invoke(ImportContactsParam params) =>
      _repository.importContacts(params);
}
