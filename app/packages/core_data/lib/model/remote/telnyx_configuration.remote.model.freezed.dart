// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telnyx_configuration.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TelnyxConfigurationRemoteModel {

 String get authenticationMode; String? get sipToken; String? get sipUser; String? get sipPassword; String get callerName; String get callerNumber; String? get notificationToken;
/// Create a copy of TelnyxConfigurationRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelnyxConfigurationRemoteModelCopyWith<TelnyxConfigurationRemoteModel> get copyWith => _$TelnyxConfigurationRemoteModelCopyWithImpl<TelnyxConfigurationRemoteModel>(this as TelnyxConfigurationRemoteModel, _$identity);







}

/// @nodoc
abstract mixin class $TelnyxConfigurationRemoteModelCopyWith<$Res>  {
  factory $TelnyxConfigurationRemoteModelCopyWith(TelnyxConfigurationRemoteModel value, $Res Function(TelnyxConfigurationRemoteModel) _then) = _$TelnyxConfigurationRemoteModelCopyWithImpl;
@useResult
$Res call({
 String authenticationMode, String? sipToken, String? sipUser, String? sipPassword, String callerName, String callerNumber, String? notificationToken
});




}
/// @nodoc
class _$TelnyxConfigurationRemoteModelCopyWithImpl<$Res>
    implements $TelnyxConfigurationRemoteModelCopyWith<$Res> {
  _$TelnyxConfigurationRemoteModelCopyWithImpl(this._self, this._then);

  final TelnyxConfigurationRemoteModel _self;
  final $Res Function(TelnyxConfigurationRemoteModel) _then;

/// Create a copy of TelnyxConfigurationRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authenticationMode = null,Object? sipToken = freezed,Object? sipUser = freezed,Object? sipPassword = freezed,Object? callerName = null,Object? callerNumber = null,Object? notificationToken = freezed,}) {
  return _then(_self.copyWith(
authenticationMode: null == authenticationMode ? _self.authenticationMode : authenticationMode // ignore: cast_nullable_to_non_nullable
as String,sipToken: freezed == sipToken ? _self.sipToken : sipToken // ignore: cast_nullable_to_non_nullable
as String?,sipUser: freezed == sipUser ? _self.sipUser : sipUser // ignore: cast_nullable_to_non_nullable
as String?,sipPassword: freezed == sipPassword ? _self.sipPassword : sipPassword // ignore: cast_nullable_to_non_nullable
as String?,callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,callerNumber: null == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String,notificationToken: freezed == notificationToken ? _self.notificationToken : notificationToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TelnyxConfigurationRemoteModel].
extension TelnyxConfigurationRemoteModelPatterns on TelnyxConfigurationRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelnyxConfigurationRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelnyxConfigurationRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelnyxConfigurationRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _TelnyxConfigurationRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelnyxConfigurationRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _TelnyxConfigurationRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String authenticationMode,  String? sipToken,  String? sipUser,  String? sipPassword,  String callerName,  String callerNumber,  String? notificationToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelnyxConfigurationRemoteModel() when $default != null:
return $default(_that.authenticationMode,_that.sipToken,_that.sipUser,_that.sipPassword,_that.callerName,_that.callerNumber,_that.notificationToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String authenticationMode,  String? sipToken,  String? sipUser,  String? sipPassword,  String callerName,  String callerNumber,  String? notificationToken)  $default,) {final _that = this;
switch (_that) {
case _TelnyxConfigurationRemoteModel():
return $default(_that.authenticationMode,_that.sipToken,_that.sipUser,_that.sipPassword,_that.callerName,_that.callerNumber,_that.notificationToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String authenticationMode,  String? sipToken,  String? sipUser,  String? sipPassword,  String callerName,  String callerNumber,  String? notificationToken)?  $default,) {final _that = this;
switch (_that) {
case _TelnyxConfigurationRemoteModel() when $default != null:
return $default(_that.authenticationMode,_that.sipToken,_that.sipUser,_that.sipPassword,_that.callerName,_that.callerNumber,_that.notificationToken);case _:
  return null;

}
}

}

/// @nodoc


class _TelnyxConfigurationRemoteModel extends TelnyxConfigurationRemoteModel {
  const _TelnyxConfigurationRemoteModel({required this.authenticationMode, this.sipToken, this.sipUser, this.sipPassword, required this.callerName, required this.callerNumber, this.notificationToken}): super._();
  

@override final  String authenticationMode;
@override final  String? sipToken;
@override final  String? sipUser;
@override final  String? sipPassword;
@override final  String callerName;
@override final  String callerNumber;
@override final  String? notificationToken;

/// Create a copy of TelnyxConfigurationRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelnyxConfigurationRemoteModelCopyWith<_TelnyxConfigurationRemoteModel> get copyWith => __$TelnyxConfigurationRemoteModelCopyWithImpl<_TelnyxConfigurationRemoteModel>(this, _$identity);







}

/// @nodoc
abstract mixin class _$TelnyxConfigurationRemoteModelCopyWith<$Res> implements $TelnyxConfigurationRemoteModelCopyWith<$Res> {
  factory _$TelnyxConfigurationRemoteModelCopyWith(_TelnyxConfigurationRemoteModel value, $Res Function(_TelnyxConfigurationRemoteModel) _then) = __$TelnyxConfigurationRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String authenticationMode, String? sipToken, String? sipUser, String? sipPassword, String callerName, String callerNumber, String? notificationToken
});




}
/// @nodoc
class __$TelnyxConfigurationRemoteModelCopyWithImpl<$Res>
    implements _$TelnyxConfigurationRemoteModelCopyWith<$Res> {
  __$TelnyxConfigurationRemoteModelCopyWithImpl(this._self, this._then);

  final _TelnyxConfigurationRemoteModel _self;
  final $Res Function(_TelnyxConfigurationRemoteModel) _then;

/// Create a copy of TelnyxConfigurationRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authenticationMode = null,Object? sipToken = freezed,Object? sipUser = freezed,Object? sipPassword = freezed,Object? callerName = null,Object? callerNumber = null,Object? notificationToken = freezed,}) {
  return _then(_TelnyxConfigurationRemoteModel(
authenticationMode: null == authenticationMode ? _self.authenticationMode : authenticationMode // ignore: cast_nullable_to_non_nullable
as String,sipToken: freezed == sipToken ? _self.sipToken : sipToken // ignore: cast_nullable_to_non_nullable
as String?,sipUser: freezed == sipUser ? _self.sipUser : sipUser // ignore: cast_nullable_to_non_nullable
as String?,sipPassword: freezed == sipPassword ? _self.sipPassword : sipPassword // ignore: cast_nullable_to_non_nullable
as String?,callerName: null == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String,callerNumber: null == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String,notificationToken: freezed == notificationToken ? _self.notificationToken : notificationToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
