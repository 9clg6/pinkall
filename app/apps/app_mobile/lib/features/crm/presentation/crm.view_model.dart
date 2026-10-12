import 'package:core_domain/core_domain.dart';
import 'package:pinkall/core/providers/pinkall_backend.providers.dart';
import 'package:pinkall/features/crm/data/contact_import_parser.dart';
import 'package:pinkall/features/crm/presentation/crm.state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crm.view_model.g.dart';

/// Drives the minimal CRM exclusively through the Pinkall backend.
@riverpod
class CrmViewModel extends _$CrmViewModel {
  late ContactRepository _repository;

  @override
  Future<CrmState> build() async {
    _repository = ref.watch(contactRepositoryProvider);
    final List<ContactEntity> contacts = await _repository.listContacts(
      const ListContactsParam(),
    );
    return CrmState(contacts: contacts, isOperating: false);
  }

  /// Reloads contacts from the SaaS backend.
  Future<void> refresh() async {
    final CrmState? current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncData<CrmState>(
      current.copyWith(
        isOperating: true,
        clearFailure: true,
        clearFeedback: true,
      ),
    );
    try {
      final List<ContactEntity> contacts = await _repository.listContacts(
        const ListContactsParam(),
      );
      state = AsyncData<CrmState>(
        CrmState(contacts: contacts, isOperating: false),
      );
    } catch (error) {
      _fail('Les contacts n’ont pas pu être actualisés. Réessaie.');
    }
  }

  /// Creates one real backend contact.
  Future<bool> createContact(CreateContactParam params) async {
    final CrmState? current = state.value;
    if (current == null) {
      return false;
    }
    _operate(current);
    try {
      await _repository.createContact(params);
      final List<ContactEntity> contacts = await _repository.listContacts(
        const ListContactsParam(),
      );
      state = AsyncData<CrmState>(
        CrmState(
          contacts: contacts,
          isOperating: false,
          feedback: 'Contact ajouté au CRM.',
        ),
      );
      return true;
    } catch (error) {
      _fail('Le contact n’a pas pu être ajouté. Réessaie.');
      return false;
    }
  }

  /// Parses pasted CSV/JSON and sends normalized rows to the backend.
  Future<bool> importContacts(String rawInput) async {
    final CrmState? current = state.value;
    if (current == null) {
      return false;
    }
    _operate(current);
    try {
      final List<ContactImportRowParam> rows = ContactImportParser.parse(
        rawInput,
      );
      final ContactImportResultEntity result = await _repository.importContacts(
        ImportContactsParam(sourceName: 'pasted-input', rows: rows),
      );
      final List<ContactEntity> contacts = await _repository.listContacts(
        const ListContactsParam(),
      );
      final String errors = result.errors.isEmpty
          ? ''
          : ' · ${result.errors.length} erreur(s)';
      state = AsyncData<CrmState>(
        CrmState(
          contacts: contacts,
          isOperating: false,
          feedback:
              '${result.importedCount} importé(s), '
              '${result.skippedCount} ignoré(s)$errors.',
        ),
      );
      return true;
    } catch (error) {
      final String detail = _message(error);
      _fail(
        detail.isEmpty ? 'L’import n’a pas pu être terminé. Réessaie.' : detail,
      );
      return false;
    }
  }

  void _operate(CrmState current) {
    state = AsyncData<CrmState>(
      current.copyWith(
        isOperating: true,
        clearFailure: true,
        clearFeedback: true,
      ),
    );
  }

  void _fail(String message) {
    final CrmState? current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncData<CrmState>(
      current.copyWith(
        isOperating: false,
        failure: message,
        clearFeedback: true,
      ),
    );
  }
}

String _message(Object error) {
  final String value = error.toString();
  if (value.startsWith('FormatException: ')) {
    return value.substring('FormatException: '.length);
  }
  return '';
}
