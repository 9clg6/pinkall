import 'package:core_domain/domain/entities/contact.entity.dart';
import 'package:core_domain/domain/params/create_contact.param.dart';
import 'package:core_domain/domain/repositories/contact.repository.dart';
import 'package:core_foundation/core_foundation.dart';

/// Creates one minimal Pinkall CRM contact.
final class CreateContactUseCase
    extends FutureUseCaseWithParams<ContactEntity, CreateContactParam> {
  /// Creates the use case with its [contactRepository].
  CreateContactUseCase({required ContactRepository contactRepository})
    : _repository = contactRepository;

  final ContactRepository _repository;

  @override
  Future<ContactEntity> invoke(CreateContactParam params) =>
      _repository.createContact(params);
}
