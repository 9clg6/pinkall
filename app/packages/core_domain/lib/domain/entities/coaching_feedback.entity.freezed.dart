// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coaching_feedback.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoachingFeedbackEntity {

 String get id; String get sessionId; String get suggestionId; SuggestionFeedbackValue get value; bool get applied; DateTime get submittedAt; String? get note;
/// Create a copy of CoachingFeedbackEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingFeedbackEntityCopyWith<CoachingFeedbackEntity> get copyWith => _$CoachingFeedbackEntityCopyWithImpl<CoachingFeedbackEntity>(this as CoachingFeedbackEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingFeedbackEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.suggestionId, suggestionId) || other.suggestionId == suggestionId)&&(identical(other.value, value) || other.value == value)&&(identical(other.applied, applied) || other.applied == applied)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,suggestionId,value,applied,submittedAt,note);

@override
String toString() {
  return 'CoachingFeedbackEntity(id: $id, sessionId: $sessionId, suggestionId: $suggestionId, value: $value, applied: $applied, submittedAt: $submittedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class $CoachingFeedbackEntityCopyWith<$Res>  {
  factory $CoachingFeedbackEntityCopyWith(CoachingFeedbackEntity value, $Res Function(CoachingFeedbackEntity) _then) = _$CoachingFeedbackEntityCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, String suggestionId, SuggestionFeedbackValue value, bool applied, DateTime submittedAt, String? note
});




}
/// @nodoc
class _$CoachingFeedbackEntityCopyWithImpl<$Res>
    implements $CoachingFeedbackEntityCopyWith<$Res> {
  _$CoachingFeedbackEntityCopyWithImpl(this._self, this._then);

  final CoachingFeedbackEntity _self;
  final $Res Function(CoachingFeedbackEntity) _then;

/// Create a copy of CoachingFeedbackEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? suggestionId = null,Object? value = null,Object? applied = null,Object? submittedAt = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,suggestionId: null == suggestionId ? _self.suggestionId : suggestionId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as SuggestionFeedbackValue,applied: null == applied ? _self.applied : applied // ignore: cast_nullable_to_non_nullable
as bool,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachingFeedbackEntity].
extension CoachingFeedbackEntityPatterns on CoachingFeedbackEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingFeedbackEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingFeedbackEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingFeedbackEntity value)  $default,){
final _that = this;
switch (_that) {
case _CoachingFeedbackEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingFeedbackEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingFeedbackEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  String suggestionId,  SuggestionFeedbackValue value,  bool applied,  DateTime submittedAt,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingFeedbackEntity() when $default != null:
return $default(_that.id,_that.sessionId,_that.suggestionId,_that.value,_that.applied,_that.submittedAt,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  String suggestionId,  SuggestionFeedbackValue value,  bool applied,  DateTime submittedAt,  String? note)  $default,) {final _that = this;
switch (_that) {
case _CoachingFeedbackEntity():
return $default(_that.id,_that.sessionId,_that.suggestionId,_that.value,_that.applied,_that.submittedAt,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  String suggestionId,  SuggestionFeedbackValue value,  bool applied,  DateTime submittedAt,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _CoachingFeedbackEntity() when $default != null:
return $default(_that.id,_that.sessionId,_that.suggestionId,_that.value,_that.applied,_that.submittedAt,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _CoachingFeedbackEntity implements CoachingFeedbackEntity {
  const _CoachingFeedbackEntity({required this.id, required this.sessionId, required this.suggestionId, required this.value, required this.applied, required this.submittedAt, this.note});
  

@override final  String id;
@override final  String sessionId;
@override final  String suggestionId;
@override final  SuggestionFeedbackValue value;
@override final  bool applied;
@override final  DateTime submittedAt;
@override final  String? note;

/// Create a copy of CoachingFeedbackEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingFeedbackEntityCopyWith<_CoachingFeedbackEntity> get copyWith => __$CoachingFeedbackEntityCopyWithImpl<_CoachingFeedbackEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingFeedbackEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.suggestionId, suggestionId) || other.suggestionId == suggestionId)&&(identical(other.value, value) || other.value == value)&&(identical(other.applied, applied) || other.applied == applied)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,suggestionId,value,applied,submittedAt,note);

@override
String toString() {
  return 'CoachingFeedbackEntity(id: $id, sessionId: $sessionId, suggestionId: $suggestionId, value: $value, applied: $applied, submittedAt: $submittedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CoachingFeedbackEntityCopyWith<$Res> implements $CoachingFeedbackEntityCopyWith<$Res> {
  factory _$CoachingFeedbackEntityCopyWith(_CoachingFeedbackEntity value, $Res Function(_CoachingFeedbackEntity) _then) = __$CoachingFeedbackEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, String suggestionId, SuggestionFeedbackValue value, bool applied, DateTime submittedAt, String? note
});




}
/// @nodoc
class __$CoachingFeedbackEntityCopyWithImpl<$Res>
    implements _$CoachingFeedbackEntityCopyWith<$Res> {
  __$CoachingFeedbackEntityCopyWithImpl(this._self, this._then);

  final _CoachingFeedbackEntity _self;
  final $Res Function(_CoachingFeedbackEntity) _then;

/// Create a copy of CoachingFeedbackEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? suggestionId = null,Object? value = null,Object? applied = null,Object? submittedAt = null,Object? note = freezed,}) {
  return _then(_CoachingFeedbackEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,suggestionId: null == suggestionId ? _self.suggestionId : suggestionId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as SuggestionFeedbackValue,applied: null == applied ? _self.applied : applied // ignore: cast_nullable_to_non_nullable
as bool,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
