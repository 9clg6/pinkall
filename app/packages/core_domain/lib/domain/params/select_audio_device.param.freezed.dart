// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_audio_device.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SelectAudioDeviceParam {

 String get deviceId; AudioDeviceKind get kind;
/// Create a copy of SelectAudioDeviceParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SelectAudioDeviceParamCopyWith<SelectAudioDeviceParam> get copyWith => _$SelectAudioDeviceParamCopyWithImpl<SelectAudioDeviceParam>(this as SelectAudioDeviceParam, _$identity);

  /// Serializes this SelectAudioDeviceParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectAudioDeviceParam&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,kind);

@override
String toString() {
  return 'SelectAudioDeviceParam(deviceId: $deviceId, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $SelectAudioDeviceParamCopyWith<$Res>  {
  factory $SelectAudioDeviceParamCopyWith(SelectAudioDeviceParam value, $Res Function(SelectAudioDeviceParam) _then) = _$SelectAudioDeviceParamCopyWithImpl;
@useResult
$Res call({
 String deviceId, AudioDeviceKind kind
});




}
/// @nodoc
class _$SelectAudioDeviceParamCopyWithImpl<$Res>
    implements $SelectAudioDeviceParamCopyWith<$Res> {
  _$SelectAudioDeviceParamCopyWithImpl(this._self, this._then);

  final SelectAudioDeviceParam _self;
  final $Res Function(SelectAudioDeviceParam) _then;

/// Create a copy of SelectAudioDeviceParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? kind = null,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AudioDeviceKind,
  ));
}

}


/// Adds pattern-matching-related methods to [SelectAudioDeviceParam].
extension SelectAudioDeviceParamPatterns on SelectAudioDeviceParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SelectAudioDeviceParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SelectAudioDeviceParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SelectAudioDeviceParam value)  $default,){
final _that = this;
switch (_that) {
case _SelectAudioDeviceParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SelectAudioDeviceParam value)?  $default,){
final _that = this;
switch (_that) {
case _SelectAudioDeviceParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  AudioDeviceKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SelectAudioDeviceParam() when $default != null:
return $default(_that.deviceId,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  AudioDeviceKind kind)  $default,) {final _that = this;
switch (_that) {
case _SelectAudioDeviceParam():
return $default(_that.deviceId,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  AudioDeviceKind kind)?  $default,) {final _that = this;
switch (_that) {
case _SelectAudioDeviceParam() when $default != null:
return $default(_that.deviceId,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SelectAudioDeviceParam implements SelectAudioDeviceParam {
  const _SelectAudioDeviceParam({required this.deviceId, required this.kind});
  factory _SelectAudioDeviceParam.fromJson(Map<String, dynamic> json) => _$SelectAudioDeviceParamFromJson(json);

@override final  String deviceId;
@override final  AudioDeviceKind kind;

/// Create a copy of SelectAudioDeviceParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SelectAudioDeviceParamCopyWith<_SelectAudioDeviceParam> get copyWith => __$SelectAudioDeviceParamCopyWithImpl<_SelectAudioDeviceParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SelectAudioDeviceParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SelectAudioDeviceParam&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,kind);

@override
String toString() {
  return 'SelectAudioDeviceParam(deviceId: $deviceId, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$SelectAudioDeviceParamCopyWith<$Res> implements $SelectAudioDeviceParamCopyWith<$Res> {
  factory _$SelectAudioDeviceParamCopyWith(_SelectAudioDeviceParam value, $Res Function(_SelectAudioDeviceParam) _then) = __$SelectAudioDeviceParamCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, AudioDeviceKind kind
});




}
/// @nodoc
class __$SelectAudioDeviceParamCopyWithImpl<$Res>
    implements _$SelectAudioDeviceParamCopyWith<$Res> {
  __$SelectAudioDeviceParamCopyWithImpl(this._self, this._then);

  final _SelectAudioDeviceParam _self;
  final $Res Function(_SelectAudioDeviceParam) _then;

/// Create a copy of SelectAudioDeviceParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? kind = null,}) {
  return _then(_SelectAudioDeviceParam(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as AudioDeviceKind,
  ));
}


}

// dart format on
