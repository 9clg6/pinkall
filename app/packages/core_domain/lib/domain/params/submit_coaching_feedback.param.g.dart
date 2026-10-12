// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_coaching_feedback.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubmitCoachingFeedbackParam _$SubmitCoachingFeedbackParamFromJson(
  Map<String, dynamic> json,
) => _SubmitCoachingFeedbackParam(
  sessionId: json['session_id'] as String,
  suggestionId: json['suggestion_id'] as String,
  value: $enumDecode(_$SuggestionFeedbackValueEnumMap, json['value']),
  applied: json['applied'] as bool? ?? false,
  note: json['note'] as String?,
);

Map<String, dynamic> _$SubmitCoachingFeedbackParamToJson(
  _SubmitCoachingFeedbackParam instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'suggestion_id': instance.suggestionId,
  'value': _$SuggestionFeedbackValueEnumMap[instance.value]!,
  'applied': instance.applied,
  'note': instance.note,
};

const _$SuggestionFeedbackValueEnumMap = {
  SuggestionFeedbackValue.useful: 'useful',
  SuggestionFeedbackValue.notUseful: 'not_useful',
  SuggestionFeedbackValue.incorrect: 'incorrect',
  SuggestionFeedbackValue.distracting: 'distracting',
};
