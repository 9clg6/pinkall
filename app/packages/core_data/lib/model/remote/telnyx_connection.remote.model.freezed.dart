// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telnyx_connection.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TelnyxConnectionRemoteModel {

 String get status; String? get failureReason;
/// Create a copy of TelnyxConnectionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelnyxConnectionRemoteModelCopyWith<TelnyxConnectionRemoteModel> get copyWith => _$TelnyxConnectionRemoteModelCopyWithImpl<TelnyxConnectionRemoteModel>(this as TelnyxConnectionRemoteModel, _$identity);

  /// Serializes this TelnyxConnectionRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelnyxConnectionRemoteModel&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,failureReason);

@override
String toString() {
  return 'TelnyxConnectionRemoteModel(status: $status, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class $TelnyxConnectionRemoteModelCopyWith<$Res>  {
  factory $TelnyxConnectionRemoteModelCopyWith(TelnyxConnectionRemoteModel value, $Res Function(TelnyxConnectionRemoteModel) _then) = _$TelnyxConnectionRemoteModelCopyWithImpl;
@useResult
$Res call({
 String status, String? failureReason
});




}
/// @nodoc
class _$TelnyxConnectionRemoteModelCopyWithImpl<$Res>
    implements $TelnyxConnectionRemoteModelCopyWith<$Res> {
  _$TelnyxConnectionRemoteModelCopyWithImpl(this._self, this._then);

  final TelnyxConnectionRemoteModel _self;
  final $Res Function(TelnyxConnectionRemoteModel) _then;

/// Create a copy of TelnyxConnectionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? failureReason = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TelnyxConnectionRemoteModel].
extension TelnyxConnectionRemoteModelPatterns on TelnyxConnectionRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelnyxConnectionRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelnyxConnectionRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelnyxConnectionRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _TelnyxConnectionRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelnyxConnectionRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _TelnyxConnectionRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? failureReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelnyxConnectionRemoteModel() when $default != null:
return $default(_that.status,_that.failureReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? failureReason)  $default,) {final _that = this;
switch (_that) {
case _TelnyxConnectionRemoteModel():
return $default(_that.status,_that.failureReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? failureReason)?  $default,) {final _that = this;
switch (_that) {
case _TelnyxConnectionRemoteModel() when $default != null:
return $default(_that.status,_that.failureReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TelnyxConnectionRemoteModel implements TelnyxConnectionRemoteModel {
  const _TelnyxConnectionRemoteModel({required this.status, this.failureReason});
  factory _TelnyxConnectionRemoteModel.fromJson(Map<String, dynamic> json) => _$TelnyxConnectionRemoteModelFromJson(json);

@override final  String status;
@override final  String? failureReason;

/// Create a copy of TelnyxConnectionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelnyxConnectionRemoteModelCopyWith<_TelnyxConnectionRemoteModel> get copyWith => __$TelnyxConnectionRemoteModelCopyWithImpl<_TelnyxConnectionRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TelnyxConnectionRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TelnyxConnectionRemoteModel&&(identical(other.status, status) || other.status == status)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,failureReason);

@override
String toString() {
  return 'TelnyxConnectionRemoteModel(status: $status, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class _$TelnyxConnectionRemoteModelCopyWith<$Res> implements $TelnyxConnectionRemoteModelCopyWith<$Res> {
  factory _$TelnyxConnectionRemoteModelCopyWith(_TelnyxConnectionRemoteModel value, $Res Function(_TelnyxConnectionRemoteModel) _then) = __$TelnyxConnectionRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String status, String? failureReason
});




}
/// @nodoc
class __$TelnyxConnectionRemoteModelCopyWithImpl<$Res>
    implements _$TelnyxConnectionRemoteModelCopyWith<$Res> {
  __$TelnyxConnectionRemoteModelCopyWithImpl(this._self, this._then);

  final _TelnyxConnectionRemoteModel _self;
  final $Res Function(_TelnyxConnectionRemoteModel) _then;

/// Create a copy of TelnyxConnectionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? failureReason = freezed,}) {
  return _then(_TelnyxConnectionRemoteModel(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
