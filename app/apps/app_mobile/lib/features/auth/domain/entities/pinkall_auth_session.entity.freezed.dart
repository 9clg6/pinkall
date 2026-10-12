// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pinkall_auth_session.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinkallAuthSessionEntity {

 String get userId; String? get email; bool get isLegacyDevelopmentSession;
/// Create a copy of PinkallAuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinkallAuthSessionEntityCopyWith<PinkallAuthSessionEntity> get copyWith => _$PinkallAuthSessionEntityCopyWithImpl<PinkallAuthSessionEntity>(this as PinkallAuthSessionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinkallAuthSessionEntity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.isLegacyDevelopmentSession, isLegacyDevelopmentSession) || other.isLegacyDevelopmentSession == isLegacyDevelopmentSession));
}


@override
int get hashCode => Object.hash(runtimeType,userId,email,isLegacyDevelopmentSession);

@override
String toString() {
  return 'PinkallAuthSessionEntity(userId: $userId, email: $email, isLegacyDevelopmentSession: $isLegacyDevelopmentSession)';
}


}

/// @nodoc
abstract mixin class $PinkallAuthSessionEntityCopyWith<$Res>  {
  factory $PinkallAuthSessionEntityCopyWith(PinkallAuthSessionEntity value, $Res Function(PinkallAuthSessionEntity) _then) = _$PinkallAuthSessionEntityCopyWithImpl;
@useResult
$Res call({
 String userId, String? email, bool isLegacyDevelopmentSession
});




}
/// @nodoc
class _$PinkallAuthSessionEntityCopyWithImpl<$Res>
    implements $PinkallAuthSessionEntityCopyWith<$Res> {
  _$PinkallAuthSessionEntityCopyWithImpl(this._self, this._then);

  final PinkallAuthSessionEntity _self;
  final $Res Function(PinkallAuthSessionEntity) _then;

/// Create a copy of PinkallAuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? email = freezed,Object? isLegacyDevelopmentSession = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,isLegacyDevelopmentSession: null == isLegacyDevelopmentSession ? _self.isLegacyDevelopmentSession : isLegacyDevelopmentSession // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PinkallAuthSessionEntity].
extension PinkallAuthSessionEntityPatterns on PinkallAuthSessionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinkallAuthSessionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinkallAuthSessionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinkallAuthSessionEntity value)  $default,){
final _that = this;
switch (_that) {
case _PinkallAuthSessionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinkallAuthSessionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PinkallAuthSessionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? email,  bool isLegacyDevelopmentSession)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PinkallAuthSessionEntity() when $default != null:
return $default(_that.userId,_that.email,_that.isLegacyDevelopmentSession);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? email,  bool isLegacyDevelopmentSession)  $default,) {final _that = this;
switch (_that) {
case _PinkallAuthSessionEntity():
return $default(_that.userId,_that.email,_that.isLegacyDevelopmentSession);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? email,  bool isLegacyDevelopmentSession)?  $default,) {final _that = this;
switch (_that) {
case _PinkallAuthSessionEntity() when $default != null:
return $default(_that.userId,_that.email,_that.isLegacyDevelopmentSession);case _:
  return null;

}
}

}

/// @nodoc


class _PinkallAuthSessionEntity implements PinkallAuthSessionEntity {
  const _PinkallAuthSessionEntity({required this.userId, this.email, this.isLegacyDevelopmentSession = false});


@override final  String userId;
@override final  String? email;
@override@JsonKey() final  bool isLegacyDevelopmentSession;

/// Create a copy of PinkallAuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinkallAuthSessionEntityCopyWith<_PinkallAuthSessionEntity> get copyWith => __$PinkallAuthSessionEntityCopyWithImpl<_PinkallAuthSessionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinkallAuthSessionEntity&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.isLegacyDevelopmentSession, isLegacyDevelopmentSession) || other.isLegacyDevelopmentSession == isLegacyDevelopmentSession));
}


@override
int get hashCode => Object.hash(runtimeType,userId,email,isLegacyDevelopmentSession);

@override
String toString() {
  return 'PinkallAuthSessionEntity(userId: $userId, email: $email, isLegacyDevelopmentSession: $isLegacyDevelopmentSession)';
}


}

/// @nodoc
abstract mixin class _$PinkallAuthSessionEntityCopyWith<$Res> implements $PinkallAuthSessionEntityCopyWith<$Res> {
  factory _$PinkallAuthSessionEntityCopyWith(_PinkallAuthSessionEntity value, $Res Function(_PinkallAuthSessionEntity) _then) = __$PinkallAuthSessionEntityCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? email, bool isLegacyDevelopmentSession
});




}
/// @nodoc
class __$PinkallAuthSessionEntityCopyWithImpl<$Res>
    implements _$PinkallAuthSessionEntityCopyWith<$Res> {
  __$PinkallAuthSessionEntityCopyWithImpl(this._self, this._then);

  final _PinkallAuthSessionEntity _self;
  final $Res Function(_PinkallAuthSessionEntity) _then;

/// Create a copy of PinkallAuthSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? email = freezed,Object? isLegacyDevelopmentSession = null,}) {
  return _then(_PinkallAuthSessionEntity(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,isLegacyDevelopmentSession: null == isLegacyDevelopmentSession ? _self.isLegacyDevelopmentSession : isLegacyDevelopmentSession // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
