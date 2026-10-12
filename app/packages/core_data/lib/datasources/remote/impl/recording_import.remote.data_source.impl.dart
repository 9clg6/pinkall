import 'package:core_data/clients/pinkall_file_http.client.dart';
import 'package:core_data/clients/pinkall_http.client.dart';
import 'package:core_data/datasources/remote/recording_import.remote.data_source.dart';
import 'package:core_data/model/remote/recording_import.remote.model.dart';

/// Real same-origin API implementation of recording imports.
final class RecordingImportRemoteDataSourceImpl
    implements RecordingImportRemoteDataSource {
  /// Creates the source from authenticated JSON and streaming clients.
  const RecordingImportRemoteDataSourceImpl({
    required PinkallHttpClient httpClient,
    required PinkallFileHttpClient fileHttpClient,
  }) : _httpClient = httpClient,
       _fileHttpClient = fileHttpClient;

  final PinkallHttpClient _httpClient;
  final PinkallFileHttpClient _fileHttpClient;

  @override
  Future<RecordingImportRemoteModel> createImport(
    Map<String, dynamic> body,
  ) async {
    final Map<String, dynamic> json = await _httpClient.postJson(
      '/v1/recording-imports',
      body: body,
    );
    return RecordingImportRemoteModel.fromJson(json);
  }

  @override
  Future<RecordingImportRemoteModel> getImport(String importId) async {
    final Map<String, dynamic> json = await _httpClient.getJson(
      '/v1/recording-imports/${Uri.encodeComponent(importId)}',
    );
    return RecordingImportRemoteModel.fromJson(json);
  }

  @override
  Future<RecordingImportRemoteModel> uploadRecording({
    required String uploadPath,
    required String filePath,
    required int sizeBytes,
    required String mimeType,
  }) async {
    final Map<String, dynamic> json = await _fileHttpClient.putFile(
      uploadPath,
      filePath: filePath,
      sizeBytes: sizeBytes,
      contentType: mimeType,
    );
    return RecordingImportRemoteModel.fromJson(json);
  }

  @override
  Future<RecordingImportRemoteModel> assignUserVoice(
    String importId,
    Map<String, dynamic> body,
  ) async {
    await _httpClient.postJson(
      '/v1/recording-imports/${Uri.encodeComponent(importId)}/speaker-assignment',
      body: body,
    );
    return getImport(importId);
  }
}
