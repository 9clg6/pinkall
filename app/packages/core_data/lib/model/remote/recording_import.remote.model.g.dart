// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recording_import.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecordingImportRemoteModel _$RecordingImportRemoteModelFromJson(
  Map<String, dynamic> json,
) => _RecordingImportRemoteModel(
  id: json['id'] as String,
  sessionId: json['session_id'] as String,
  status: json['status'] as String,
  consentRequired: json['consent_required'] as bool? ?? true,
  acceptedMimeTypes:
      (json['accepted_mime_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  voices:
      (json['voices'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  provisionalSegments:
      (json['provisional_segments'] as List<dynamic>?)
          ?.map(
            (e) => ProvisionalTranscriptSegmentRemoteModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const <ProvisionalTranscriptSegmentRemoteModel>[],
  uploadUrl: json['upload_url'] as String?,
  maxSizeBytes: (json['max_size_bytes'] as num?)?.toInt(),
  maxDurationSeconds: (json['max_duration_seconds'] as num?)?.toInt(),
  failureCode: json['failure_code'] as String?,
  failureReason: json['failure_reason'] as String?,
  failureRetryable: json['failure_retryable'] as bool?,
);

Map<String, dynamic> _$RecordingImportRemoteModelToJson(
  _RecordingImportRemoteModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'session_id': instance.sessionId,
  'status': instance.status,
  'consent_required': instance.consentRequired,
  'accepted_mime_types': instance.acceptedMimeTypes,
  'voices': instance.voices,
  'provisional_segments': instance.provisionalSegments,
  'upload_url': instance.uploadUrl,
  'max_size_bytes': instance.maxSizeBytes,
  'max_duration_seconds': instance.maxDurationSeconds,
  'failure_code': instance.failureCode,
  'failure_reason': instance.failureReason,
  'failure_retryable': instance.failureRetryable,
};
