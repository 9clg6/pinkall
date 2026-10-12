// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_call_outcome.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecordCallOutcomeParam {

 String get sessionId; CallOutcomeType get type; String? get note;
/// Create a copy of RecordCallOutcomeParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordCallOutcomeParamCopyWith<RecordCallOutcomeParam> get copyWith => _$RecordCallOutcomeParamCopyWithImpl<RecordCallOutcomeParam>(this as RecordCallOutcomeParam, _$identity);

  /// Serializes this RecordCallOutcomeParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordCallOutcomeParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,type,note);

@override
String toString() {
  return 'RecordCallOutcomeParam(sessionId: $sessionId, type: $type, note: $note)';
}


}

/// @nodoc
abstract mixin class $RecordCallOutcomeParamCopyWith<$Res>  {
  factory $RecordCallOutcomeParamCopyWith(RecordCallOutcomeParam value, $Res Function(RecordCallOutcomeParam) _then) = _$RecordCallOutcomeParamCopyWithImpl;
@useResult
$Res call({
 String sessionId, CallOutcomeType type, String? note
});




}
/// @nodoc
class _$RecordCallOutcomeParamCopyWithImpl<$Res>
    implements $RecordCallOutcomeParamCopyWith<$Res> {
  _$RecordCallOutcomeParamCopyWithImpl(this._self, this._then);

  final RecordCallOutcomeParam _self;
  final $Res Function(RecordCallOutcomeParam) _then;

/// Create a copy of RecordCallOutcomeParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? type = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CallOutcomeType,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordCallOutcomeParam].
extension RecordCallOutcomeParamPatterns on RecordCallOutcomeParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordCallOutcomeParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordCallOutcomeParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordCallOutcomeParam value)  $default,){
final _that = this;
switch (_that) {
case _RecordCallOutcomeParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordCallOutcomeParam value)?  $default,){
final _that = this;
switch (_that) {
case _RecordCallOutcomeParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  CallOutcomeType type,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordCallOutcomeParam() when $default != null:
return $default(_that.sessionId,_that.type,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  CallOutcomeType type,  String? note)  $default,) {final _that = this;
switch (_that) {
case _RecordCallOutcomeParam():
return $default(_that.sessionId,_that.type,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  CallOutcomeType type,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _RecordCallOutcomeParam() when $default != null:
return $default(_that.sessionId,_that.type,_that.note);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _RecordCallOutcomeParam implements RecordCallOutcomeParam {
  const _RecordCallOutcomeParam({required this.sessionId, required this.type, this.note});
  factory _RecordCallOutcomeParam.fromJson(Map<String, dynamic> json) => _$RecordCallOutcomeParamFromJson(json);

@override final  String sessionId;
@override final  CallOutcomeType type;
@override final  String? note;

/// Create a copy of RecordCallOutcomeParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordCallOutcomeParamCopyWith<_RecordCallOutcomeParam> get copyWith => __$RecordCallOutcomeParamCopyWithImpl<_RecordCallOutcomeParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecordCallOutcomeParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordCallOutcomeParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,type,note);

@override
String toString() {
  return 'RecordCallOutcomeParam(sessionId: $sessionId, type: $type, note: $note)';
}


}

/// @nodoc
abstract mixin class _$RecordCallOutcomeParamCopyWith<$Res> implements $RecordCallOutcomeParamCopyWith<$Res> {
  factory _$RecordCallOutcomeParamCopyWith(_RecordCallOutcomeParam value, $Res Function(_RecordCallOutcomeParam) _then) = __$RecordCallOutcomeParamCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, CallOutcomeType type, String? note
});




}
/// @nodoc
class __$RecordCallOutcomeParamCopyWithImpl<$Res>
    implements _$RecordCallOutcomeParamCopyWith<$Res> {
  __$RecordCallOutcomeParamCopyWithImpl(this._self, this._then);

  final _RecordCallOutcomeParam _self;
  final $Res Function(_RecordCallOutcomeParam) _then;

/// Create a copy of RecordCallOutcomeParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? type = null,Object? note = freezed,}) {
  return _then(_RecordCallOutcomeParam(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CallOutcomeType,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
