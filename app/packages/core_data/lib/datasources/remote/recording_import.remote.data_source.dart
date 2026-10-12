import 'package:core_data/model/remote/recording_import.remote.model.dart';

/// Remote operations for post-call recording imports.
abstract interface class RecordingImportRemoteDataSource {
  /// Initializes a consent-gated recording import.
  Future<RecordingImportRemoteModel> createImport(Map<String, dynamic> body);

  /// Streams one temporary app-owned audio file.
  Future<RecordingImportRemoteModel> uploadRecording({
    required String uploadPath,
    required String filePath,
    required int sizeBytes,
    required String mimeType,
  });

  /// Retrieves current processing and provisional voice state.
  Future<RecordingImportRemoteModel> getImport(String importId);

  /// Assigns the user voice, then retrieves the finalized snapshot.
  Future<RecordingImportRemoteModel> assignUserVoice(
    String importId,
    Map<String, dynamic> body,
  );
}
