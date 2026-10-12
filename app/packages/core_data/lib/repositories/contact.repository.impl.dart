import 'package:core_data/datasources/remote/contact.remote.data_source.dart';
import 'package:core_data/mappers/contact.mapper.dart';
import 'package:core_data/model/remote/contact.remote.model.dart';
import 'package:core_domain/core_domain.dart';

/// Pinkall-backend implementation of [ContactRepository].
final class ContactRepositoryImpl implements ContactRepository {
  /// Creates the repository with its [remoteDataSource].
  const ContactRepositoryImpl({
    required ContactRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ContactRemoteDataSource _remoteDataSource;

  @override
  Future<ContactEntity> createContact(CreateContactParam params) async {
    return (await _remoteDataSource.createContact(params.toJson())).toEntity();
  }

  @override
  Future<ContactImportResultEntity> importContacts(
    ImportContactsParam params,
  ) async {
    return (await _remoteDataSource.importContacts(params.toJson())).toEntity();
  }

  @override
  Future<List<ContactEntity>> listContacts(ListContactsParam params) async {
    final List<ContactRemoteModel> models = await _remoteDataSource
        .listContacts(
          params.toJson()
            ..removeWhere((String _, dynamic value) => value == null),
        );
    return models
        .map((ContactRemoteModel model) => model.toEntity())
        .toList(growable: false);
  }
}
