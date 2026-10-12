import 'package:core_data/model/remote/contact.remote.model.dart';
import 'package:core_data/model/remote/contact_import_result.remote.model.dart';

/// Remote source for the minimal Pinkall CRM.
abstract interface class ContactRemoteDataSource {
  /// Lists CRM contacts using backend query parameters.
  Future<List<ContactRemoteModel>> listContacts(
    Map<String, dynamic> queryParameters,
  );

  /// Creates one CRM contact.
  Future<ContactRemoteModel> createContact(Map<String, dynamic> body);

  /// Imports normalized CRM rows.
  Future<ContactImportResultRemoteModel> importContacts(
    Map<String, dynamic> body,
  );
}
