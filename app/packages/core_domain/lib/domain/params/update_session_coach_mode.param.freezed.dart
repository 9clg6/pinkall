// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_session_coach_mode.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateSessionCoachModeParam {

 String get sessionId; CoachMode get mode;
/// Create a copy of UpdateSessionCoachModeParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateSessionCoachModeParamCopyWith<UpdateSessionCoachModeParam> get copyWith => _$UpdateSessionCoachModeParamCopyWithImpl<UpdateSessionCoachModeParam>(this as UpdateSessionCoachModeParam, _$identity);

  /// Serializes this UpdateSessionCoachModeParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateSessionCoachModeParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,mode);

@override
String toString() {
  return 'UpdateSessionCoachModeParam(sessionId: $sessionId, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $UpdateSessionCoachModeParamCopyWith<$Res>  {
  factory $UpdateSessionCoachModeParamCopyWith(UpdateSessionCoachModeParam value, $Res Function(UpdateSessionCoachModeParam) _then) = _$UpdateSessionCoachModeParamCopyWithImpl;
@useResult
$Res call({
 String sessionId, CoachMode mode
});




}
/// @nodoc
class _$UpdateSessionCoachModeParamCopyWithImpl<$Res>
    implements $UpdateSessionCoachModeParamCopyWith<$Res> {
  _$UpdateSessionCoachModeParamCopyWithImpl(this._self, this._then);

  final UpdateSessionCoachModeParam _self;
  final $Res Function(UpdateSessionCoachModeParam) _then;

/// Create a copy of UpdateSessionCoachModeParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? mode = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as CoachMode,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateSessionCoachModeParam].
extension UpdateSessionCoachModeParamPatterns on UpdateSessionCoachModeParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateSessionCoachModeParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateSessionCoachModeParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateSessionCoachModeParam value)  $default,){
final _that = this;
switch (_that) {
case _UpdateSessionCoachModeParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateSessionCoachModeParam value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateSessionCoachModeParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  CoachMode mode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateSessionCoachModeParam() when $default != null:
return $default(_that.sessionId,_that.mode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  CoachMode mode)  $default,) {final _that = this;
switch (_that) {
case _UpdateSessionCoachModeParam():
return $default(_that.sessionId,_that.mode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  CoachMode mode)?  $default,) {final _that = this;
switch (_that) {
case _UpdateSessionCoachModeParam() when $default != null:
return $default(_that.sessionId,_that.mode);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UpdateSessionCoachModeParam implements UpdateSessionCoachModeParam {
  const _UpdateSessionCoachModeParam({required this.sessionId, required this.mode});
  factory _UpdateSessionCoachModeParam.fromJson(Map<String, dynamic> json) => _$UpdateSessionCoachModeParamFromJson(json);

@override final  String sessionId;
@override final  CoachMode mode;

/// Create a copy of UpdateSessionCoachModeParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateSessionCoachModeParamCopyWith<_UpdateSessionCoachModeParam> get copyWith => __$UpdateSessionCoachModeParamCopyWithImpl<_UpdateSessionCoachModeParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateSessionCoachModeParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateSessionCoachModeParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,mode);

@override
String toString() {
  return 'UpdateSessionCoachModeParam(sessionId: $sessionId, mode: $mode)';
}


}

/// @nodoc
abstract mixin class _$UpdateSessionCoachModeParamCopyWith<$Res> implements $UpdateSessionCoachModeParamCopyWith<$Res> {
  factory _$UpdateSessionCoachModeParamCopyWith(_UpdateSessionCoachModeParam value, $Res Function(_UpdateSessionCoachModeParam) _then) = __$UpdateSessionCoachModeParamCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, CoachMode mode
});




}
/// @nodoc
class __$UpdateSessionCoachModeParamCopyWithImpl<$Res>
    implements _$UpdateSessionCoachModeParamCopyWith<$Res> {
  __$UpdateSessionCoachModeParamCopyWithImpl(this._self, this._then);

  final _UpdateSessionCoachModeParam _self;
  final $Res Function(_UpdateSessionCoachModeParam) _then;

/// Create a copy of UpdateSessionCoachModeParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? mode = null,}) {
  return _then(_UpdateSessionCoachModeParam(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as CoachMode,
  ));
}


}

// dart format on
