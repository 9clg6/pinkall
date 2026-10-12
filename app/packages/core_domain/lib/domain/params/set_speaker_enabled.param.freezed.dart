// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_speaker_enabled.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SetSpeakerEnabledParam {

 String get callId; bool get isEnabled;
/// Create a copy of SetSpeakerEnabledParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetSpeakerEnabledParamCopyWith<SetSpeakerEnabledParam> get copyWith => _$SetSpeakerEnabledParamCopyWithImpl<SetSpeakerEnabledParam>(this as SetSpeakerEnabledParam, _$identity);

  /// Serializes this SetSpeakerEnabledParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetSpeakerEnabledParam&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,isEnabled);

@override
String toString() {
  return 'SetSpeakerEnabledParam(callId: $callId, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class $SetSpeakerEnabledParamCopyWith<$Res>  {
  factory $SetSpeakerEnabledParamCopyWith(SetSpeakerEnabledParam value, $Res Function(SetSpeakerEnabledParam) _then) = _$SetSpeakerEnabledParamCopyWithImpl;
@useResult
$Res call({
 String callId, bool isEnabled
});




}
/// @nodoc
class _$SetSpeakerEnabledParamCopyWithImpl<$Res>
    implements $SetSpeakerEnabledParamCopyWith<$Res> {
  _$SetSpeakerEnabledParamCopyWithImpl(this._self, this._then);

  final SetSpeakerEnabledParam _self;
  final $Res Function(SetSpeakerEnabledParam) _then;

/// Create a copy of SetSpeakerEnabledParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? isEnabled = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SetSpeakerEnabledParam].
extension SetSpeakerEnabledParamPatterns on SetSpeakerEnabledParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetSpeakerEnabledParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetSpeakerEnabledParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetSpeakerEnabledParam value)  $default,){
final _that = this;
switch (_that) {
case _SetSpeakerEnabledParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetSpeakerEnabledParam value)?  $default,){
final _that = this;
switch (_that) {
case _SetSpeakerEnabledParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  bool isEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetSpeakerEnabledParam() when $default != null:
return $default(_that.callId,_that.isEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  bool isEnabled)  $default,) {final _that = this;
switch (_that) {
case _SetSpeakerEnabledParam():
return $default(_that.callId,_that.isEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  bool isEnabled)?  $default,) {final _that = this;
switch (_that) {
case _SetSpeakerEnabledParam() when $default != null:
return $default(_that.callId,_that.isEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetSpeakerEnabledParam implements SetSpeakerEnabledParam {
  const _SetSpeakerEnabledParam({required this.callId, required this.isEnabled});
  factory _SetSpeakerEnabledParam.fromJson(Map<String, dynamic> json) => _$SetSpeakerEnabledParamFromJson(json);

@override final  String callId;
@override final  bool isEnabled;

/// Create a copy of SetSpeakerEnabledParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetSpeakerEnabledParamCopyWith<_SetSpeakerEnabledParam> get copyWith => __$SetSpeakerEnabledParamCopyWithImpl<_SetSpeakerEnabledParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetSpeakerEnabledParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetSpeakerEnabledParam&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,isEnabled);

@override
String toString() {
  return 'SetSpeakerEnabledParam(callId: $callId, isEnabled: $isEnabled)';
}


}

/// @nodoc
abstract mixin class _$SetSpeakerEnabledParamCopyWith<$Res> implements $SetSpeakerEnabledParamCopyWith<$Res> {
  factory _$SetSpeakerEnabledParamCopyWith(_SetSpeakerEnabledParam value, $Res Function(_SetSpeakerEnabledParam) _then) = __$SetSpeakerEnabledParamCopyWithImpl;
@override @useResult
$Res call({
 String callId, bool isEnabled
});




}
/// @nodoc
class __$SetSpeakerEnabledParamCopyWithImpl<$Res>
    implements _$SetSpeakerEnabledParamCopyWith<$Res> {
  __$SetSpeakerEnabledParamCopyWithImpl(this._self, this._then);

  final _SetSpeakerEnabledParam _self;
  final $Res Function(_SetSpeakerEnabledParam) _then;

/// Create a copy of SetSpeakerEnabledParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? isEnabled = null,}) {
  return _then(_SetSpeakerEnabledParam(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
