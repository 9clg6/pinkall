// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telnyx_connection_state.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TelnyxConnectionStateEntity {

 TelnyxConnectionStatus get status; String? get failureReason;
/// Create a copy of TelnyxConnectionStateEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelnyxConnectionStateEntityCopyWith<TelnyxConnectionStateEntity> get copyWith => _$TelnyxConnectionStateEntityCopyWithImpl<TelnyxConnectionStateEntity>(this as TelnyxConnectionStateEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelnyxConnectionStateEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}


@override
int get hashCode => Object.hash(runtimeType,status,failureReason);

@override
String toString() {
  return 'TelnyxConnectionStateEntity(status: $status, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class $TelnyxConnectionStateEntityCopyWith<$Res>  {
  factory $TelnyxConnectionStateEntityCopyWith(TelnyxConnectionStateEntity value, $Res Function(TelnyxConnectionStateEntity) _then) = _$TelnyxConnectionStateEntityCopyWithImpl;
@useResult
$Res call({
 TelnyxConnectionStatus status, String? failureReason
});




}
/// @nodoc
class _$TelnyxConnectionStateEntityCopyWithImpl<$Res>
    implements $TelnyxConnectionStateEntityCopyWith<$Res> {
  _$TelnyxConnectionStateEntityCopyWithImpl(this._self, this._then);

  final TelnyxConnectionStateEntity _self;
  final $Res Function(TelnyxConnectionStateEntity) _then;

/// Create a copy of TelnyxConnectionStateEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? failureReason = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TelnyxConnectionStatus,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TelnyxConnectionStateEntity].
extension TelnyxConnectionStateEntityPatterns on TelnyxConnectionStateEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelnyxConnectionStateEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelnyxConnectionStateEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelnyxConnectionStateEntity value)  $default,){
final _that = this;
switch (_that) {
case _TelnyxConnectionStateEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelnyxConnectionStateEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TelnyxConnectionStateEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TelnyxConnectionStatus status,  String? failureReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelnyxConnectionStateEntity() when $default != null:
return $default(_that.status,_that.failureReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TelnyxConnectionStatus status,  String? failureReason)  $default,) {final _that = this;
switch (_that) {
case _TelnyxConnectionStateEntity():
return $default(_that.status,_that.failureReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TelnyxConnectionStatus status,  String? failureReason)?  $default,) {final _that = this;
switch (_that) {
case _TelnyxConnectionStateEntity() when $default != null:
return $default(_that.status,_that.failureReason);case _:
  return null;

}
}

}

/// @nodoc


class _TelnyxConnectionStateEntity implements TelnyxConnectionStateEntity {
  const _TelnyxConnectionStateEntity({required this.status, this.failureReason});
  

@override final  TelnyxConnectionStatus status;
@override final  String? failureReason;

/// Create a copy of TelnyxConnectionStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelnyxConnectionStateEntityCopyWith<_TelnyxConnectionStateEntity> get copyWith => __$TelnyxConnectionStateEntityCopyWithImpl<_TelnyxConnectionStateEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TelnyxConnectionStateEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}


@override
int get hashCode => Object.hash(runtimeType,status,failureReason);

@override
String toString() {
  return 'TelnyxConnectionStateEntity(status: $status, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class _$TelnyxConnectionStateEntityCopyWith<$Res> implements $TelnyxConnectionStateEntityCopyWith<$Res> {
  factory _$TelnyxConnectionStateEntityCopyWith(_TelnyxConnectionStateEntity value, $Res Function(_TelnyxConnectionStateEntity) _then) = __$TelnyxConnectionStateEntityCopyWithImpl;
@override @useResult
$Res call({
 TelnyxConnectionStatus status, String? failureReason
});




}
/// @nodoc
class __$TelnyxConnectionStateEntityCopyWithImpl<$Res>
    implements _$TelnyxConnectionStateEntityCopyWith<$Res> {
  __$TelnyxConnectionStateEntityCopyWithImpl(this._self, this._then);

  final _TelnyxConnectionStateEntity _self;
  final $Res Function(_TelnyxConnectionStateEntity) _then;

/// Create a copy of TelnyxConnectionStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? failureReason = freezed,}) {
  return _then(_TelnyxConnectionStateEntity(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TelnyxConnectionStatus,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
