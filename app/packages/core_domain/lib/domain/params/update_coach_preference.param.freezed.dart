// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_coach_preference.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateCoachPreferenceParam {

 CoachMode get defaultMode;
/// Create a copy of UpdateCoachPreferenceParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateCoachPreferenceParamCopyWith<UpdateCoachPreferenceParam> get copyWith => _$UpdateCoachPreferenceParamCopyWithImpl<UpdateCoachPreferenceParam>(this as UpdateCoachPreferenceParam, _$identity);

  /// Serializes this UpdateCoachPreferenceParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateCoachPreferenceParam&&(identical(other.defaultMode, defaultMode) || other.defaultMode == defaultMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultMode);

@override
String toString() {
  return 'UpdateCoachPreferenceParam(defaultMode: $defaultMode)';
}


}

/// @nodoc
abstract mixin class $UpdateCoachPreferenceParamCopyWith<$Res>  {
  factory $UpdateCoachPreferenceParamCopyWith(UpdateCoachPreferenceParam value, $Res Function(UpdateCoachPreferenceParam) _then) = _$UpdateCoachPreferenceParamCopyWithImpl;
@useResult
$Res call({
 CoachMode defaultMode
});




}
/// @nodoc
class _$UpdateCoachPreferenceParamCopyWithImpl<$Res>
    implements $UpdateCoachPreferenceParamCopyWith<$Res> {
  _$UpdateCoachPreferenceParamCopyWithImpl(this._self, this._then);

  final UpdateCoachPreferenceParam _self;
  final $Res Function(UpdateCoachPreferenceParam) _then;

/// Create a copy of UpdateCoachPreferenceParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultMode = null,}) {
  return _then(_self.copyWith(
defaultMode: null == defaultMode ? _self.defaultMode : defaultMode // ignore: cast_nullable_to_non_nullable
as CoachMode,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateCoachPreferenceParam].
extension UpdateCoachPreferenceParamPatterns on UpdateCoachPreferenceParam {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateCoachPreferenceParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateCoachPreferenceParam() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateCoachPreferenceParam value)  $default,){
final _that = this;
switch (_that) {
case _UpdateCoachPreferenceParam():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateCoachPreferenceParam value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateCoachPreferenceParam() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoachMode defaultMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateCoachPreferenceParam() when $default != null:
return $default(_that.defaultMode);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoachMode defaultMode)  $default,) {final _that = this;
switch (_that) {
case _UpdateCoachPreferenceParam():
return $default(_that.defaultMode);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoachMode defaultMode)?  $default,) {final _that = this;
switch (_that) {
case _UpdateCoachPreferenceParam() when $default != null:
return $default(_that.defaultMode);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UpdateCoachPreferenceParam implements UpdateCoachPreferenceParam {
  const _UpdateCoachPreferenceParam({required this.defaultMode});
  factory _UpdateCoachPreferenceParam.fromJson(Map<String, dynamic> json) => _$UpdateCoachPreferenceParamFromJson(json);

@override final  CoachMode defaultMode;

/// Create a copy of UpdateCoachPreferenceParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateCoachPreferenceParamCopyWith<_UpdateCoachPreferenceParam> get copyWith => __$UpdateCoachPreferenceParamCopyWithImpl<_UpdateCoachPreferenceParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateCoachPreferenceParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateCoachPreferenceParam&&(identical(other.defaultMode, defaultMode) || other.defaultMode == defaultMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultMode);

@override
String toString() {
  return 'UpdateCoachPreferenceParam(defaultMode: $defaultMode)';
}


}

/// @nodoc
abstract mixin class _$UpdateCoachPreferenceParamCopyWith<$Res> implements $UpdateCoachPreferenceParamCopyWith<$Res> {
  factory _$UpdateCoachPreferenceParamCopyWith(_UpdateCoachPreferenceParam value, $Res Function(_UpdateCoachPreferenceParam) _then) = __$UpdateCoachPreferenceParamCopyWithImpl;
@override @useResult
$Res call({
 CoachMode defaultMode
});




}
/// @nodoc
class __$UpdateCoachPreferenceParamCopyWithImpl<$Res>
    implements _$UpdateCoachPreferenceParamCopyWith<$Res> {
  __$UpdateCoachPreferenceParamCopyWithImpl(this._self, this._then);

  final _UpdateCoachPreferenceParam _self;
  final $Res Function(_UpdateCoachPreferenceParam) _then;

/// Create a copy of UpdateCoachPreferenceParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultMode = null,}) {
  return _then(_UpdateCoachPreferenceParam(
defaultMode: null == defaultMode ? _self.defaultMode : defaultMode // ignore: cast_nullable_to_non_nullable
as CoachMode,
  ));
}


}

// dart format on
