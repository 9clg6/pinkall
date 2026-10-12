// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_sales_context.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkspaceSalesContextEntity {

 String get companyName; String get productName; String get pitchMarkdown; int get revision; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of WorkspaceSalesContextEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceSalesContextEntityCopyWith<WorkspaceSalesContextEntity> get copyWith => _$WorkspaceSalesContextEntityCopyWithImpl<WorkspaceSalesContextEntity>(this as WorkspaceSalesContextEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceSalesContextEntity&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.pitchMarkdown, pitchMarkdown) || other.pitchMarkdown == pitchMarkdown)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,companyName,productName,pitchMarkdown,revision,createdAt,updatedAt);

@override
String toString() {
  return 'WorkspaceSalesContextEntity(companyName: $companyName, productName: $productName, pitchMarkdown: $pitchMarkdown, revision: $revision, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WorkspaceSalesContextEntityCopyWith<$Res>  {
  factory $WorkspaceSalesContextEntityCopyWith(WorkspaceSalesContextEntity value, $Res Function(WorkspaceSalesContextEntity) _then) = _$WorkspaceSalesContextEntityCopyWithImpl;
@useResult
$Res call({
 String companyName, String productName, String pitchMarkdown, int revision, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$WorkspaceSalesContextEntityCopyWithImpl<$Res>
    implements $WorkspaceSalesContextEntityCopyWith<$Res> {
  _$WorkspaceSalesContextEntityCopyWithImpl(this._self, this._then);

  final WorkspaceSalesContextEntity _self;
  final $Res Function(WorkspaceSalesContextEntity) _then;

/// Create a copy of WorkspaceSalesContextEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? companyName = null,Object? productName = null,Object? pitchMarkdown = null,Object? revision = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,pitchMarkdown: null == pitchMarkdown ? _self.pitchMarkdown : pitchMarkdown // ignore: cast_nullable_to_non_nullable
as String,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkspaceSalesContextEntity].
extension WorkspaceSalesContextEntityPatterns on WorkspaceSalesContextEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceSalesContextEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceSalesContextEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceSalesContextEntity value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceSalesContextEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceSalesContextEntity value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceSalesContextEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String companyName,  String productName,  String pitchMarkdown,  int revision,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceSalesContextEntity() when $default != null:
return $default(_that.companyName,_that.productName,_that.pitchMarkdown,_that.revision,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String companyName,  String productName,  String pitchMarkdown,  int revision,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceSalesContextEntity():
return $default(_that.companyName,_that.productName,_that.pitchMarkdown,_that.revision,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String companyName,  String productName,  String pitchMarkdown,  int revision,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceSalesContextEntity() when $default != null:
return $default(_that.companyName,_that.productName,_that.pitchMarkdown,_that.revision,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _WorkspaceSalesContextEntity implements WorkspaceSalesContextEntity {
  const _WorkspaceSalesContextEntity({required this.companyName, required this.productName, required this.pitchMarkdown, required this.revision, required this.createdAt, required this.updatedAt});
  

@override final  String companyName;
@override final  String productName;
@override final  String pitchMarkdown;
@override final  int revision;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of WorkspaceSalesContextEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceSalesContextEntityCopyWith<_WorkspaceSalesContextEntity> get copyWith => __$WorkspaceSalesContextEntityCopyWithImpl<_WorkspaceSalesContextEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceSalesContextEntity&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.pitchMarkdown, pitchMarkdown) || other.pitchMarkdown == pitchMarkdown)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,companyName,productName,pitchMarkdown,revision,createdAt,updatedAt);

@override
String toString() {
  return 'WorkspaceSalesContextEntity(companyName: $companyName, productName: $productName, pitchMarkdown: $pitchMarkdown, revision: $revision, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceSalesContextEntityCopyWith<$Res> implements $WorkspaceSalesContextEntityCopyWith<$Res> {
  factory _$WorkspaceSalesContextEntityCopyWith(_WorkspaceSalesContextEntity value, $Res Function(_WorkspaceSalesContextEntity) _then) = __$WorkspaceSalesContextEntityCopyWithImpl;
@override @useResult
$Res call({
 String companyName, String productName, String pitchMarkdown, int revision, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$WorkspaceSalesContextEntityCopyWithImpl<$Res>
    implements _$WorkspaceSalesContextEntityCopyWith<$Res> {
  __$WorkspaceSalesContextEntityCopyWithImpl(this._self, this._then);

  final _WorkspaceSalesContextEntity _self;
  final $Res Function(_WorkspaceSalesContextEntity) _then;

/// Create a copy of WorkspaceSalesContextEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = null,Object? productName = null,Object? pitchMarkdown = null,Object? revision = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_WorkspaceSalesContextEntity(
companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,pitchMarkdown: null == pitchMarkdown ? _self.pitchMarkdown : pitchMarkdown // ignore: cast_nullable_to_non_nullable
as String,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
