// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_outcome.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallOutcomeRemoteModel {

 String get sessionId; String get type; DateTime get recordedAt; String? get note;
/// Create a copy of CallOutcomeRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallOutcomeRemoteModelCopyWith<CallOutcomeRemoteModel> get copyWith => _$CallOutcomeRemoteModelCopyWithImpl<CallOutcomeRemoteModel>(this as CallOutcomeRemoteModel, _$identity);

  /// Serializes this CallOutcomeRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallOutcomeRemoteModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,type,recordedAt,note);

@override
String toString() {
  return 'CallOutcomeRemoteModel(sessionId: $sessionId, type: $type, recordedAt: $recordedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class $CallOutcomeRemoteModelCopyWith<$Res>  {
  factory $CallOutcomeRemoteModelCopyWith(CallOutcomeRemoteModel value, $Res Function(CallOutcomeRemoteModel) _then) = _$CallOutcomeRemoteModelCopyWithImpl;
@useResult
$Res call({
 String sessionId, String type, DateTime recordedAt, String? note
});




}
/// @nodoc
class _$CallOutcomeRemoteModelCopyWithImpl<$Res>
    implements $CallOutcomeRemoteModelCopyWith<$Res> {
  _$CallOutcomeRemoteModelCopyWithImpl(this._self, this._then);

  final CallOutcomeRemoteModel _self;
  final $Res Function(CallOutcomeRemoteModel) _then;

/// Create a copy of CallOutcomeRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? type = null,Object? recordedAt = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallOutcomeRemoteModel].
extension CallOutcomeRemoteModelPatterns on CallOutcomeRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallOutcomeRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallOutcomeRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallOutcomeRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CallOutcomeRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallOutcomeRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CallOutcomeRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String type,  DateTime recordedAt,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallOutcomeRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String type,  DateTime recordedAt,  String? note)  $default,) {final _that = this;
switch (_that) {
case _CallOutcomeRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String type,  DateTime recordedAt,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _CallOutcomeRemoteModel() when $default != null:
return $default(_that.sessionId,_that.type,_that.recordedAt,_that.note);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CallOutcomeRemoteModel implements CallOutcomeRemoteModel {
  const _CallOutcomeRemoteModel({required this.sessionId, required this.type, required this.recordedAt, this.note});
  factory _CallOutcomeRemoteModel.fromJson(Map<String, dynamic> json) => _$CallOutcomeRemoteModelFromJson(json);

@override final  String sessionId;
@override final  String type;
@override final  DateTime recordedAt;
@override final  String? note;

/// Create a copy of CallOutcomeRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallOutcomeRemoteModelCopyWith<_CallOutcomeRemoteModel> get copyWith => __$CallOutcomeRemoteModelCopyWithImpl<_CallOutcomeRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallOutcomeRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallOutcomeRemoteModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,type,recordedAt,note);

@override
String toString() {
  return 'CallOutcomeRemoteModel(sessionId: $sessionId, type: $type, recordedAt: $recordedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class _$CallOutcomeRemoteModelCopyWith<$Res> implements $CallOutcomeRemoteModelCopyWith<$Res> {
  factory _$CallOutcomeRemoteModelCopyWith(_CallOutcomeRemoteModel value, $Res Function(_CallOutcomeRemoteModel) _then) = __$CallOutcomeRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String type, DateTime recordedAt, String? note
});




}
/// @nodoc
class __$CallOutcomeRemoteModelCopyWithImpl<$Res>
    implements _$CallOutcomeRemoteModelCopyWith<$Res> {
  __$CallOutcomeRemoteModelCopyWithImpl(this._self, this._then);

  final _CallOutcomeRemoteModel _self;
  final $Res Function(_CallOutcomeRemoteModel) _then;

/// Create a copy of CallOutcomeRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? type = null,Object? recordedAt = null,Object? note = freezed,}) {
  return _then(_CallOutcomeRemoteModel(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
