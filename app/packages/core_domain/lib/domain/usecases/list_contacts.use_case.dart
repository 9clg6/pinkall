import 'package:core_domain/domain/entities/contact.entity.dart';
import 'package:core_domain/domain/params/list_contacts.param.dart';
import 'package:core_domain/domain/repositories/contact.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Lists contacts from the minimal Pinkall CRM.
final class ListContactsUseCase
    extends FutureUseCaseWithParams<List<ContactEntity>, ListContactsParam> {
  /// Creates the use case with its [contactRepository].
  ListContactsUseCase({required ContactRepository contactRepository})
    : _repository = contactRepository;

  final ContactRepository _repository;

  @override
  Future<List<ContactEntity>> invoke(ListContactsParam params) =>
      _repository.listContacts(params);
}
