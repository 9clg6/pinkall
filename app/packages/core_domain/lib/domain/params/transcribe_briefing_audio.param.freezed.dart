// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcribe_briefing_audio.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TranscribeBriefingAudioParam {

/// Signed 16-bit little-endian mono PCM.
 Uint8List get pcmBytes;/// Effective recorder sample rate in Hertz.
 int get sampleRate;
/// Create a copy of TranscribeBriefingAudioParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscribeBriefingAudioParamCopyWith<TranscribeBriefingAudioParam> get copyWith => _$TranscribeBriefingAudioParamCopyWithImpl<TranscribeBriefingAudioParam>(this as TranscribeBriefingAudioParam, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscribeBriefingAudioParam&&const DeepCollectionEquality().equals(other.pcmBytes, pcmBytes)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pcmBytes),sampleRate);

@override
String toString() {
  return 'TranscribeBriefingAudioParam(pcmBytes: $pcmBytes, sampleRate: $sampleRate)';
}


}

/// @nodoc
abstract mixin class $TranscribeBriefingAudioParamCopyWith<$Res>  {
  factory $TranscribeBriefingAudioParamCopyWith(TranscribeBriefingAudioParam value, $Res Function(TranscribeBriefingAudioParam) _then) = _$TranscribeBriefingAudioParamCopyWithImpl;
@useResult
$Res call({
 Uint8List pcmBytes, int sampleRate
});




}
/// @nodoc
class _$TranscribeBriefingAudioParamCopyWithImpl<$Res>
    implements $TranscribeBriefingAudioParamCopyWith<$Res> {
  _$TranscribeBriefingAudioParamCopyWithImpl(this._self, this._then);

  final TranscribeBriefingAudioParam _self;
  final $Res Function(TranscribeBriefingAudioParam) _then;

/// Create a copy of TranscribeBriefingAudioParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pcmBytes = null,Object? sampleRate = null,}) {
  return _then(_self.copyWith(
pcmBytes: null == pcmBytes ? _self.pcmBytes : pcmBytes // ignore: cast_nullable_to_non_nullable
as Uint8List,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscribeBriefingAudioParam].
extension TranscribeBriefingAudioParamPatterns on TranscribeBriefingAudioParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscribeBriefingAudioParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscribeBriefingAudioParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscribeBriefingAudioParam value)  $default,){
final _that = this;
switch (_that) {
case _TranscribeBriefingAudioParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscribeBriefingAudioParam value)?  $default,){
final _that = this;
switch (_that) {
case _TranscribeBriefingAudioParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Uint8List pcmBytes,  int sampleRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscribeBriefingAudioParam() when $default != null:
return $default(_that.pcmBytes,_that.sampleRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Uint8List pcmBytes,  int sampleRate)  $default,) {final _that = this;
switch (_that) {
case _TranscribeBriefingAudioParam():
return $default(_that.pcmBytes,_that.sampleRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Uint8List pcmBytes,  int sampleRate)?  $default,) {final _that = this;
switch (_that) {
case _TranscribeBriefingAudioParam() when $default != null:
return $default(_that.pcmBytes,_that.sampleRate);case _:
  return null;

}
}

}

/// @nodoc


class _TranscribeBriefingAudioParam implements TranscribeBriefingAudioParam {
  const _TranscribeBriefingAudioParam({required this.pcmBytes, required this.sampleRate});
  

/// Signed 16-bit little-endian mono PCM.
@override final  Uint8List pcmBytes;
/// Effective recorder sample rate in Hertz.
@override final  int sampleRate;

/// Create a copy of TranscribeBriefingAudioParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscribeBriefingAudioParamCopyWith<_TranscribeBriefingAudioParam> get copyWith => __$TranscribeBriefingAudioParamCopyWithImpl<_TranscribeBriefingAudioParam>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscribeBriefingAudioParam&&const DeepCollectionEquality().equals(other.pcmBytes, pcmBytes)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(pcmBytes),sampleRate);

@override
String toString() {
  return 'TranscribeBriefingAudioParam(pcmBytes: $pcmBytes, sampleRate: $sampleRate)';
}


}

/// @nodoc
abstract mixin class _$TranscribeBriefingAudioParamCopyWith<$Res> implements $TranscribeBriefingAudioParamCopyWith<$Res> {
  factory _$TranscribeBriefingAudioParamCopyWith(_TranscribeBriefingAudioParam value, $Res Function(_TranscribeBriefingAudioParam) _then) = __$TranscribeBriefingAudioParamCopyWithImpl;
@override @useResult
$Res call({
 Uint8List pcmBytes, int sampleRate
});




}
/// @nodoc
class __$TranscribeBriefingAudioParamCopyWithImpl<$Res>
    implements _$TranscribeBriefingAudioParamCopyWith<$Res> {
  __$TranscribeBriefingAudioParamCopyWithImpl(this._self, this._then);

  final _TranscribeBriefingAudioParam _self;
  final $Res Function(_TranscribeBriefingAudioParam) _then;

/// Create a copy of TranscribeBriefingAudioParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pcmBytes = null,Object? sampleRate = null,}) {
  return _then(_TranscribeBriefingAudioParam(
pcmBytes: null == pcmBytes ? _self.pcmBytes : pcmBytes // ignore: cast_nullable_to_non_nullable
as Uint8List,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
