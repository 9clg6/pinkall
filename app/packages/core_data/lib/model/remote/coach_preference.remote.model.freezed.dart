// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_preference.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoachPreferenceRemoteModel {

 String get defaultMode; DateTime get updatedAt;
/// Create a copy of CoachPreferenceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachPreferenceRemoteModelCopyWith<CoachPreferenceRemoteModel> get copyWith => _$CoachPreferenceRemoteModelCopyWithImpl<CoachPreferenceRemoteModel>(this as CoachPreferenceRemoteModel, _$identity);

  /// Serializes this CoachPreferenceRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachPreferenceRemoteModel&&(identical(other.defaultMode, defaultMode) || other.defaultMode == defaultMode)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultMode,updatedAt);

@override
String toString() {
  return 'CoachPreferenceRemoteModel(defaultMode: $defaultMode, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CoachPreferenceRemoteModelCopyWith<$Res>  {
  factory $CoachPreferenceRemoteModelCopyWith(CoachPreferenceRemoteModel value, $Res Function(CoachPreferenceRemoteModel) _then) = _$CoachPreferenceRemoteModelCopyWithImpl;
@useResult
$Res call({
 String defaultMode, DateTime updatedAt
});




}
/// @nodoc
class _$CoachPreferenceRemoteModelCopyWithImpl<$Res>
    implements $CoachPreferenceRemoteModelCopyWith<$Res> {
  _$CoachPreferenceRemoteModelCopyWithImpl(this._self, this._then);

  final CoachPreferenceRemoteModel _self;
  final $Res Function(CoachPreferenceRemoteModel) _then;

/// Create a copy of CoachPreferenceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? defaultMode = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
defaultMode: null == defaultMode ? _self.defaultMode : defaultMode // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachPreferenceRemoteModel].
extension CoachPreferenceRemoteModelPatterns on CoachPreferenceRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachPreferenceRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachPreferenceRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachPreferenceRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CoachPreferenceRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachPreferenceRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CoachPreferenceRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String defaultMode,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachPreferenceRemoteModel() when $default != null:
return $default(_that.defaultMode,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String defaultMode,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CoachPreferenceRemoteModel():
return $default(_that.defaultMode,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String defaultMode,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CoachPreferenceRemoteModel() when $default != null:
return $default(_that.defaultMode,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CoachPreferenceRemoteModel implements CoachPreferenceRemoteModel {
  const _CoachPreferenceRemoteModel({required this.defaultMode, required this.updatedAt});
  factory _CoachPreferenceRemoteModel.fromJson(Map<String, dynamic> json) => _$CoachPreferenceRemoteModelFromJson(json);

@override final  String defaultMode;
@override final  DateTime updatedAt;

/// Create a copy of CoachPreferenceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachPreferenceRemoteModelCopyWith<_CoachPreferenceRemoteModel> get copyWith => __$CoachPreferenceRemoteModelCopyWithImpl<_CoachPreferenceRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachPreferenceRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachPreferenceRemoteModel&&(identical(other.defaultMode, defaultMode) || other.defaultMode == defaultMode)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,defaultMode,updatedAt);

@override
String toString() {
  return 'CoachPreferenceRemoteModel(defaultMode: $defaultMode, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CoachPreferenceRemoteModelCopyWith<$Res> implements $CoachPreferenceRemoteModelCopyWith<$Res> {
  factory _$CoachPreferenceRemoteModelCopyWith(_CoachPreferenceRemoteModel value, $Res Function(_CoachPreferenceRemoteModel) _then) = __$CoachPreferenceRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String defaultMode, DateTime updatedAt
});




}
/// @nodoc
class __$CoachPreferenceRemoteModelCopyWithImpl<$Res>
    implements _$CoachPreferenceRemoteModelCopyWith<$Res> {
  __$CoachPreferenceRemoteModelCopyWithImpl(this._self, this._then);

  final _CoachPreferenceRemoteModel _self;
  final $Res Function(_CoachPreferenceRemoteModel) _then;

/// Create a copy of CoachPreferenceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? defaultMode = null,Object? updatedAt = null,}) {
  return _then(_CoachPreferenceRemoteModel(
defaultMode: null == defaultMode ? _self.defaultMode : defaultMode // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
