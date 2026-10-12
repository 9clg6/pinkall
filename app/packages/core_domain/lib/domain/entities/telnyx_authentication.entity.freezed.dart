// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telnyx_authentication.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TelnyxAuthenticationEntity {









}

/// @nodoc
class $TelnyxAuthenticationEntityCopyWith<$Res>  {
$TelnyxAuthenticationEntityCopyWith(TelnyxAuthenticationEntity _, $Res Function(TelnyxAuthenticationEntity) __);
}


/// Adds pattern-matching-related methods to [TelnyxAuthenticationEntity].
extension TelnyxAuthenticationEntityPatterns on TelnyxAuthenticationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TelnyxTokenAuthenticationEntity value)?  token,TResult Function( TelnyxCredentialsAuthenticationEntity value)?  credentials,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TelnyxTokenAuthenticationEntity() when token != null:
return token(_that);case TelnyxCredentialsAuthenticationEntity() when credentials != null:
return credentials(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TelnyxTokenAuthenticationEntity value)  token,required TResult Function( TelnyxCredentialsAuthenticationEntity value)  credentials,}){
final _that = this;
switch (_that) {
case TelnyxTokenAuthenticationEntity():
return token(_that);case TelnyxCredentialsAuthenticationEntity():
return credentials(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TelnyxTokenAuthenticationEntity value)?  token,TResult? Function( TelnyxCredentialsAuthenticationEntity value)?  credentials,}){
final _that = this;
switch (_that) {
case TelnyxTokenAuthenticationEntity() when token != null:
return token(_that);case TelnyxCredentialsAuthenticationEntity() when credentials != null:
return credentials(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String sipToken)?  token,TResult Function( String sipUser,  String sipPassword)?  credentials,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TelnyxTokenAuthenticationEntity() when token != null:
return token(_that.sipToken);case TelnyxCredentialsAuthenticationEntity() when credentials != null:
return credentials(_that.sipUser,_that.sipPassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String sipToken)  token,required TResult Function( String sipUser,  String sipPassword)  credentials,}) {final _that = this;
switch (_that) {
case TelnyxTokenAuthenticationEntity():
return token(_that.sipToken);case TelnyxCredentialsAuthenticationEntity():
return credentials(_that.sipUser,_that.sipPassword);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String sipToken)?  token,TResult? Function( String sipUser,  String sipPassword)?  credentials,}) {final _that = this;
switch (_that) {
case TelnyxTokenAuthenticationEntity() when token != null:
return token(_that.sipToken);case TelnyxCredentialsAuthenticationEntity() when credentials != null:
return credentials(_that.sipUser,_that.sipPassword);case _:
  return null;

}
}

}

/// @nodoc


class TelnyxTokenAuthenticationEntity extends TelnyxAuthenticationEntity {
  const TelnyxTokenAuthenticationEntity({required this.sipToken}): super._();
  

 final  String sipToken;

/// Create a copy of TelnyxAuthenticationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelnyxTokenAuthenticationEntityCopyWith<TelnyxTokenAuthenticationEntity> get copyWith => _$TelnyxTokenAuthenticationEntityCopyWithImpl<TelnyxTokenAuthenticationEntity>(this, _$identity);







}

/// @nodoc
abstract mixin class $TelnyxTokenAuthenticationEntityCopyWith<$Res> implements $TelnyxAuthenticationEntityCopyWith<$Res> {
  factory $TelnyxTokenAuthenticationEntityCopyWith(TelnyxTokenAuthenticationEntity value, $Res Function(TelnyxTokenAuthenticationEntity) _then) = _$TelnyxTokenAuthenticationEntityCopyWithImpl;
@useResult
$Res call({
 String sipToken
});




}
/// @nodoc
class _$TelnyxTokenAuthenticationEntityCopyWithImpl<$Res>
    implements $TelnyxTokenAuthenticationEntityCopyWith<$Res> {
  _$TelnyxTokenAuthenticationEntityCopyWithImpl(this._self, this._then);

  final TelnyxTokenAuthenticationEntity _self;
  final $Res Function(TelnyxTokenAuthenticationEntity) _then;

/// Create a copy of TelnyxAuthenticationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sipToken = null,}) {
  return _then(TelnyxTokenAuthenticationEntity(
sipToken: null == sipToken ? _self.sipToken : sipToken // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TelnyxCredentialsAuthenticationEntity extends TelnyxAuthenticationEntity {
  const TelnyxCredentialsAuthenticationEntity({required this.sipUser, required this.sipPassword}): super._();
  

 final  String sipUser;
 final  String sipPassword;

/// Create a copy of TelnyxAuthenticationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelnyxCredentialsAuthenticationEntityCopyWith<TelnyxCredentialsAuthenticationEntity> get copyWith => _$TelnyxCredentialsAuthenticationEntityCopyWithImpl<TelnyxCredentialsAuthenticationEntity>(this, _$identity);







}

/// @nodoc
abstract mixin class $TelnyxCredentialsAuthenticationEntityCopyWith<$Res> implements $TelnyxAuthenticationEntityCopyWith<$Res> {
  factory $TelnyxCredentialsAuthenticationEntityCopyWith(TelnyxCredentialsAuthenticationEntity value, $Res Function(TelnyxCredentialsAuthenticationEntity) _then) = _$TelnyxCredentialsAuthenticationEntityCopyWithImpl;
@useResult
$Res call({
 String sipUser, String sipPassword
});




}
/// @nodoc
class _$TelnyxCredentialsAuthenticationEntityCopyWithImpl<$Res>
    implements $TelnyxCredentialsAuthenticationEntityCopyWith<$Res> {
  _$TelnyxCredentialsAuthenticationEntityCopyWithImpl(this._self, this._then);

  final TelnyxCredentialsAuthenticationEntity _self;
  final $Res Function(TelnyxCredentialsAuthenticationEntity) _then;

/// Create a copy of TelnyxAuthenticationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sipUser = null,Object? sipPassword = null,}) {
  return _then(TelnyxCredentialsAuthenticationEntity(
sipUser: null == sipUser ? _self.sipUser : sipUser // ignore: cast_nullable_to_non_nullable
as String,sipPassword: null == sipPassword ? _self.sipPassword : sipPassword // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
