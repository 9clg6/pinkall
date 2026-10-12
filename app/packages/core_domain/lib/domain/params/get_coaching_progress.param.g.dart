// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_coaching_progress.param.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetCoachingProgressParam _$GetCoachingProgressParamFromJson(
  Map<String, dynamic> json,
) => _GetCoachingProgressParam(
  windowSize: (json['window_size'] as num?)?.toInt() ?? 5,
  recentLimit: (json['recent_limit'] as num?)?.toInt() ?? 20,
);

Map<String, dynamic> _$GetCoachingProgressParamToJson(
  _GetCoachingProgressParam instance,
) => <String, dynamic>{
  'window_size': instance.windowSize,
  'recent_limit': instance.recentLimit,
};
