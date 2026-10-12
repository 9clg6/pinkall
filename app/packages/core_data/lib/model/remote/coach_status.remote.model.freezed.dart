// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach_status.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoachStatusRemoteModel {

 String get status; String? get outcome;
/// Create a copy of CoachStatusRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachStatusRemoteModelCopyWith<CoachStatusRemoteModel> get copyWith => _$CoachStatusRemoteModelCopyWithImpl<CoachStatusRemoteModel>(this as CoachStatusRemoteModel, _$identity);

  /// Serializes this CoachStatusRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachStatusRemoteModel&&(identical(other.status, status) || other.status == status)&&(identical(other.outcome, outcome) || other.outcome == outcome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,outcome);

@override
String toString() {
  return 'CoachStatusRemoteModel(status: $status, outcome: $outcome)';
}


}

/// @nodoc
abstract mixin class $CoachStatusRemoteModelCopyWith<$Res>  {
  factory $CoachStatusRemoteModelCopyWith(CoachStatusRemoteModel value, $Res Function(CoachStatusRemoteModel) _then) = _$CoachStatusRemoteModelCopyWithImpl;
@useResult
$Res call({
 String status, String? outcome
});




}
/// @nodoc
class _$CoachStatusRemoteModelCopyWithImpl<$Res>
    implements $CoachStatusRemoteModelCopyWith<$Res> {
  _$CoachStatusRemoteModelCopyWithImpl(this._self, this._then);

  final CoachStatusRemoteModel _self;
  final $Res Function(CoachStatusRemoteModel) _then;

/// Create a copy of CoachStatusRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? outcome = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachStatusRemoteModel].
extension CoachStatusRemoteModelPatterns on CoachStatusRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachStatusRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachStatusRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachStatusRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CoachStatusRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachStatusRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CoachStatusRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  String? outcome)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachStatusRemoteModel() when $default != null:
return $default(_that.status,_that.outcome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  String? outcome)  $default,) {final _that = this;
switch (_that) {
case _CoachStatusRemoteModel():
return $default(_that.status,_that.outcome);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  String? outcome)?  $default,) {final _that = this;
switch (_that) {
case _CoachStatusRemoteModel() when $default != null:
return $default(_that.status,_that.outcome);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CoachStatusRemoteModel implements CoachStatusRemoteModel {
  const _CoachStatusRemoteModel({required this.status, this.outcome});
  factory _CoachStatusRemoteModel.fromJson(Map<String, dynamic> json) => _$CoachStatusRemoteModelFromJson(json);

@override final  String status;
@override final  String? outcome;

/// Create a copy of CoachStatusRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachStatusRemoteModelCopyWith<_CoachStatusRemoteModel> get copyWith => __$CoachStatusRemoteModelCopyWithImpl<_CoachStatusRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachStatusRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachStatusRemoteModel&&(identical(other.status, status) || other.status == status)&&(identical(other.outcome, outcome) || other.outcome == outcome));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,outcome);

@override
String toString() {
  return 'CoachStatusRemoteModel(status: $status, outcome: $outcome)';
}


}

/// @nodoc
abstract mixin class _$CoachStatusRemoteModelCopyWith<$Res> implements $CoachStatusRemoteModelCopyWith<$Res> {
  factory _$CoachStatusRemoteModelCopyWith(_CoachStatusRemoteModel value, $Res Function(_CoachStatusRemoteModel) _then) = __$CoachStatusRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String status, String? outcome
});




}
/// @nodoc
class __$CoachStatusRemoteModelCopyWithImpl<$Res>
    implements _$CoachStatusRemoteModelCopyWith<$Res> {
  __$CoachStatusRemoteModelCopyWithImpl(this._self, this._then);

  final _CoachStatusRemoteModel _self;
  final $Res Function(_CoachStatusRemoteModel) _then;

/// Create a copy of CoachStatusRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? outcome = freezed,}) {
  return _then(_CoachStatusRemoteModel(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
