// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telnyx_configuration.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TelnyxConfigurationEntity {

 TelnyxAuthenticationEntity get authentication; String get callerName; String get callerNumber; String? get notificationToken;
/// Create a copy of TelnyxConfigurationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelnyxConfigurationEntityCopyWith<TelnyxConfigurationEntity> get copyWith => _$TelnyxConfigurationEntityCopyWithImpl<TelnyxConfigurationEntity>(this as TelnyxConfigurationEntity, _$identity);







}

/// @nodoc
abstract mixin class $TelnyxConfigurationEntityCopyWith<$Res>  {
  factory $TelnyxConfigurationEntityCopyWith(TelnyxConfigurationEntity value, $Res Function(TelnyxConfigurationEntity) _then) = _$TelnyxConfigurationEntityCopyWithImpl;
@useResult
$Res call({
 TelnyxAuthenticationEntity authentication, String callerName, String callerNumber, String? notificationToken
});


$TelnyxAuthenticationEntityCopyWith<$Res> get authentication;

}
/// @nodoc
class _$TelnyxConfigurationEntityCopyWithImpl<$Res>
    implements $TelnyxConfigurationEntityCopyWith<$Res> {
  _$TelnyxConfigurationEntityCopyWithImpl(this._self, this._then);

  final TelnyxConfigurationEntity _self;
  final $Res Function(TelnyxConfigurationEntity) _then;

/// Create a copy of TelnyxConfigurationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authentication = null,Object? callerName = null,Object? callerNumber = null,Object? notificationToken = freezed,}) {
  return _then(_self.copyWith(
authentication: null == authentication ? _self.authentication : authentication // ignore: cast_nullable_to_non_nullable
as TelnyxAuthenticationEntity,callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,callerNumber: null == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String,notificationToken: freezed == notificationToken ? _self.notificationToken : notificationToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TelnyxConfigurationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TelnyxAuthenticationEntityCopyWith<$Res> get authentication {
  
  return $TelnyxAuthenticationEntityCopyWith<$Res>(_self.authentication, (value) {
    return _then(_self.copyWith(authentication: value));
  });
}
}


/// Adds pattern-matching-related methods to [TelnyxConfigurationEntity].
extension TelnyxConfigurationEntityPatterns on TelnyxConfigurationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelnyxConfigurationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelnyxConfigurationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelnyxConfigurationEntity value)  $default,){
final _that = this;
switch (_that) {
case _TelnyxConfigurationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelnyxConfigurationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TelnyxConfigurationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TelnyxAuthenticationEntity authentication,  String callerName,  String callerNumber,  String? notificationToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelnyxConfigurationEntity() when $default != null:
return $default(_that.authentication,_that.callerName,_that.callerNumber,_that.notificationToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TelnyxAuthenticationEntity authentication,  String callerName,  String callerNumber,  String? notificationToken)  $default,) {final _that = this;
switch (_that) {
case _TelnyxConfigurationEntity():
return $default(_that.authentication,_that.callerName,_that.callerNumber,_that.notificationToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TelnyxAuthenticationEntity authentication,  String callerName,  String callerNumber,  String? notificationToken)?  $default,) {final _that = this;
switch (_that) {
case _TelnyxConfigurationEntity() when $default != null:
return $default(_that.authentication,_that.callerName,_that.callerNumber,_that.notificationToken);case _:
  return null;

}
}

}

/// @nodoc


class _TelnyxConfigurationEntity extends TelnyxConfigurationEntity {
  const _TelnyxConfigurationEntity({required this.authentication, required this.callerName, required this.callerNumber, this.notificationToken}): super._();
  

@override final  TelnyxAuthenticationEntity authentication;
@override final  String callerName;
@override final  String callerNumber;
@override final  String? notificationToken;

/// Create a copy of TelnyxConfigurationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelnyxConfigurationEntityCopyWith<_TelnyxConfigurationEntity> get copyWith => __$TelnyxConfigurationEntityCopyWithImpl<_TelnyxConfigurationEntity>(this, _$identity);







}

/// @nodoc
abstract mixin class _$TelnyxConfigurationEntityCopyWith<$Res> implements $TelnyxConfigurationEntityCopyWith<$Res> {
  factory _$TelnyxConfigurationEntityCopyWith(_TelnyxConfigurationEntity value, $Res Function(_TelnyxConfigurationEntity) _then) = __$TelnyxConfigurationEntityCopyWithImpl;
@override @useResult
$Res call({
 TelnyxAuthenticationEntity authentication, String callerName, String callerNumber, String? notificationToken
});


@override $TelnyxAuthenticationEntityCopyWith<$Res> get authentication;

}
/// @nodoc
class __$TelnyxConfigurationEntityCopyWithImpl<$Res>
    implements _$TelnyxConfigurationEntityCopyWith<$Res> {
  __$TelnyxConfigurationEntityCopyWithImpl(this._self, this._then);

  final _TelnyxConfigurationEntity _self;
  final $Res Function(_TelnyxConfigurationEntity) _then;

/// Create a copy of TelnyxConfigurationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authentication = null,Object? callerName = null,Object? callerNumber = null,Object? notificationToken = freezed,}) {
  return _then(_TelnyxConfigurationEntity(
authentication: null == authentication ? _self.authentication : authentication // ignore: cast_nullable_to_non_nullable
as TelnyxAuthenticationEntity,callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,callerNumber: null == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String,notificationToken: freezed == notificationToken ? _self.notificationToken : notificationToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TelnyxConfigurationEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TelnyxAuthenticationEntityCopyWith<$Res> get authentication {
  
  return $TelnyxAuthenticationEntityCopyWith<$Res>(_self.authentication, (value) {
    return _then(_self.copyWith(authentication: value));
  });
}
}

// dart format on
