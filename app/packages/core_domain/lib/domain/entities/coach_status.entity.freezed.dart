// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_status.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoachStatusEntity {

 CoachAnalysisStatus get status; CoachAnalysisOutcome? get outcome;
/// Create a copy of CoachStatusEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachStatusEntityCopyWith<CoachStatusEntity> get copyWith => _$CoachStatusEntityCopyWithImpl<CoachStatusEntity>(this as CoachStatusEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachStatusEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.outcome, outcome) || other.outcome == outcome));
}


@override
int get hashCode => Object.hash(runtimeType,status,outcome);

@override
String toString() {
  return 'CoachStatusEntity(status: $status, outcome: $outcome)';
}


}

/// @nodoc
abstract mixin class $CoachStatusEntityCopyWith<$Res>  {
  factory $CoachStatusEntityCopyWith(CoachStatusEntity value, $Res Function(CoachStatusEntity) _then) = _$CoachStatusEntityCopyWithImpl;
@useResult
$Res call({
 CoachAnalysisStatus status, CoachAnalysisOutcome? outcome
});




}
/// @nodoc
class _$CoachStatusEntityCopyWithImpl<$Res>
    implements $CoachStatusEntityCopyWith<$Res> {
  _$CoachStatusEntityCopyWithImpl(this._self, this._then);

  final CoachStatusEntity _self;
  final $Res Function(CoachStatusEntity) _then;

/// Create a copy of CoachStatusEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? outcome = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CoachAnalysisStatus,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as CoachAnalysisOutcome?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachStatusEntity].
extension CoachStatusEntityPatterns on CoachStatusEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachStatusEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachStatusEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachStatusEntity value)  $default,){
final _that = this;
switch (_that) {
case _CoachStatusEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachStatusEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CoachStatusEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoachAnalysisStatus status,  CoachAnalysisOutcome? outcome)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachStatusEntity() when $default != null:
return $default(_that.status,_that.outcome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoachAnalysisStatus status,  CoachAnalysisOutcome? outcome)  $default,) {final _that = this;
switch (_that) {
case _CoachStatusEntity():
return $default(_that.status,_that.outcome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoachAnalysisStatus status,  CoachAnalysisOutcome? outcome)?  $default,) {final _that = this;
switch (_that) {
case _CoachStatusEntity() when $default != null:
return $default(_that.status,_that.outcome);case _:
  return null;

}
}

}

/// @nodoc


class _CoachStatusEntity implements CoachStatusEntity {
  const _CoachStatusEntity({required this.status, this.outcome});
  

@override final  CoachAnalysisStatus status;
@override final  CoachAnalysisOutcome? outcome;

/// Create a copy of CoachStatusEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachStatusEntityCopyWith<_CoachStatusEntity> get copyWith => __$CoachStatusEntityCopyWithImpl<_CoachStatusEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachStatusEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.outcome, outcome) || other.outcome == outcome));
}


@override
int get hashCode => Object.hash(runtimeType,status,outcome);

@override
String toString() {
  return 'CoachStatusEntity(status: $status, outcome: $outcome)';
}


}

/// @nodoc
abstract mixin class _$CoachStatusEntityCopyWith<$Res> implements $CoachStatusEntityCopyWith<$Res> {
  factory _$CoachStatusEntityCopyWith(_CoachStatusEntity value, $Res Function(_CoachStatusEntity) _then) = __$CoachStatusEntityCopyWithImpl;
@override @useResult
$Res call({
 CoachAnalysisStatus status, CoachAnalysisOutcome? outcome
});




}
/// @nodoc
class __$CoachStatusEntityCopyWithImpl<$Res>
    implements _$CoachStatusEntityCopyWith<$Res> {
  __$CoachStatusEntityCopyWithImpl(this._self, this._then);

  final _CoachStatusEntity _self;
  final $Res Function(_CoachStatusEntity) _then;

/// Create a copy of CoachStatusEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? outcome = freezed,}) {
  return _then(_CoachStatusEntity(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CoachAnalysisStatus,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as CoachAnalysisOutcome?,
  ));
}


}

// dart format on
