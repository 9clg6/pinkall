// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submit_coaching_feedback.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmitCoachingFeedbackParam {

 String get sessionId; String get suggestionId; SuggestionFeedbackValue get value; bool get applied; String? get note;
/// Create a copy of SubmitCoachingFeedbackParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitCoachingFeedbackParamCopyWith<SubmitCoachingFeedbackParam> get copyWith => _$SubmitCoachingFeedbackParamCopyWithImpl<SubmitCoachingFeedbackParam>(this as SubmitCoachingFeedbackParam, _$identity);

  /// Serializes this SubmitCoachingFeedbackParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitCoachingFeedbackParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.suggestionId, suggestionId) || other.suggestionId == suggestionId)&&(identical(other.value, value) || other.value == value)&&(identical(other.applied, applied) || other.applied == applied)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,suggestionId,value,applied,note);

@override
String toString() {
  return 'SubmitCoachingFeedbackParam(sessionId: $sessionId, suggestionId: $suggestionId, value: $value, applied: $applied, note: $note)';
}


}

/// @nodoc
abstract mixin class $SubmitCoachingFeedbackParamCopyWith<$Res>  {
  factory $SubmitCoachingFeedbackParamCopyWith(SubmitCoachingFeedbackParam value, $Res Function(SubmitCoachingFeedbackParam) _then) = _$SubmitCoachingFeedbackParamCopyWithImpl;
@useResult
$Res call({
 String sessionId, String suggestionId, SuggestionFeedbackValue value, bool applied, String? note
});




}
/// @nodoc
class _$SubmitCoachingFeedbackParamCopyWithImpl<$Res>
    implements $SubmitCoachingFeedbackParamCopyWith<$Res> {
  _$SubmitCoachingFeedbackParamCopyWithImpl(this._self, this._then);

  final SubmitCoachingFeedbackParam _self;
  final $Res Function(SubmitCoachingFeedbackParam) _then;

/// Create a copy of SubmitCoachingFeedbackParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? suggestionId = null,Object? value = null,Object? applied = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,suggestionId: null == suggestionId ? _self.suggestionId : suggestionId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as SuggestionFeedbackValue,applied: null == applied ? _self.applied : applied // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubmitCoachingFeedbackParam].
extension SubmitCoachingFeedbackParamPatterns on SubmitCoachingFeedbackParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmitCoachingFeedbackParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmitCoachingFeedbackParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmitCoachingFeedbackParam value)  $default,){
final _that = this;
switch (_that) {
case _SubmitCoachingFeedbackParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmitCoachingFeedbackParam value)?  $default,){
final _that = this;
switch (_that) {
case _SubmitCoachingFeedbackParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String suggestionId,  SuggestionFeedbackValue value,  bool applied,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmitCoachingFeedbackParam() when $default != null:
return $default(_that.sessionId,_that.suggestionId,_that.value,_that.applied,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String suggestionId,  SuggestionFeedbackValue value,  bool applied,  String? note)  $default,) {final _that = this;
switch (_that) {
case _SubmitCoachingFeedbackParam():
return $default(_that.sessionId,_that.suggestionId,_that.value,_that.applied,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String suggestionId,  SuggestionFeedbackValue value,  bool applied,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _SubmitCoachingFeedbackParam() when $default != null:
return $default(_that.sessionId,_that.suggestionId,_that.value,_that.applied,_that.note);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _SubmitCoachingFeedbackParam implements SubmitCoachingFeedbackParam {
  const _SubmitCoachingFeedbackParam({required this.sessionId, required this.suggestionId, required this.value, this.applied = false, this.note});
  factory _SubmitCoachingFeedbackParam.fromJson(Map<String, dynamic> json) => _$SubmitCoachingFeedbackParamFromJson(json);

@override final  String sessionId;
@override final  String suggestionId;
@override final  SuggestionFeedbackValue value;
@override@JsonKey() final  bool applied;
@override final  String? note;

/// Create a copy of SubmitCoachingFeedbackParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitCoachingFeedbackParamCopyWith<_SubmitCoachingFeedbackParam> get copyWith => __$SubmitCoachingFeedbackParamCopyWithImpl<_SubmitCoachingFeedbackParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmitCoachingFeedbackParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitCoachingFeedbackParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.suggestionId, suggestionId) || other.suggestionId == suggestionId)&&(identical(other.value, value) || other.value == value)&&(identical(other.applied, applied) || other.applied == applied)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,suggestionId,value,applied,note);

@override
String toString() {
  return 'SubmitCoachingFeedbackParam(sessionId: $sessionId, suggestionId: $suggestionId, value: $value, applied: $applied, note: $note)';
}


}

/// @nodoc
abstract mixin class _$SubmitCoachingFeedbackParamCopyWith<$Res> implements $SubmitCoachingFeedbackParamCopyWith<$Res> {
  factory _$SubmitCoachingFeedbackParamCopyWith(_SubmitCoachingFeedbackParam value, $Res Function(_SubmitCoachingFeedbackParam) _then) = __$SubmitCoachingFeedbackParamCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String suggestionId, SuggestionFeedbackValue value, bool applied, String? note
});




}
/// @nodoc
class __$SubmitCoachingFeedbackParamCopyWithImpl<$Res>
    implements _$SubmitCoachingFeedbackParamCopyWith<$Res> {
  __$SubmitCoachingFeedbackParamCopyWithImpl(this._self, this._then);

  final _SubmitCoachingFeedbackParam _self;
  final $Res Function(_SubmitCoachingFeedbackParam) _then;

/// Create a copy of SubmitCoachingFeedbackParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? suggestionId = null,Object? value = null,Object? applied = null,Object? note = freezed,}) {
  return _then(_SubmitCoachingFeedbackParam(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,suggestionId: null == suggestionId ? _self.suggestionId : suggestionId // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as SuggestionFeedbackValue,applied: null == applied ? _self.applied : applied // ignore: cast_nullable_to_non_nullable
as bool,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
