// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coaching_feedback.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoachingFeedbackRemoteModel {

 String get id; String get sessionId; String get suggestionId; String get value; bool get applied; DateTime get submittedAt; String? get note;
/// Create a copy of CoachingFeedbackRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingFeedbackRemoteModelCopyWith<CoachingFeedbackRemoteModel> get copyWith => _$CoachingFeedbackRemoteModelCopyWithImpl<CoachingFeedbackRemoteModel>(this as CoachingFeedbackRemoteModel, _$identity);

  /// Serializes this CoachingFeedbackRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingFeedbackRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.suggestionId, suggestionId) || other.suggestionId == suggestionId)&&(identical(other.value, value) || other.value == value)&&(identical(other.applied, applied) || other.applied == applied)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,suggestionId,value,applied,submittedAt,note);

@override
String toString() {
  return 'CoachingFeedbackRemoteModel(id: $id, sessionId: $sessionId, suggestionId: $suggestionId, value: $value, applied: $applied, submittedAt: $submittedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class $CoachingFeedbackRemoteModelCopyWith<$Res>  {
  factory $CoachingFeedbackRemoteModelCopyWith(CoachingFeedbackRemoteModel value, $Res Function(CoachingFeedbackRemoteModel) _then) = _$CoachingFeedbackRemoteModelCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, String suggestionId, String value, bool applied, DateTime submittedAt, String? note
});




}
/// @nodoc
class _$CoachingFeedbackRemoteModelCopyWithImpl<$Res>
    implements $CoachingFeedbackRemoteModelCopyWith<$Res> {
  _$CoachingFeedbackRemoteModelCopyWithImpl(this._self, this._then);

  final CoachingFeedbackRemoteModel _self;
  final $Res Function(CoachingFeedbackRemoteModel) _then;

/// Create a copy of CoachingFeedbackRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? suggestionId = null,Object? value = null,Object? applied = null,Object? submittedAt = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,suggestionId: null == suggestionId ? _self.suggestionId : suggestionId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,applied: null == applied ? _self.applied : applied // ignore: cast_nullable_to_non_nullable
as bool,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachingFeedbackRemoteModel].
extension CoachingFeedbackRemoteModelPatterns on CoachingFeedbackRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingFeedbackRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingFeedbackRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingFeedbackRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CoachingFeedbackRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingFeedbackRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingFeedbackRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  String suggestionId,  String value,  bool applied,  DateTime submittedAt,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingFeedbackRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  String suggestionId,  String value,  bool applied,  DateTime submittedAt,  String? note)  $default,) {final _that = this;
switch (_that) {
case _CoachingFeedbackRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  String suggestionId,  String value,  bool applied,  DateTime submittedAt,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _CoachingFeedbackRemoteModel() when $default != null:
return $default(_that.id,_that.sessionId,_that.suggestionId,_that.value,_that.applied,_that.submittedAt,_that.note);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CoachingFeedbackRemoteModel implements CoachingFeedbackRemoteModel {
  const _CoachingFeedbackRemoteModel({required this.id, required this.sessionId, required this.suggestionId, required this.value, required this.applied, required this.submittedAt, this.note});
  factory _CoachingFeedbackRemoteModel.fromJson(Map<String, dynamic> json) => _$CoachingFeedbackRemoteModelFromJson(json);

@override final  String id;
@override final  String sessionId;
@override final  String suggestionId;
@override final  String value;
@override final  bool applied;
@override final  DateTime submittedAt;
@override final  String? note;

/// Create a copy of CoachingFeedbackRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingFeedbackRemoteModelCopyWith<_CoachingFeedbackRemoteModel> get copyWith => __$CoachingFeedbackRemoteModelCopyWithImpl<_CoachingFeedbackRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachingFeedbackRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingFeedbackRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.suggestionId, suggestionId) || other.suggestionId == suggestionId)&&(identical(other.value, value) || other.value == value)&&(identical(other.applied, applied) || other.applied == applied)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,suggestionId,value,applied,submittedAt,note);

@override
String toString() {
  return 'CoachingFeedbackRemoteModel(id: $id, sessionId: $sessionId, suggestionId: $suggestionId, value: $value, applied: $applied, submittedAt: $submittedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CoachingFeedbackRemoteModelCopyWith<$Res> implements $CoachingFeedbackRemoteModelCopyWith<$Res> {
  factory _$CoachingFeedbackRemoteModelCopyWith(_CoachingFeedbackRemoteModel value, $Res Function(_CoachingFeedbackRemoteModel) _then) = __$CoachingFeedbackRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, String suggestionId, String value, bool applied, DateTime submittedAt, String? note
});




}
/// @nodoc
class __$CoachingFeedbackRemoteModelCopyWithImpl<$Res>
    implements _$CoachingFeedbackRemoteModelCopyWith<$Res> {
  __$CoachingFeedbackRemoteModelCopyWithImpl(this._self, this._then);

  final _CoachingFeedbackRemoteModel _self;
  final $Res Function(_CoachingFeedbackRemoteModel) _then;

/// Create a copy of CoachingFeedbackRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? suggestionId = null,Object? value = null,Object? applied = null,Object? submittedAt = null,Object? note = freezed,}) {
  return _then(_CoachingFeedbackRemoteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,suggestionId: null == suggestionId ? _self.suggestionId : suggestionId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,applied: null == applied ? _self.applied : applied // ignore: cast_nullable_to_non_nullable
as bool,submittedAt: null == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
