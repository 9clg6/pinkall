// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_conversation_session.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateConversationSessionParam _$CreateConversationSessionParamFromJson(
  Map<String, dynamic> json,
) => _CreateConversationSessionParam(
  callId: json['call_id'] as String,
  destinationNumber: json['destination_number'] as String,
  contactId: json['contact_id'] as String?,
  coachModeOverride: $enumDecodeNullable(
    _$CoachModeEnumMap,
    json['coach_mode_override'],
  ),
  locale: json['locale'] as String?,
  preparationMarkdown: json['preparation_markdown'] as String?,
  context:
      (json['context'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
);

Map<String, dynamic> _$CreateConversationSessionParamToJson(
  _CreateConversationSessionParam instance,
) => <String, dynamic>{
  'call_id': instance.callId,
  'destination_number': instance.destinationNumber,
  'contact_id': instance.contactId,
  'coach_mode_override': _$CoachModeEnumMap[instance.coachModeOverride],
  'locale': instance.locale,
  'preparation_markdown': instance.preparationMarkdown,
  'context': instance.context,
};

const _$CoachModeEnumMap = {
  CoachMode.off: 'off',
  CoachMode.shadow: 'shadow',
  CoachMode.live: 'live',
};
