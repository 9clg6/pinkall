// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_session.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationSessionRemoteModel _$ConversationSessionRemoteModelFromJson(
  Map<String, dynamic> json,
) => _ConversationSessionRemoteModel(
  id: json['id'] as String,
  callId: json['call_id'] as String,
  status: json['status'] as String,
  coachMode: json['coach_mode'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  transcriptionConsentAcknowledged:
      json['transcription_consent_acknowledged'] as bool? ?? false,
  destinationNumber: json['destination_number'] as String?,
  contactId: json['contact_id'] as String?,
  preparationMarkdown: json['preparation_markdown'] as String?,
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
  endedAt: json['ended_at'] == null
      ? null
      : DateTime.parse(json['ended_at'] as String),
  failureReason: json['failure_reason'] as String?,
);

Map<String, dynamic> _$ConversationSessionRemoteModelToJson(
  _ConversationSessionRemoteModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'call_id': instance.callId,
  'status': instance.status,
  'coach_mode': instance.coachMode,
  'created_at': instance.createdAt.toIso8601String(),
  'transcription_consent_acknowledged':
      instance.transcriptionConsentAcknowledged,
  'destination_number': instance.destinationNumber,
  'contact_id': instance.contactId,
  'preparation_markdown': instance.preparationMarkdown,
  'started_at': instance.startedAt?.toIso8601String(),
  'ended_at': instance.endedAt?.toIso8601String(),
  'failure_reason': instance.failureReason,
};
