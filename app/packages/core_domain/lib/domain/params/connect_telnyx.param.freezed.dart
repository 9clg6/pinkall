// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connect_telnyx.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectTelnyxParam {

 TelnyxConfigurationEntity get configuration;
/// Create a copy of ConnectTelnyxParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectTelnyxParamCopyWith<ConnectTelnyxParam> get copyWith => _$ConnectTelnyxParamCopyWithImpl<ConnectTelnyxParam>(this as ConnectTelnyxParam, _$identity);







}

/// @nodoc
abstract mixin class $ConnectTelnyxParamCopyWith<$Res>  {
  factory $ConnectTelnyxParamCopyWith(ConnectTelnyxParam value, $Res Function(ConnectTelnyxParam) _then) = _$ConnectTelnyxParamCopyWithImpl;
@useResult
$Res call({
 TelnyxConfigurationEntity configuration
});


$TelnyxConfigurationEntityCopyWith<$Res> get configuration;

}
/// @nodoc
class _$ConnectTelnyxParamCopyWithImpl<$Res>
    implements $ConnectTelnyxParamCopyWith<$Res> {
  _$ConnectTelnyxParamCopyWithImpl(this._self, this._then);

  final ConnectTelnyxParam _self;
  final $Res Function(ConnectTelnyxParam) _then;

/// Create a copy of ConnectTelnyxParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? configuration = null,}) {
  return _then(_self.copyWith(
configuration: null == configuration ? _self.configuration : configuration // ignore: cast_nullable_to_non_nullable
as TelnyxConfigurationEntity,
  ));
}
/// Create a copy of ConnectTelnyxParam
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TelnyxConfigurationEntityCopyWith<$Res> get configuration {
  
  return $TelnyxConfigurationEntityCopyWith<$Res>(_self.configuration, (value) {
    return _then(_self.copyWith(configuration: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConnectTelnyxParam].
extension ConnectTelnyxParamPatterns on ConnectTelnyxParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectTelnyxParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectTelnyxParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectTelnyxParam value)  $default,){
final _that = this;
switch (_that) {
case _ConnectTelnyxParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectTelnyxParam value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectTelnyxParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TelnyxConfigurationEntity configuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectTelnyxParam() when $default != null:
return $default(_that.configuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TelnyxConfigurationEntity configuration)  $default,) {final _that = this;
switch (_that) {
case _ConnectTelnyxParam():
return $default(_that.configuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TelnyxConfigurationEntity configuration)?  $default,) {final _that = this;
switch (_that) {
case _ConnectTelnyxParam() when $default != null:
return $default(_that.configuration);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectTelnyxParam extends ConnectTelnyxParam {
  const _ConnectTelnyxParam({required this.configuration}): super._();
  

@override final  TelnyxConfigurationEntity configuration;

/// Create a copy of ConnectTelnyxParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectTelnyxParamCopyWith<_ConnectTelnyxParam> get copyWith => __$ConnectTelnyxParamCopyWithImpl<_ConnectTelnyxParam>(this, _$identity);







}

/// @nodoc
abstract mixin class _$ConnectTelnyxParamCopyWith<$Res> implements $ConnectTelnyxParamCopyWith<$Res> {
  factory _$ConnectTelnyxParamCopyWith(_ConnectTelnyxParam value, $Res Function(_ConnectTelnyxParam) _then) = __$ConnectTelnyxParamCopyWithImpl;
@override @useResult
$Res call({
 TelnyxConfigurationEntity configuration
});


@override $TelnyxConfigurationEntityCopyWith<$Res> get configuration;

}
/// @nodoc
class __$ConnectTelnyxParamCopyWithImpl<$Res>
    implements _$ConnectTelnyxParamCopyWith<$Res> {
  __$ConnectTelnyxParamCopyWithImpl(this._self, this._then);

  final _ConnectTelnyxParam _self;
  final $Res Function(_ConnectTelnyxParam) _then;

/// Create a copy of ConnectTelnyxParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? configuration = null,}) {
  return _then(_ConnectTelnyxParam(
configuration: null == configuration ? _self.configuration : configuration // ignore: cast_nullable_to_non_nullable
as TelnyxConfigurationEntity,
  ));
}

/// Create a copy of ConnectTelnyxParam
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TelnyxConfigurationEntityCopyWith<$Res> get configuration {
  
  return $TelnyxConfigurationEntityCopyWith<$Res>(_self.configuration, (value) {
    return _then(_self.copyWith(configuration: value));
  });
}
}

// dart format on
