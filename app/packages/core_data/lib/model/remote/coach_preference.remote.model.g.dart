// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_preference.remote.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CoachPreferenceRemoteModel _$CoachPreferenceRemoteModelFromJson(
  Map<String, dynamic> json,
) => _CoachPreferenceRemoteModel(
  defaultMode: json['default_mode'] as String,
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CoachPreferenceRemoteModelToJson(
  _CoachPreferenceRemoteModel instance,
) => <String, dynamic>{
  'default_mode': instance.defaultMode,
  'updated_at': instance.updatedAt.toIso8601String(),
};
