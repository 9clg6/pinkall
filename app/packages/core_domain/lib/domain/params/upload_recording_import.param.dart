import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_recording_import.param.freezed.dart';

/// App-owned temporary file streamed to an initialized recording import.
@freezed
abstract class UploadRecordingImportParam with _$UploadRecordingImportParam {
  /// Creates upload parameters without exposing source-provider details.
  const factory UploadRecordingImportParam({
    required String importId,
    required String uploadPath,
    required String filePath,
    required String mimeType,
    required int sizeBytes,
  }) = _UploadRecordingImportParam;
}
