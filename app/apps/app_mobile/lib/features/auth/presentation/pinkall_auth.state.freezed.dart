// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pinkall_auth.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinkallAuthState {

 bool get isAvailable; bool get canSignOut; bool get isSubmitting; PinkallAuthSessionEntity? get session; PinkallAuthFailureCode? get failureCode;
/// Create a copy of PinkallAuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinkallAuthStateCopyWith<PinkallAuthState> get copyWith => _$PinkallAuthStateCopyWithImpl<PinkallAuthState>(this as PinkallAuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinkallAuthState&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.canSignOut, canSignOut) || other.canSignOut == canSignOut)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.session, session) || other.session == session)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode));
}


@override
int get hashCode => Object.hash(runtimeType,isAvailable,canSignOut,isSubmitting,session,failureCode);

@override
String toString() {
  return 'PinkallAuthState(isAvailable: $isAvailable, canSignOut: $canSignOut, isSubmitting: $isSubmitting, session: $session, failureCode: $failureCode)';
}


}

/// @nodoc
abstract mixin class $PinkallAuthStateCopyWith<$Res>  {
  factory $PinkallAuthStateCopyWith(PinkallAuthState value, $Res Function(PinkallAuthState) _then) = _$PinkallAuthStateCopyWithImpl;
@useResult
$Res call({
 bool isAvailable, bool canSignOut, bool isSubmitting, PinkallAuthSessionEntity? session, PinkallAuthFailureCode? failureCode
});


$PinkallAuthSessionEntityCopyWith<$Res>? get session;

}
/// @nodoc
class _$PinkallAuthStateCopyWithImpl<$Res>
    implements $PinkallAuthStateCopyWith<$Res> {
  _$PinkallAuthStateCopyWithImpl(this._self, this._then);

  final PinkallAuthState _self;
  final $Res Function(PinkallAuthState) _then;

/// Create a copy of PinkallAuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isAvailable = null,Object? canSignOut = null,Object? isSubmitting = null,Object? session = freezed,Object? failureCode = freezed,}) {
  return _then(_self.copyWith(
isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,canSignOut: null == canSignOut ? _self.canSignOut : canSignOut // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PinkallAuthSessionEntity?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as PinkallAuthFailureCode?,
  ));
}
/// Create a copy of PinkallAuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PinkallAuthSessionEntityCopyWith<$Res>? get session {
    if (_self.session == null) {
    return null;
  }

  return $PinkallAuthSessionEntityCopyWith<$Res>(_self.session!, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [PinkallAuthState].
extension PinkallAuthStatePatterns on PinkallAuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinkallAuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinkallAuthState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinkallAuthState value)  $default,){
final _that = this;
switch (_that) {
case _PinkallAuthState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinkallAuthState value)?  $default,){
final _that = this;
switch (_that) {
case _PinkallAuthState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isAvailable,  bool canSignOut,  bool isSubmitting,  PinkallAuthSessionEntity? session,  PinkallAuthFailureCode? failureCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PinkallAuthState() when $default != null:
return $default(_that.isAvailable,_that.canSignOut,_that.isSubmitting,_that.session,_that.failureCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isAvailable,  bool canSignOut,  bool isSubmitting,  PinkallAuthSessionEntity? session,  PinkallAuthFailureCode? failureCode)  $default,) {final _that = this;
switch (_that) {
case _PinkallAuthState():
return $default(_that.isAvailable,_that.canSignOut,_that.isSubmitting,_that.session,_that.failureCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isAvailable,  bool canSignOut,  bool isSubmitting,  PinkallAuthSessionEntity? session,  PinkallAuthFailureCode? failureCode)?  $default,) {final _that = this;
switch (_that) {
case _PinkallAuthState() when $default != null:
return $default(_that.isAvailable,_that.canSignOut,_that.isSubmitting,_that.session,_that.failureCode);case _:
  return null;

}
}

}

/// @nodoc


class _PinkallAuthState implements PinkallAuthState {
  const _PinkallAuthState({required this.isAvailable, required this.canSignOut, required this.isSubmitting, required this.session, this.failureCode});


@override final  bool isAvailable;
@override final  bool canSignOut;
@override final  bool isSubmitting;
@override final  PinkallAuthSessionEntity? session;
@override final  PinkallAuthFailureCode? failureCode;

/// Create a copy of PinkallAuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinkallAuthStateCopyWith<_PinkallAuthState> get copyWith => __$PinkallAuthStateCopyWithImpl<_PinkallAuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinkallAuthState&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.canSignOut, canSignOut) || other.canSignOut == canSignOut)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.session, session) || other.session == session)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode));
}


@override
int get hashCode => Object.hash(runtimeType,isAvailable,canSignOut,isSubmitting,session,failureCode);

@override
String toString() {
  return 'PinkallAuthState(isAvailable: $isAvailable, canSignOut: $canSignOut, isSubmitting: $isSubmitting, session: $session, failureCode: $failureCode)';
}


}

/// @nodoc
abstract mixin class _$PinkallAuthStateCopyWith<$Res> implements $PinkallAuthStateCopyWith<$Res> {
  factory _$PinkallAuthStateCopyWith(_PinkallAuthState value, $Res Function(_PinkallAuthState) _then) = __$PinkallAuthStateCopyWithImpl;
@override @useResult
$Res call({
 bool isAvailable, bool canSignOut, bool isSubmitting, PinkallAuthSessionEntity? session, PinkallAuthFailureCode? failureCode
});


@override $PinkallAuthSessionEntityCopyWith<$Res>? get session;

}
/// @nodoc
class __$PinkallAuthStateCopyWithImpl<$Res>
    implements _$PinkallAuthStateCopyWith<$Res> {
  __$PinkallAuthStateCopyWithImpl(this._self, this._then);

  final _PinkallAuthState _self;
  final $Res Function(_PinkallAuthState) _then;

/// Create a copy of PinkallAuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isAvailable = null,Object? canSignOut = null,Object? isSubmitting = null,Object? session = freezed,Object? failureCode = freezed,}) {
  return _then(_PinkallAuthState(
isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,canSignOut: null == canSignOut ? _self.canSignOut : canSignOut // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,session: freezed == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PinkallAuthSessionEntity?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as PinkallAuthFailureCode?,
  ));
}

/// Create a copy of PinkallAuthState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PinkallAuthSessionEntityCopyWith<$Res>? get session {
    if (_self.session == null) {
    return null;
  }

  return $PinkallAuthSessionEntityCopyWith<$Res>(_self.session!, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

// dart format on
