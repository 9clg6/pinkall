// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_voice_access_token.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestVoiceAccessTokenParam {

 String get deviceId;
/// Create a copy of RequestVoiceAccessTokenParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestVoiceAccessTokenParamCopyWith<RequestVoiceAccessTokenParam> get copyWith => _$RequestVoiceAccessTokenParamCopyWithImpl<RequestVoiceAccessTokenParam>(this as RequestVoiceAccessTokenParam, _$identity);

  /// Serializes this RequestVoiceAccessTokenParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestVoiceAccessTokenParam&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId);

@override
String toString() {
  return 'RequestVoiceAccessTokenParam(deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $RequestVoiceAccessTokenParamCopyWith<$Res>  {
  factory $RequestVoiceAccessTokenParamCopyWith(RequestVoiceAccessTokenParam value, $Res Function(RequestVoiceAccessTokenParam) _then) = _$RequestVoiceAccessTokenParamCopyWithImpl;
@useResult
$Res call({
 String deviceId
});




}
/// @nodoc
class _$RequestVoiceAccessTokenParamCopyWithImpl<$Res>
    implements $RequestVoiceAccessTokenParamCopyWith<$Res> {
  _$RequestVoiceAccessTokenParamCopyWithImpl(this._self, this._then);

  final RequestVoiceAccessTokenParam _self;
  final $Res Function(RequestVoiceAccessTokenParam) _then;

/// Create a copy of RequestVoiceAccessTokenParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestVoiceAccessTokenParam].
extension RequestVoiceAccessTokenParamPatterns on RequestVoiceAccessTokenParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestVoiceAccessTokenParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestVoiceAccessTokenParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestVoiceAccessTokenParam value)  $default,){
final _that = this;
switch (_that) {
case _RequestVoiceAccessTokenParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestVoiceAccessTokenParam value)?  $default,){
final _that = this;
switch (_that) {
case _RequestVoiceAccessTokenParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestVoiceAccessTokenParam() when $default != null:
return $default(_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId)  $default,) {final _that = this;
switch (_that) {
case _RequestVoiceAccessTokenParam():
return $default(_that.deviceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId)?  $default,) {final _that = this;
switch (_that) {
case _RequestVoiceAccessTokenParam() when $default != null:
return $default(_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _RequestVoiceAccessTokenParam implements RequestVoiceAccessTokenParam {
  const _RequestVoiceAccessTokenParam({required this.deviceId});
  factory _RequestVoiceAccessTokenParam.fromJson(Map<String, dynamic> json) => _$RequestVoiceAccessTokenParamFromJson(json);

@override final  String deviceId;

/// Create a copy of RequestVoiceAccessTokenParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestVoiceAccessTokenParamCopyWith<_RequestVoiceAccessTokenParam> get copyWith => __$RequestVoiceAccessTokenParamCopyWithImpl<_RequestVoiceAccessTokenParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestVoiceAccessTokenParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestVoiceAccessTokenParam&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId);

@override
String toString() {
  return 'RequestVoiceAccessTokenParam(deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$RequestVoiceAccessTokenParamCopyWith<$Res> implements $RequestVoiceAccessTokenParamCopyWith<$Res> {
  factory _$RequestVoiceAccessTokenParamCopyWith(_RequestVoiceAccessTokenParam value, $Res Function(_RequestVoiceAccessTokenParam) _then) = __$RequestVoiceAccessTokenParamCopyWithImpl;
@override @useResult
$Res call({
 String deviceId
});




}
/// @nodoc
class __$RequestVoiceAccessTokenParamCopyWithImpl<$Res>
    implements _$RequestVoiceAccessTokenParamCopyWith<$Res> {
  __$RequestVoiceAccessTokenParamCopyWithImpl(this._self, this._then);

  final _RequestVoiceAccessTokenParam _self;
  final $Res Function(_RequestVoiceAccessTokenParam) _then;

/// Create a copy of RequestVoiceAccessTokenParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,}) {
  return _then(_RequestVoiceAccessTokenParam(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
