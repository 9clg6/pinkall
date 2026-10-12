// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcription_consent.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TranscriptionConsentRemoteModel {

 String get sessionId; bool get acknowledged; String get method; DateTime get acknowledgedAt;
/// Create a copy of TranscriptionConsentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptionConsentRemoteModelCopyWith<TranscriptionConsentRemoteModel> get copyWith => _$TranscriptionConsentRemoteModelCopyWithImpl<TranscriptionConsentRemoteModel>(this as TranscriptionConsentRemoteModel, _$identity);

  /// Serializes this TranscriptionConsentRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptionConsentRemoteModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged)&&(identical(other.method, method) || other.method == method)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,acknowledged,method,acknowledgedAt);

@override
String toString() {
  return 'TranscriptionConsentRemoteModel(sessionId: $sessionId, acknowledged: $acknowledged, method: $method, acknowledgedAt: $acknowledgedAt)';
}


}

/// @nodoc
abstract mixin class $TranscriptionConsentRemoteModelCopyWith<$Res>  {
  factory $TranscriptionConsentRemoteModelCopyWith(TranscriptionConsentRemoteModel value, $Res Function(TranscriptionConsentRemoteModel) _then) = _$TranscriptionConsentRemoteModelCopyWithImpl;
@useResult
$Res call({
 String sessionId, bool acknowledged, String method, DateTime acknowledgedAt
});




}
/// @nodoc
class _$TranscriptionConsentRemoteModelCopyWithImpl<$Res>
    implements $TranscriptionConsentRemoteModelCopyWith<$Res> {
  _$TranscriptionConsentRemoteModelCopyWithImpl(this._self, this._then);

  final TranscriptionConsentRemoteModel _self;
  final $Res Function(TranscriptionConsentRemoteModel) _then;

/// Create a copy of TranscriptionConsentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? acknowledged = null,Object? method = null,Object? acknowledgedAt = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,acknowledged: null == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,acknowledgedAt: null == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptionConsentRemoteModel].
extension TranscriptionConsentRemoteModelPatterns on TranscriptionConsentRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptionConsentRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptionConsentRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptionConsentRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptionConsentRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptionConsentRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptionConsentRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  bool acknowledged,  String method,  DateTime acknowledgedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptionConsentRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  bool acknowledged,  String method,  DateTime acknowledgedAt)  $default,) {final _that = this;
switch (_that) {
case _TranscriptionConsentRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  bool acknowledged,  String method,  DateTime acknowledgedAt)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptionConsentRemoteModel() when $default != null:
return $default(_that.sessionId,_that.acknowledged,_that.method,_that.acknowledgedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TranscriptionConsentRemoteModel implements TranscriptionConsentRemoteModel {
  const _TranscriptionConsentRemoteModel({required this.sessionId, required this.acknowledged, required this.method, required this.acknowledgedAt});
  factory _TranscriptionConsentRemoteModel.fromJson(Map<String, dynamic> json) => _$TranscriptionConsentRemoteModelFromJson(json);

@override final  String sessionId;
@override final  bool acknowledged;
@override final  String method;
@override final  DateTime acknowledgedAt;

/// Create a copy of TranscriptionConsentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptionConsentRemoteModelCopyWith<_TranscriptionConsentRemoteModel> get copyWith => __$TranscriptionConsentRemoteModelCopyWithImpl<_TranscriptionConsentRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranscriptionConsentRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptionConsentRemoteModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.acknowledged, acknowledged) || other.acknowledged == acknowledged)&&(identical(other.method, method) || other.method == method)&&(identical(other.acknowledgedAt, acknowledgedAt) || other.acknowledgedAt == acknowledgedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,acknowledged,method,acknowledgedAt);

@override
String toString() {
  return 'TranscriptionConsentRemoteModel(sessionId: $sessionId, acknowledged: $acknowledged, method: $method, acknowledgedAt: $acknowledgedAt)';
}


}

/// @nodoc
abstract mixin class _$TranscriptionConsentRemoteModelCopyWith<$Res> implements $TranscriptionConsentRemoteModelCopyWith<$Res> {
  factory _$TranscriptionConsentRemoteModelCopyWith(_TranscriptionConsentRemoteModel value, $Res Function(_TranscriptionConsentRemoteModel) _then) = __$TranscriptionConsentRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, bool acknowledged, String method, DateTime acknowledgedAt
});




}
/// @nodoc
class __$TranscriptionConsentRemoteModelCopyWithImpl<$Res>
    implements _$TranscriptionConsentRemoteModelCopyWith<$Res> {
  __$TranscriptionConsentRemoteModelCopyWithImpl(this._self, this._then);

  final _TranscriptionConsentRemoteModel _self;
  final $Res Function(_TranscriptionConsentRemoteModel) _then;

/// Create a copy of TranscriptionConsentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? acknowledged = null,Object? method = null,Object? acknowledgedAt = null,}) {
  return _then(_TranscriptionConsentRemoteModel(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,acknowledged: null == acknowledged ? _self.acknowledged : acknowledged // ignore: cast_nullable_to_non_nullable
as bool,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,acknowledgedAt: null == acknowledgedAt ? _self.acknowledgedAt : acknowledgedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
