import 'package:core_domain/domain/entities/recording_import.entity.dart';
import 'package:core_domain/domain/params/assign_recording_speaker.param.dart';
import 'package:core_domain/domain/params/create_recording_import.param.dart';
import 'package:core_domain/domain/params/upload_recording_import.param.dart';

/// Post-call recording initialization, upload, diarization and assignment.
abstract interface class RecordingImportRepository {
  /// Creates a consent-gated import before any audio is uploaded.
  Future<RecordingImportEntity> createImport(CreateRecordingImportParam params);

  /// Streams the app-owned temporary file to its same-origin upload path.
  Future<RecordingImportEntity> uploadRecording(
    UploadRecordingImportParam params,
  );

  /// Retrieves transcription/diarization progress and provisional voices.
  Future<RecordingImportEntity> getImport(String importId);

  /// Assigns the user's voice before final seller/prospect attribution.
  Future<RecordingImportEntity> assignUserVoice(
    AssignRecordingSpeakerParam params,
  );
}
