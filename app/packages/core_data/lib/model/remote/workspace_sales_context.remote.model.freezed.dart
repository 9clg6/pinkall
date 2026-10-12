// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_sales_context.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkspaceSalesContextRemoteModel {

 String get companyName; String get productName; String get pitchMarkdown; int get revision; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of WorkspaceSalesContextRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceSalesContextRemoteModelCopyWith<WorkspaceSalesContextRemoteModel> get copyWith => _$WorkspaceSalesContextRemoteModelCopyWithImpl<WorkspaceSalesContextRemoteModel>(this as WorkspaceSalesContextRemoteModel, _$identity);

  /// Serializes this WorkspaceSalesContextRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceSalesContextRemoteModel&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.pitchMarkdown, pitchMarkdown) || other.pitchMarkdown == pitchMarkdown)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName,productName,pitchMarkdown,revision,createdAt,updatedAt);

@override
String toString() {
  return 'WorkspaceSalesContextRemoteModel(companyName: $companyName, productName: $productName, pitchMarkdown: $pitchMarkdown, revision: $revision, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WorkspaceSalesContextRemoteModelCopyWith<$Res>  {
  factory $WorkspaceSalesContextRemoteModelCopyWith(WorkspaceSalesContextRemoteModel value, $Res Function(WorkspaceSalesContextRemoteModel) _then) = _$WorkspaceSalesContextRemoteModelCopyWithImpl;
@useResult
$Res call({
 String companyName, String productName, String pitchMarkdown, int revision, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$WorkspaceSalesContextRemoteModelCopyWithImpl<$Res>
    implements $WorkspaceSalesContextRemoteModelCopyWith<$Res> {
  _$WorkspaceSalesContextRemoteModelCopyWithImpl(this._self, this._then);

  final WorkspaceSalesContextRemoteModel _self;
  final $Res Function(WorkspaceSalesContextRemoteModel) _then;

/// Create a copy of WorkspaceSalesContextRemoteModel
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


/// Adds pattern-matching-related methods to [WorkspaceSalesContextRemoteModel].
extension WorkspaceSalesContextRemoteModelPatterns on WorkspaceSalesContextRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceSalesContextRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceSalesContextRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceSalesContextRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceSalesContextRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceSalesContextRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceSalesContextRemoteModel() when $default != null:
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
case _WorkspaceSalesContextRemoteModel() when $default != null:
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
case _WorkspaceSalesContextRemoteModel():
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
case _WorkspaceSalesContextRemoteModel() when $default != null:
return $default(_that.companyName,_that.productName,_that.pitchMarkdown,_that.revision,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _WorkspaceSalesContextRemoteModel implements WorkspaceSalesContextRemoteModel {
  const _WorkspaceSalesContextRemoteModel({required this.companyName, required this.productName, required this.pitchMarkdown, required this.revision, required this.createdAt, required this.updatedAt});
  factory _WorkspaceSalesContextRemoteModel.fromJson(Map<String, dynamic> json) => _$WorkspaceSalesContextRemoteModelFromJson(json);

@override final  String companyName;
@override final  String productName;
@override final  String pitchMarkdown;
@override final  int revision;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of WorkspaceSalesContextRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceSalesContextRemoteModelCopyWith<_WorkspaceSalesContextRemoteModel> get copyWith => __$WorkspaceSalesContextRemoteModelCopyWithImpl<_WorkspaceSalesContextRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkspaceSalesContextRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceSalesContextRemoteModel&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.pitchMarkdown, pitchMarkdown) || other.pitchMarkdown == pitchMarkdown)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,companyName,productName,pitchMarkdown,revision,createdAt,updatedAt);

@override
String toString() {
  return 'WorkspaceSalesContextRemoteModel(companyName: $companyName, productName: $productName, pitchMarkdown: $pitchMarkdown, revision: $revision, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceSalesContextRemoteModelCopyWith<$Res> implements $WorkspaceSalesContextRemoteModelCopyWith<$Res> {
  factory _$WorkspaceSalesContextRemoteModelCopyWith(_WorkspaceSalesContextRemoteModel value, $Res Function(_WorkspaceSalesContextRemoteModel) _then) = __$WorkspaceSalesContextRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String companyName, String productName, String pitchMarkdown, int revision, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$WorkspaceSalesContextRemoteModelCopyWithImpl<$Res>
    implements _$WorkspaceSalesContextRemoteModelCopyWith<$Res> {
  __$WorkspaceSalesContextRemoteModelCopyWithImpl(this._self, this._then);

  final _WorkspaceSalesContextRemoteModel _self;
  final $Res Function(_WorkspaceSalesContextRemoteModel) _then;

/// Create a copy of WorkspaceSalesContextRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? companyName = null,Object? productName = null,Object? pitchMarkdown = null,Object? revision = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_WorkspaceSalesContextRemoteModel(
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
