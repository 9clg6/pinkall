// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_transcription_consent.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecordTranscriptionConsentParam {

 String get sessionId; bool get acknowledged; TranscriptionConsentMethod get method; DateTime get acknowledgedAt;
/// Create a copy of RecordTranscriptionConsentParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordTranscriptionConsentParamCopyWith<RecordTranscriptionConsentParam> get copyWith => _$RecordTranscriptionConsentParamCopyWithImpl<RecordTranscriptionConsentParam>(this as RecordTranscriptionConsentParam, _$identity);

  /// Serializes this RecordTranscriptionConsentParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordTranscriptionConsentParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged)&&(identical(other.method, method) || other.method == method)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,acknowledged,method,acknowledgedAt);

@override
String toString() {
  return 'RecordTranscriptionConsentParam(sessionId: $sessionId, acknowledged: $acknowledged, method: $method, acknowledgedAt: $acknowledgedAt)';
}


}

/// @nodoc
abstract mixin class $RecordTranscriptionConsentParamCopyWith<$Res>  {
  factory $RecordTranscriptionConsentParamCopyWith(RecordTranscriptionConsentParam value, $Res Function(RecordTranscriptionConsentParam) _then) = _$RecordTranscriptionConsentParamCopyWithImpl;
@useResult
$Res call({
 String sessionId, bool acknowledged, TranscriptionConsentMethod method, DateTime acknowledgedAt
});




}
/// @nodoc
class _$RecordTranscriptionConsentParamCopyWithImpl<$Res>
    implements $RecordTranscriptionConsentParamCopyWith<$Res> {
  _$RecordTranscriptionConsentParamCopyWithImpl(this._self, this._then);

  final RecordTranscriptionConsentParam _self;
  final $Res Function(RecordTranscriptionConsentParam) _then;

/// Create a copy of RecordTranscriptionConsentParam
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


/// Adds pattern-matching-related methods to [RecordTranscriptionConsentParam].
extension RecordTranscriptionConsentParamPatterns on RecordTranscriptionConsentParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordTranscriptionConsentParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordTranscriptionConsentParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordTranscriptionConsentParam value)  $default,){
final _that = this;
switch (_that) {
case _RecordTranscriptionConsentParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordTranscriptionConsentParam value)?  $default,){
final _that = this;
switch (_that) {
case _RecordTranscriptionConsentParam() when $default != null:
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
case _RecordTranscriptionConsentParam() when $default != null:
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
case _RecordTranscriptionConsentParam():
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
case _RecordTranscriptionConsentParam() when $default != null:
return $default(_that.sessionId,_that.acknowledged,_that.method,_that.acknowledgedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _RecordTranscriptionConsentParam implements RecordTranscriptionConsentParam {
  const _RecordTranscriptionConsentParam({required this.sessionId, required this.acknowledged, required this.method, required this.acknowledgedAt});
  factory _RecordTranscriptionConsentParam.fromJson(Map<String, dynamic> json) => _$RecordTranscriptionConsentParamFromJson(json);

@override final  String sessionId;
@override final  bool acknowledged;
@override final  TranscriptionConsentMethod method;
@override final  DateTime acknowledgedAt;

/// Create a copy of RecordTranscriptionConsentParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordTranscriptionConsentParamCopyWith<_RecordTranscriptionConsentParam> get copyWith => __$RecordTranscriptionConsentParamCopyWithImpl<_RecordTranscriptionConsentParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecordTranscriptionConsentParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordTranscriptionConsentParam&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged)&&(identical(other.method, method) || other.method == method)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,acknowledged,method,acknowledgedAt);

@override
String toString() {
  return 'RecordTranscriptionConsentParam(sessionId: $sessionId, acknowledged: $acknowledged, method: $method, acknowledgedAt: $acknowledgedAt)';
}


}

/// @nodoc
abstract mixin class _$RecordTranscriptionConsentParamCopyWith<$Res> implements $RecordTranscriptionConsentParamCopyWith<$Res> {
  factory _$RecordTranscriptionConsentParamCopyWith(_RecordTranscriptionConsentParam value, $Res Function(_RecordTranscriptionConsentParam) _then) = __$RecordTranscriptionConsentParamCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, bool acknowledged, TranscriptionConsentMethod method, DateTime acknowledgedAt
});




}
/// @nodoc
class __$RecordTranscriptionConsentParamCopyWithImpl<$Res>
    implements _$RecordTranscriptionConsentParamCopyWith<$Res> {
  __$RecordTranscriptionConsentParamCopyWithImpl(this._self, this._then);

  final _RecordTranscriptionConsentParam _self;
  final $Res Function(_RecordTranscriptionConsentParam) _then;

/// Create a copy of RecordTranscriptionConsentParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? acknowledged = null,Object? method = null,Object? acknowledgedAt = null,}) {
  return _then(_RecordTranscriptionConsentParam(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,acknowledged: null == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as TranscriptionConsentMethod,acknowledgedAt: null == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
