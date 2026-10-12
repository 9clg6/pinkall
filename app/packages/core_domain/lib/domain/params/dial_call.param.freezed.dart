// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dial_call.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DialCallParam {

 String get destinationNumber; String get clientState; Map<String, String> get customHeaders;
/// Create a copy of DialCallParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DialCallParamCopyWith<DialCallParam> get copyWith => _$DialCallParamCopyWithImpl<DialCallParam>(this as DialCallParam, _$identity);

  /// Serializes this DialCallParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DialCallParam&&(identical(other.destinationNumber, destinationNumber) || other.destinationNumber == destinationNumber)&&(identical(other.clientState, clientState) || other.clientState == clientState)&&const DeepCollectionEquality().equals(other.customHeaders, customHeaders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,destinationNumber,clientState,const DeepCollectionEquality().hash(customHeaders));

@override
String toString() {
  return 'DialCallParam(destinationNumber: $destinationNumber, clientState: $clientState, customHeaders: $customHeaders)';
}


}

/// @nodoc
abstract mixin class $DialCallParamCopyWith<$Res>  {
  factory $DialCallParamCopyWith(DialCallParam value, $Res Function(DialCallParam) _then) = _$DialCallParamCopyWithImpl;
@useResult
$Res call({
 String destinationNumber, String clientState, Map<String, String> customHeaders
});




}
/// @nodoc
class _$DialCallParamCopyWithImpl<$Res>
    implements $DialCallParamCopyWith<$Res> {
  _$DialCallParamCopyWithImpl(this._self, this._then);

  final DialCallParam _self;
  final $Res Function(DialCallParam) _then;

/// Create a copy of DialCallParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? destinationNumber = null,Object? clientState = null,Object? customHeaders = null,}) {
  return _then(_self.copyWith(
destinationNumber: null == destinationNumber ? _self.destinationNumber : destinationNumber // ignore: cast_nullable_to_non_nullable
as String,clientState: null == clientState ? _self.clientState : clientState // ignore: cast_nullable_to_non_nullable
as String,customHeaders: null == customHeaders ? _self.customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DialCallParam].
extension DialCallParamPatterns on DialCallParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DialCallParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DialCallParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DialCallParam value)  $default,){
final _that = this;
switch (_that) {
case _DialCallParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DialCallParam value)?  $default,){
final _that = this;
switch (_that) {
case _DialCallParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String destinationNumber,  String clientState,  Map<String, String> customHeaders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DialCallParam() when $default != null:
return $default(_that.destinationNumber,_that.clientState,_that.customHeaders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String destinationNumber,  String clientState,  Map<String, String> customHeaders)  $default,) {final _that = this;
switch (_that) {
case _DialCallParam():
return $default(_that.destinationNumber,_that.clientState,_that.customHeaders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String destinationNumber,  String clientState,  Map<String, String> customHeaders)?  $default,) {final _that = this;
switch (_that) {
case _DialCallParam() when $default != null:
return $default(_that.destinationNumber,_that.clientState,_that.customHeaders);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DialCallParam implements DialCallParam {
  const _DialCallParam({required this.destinationNumber, this.clientState = '', final  Map<String, String> customHeaders = const <String, String>{}}): _customHeaders = customHeaders;
  factory _DialCallParam.fromJson(Map<String, dynamic> json) => _$DialCallParamFromJson(json);

@override final  String destinationNumber;
@override@JsonKey() final  String clientState;
 final  Map<String, String> _customHeaders;
@override@JsonKey() Map<String, String> get customHeaders {
  if (_customHeaders is EqualUnmodifiableMapView) return _customHeaders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_customHeaders);
}


/// Create a copy of DialCallParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DialCallParamCopyWith<_DialCallParam> get copyWith => __$DialCallParamCopyWithImpl<_DialCallParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DialCallParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DialCallParam&&(identical(other.destinationNumber, destinationNumber) || other.destinationNumber == destinationNumber)&&(identical(other.clientState, clientState) || other.clientState == clientState)&&const DeepCollectionEquality().equals(other._customHeaders, _customHeaders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,destinationNumber,clientState,const DeepCollectionEquality().hash(_customHeaders));

@override
String toString() {
  return 'DialCallParam(destinationNumber: $destinationNumber, clientState: $clientState, customHeaders: $customHeaders)';
}


}

/// @nodoc
abstract mixin class _$DialCallParamCopyWith<$Res> implements $DialCallParamCopyWith<$Res> {
  factory _$DialCallParamCopyWith(_DialCallParam value, $Res Function(_DialCallParam) _then) = __$DialCallParamCopyWithImpl;
@override @useResult
$Res call({
 String destinationNumber, String clientState, Map<String, String> customHeaders
});




}
/// @nodoc
class __$DialCallParamCopyWithImpl<$Res>
    implements _$DialCallParamCopyWith<$Res> {
  __$DialCallParamCopyWithImpl(this._self, this._then);

  final _DialCallParam _self;
  final $Res Function(_DialCallParam) _then;

/// Create a copy of DialCallParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? destinationNumber = null,Object? clientState = null,Object? customHeaders = null,}) {
  return _then(_DialCallParam(
destinationNumber: null == destinationNumber ? _self.destinationNumber : destinationNumber // ignore: cast_nullable_to_non_nullable
as String,clientState: null == clientState ? _self.clientState : clientState // ignore: cast_nullable_to_non_nullable
as String,customHeaders: null == customHeaders ? _self._customHeaders : customHeaders // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
