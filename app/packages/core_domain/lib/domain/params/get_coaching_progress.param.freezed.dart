// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_coaching_progress.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetCoachingProgressParam {

 int get windowSize; int get recentLimit;
/// Create a copy of GetCoachingProgressParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetCoachingProgressParamCopyWith<GetCoachingProgressParam> get copyWith => _$GetCoachingProgressParamCopyWithImpl<GetCoachingProgressParam>(this as GetCoachingProgressParam, _$identity);

  /// Serializes this GetCoachingProgressParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetCoachingProgressParam&&(identical(other.windowSize, windowSize) || other.windowSize == windowSize)&&(identical(other.recentLimit, recentLimit) || other.recentLimit == recentLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,windowSize,recentLimit);

@override
String toString() {
  return 'GetCoachingProgressParam(windowSize: $windowSize, recentLimit: $recentLimit)';
}


}

/// @nodoc
abstract mixin class $GetCoachingProgressParamCopyWith<$Res>  {
  factory $GetCoachingProgressParamCopyWith(GetCoachingProgressParam value, $Res Function(GetCoachingProgressParam) _then) = _$GetCoachingProgressParamCopyWithImpl;
@useResult
$Res call({
 int windowSize, int recentLimit
});




}
/// @nodoc
class _$GetCoachingProgressParamCopyWithImpl<$Res>
    implements $GetCoachingProgressParamCopyWith<$Res> {
  _$GetCoachingProgressParamCopyWithImpl(this._self, this._then);

  final GetCoachingProgressParam _self;
  final $Res Function(GetCoachingProgressParam) _then;

/// Create a copy of GetCoachingProgressParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? windowSize = null,Object? recentLimit = null,}) {
  return _then(_self.copyWith(
windowSize: null == windowSize ? _self.windowSize : windowSize // ignore: cast_nullable_to_non_nullable
as int,recentLimit: null == recentLimit ? _self.recentLimit : recentLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GetCoachingProgressParam].
extension GetCoachingProgressParamPatterns on GetCoachingProgressParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetCoachingProgressParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetCoachingProgressParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetCoachingProgressParam value)  $default,){
final _that = this;
switch (_that) {
case _GetCoachingProgressParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetCoachingProgressParam value)?  $default,){
final _that = this;
switch (_that) {
case _GetCoachingProgressParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int windowSize,  int recentLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetCoachingProgressParam() when $default != null:
return $default(_that.windowSize,_that.recentLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int windowSize,  int recentLimit)  $default,) {final _that = this;
switch (_that) {
case _GetCoachingProgressParam():
return $default(_that.windowSize,_that.recentLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int windowSize,  int recentLimit)?  $default,) {final _that = this;
switch (_that) {
case _GetCoachingProgressParam() when $default != null:
return $default(_that.windowSize,_that.recentLimit);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _GetCoachingProgressParam implements GetCoachingProgressParam {
  const _GetCoachingProgressParam({this.windowSize = 5, this.recentLimit = 20});
  factory _GetCoachingProgressParam.fromJson(Map<String, dynamic> json) => _$GetCoachingProgressParamFromJson(json);

@override@JsonKey() final  int windowSize;
@override@JsonKey() final  int recentLimit;

/// Create a copy of GetCoachingProgressParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetCoachingProgressParamCopyWith<_GetCoachingProgressParam> get copyWith => __$GetCoachingProgressParamCopyWithImpl<_GetCoachingProgressParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetCoachingProgressParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetCoachingProgressParam&&(identical(other.windowSize, windowSize) || other.windowSize == windowSize)&&(identical(other.recentLimit, recentLimit) || other.recentLimit == recentLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,windowSize,recentLimit);

@override
String toString() {
  return 'GetCoachingProgressParam(windowSize: $windowSize, recentLimit: $recentLimit)';
}


}

/// @nodoc
abstract mixin class _$GetCoachingProgressParamCopyWith<$Res> implements $GetCoachingProgressParamCopyWith<$Res> {
  factory _$GetCoachingProgressParamCopyWith(_GetCoachingProgressParam value, $Res Function(_GetCoachingProgressParam) _then) = __$GetCoachingProgressParamCopyWithImpl;
@override @useResult
$Res call({
 int windowSize, int recentLimit
});




}
/// @nodoc
class __$GetCoachingProgressParamCopyWithImpl<$Res>
    implements _$GetCoachingProgressParamCopyWith<$Res> {
  __$GetCoachingProgressParamCopyWithImpl(this._self, this._then);

  final _GetCoachingProgressParam _self;
  final $Res Function(_GetCoachingProgressParam) _then;

/// Create a copy of GetCoachingProgressParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? windowSize = null,Object? recentLimit = null,}) {
  return _then(_GetCoachingProgressParam(
windowSize: null == windowSize ? _self.windowSize : windowSize // ignore: cast_nullable_to_non_nullable
as int,recentLimit: null == recentLimit ? _self.recentLimit : recentLimit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
