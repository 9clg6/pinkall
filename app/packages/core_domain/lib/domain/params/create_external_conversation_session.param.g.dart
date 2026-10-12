// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_external_conversation_session.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateExternalConversationSessionParam
_$CreateExternalConversationSessionParamFromJson(Map<String, dynamic> json) =>
    _CreateExternalConversationSessionParam(
      source:
          $enumDecodeNullable(
            _$ExternalConversationSourceEnumMap,
            json['source'],
          ) ??
          ExternalConversationSource.macosMeeting,
      title: json['title'] as String?,
      preparationMarkdown: json['preparation_markdown'] as String?,
      coachModeOverride: $enumDecodeNullable(
        _$CoachModeEnumMap,
        json['coach_mode_override'],
      ),
      locale: json['locale'] as String? ?? 'fr-FR',
    );

Map<String, dynamic> _$CreateExternalConversationSessionParamToJson(
  _CreateExternalConversationSessionParam instance,
) => <String, dynamic>{
  'source': _$ExternalConversationSourceEnumMap[instance.source]!,
  'title': instance.title,
  'preparation_markdown': instance.preparationMarkdown,
  'coach_mode_override': _$CoachModeEnumMap[instance.coachModeOverride],
  'locale': instance.locale,
};

const _$ExternalConversationSourceEnumMap = {
  ExternalConversationSource.macosMeeting: 'macos_meeting',
};

const _$CoachModeEnumMap = {
  CoachMode.off: 'off',
  CoachMode.shadow: 'shadow',
  CoachMode.live: 'live',
};
