// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_session_coach_mode.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateSessionCoachModeParam _$UpdateSessionCoachModeParamFromJson(
  Map<String, dynamic> json,
) => _UpdateSessionCoachModeParam(
  sessionId: json['session_id'] as String,
  mode: $enumDecode(_$CoachModeEnumMap, json['mode']),
);

Map<String, dynamic> _$UpdateSessionCoachModeParamToJson(
  _UpdateSessionCoachModeParam instance,
) => <String, dynamic>{
  'session_id': instance.sessionId,
  'mode': _$CoachModeEnumMap[instance.mode]!,
};

const _$CoachModeEnumMap = {
  CoachMode.off: 'off',
  CoachMode.shadow: 'shadow',
  CoachMode.live: 'live',
};
