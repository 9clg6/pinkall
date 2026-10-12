// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'set_call_muted.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SetCallMutedParam {

 String get callId; bool get isMuted;
/// Create a copy of SetCallMutedParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SetCallMutedParamCopyWith<SetCallMutedParam> get copyWith => _$SetCallMutedParamCopyWithImpl<SetCallMutedParam>(this as SetCallMutedParam, _$identity);

  /// Serializes this SetCallMutedParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SetCallMutedParam&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,isMuted);

@override
String toString() {
  return 'SetCallMutedParam(callId: $callId, isMuted: $isMuted)';
}


}

/// @nodoc
abstract mixin class $SetCallMutedParamCopyWith<$Res>  {
  factory $SetCallMutedParamCopyWith(SetCallMutedParam value, $Res Function(SetCallMutedParam) _then) = _$SetCallMutedParamCopyWithImpl;
@useResult
$Res call({
 String callId, bool isMuted
});




}
/// @nodoc
class _$SetCallMutedParamCopyWithImpl<$Res>
    implements $SetCallMutedParamCopyWith<$Res> {
  _$SetCallMutedParamCopyWithImpl(this._self, this._then);

  final SetCallMutedParam _self;
  final $Res Function(SetCallMutedParam) _then;

/// Create a copy of SetCallMutedParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? isMuted = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SetCallMutedParam].
extension SetCallMutedParamPatterns on SetCallMutedParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SetCallMutedParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SetCallMutedParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SetCallMutedParam value)  $default,){
final _that = this;
switch (_that) {
case _SetCallMutedParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SetCallMutedParam value)?  $default,){
final _that = this;
switch (_that) {
case _SetCallMutedParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  bool isMuted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SetCallMutedParam() when $default != null:
return $default(_that.callId,_that.isMuted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  bool isMuted)  $default,) {final _that = this;
switch (_that) {
case _SetCallMutedParam():
return $default(_that.callId,_that.isMuted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  bool isMuted)?  $default,) {final _that = this;
switch (_that) {
case _SetCallMutedParam() when $default != null:
return $default(_that.callId,_that.isMuted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SetCallMutedParam implements SetCallMutedParam {
  const _SetCallMutedParam({required this.callId, required this.isMuted});
  factory _SetCallMutedParam.fromJson(Map<String, dynamic> json) => _$SetCallMutedParamFromJson(json);

@override final  String callId;
@override final  bool isMuted;

/// Create a copy of SetCallMutedParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SetCallMutedParamCopyWith<_SetCallMutedParam> get copyWith => __$SetCallMutedParamCopyWithImpl<_SetCallMutedParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SetCallMutedParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SetCallMutedParam&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,isMuted);

@override
String toString() {
  return 'SetCallMutedParam(callId: $callId, isMuted: $isMuted)';
}


}

/// @nodoc
abstract mixin class _$SetCallMutedParamCopyWith<$Res> implements $SetCallMutedParamCopyWith<$Res> {
  factory _$SetCallMutedParamCopyWith(_SetCallMutedParam value, $Res Function(_SetCallMutedParam) _then) = __$SetCallMutedParamCopyWithImpl;
@override @useResult
$Res call({
 String callId, bool isMuted
});




}
/// @nodoc
class __$SetCallMutedParamCopyWithImpl<$Res>
    implements _$SetCallMutedParamCopyWith<$Res> {
  __$SetCallMutedParamCopyWithImpl(this._self, this._then);

  final _SetCallMutedParam _self;
  final $Res Function(_SetCallMutedParam) _then;

/// Create a copy of SetCallMutedParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? isMuted = null,}) {
  return _then(_SetCallMutedParam(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
