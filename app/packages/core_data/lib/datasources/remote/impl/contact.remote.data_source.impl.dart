import 'package:core_data/clients/pinkall_http.client.dart';
import 'package:core_data/datasources/remote/contact.remote.data_source.dart';
import 'package:core_data/model/remote/contact.remote.model.dart';
import 'package:core_data/model/remote/contact_import_result.remote.model.dart';

/// HTTP implementation of [ContactRemoteDataSource].
final class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  /// Creates the source from a real configurable backend [httpClient].
  const ContactRemoteDataSourceImpl({required PinkallHttpClient httpClient})
    : _httpClient = httpClient;

  final PinkallHttpClient _httpClient;

  @override
  Future<ContactRemoteModel> createContact(Map<String, dynamic> body) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/contacts',
      body: body,
    );
    return ContactRemoteModel.fromJson(json);
  }

  @override
  Future<ContactImportResultRemoteModel> importContacts(
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/contacts/import',
      body: body,
    );
    return ContactImportResultRemoteModel.fromJson(json);
  }

  @override
  Future<List<ContactRemoteModel>> listContacts(
    Map<String, dynamic> queryParameters,
  ) async {
    final Map<String, dynamic> json = await _httpClient.getJson(
      '/v1/contacts',
      queryParameters: queryParameters,
    );
    final Object? rawItems = json['items'];
    if (rawItems is! List<dynamic>) {
      throw const FormatException(
        'Pinkall contacts response must contain an items list.',
      );
    }
    return rawItems
        .map<ContactRemoteModel>((dynamic item) {
          if (item is! Map<dynamic, dynamic>) {
            throw const FormatException(
              'A Pinkall contact must be a JSON object.',
            );
          }
          return ContactRemoteModel.fromJson(
            item.map<String, dynamic>(
              (dynamic key, dynamic value) =>
                  MapEntry<String, dynamic>(key.toString(), value),
            ),
          );
        })
        .toList(growable: false);
  }
}
