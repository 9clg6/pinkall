// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'briefing_transcription.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BriefingTranscriptionRemoteModel _$BriefingTranscriptionRemoteModelFromJson(
  Map<String, dynamic> json,
) => _BriefingTranscriptionRemoteModel(
  text: json['text'] as String,
  provider: json['provider'] as String,
  languageCode: json['language'] as String?,
);

Map<String, dynamic> _$BriefingTranscriptionRemoteModelToJson(
  _BriefingTranscriptionRemoteModel instance,
) => <String, dynamic>{
  'text': instance.text,
  'provider': instance.provider,
  'language': instance.languageCode,
};
