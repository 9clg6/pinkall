// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcription_consent.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TranscriptionConsentEntity {

 String get sessionId; bool get acknowledged; TranscriptionConsentMethod get method; DateTime get acknowledgedAt;
/// Create a copy of TranscriptionConsentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptionConsentEntityCopyWith<TranscriptionConsentEntity> get copyWith => _$TranscriptionConsentEntityCopyWithImpl<TranscriptionConsentEntity>(this as TranscriptionConsentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptionConsentEntity&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged)&&(identical(other.method, method) || other.method == method)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,acknowledged,method,acknowledgedAt);

@override
String toString() {
  return 'TranscriptionConsentEntity(sessionId: $sessionId, acknowledged: $acknowledged, method: $method, acknowledgedAt: $acknowledgedAt)';
}


}

/// @nodoc
abstract mixin class $TranscriptionConsentEntityCopyWith<$Res>  {
  factory $TranscriptionConsentEntityCopyWith(TranscriptionConsentEntity value, $Res Function(TranscriptionConsentEntity) _then) = _$TranscriptionConsentEntityCopyWithImpl;
@useResult
$Res call({
 String sessionId, bool acknowledged, TranscriptionConsentMethod method, DateTime acknowledgedAt
});




}
/// @nodoc
class _$TranscriptionConsentEntityCopyWithImpl<$Res>
    implements $TranscriptionConsentEntityCopyWith<$Res> {
  _$TranscriptionConsentEntityCopyWithImpl(this._self, this._then);

  final TranscriptionConsentEntity _self;
  final $Res Function(TranscriptionConsentEntity) _then;

/// Create a copy of TranscriptionConsentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? acknowledged = null,Object? method = null,Object? acknowledgedAt = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,acknowledged: null == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as TranscriptionConsentMethod,acknowledgedAt: null == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptionConsentEntity].
extension TranscriptionConsentEntityPatterns on TranscriptionConsentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptionConsentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptionConsentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptionConsentEntity value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptionConsentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptionConsentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptionConsentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  bool acknowledged,  TranscriptionConsentMethod method,  DateTime acknowledgedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptionConsentEntity() when $default != null:
return $default(_that.sessionId,_that.acknowledged,_that.method,_that.acknowledgedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  bool acknowledged,  TranscriptionConsentMethod method,  DateTime acknowledgedAt)  $default,) {final _that = this;
switch (_that) {
case _TranscriptionConsentEntity():
return $default(_that.sessionId,_that.acknowledged,_that.method,_that.acknowledgedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  bool acknowledged,  TranscriptionConsentMethod method,  DateTime acknowledgedAt)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptionConsentEntity() when $default != null:
return $default(_that.sessionId,_that.acknowledged,_that.method,_that.acknowledgedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TranscriptionConsentEntity implements TranscriptionConsentEntity {
  const _TranscriptionConsentEntity({required this.sessionId, required this.acknowledged, required this.method, required this.acknowledgedAt});
  

@override final  String sessionId;
@override final  bool acknowledged;
@override final  TranscriptionConsentMethod method;
@override final  DateTime acknowledgedAt;

/// Create a copy of TranscriptionConsentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptionConsentEntityCopyWith<_TranscriptionConsentEntity> get copyWith => __$TranscriptionConsentEntityCopyWithImpl<_TranscriptionConsentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptionConsentEntity&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged)&&(identical(other.method, method) || other.method == method)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,acknowledged,method,acknowledgedAt);

@override
String toString() {
  return 'TranscriptionConsentEntity(sessionId: $sessionId, acknowledged: $acknowledged, method: $method, acknowledgedAt: $acknowledgedAt)';
}


}

/// @nodoc
abstract mixin class _$TranscriptionConsentEntityCopyWith<$Res> implements $TranscriptionConsentEntityCopyWith<$Res> {
  factory _$TranscriptionConsentEntityCopyWith(_TranscriptionConsentEntity value, $Res Function(_TranscriptionConsentEntity) _then) = __$TranscriptionConsentEntityCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, bool acknowledged, TranscriptionConsentMethod method, DateTime acknowledgedAt
});




}
/// @nodoc
class __$TranscriptionConsentEntityCopyWithImpl<$Res>
    implements _$TranscriptionConsentEntityCopyWith<$Res> {
  __$TranscriptionConsentEntityCopyWithImpl(this._self, this._then);

  final _TranscriptionConsentEntity _self;
  final $Res Function(_TranscriptionConsentEntity) _then;

/// Create a copy of TranscriptionConsentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? acknowledged = null,Object? method = null,Object? acknowledgedAt = null,}) {
  return _then(_TranscriptionConsentEntity(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,acknowledged: null == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as TranscriptionConsentMethod,acknowledgedAt: null == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
