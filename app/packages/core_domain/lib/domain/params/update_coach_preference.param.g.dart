// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_coach_preference.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateCoachPreferenceParam _$UpdateCoachPreferenceParamFromJson(
  Map<String, dynamic> json,
) => _UpdateCoachPreferenceParam(
  defaultMode: $enumDecode(_$CoachModeEnumMap, json['default_mode']),
);

Map<String, dynamic> _$UpdateCoachPreferenceParamToJson(
  _UpdateCoachPreferenceParam instance,
) => <String, dynamic>{
  'default_mode': _$CoachModeEnumMap[instance.defaultMode]!,
};

const _$CoachModeEnumMap = {
  CoachMode.off: 'off',
  CoachMode.shadow: 'shadow',
  CoachMode.live: 'live',
};
