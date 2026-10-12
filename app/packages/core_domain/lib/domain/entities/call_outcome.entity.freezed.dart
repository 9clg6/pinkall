// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_outcome.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallOutcomeEntity {

 String get sessionId; CallOutcomeType get type; DateTime get recordedAt; String? get note;
/// Create a copy of CallOutcomeEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallOutcomeEntityCopyWith<CallOutcomeEntity> get copyWith => _$CallOutcomeEntityCopyWithImpl<CallOutcomeEntity>(this as CallOutcomeEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallOutcomeEntity&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,type,recordedAt,note);

@override
String toString() {
  return 'CallOutcomeEntity(sessionId: $sessionId, type: $type, recordedAt: $recordedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class $CallOutcomeEntityCopyWith<$Res>  {
  factory $CallOutcomeEntityCopyWith(CallOutcomeEntity value, $Res Function(CallOutcomeEntity) _then) = _$CallOutcomeEntityCopyWithImpl;
@useResult
$Res call({
 String sessionId, CallOutcomeType type, DateTime recordedAt, String? note
});




}
/// @nodoc
class _$CallOutcomeEntityCopyWithImpl<$Res>
    implements $CallOutcomeEntityCopyWith<$Res> {
  _$CallOutcomeEntityCopyWithImpl(this._self, this._then);

  final CallOutcomeEntity _self;
  final $Res Function(CallOutcomeEntity) _then;

/// Create a copy of CallOutcomeEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? type = null,Object? recordedAt = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CallOutcomeType,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallOutcomeEntity].
extension CallOutcomeEntityPatterns on CallOutcomeEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallOutcomeEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallOutcomeEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallOutcomeEntity value)  $default,){
final _that = this;
switch (_that) {
case _CallOutcomeEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallOutcomeEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CallOutcomeEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  CallOutcomeType type,  DateTime recordedAt,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallOutcomeEntity() when $default != null:
return $default(_that.sessionId,_that.type,_that.recordedAt,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  CallOutcomeType type,  DateTime recordedAt,  String? note)  $default,) {final _that = this;
switch (_that) {
case _CallOutcomeEntity():
return $default(_that.sessionId,_that.type,_that.recordedAt,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  CallOutcomeType type,  DateTime recordedAt,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _CallOutcomeEntity() when $default != null:
return $default(_that.sessionId,_that.type,_that.recordedAt,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _CallOutcomeEntity implements CallOutcomeEntity {
  const _CallOutcomeEntity({required this.sessionId, required this.type, required this.recordedAt, this.note});
  

@override final  String sessionId;
@override final  CallOutcomeType type;
@override final  DateTime recordedAt;
@override final  String? note;

/// Create a copy of CallOutcomeEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallOutcomeEntityCopyWith<_CallOutcomeEntity> get copyWith => __$CallOutcomeEntityCopyWithImpl<_CallOutcomeEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallOutcomeEntity&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,type,recordedAt,note);

@override
String toString() {
  return 'CallOutcomeEntity(sessionId: $sessionId, type: $type, recordedAt: $recordedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CallOutcomeEntityCopyWith<$Res> implements $CallOutcomeEntityCopyWith<$Res> {
  factory _$CallOutcomeEntityCopyWith(_CallOutcomeEntity value, $Res Function(_CallOutcomeEntity) _then) = __$CallOutcomeEntityCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, CallOutcomeType type, DateTime recordedAt, String? note
});




}
/// @nodoc
class __$CallOutcomeEntityCopyWithImpl<$Res>
    implements _$CallOutcomeEntityCopyWith<$Res> {
  __$CallOutcomeEntityCopyWithImpl(this._self, this._then);

  final _CallOutcomeEntity _self;
  final $Res Function(_CallOutcomeEntity) _then;

/// Create a copy of CallOutcomeEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? type = null,Object? recordedAt = null,Object? note = freezed,}) {
  return _then(_CallOutcomeEntity(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CallOutcomeType,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
