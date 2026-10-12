import 'package:core_data/datasources/remote/recording_import.remote.data_source.dart';
import 'package:core_data/mappers/recording_import.mapper.dart';
import 'package:core_domain/core_domain.dart';

/// Pinkall API implementation of post-call recording imports.
final class RecordingImportRepositoryImpl implements RecordingImportRepository {
  /// Creates the repository from its remote boundary.
  const RecordingImportRepositoryImpl({
    required RecordingImportRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final RecordingImportRemoteDataSource _remoteDataSource;

  @override
  Future<RecordingImportEntity> createImport(
    CreateRecordingImportParam params,
  ) async => (await _remoteDataSource.createImport(params.toJson())).toEntity();

  @override
  Future<RecordingImportEntity> getImport(String importId) async =>
      (await _remoteDataSource.getImport(importId)).toEntity();

  @override
  Future<RecordingImportEntity> uploadRecording(
    UploadRecordingImportParam params,
  ) async => (await _remoteDataSource.uploadRecording(
    uploadPath: params.uploadPath,
    filePath: params.filePath,
    sizeBytes: params.sizeBytes,
    mimeType: params.mimeType,
  )).toEntity();

  @override
  Future<RecordingImportEntity> assignUserVoice(
    AssignRecordingSpeakerParam params,
  ) async {
    final Map<String, dynamic> body = params.toJson()..remove('import_id');
    return (await _remoteDataSource.assignUserVoice(
      params.importId,
      body,
    )).toEntity();
  }
}
