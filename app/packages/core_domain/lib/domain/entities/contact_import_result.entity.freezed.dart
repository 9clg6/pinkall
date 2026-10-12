// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact_import_result.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContactImportResultEntity {

 String get importId; int get importedCount; int get skippedCount; List<String> get errors;
/// Create a copy of ContactImportResultEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactImportResultEntityCopyWith<ContactImportResultEntity> get copyWith => _$ContactImportResultEntityCopyWithImpl<ContactImportResultEntity>(this as ContactImportResultEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactImportResultEntity&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.importedCount, importedCount) || other.importedCount == importedCount)&&(identical(other.skippedCount, skippedCount) || other.skippedCount == skippedCount)&&const DeepCollectionEquality().equals(other.errors, errors));
}


@override
int get hashCode => Object.hash(runtimeType,importId,importedCount,skippedCount,const DeepCollectionEquality().hash(errors));

@override
String toString() {
  return 'ContactImportResultEntity(importId: $importId, importedCount: $importedCount, skippedCount: $skippedCount, errors: $errors)';
}


}

/// @nodoc
abstract mixin class $ContactImportResultEntityCopyWith<$Res>  {
  factory $ContactImportResultEntityCopyWith(ContactImportResultEntity value, $Res Function(ContactImportResultEntity) _then) = _$ContactImportResultEntityCopyWithImpl;
@useResult
$Res call({
 String importId, int importedCount, int skippedCount, List<String> errors
});




}
/// @nodoc
class _$ContactImportResultEntityCopyWithImpl<$Res>
    implements $ContactImportResultEntityCopyWith<$Res> {
  _$ContactImportResultEntityCopyWithImpl(this._self, this._then);

  final ContactImportResultEntity _self;
  final $Res Function(ContactImportResultEntity) _then;

/// Create a copy of ContactImportResultEntity
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


/// Adds pattern-matching-related methods to [ContactImportResultEntity].
extension ContactImportResultEntityPatterns on ContactImportResultEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactImportResultEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactImportResultEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactImportResultEntity value)  $default,){
final _that = this;
switch (_that) {
case _ContactImportResultEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactImportResultEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ContactImportResultEntity() when $default != null:
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
case _ContactImportResultEntity() when $default != null:
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
case _ContactImportResultEntity():
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
case _ContactImportResultEntity() when $default != null:
return $default(_that.importId,_that.importedCount,_that.skippedCount,_that.errors);case _:
  return null;

}
}

}

/// @nodoc


class _ContactImportResultEntity implements ContactImportResultEntity {
  const _ContactImportResultEntity({required this.importId, required this.importedCount, required this.skippedCount, final  List<String> errors = const <String>[]}): _errors = errors;
  

@override final  String importId;
@override final  int importedCount;
@override final  int skippedCount;
 final  List<String> _errors;
@override@JsonKey() List<String> get errors {
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errors);
}


/// Create a copy of ContactImportResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactImportResultEntityCopyWith<_ContactImportResultEntity> get copyWith => __$ContactImportResultEntityCopyWithImpl<_ContactImportResultEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactImportResultEntity&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.importedCount, importedCount) || other.importedCount == importedCount)&&(identical(other.skippedCount, skippedCount) || other.skippedCount == skippedCount)&&const DeepCollectionEquality().equals(other._errors, _errors));
}


@override
int get hashCode => Object.hash(runtimeType,importId,importedCount,skippedCount,const DeepCollectionEquality().hash(_errors));

@override
String toString() {
  return 'ContactImportResultEntity(importId: $importId, importedCount: $importedCount, skippedCount: $skippedCount, errors: $errors)';
}


}

/// @nodoc
abstract mixin class _$ContactImportResultEntityCopyWith<$Res> implements $ContactImportResultEntityCopyWith<$Res> {
  factory _$ContactImportResultEntityCopyWith(_ContactImportResultEntity value, $Res Function(_ContactImportResultEntity) _then) = __$ContactImportResultEntityCopyWithImpl;
@override @useResult
$Res call({
 String importId, int importedCount, int skippedCount, List<String> errors
});




}
/// @nodoc
class __$ContactImportResultEntityCopyWithImpl<$Res>
    implements _$ContactImportResultEntityCopyWith<$Res> {
  __$ContactImportResultEntityCopyWithImpl(this._self, this._then);

  final _ContactImportResultEntity _self;
  final $Res Function(_ContactImportResultEntity) _then;

/// Create a copy of ContactImportResultEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? importId = null,Object? importedCount = null,Object? skippedCount = null,Object? errors = null,}) {
  return _then(_ContactImportResultEntity(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as String,importedCount: null == importedCount ? _self.importedCount : importedCount // ignore: cast_nullable_to_non_nullable
as int,skippedCount: null == skippedCount ? _self.skippedCount : skippedCount // ignore: cast_nullable_to_non_nullable
as int,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
