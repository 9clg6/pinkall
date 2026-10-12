// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_import_result.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactImportResultRemoteModel {

 String get importId; int get importedCount; int get skippedCount; List<String> get errors;
/// Create a copy of ContactImportResultRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactImportResultRemoteModelCopyWith<ContactImportResultRemoteModel> get copyWith => _$ContactImportResultRemoteModelCopyWithImpl<ContactImportResultRemoteModel>(this as ContactImportResultRemoteModel, _$identity);

  /// Serializes this ContactImportResultRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactImportResultRemoteModel&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.importedCount, importedCount) || other.importedCount == importedCount)&&(identical(other.skippedCount, skippedCount) || other.skippedCount == skippedCount)&&const DeepCollectionEquality().equals(other.errors, errors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,importId,importedCount,skippedCount,const DeepCollectionEquality().hash(errors));

@override
String toString() {
  return 'ContactImportResultRemoteModel(importId: $importId, importedCount: $importedCount, skippedCount: $skippedCount, errors: $errors)';
}


}

/// @nodoc
abstract mixin class $ContactImportResultRemoteModelCopyWith<$Res>  {
  factory $ContactImportResultRemoteModelCopyWith(ContactImportResultRemoteModel value, $Res Function(ContactImportResultRemoteModel) _then) = _$ContactImportResultRemoteModelCopyWithImpl;
@useResult
$Res call({
 String importId, int importedCount, int skippedCount, List<String> errors
});




}
/// @nodoc
class _$ContactImportResultRemoteModelCopyWithImpl<$Res>
    implements $ContactImportResultRemoteModelCopyWith<$Res> {
  _$ContactImportResultRemoteModelCopyWithImpl(this._self, this._then);

  final ContactImportResultRemoteModel _self;
  final $Res Function(ContactImportResultRemoteModel) _then;

/// Create a copy of ContactImportResultRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? importId = null,Object? importedCount = null,Object? skippedCount = null,Object? errors = null,}) {
  return _then(_self.copyWith(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as String,importedCount: null == importedCount ? _self.importedCount : importedCount // ignore: cast_nullable_to_non_nullable
as int,skippedCount: null == skippedCount ? _self.skippedCount : skippedCount // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactImportResultRemoteModel].
extension ContactImportResultRemoteModelPatterns on ContactImportResultRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactImportResultRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactImportResultRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactImportResultRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _ContactImportResultRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactImportResultRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _ContactImportResultRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String importId,  int importedCount,  int skippedCount,  List<String> errors)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactImportResultRemoteModel() when $default != null:
return $default(_that.importId,_that.importedCount,_that.skippedCount,_that.errors);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String importId,  int importedCount,  int skippedCount,  List<String> errors)  $default,) {final _that = this;
switch (_that) {
case _ContactImportResultRemoteModel():
return $default(_that.importId,_that.importedCount,_that.skippedCount,_that.errors);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String importId,  int importedCount,  int skippedCount,  List<String> errors)?  $default,) {final _that = this;
switch (_that) {
case _ContactImportResultRemoteModel() when $default != null:
return $default(_that.importId,_that.importedCount,_that.skippedCount,_that.errors);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ContactImportResultRemoteModel implements ContactImportResultRemoteModel {
  const _ContactImportResultRemoteModel({required this.importId, required this.importedCount, required this.skippedCount, final  List<String> errors = const <String>[]}): _errors = errors;
  factory _ContactImportResultRemoteModel.fromJson(Map<String, dynamic> json) => _$ContactImportResultRemoteModelFromJson(json);

@override final  String importId;
@override final  int importedCount;
@override final  int skippedCount;
 final  List<String> _errors;
@override@JsonKey() List<String> get errors {
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errors);
}


/// Create a copy of ContactImportResultRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactImportResultRemoteModelCopyWith<_ContactImportResultRemoteModel> get copyWith => __$ContactImportResultRemoteModelCopyWithImpl<_ContactImportResultRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactImportResultRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactImportResultRemoteModel&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.importedCount, importedCount) || other.importedCount == importedCount)&&(identical(other.skippedCount, skippedCount) || other.skippedCount == skippedCount)&&const DeepCollectionEquality().equals(other._errors, _errors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,importId,importedCount,skippedCount,const DeepCollectionEquality().hash(_errors));

@override
String toString() {
  return 'ContactImportResultRemoteModel(importId: $importId, importedCount: $importedCount, skippedCount: $skippedCount, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$ContactImportResultRemoteModelCopyWith<$Res> implements $ContactImportResultRemoteModelCopyWith<$Res> {
  factory _$ContactImportResultRemoteModelCopyWith(_ContactImportResultRemoteModel value, $Res Function(_ContactImportResultRemoteModel) _then) = __$ContactImportResultRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String importId, int importedCount, int skippedCount, List<String> errors
});




}
/// @nodoc
class __$ContactImportResultRemoteModelCopyWithImpl<$Res>
    implements _$ContactImportResultRemoteModelCopyWith<$Res> {
  __$ContactImportResultRemoteModelCopyWithImpl(this._self, this._then);

  final _ContactImportResultRemoteModel _self;
  final $Res Function(_ContactImportResultRemoteModel) _then;

/// Create a copy of ContactImportResultRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? importId = null,Object? importedCount = null,Object? skippedCount = null,Object? errors = null,}) {
  return _then(_ContactImportResultRemoteModel(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as String,importedCount: null == importedCount ? _self.importedCount : importedCount // ignore: cast_nullable_to_non_nullable
as int,skippedCount: null == skippedCount ? _self.skippedCount : skippedCount // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
