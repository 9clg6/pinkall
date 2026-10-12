// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upsert_workspace_sales_context.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpsertWorkspaceSalesContextParam {

 String get companyName; String get productName; String get pitchMarkdown; int? get expectedRevision;
/// Create a copy of UpsertWorkspaceSalesContextParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpsertWorkspaceSalesContextParamCopyWith<UpsertWorkspaceSalesContextParam> get copyWith => _$UpsertWorkspaceSalesContextParamCopyWithImpl<UpsertWorkspaceSalesContextParam>(this as UpsertWorkspaceSalesContextParam, _$identity);

  /// Serializes this UpsertWorkspaceSalesContextParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpsertWorkspaceSalesContextParam&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.pitchMarkdown, pitchMarkdown) || other.pitchMarkdown == pitchMarkdown)&&(identical(other.expectedRevision, expectedRevision) || other.expectedRevision == expectedRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName,productName,pitchMarkdown,expectedRevision);

@override
String toString() {
  return 'UpsertWorkspaceSalesContextParam(companyName: $companyName, productName: $productName, pitchMarkdown: $pitchMarkdown, expectedRevision: $expectedRevision)';
}


}

/// @nodoc
abstract mixin class $UpsertWorkspaceSalesContextParamCopyWith<$Res>  {
  factory $UpsertWorkspaceSalesContextParamCopyWith(UpsertWorkspaceSalesContextParam value, $Res Function(UpsertWorkspaceSalesContextParam) _then) = _$UpsertWorkspaceSalesContextParamCopyWithImpl;
@useResult
$Res call({
 String companyName, String productName, String pitchMarkdown, int? expectedRevision
});




}
/// @nodoc
class _$UpsertWorkspaceSalesContextParamCopyWithImpl<$Res>
    implements $UpsertWorkspaceSalesContextParamCopyWith<$Res> {
  _$UpsertWorkspaceSalesContextParamCopyWithImpl(this._self, this._then);

  final UpsertWorkspaceSalesContextParam _self;
  final $Res Function(UpsertWorkspaceSalesContextParam) _then;

/// Create a copy of UpsertWorkspaceSalesContextParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = null,Object? productName = null,Object? pitchMarkdown = null,Object? expectedRevision = freezed,}) {
  return _then(_self.copyWith(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,pitchMarkdown: null == pitchMarkdown ? _self.pitchMarkdown : pitchMarkdown // ignore: cast_nullable_to_non_nullable
as String,expectedRevision: freezed == expectedRevision ? _self.expectedRevision : expectedRevision // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpsertWorkspaceSalesContextParam].
extension UpsertWorkspaceSalesContextParamPatterns on UpsertWorkspaceSalesContextParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpsertWorkspaceSalesContextParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpsertWorkspaceSalesContextParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpsertWorkspaceSalesContextParam value)  $default,){
final _that = this;
switch (_that) {
case _UpsertWorkspaceSalesContextParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpsertWorkspaceSalesContextParam value)?  $default,){
final _that = this;
switch (_that) {
case _UpsertWorkspaceSalesContextParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String companyName,  String productName,  String pitchMarkdown,  int? expectedRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpsertWorkspaceSalesContextParam() when $default != null:
return $default(_that.companyName,_that.productName,_that.pitchMarkdown,_that.expectedRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String companyName,  String productName,  String pitchMarkdown,  int? expectedRevision)  $default,) {final _that = this;
switch (_that) {
case _UpsertWorkspaceSalesContextParam():
return $default(_that.companyName,_that.productName,_that.pitchMarkdown,_that.expectedRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String companyName,  String productName,  String pitchMarkdown,  int? expectedRevision)?  $default,) {final _that = this;
switch (_that) {
case _UpsertWorkspaceSalesContextParam() when $default != null:
return $default(_that.companyName,_that.productName,_that.pitchMarkdown,_that.expectedRevision);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UpsertWorkspaceSalesContextParam implements UpsertWorkspaceSalesContextParam {
  const _UpsertWorkspaceSalesContextParam({required this.companyName, required this.productName, required this.pitchMarkdown, this.expectedRevision});
  factory _UpsertWorkspaceSalesContextParam.fromJson(Map<String, dynamic> json) => _$UpsertWorkspaceSalesContextParamFromJson(json);

@override final  String companyName;
@override final  String productName;
@override final  String pitchMarkdown;
@override final  int? expectedRevision;

/// Create a copy of UpsertWorkspaceSalesContextParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpsertWorkspaceSalesContextParamCopyWith<_UpsertWorkspaceSalesContextParam> get copyWith => __$UpsertWorkspaceSalesContextParamCopyWithImpl<_UpsertWorkspaceSalesContextParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpsertWorkspaceSalesContextParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpsertWorkspaceSalesContextParam&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.pitchMarkdown, pitchMarkdown) || other.pitchMarkdown == pitchMarkdown)&&(identical(other.expectedRevision, expectedRevision) || other.expectedRevision == expectedRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName,productName,pitchMarkdown,expectedRevision);

@override
String toString() {
  return 'UpsertWorkspaceSalesContextParam(companyName: $companyName, productName: $productName, pitchMarkdown: $pitchMarkdown, expectedRevision: $expectedRevision)';
}


}

/// @nodoc
abstract mixin class _$UpsertWorkspaceSalesContextParamCopyWith<$Res> implements $UpsertWorkspaceSalesContextParamCopyWith<$Res> {
  factory _$UpsertWorkspaceSalesContextParamCopyWith(_UpsertWorkspaceSalesContextParam value, $Res Function(_UpsertWorkspaceSalesContextParam) _then) = __$UpsertWorkspaceSalesContextParamCopyWithImpl;
@override @useResult
$Res call({
 String companyName, String productName, String pitchMarkdown, int? expectedRevision
});




}
/// @nodoc
class __$UpsertWorkspaceSalesContextParamCopyWithImpl<$Res>
    implements _$UpsertWorkspaceSalesContextParamCopyWith<$Res> {
  __$UpsertWorkspaceSalesContextParamCopyWithImpl(this._self, this._then);

  final _UpsertWorkspaceSalesContextParam _self;
  final $Res Function(_UpsertWorkspaceSalesContextParam) _then;

/// Create a copy of UpsertWorkspaceSalesContextParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = null,Object? productName = null,Object? pitchMarkdown = null,Object? expectedRevision = freezed,}) {
  return _then(_UpsertWorkspaceSalesContextParam(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,pitchMarkdown: null == pitchMarkdown ? _self.pitchMarkdown : pitchMarkdown // ignore: cast_nullable_to_non_nullable
as String,expectedRevision: freezed == expectedRevision ? _self.expectedRevision : expectedRevision // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
