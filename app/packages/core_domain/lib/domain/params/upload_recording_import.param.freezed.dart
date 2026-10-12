// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'upload_recording_import.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UploadRecordingImportParam {

 String get importId; String get uploadPath; String get filePath; String get mimeType; int get sizeBytes;
/// Create a copy of UploadRecordingImportParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadRecordingImportParamCopyWith<UploadRecordingImportParam> get copyWith => _$UploadRecordingImportParamCopyWithImpl<UploadRecordingImportParam>(this as UploadRecordingImportParam, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadRecordingImportParam&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.uploadPath, uploadPath) || other.uploadPath == uploadPath)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}


@override
int get hashCode => Object.hash(runtimeType,importId,uploadPath,filePath,mimeType,sizeBytes);

@override
String toString() {
  return 'UploadRecordingImportParam(importId: $importId, uploadPath: $uploadPath, filePath: $filePath, mimeType: $mimeType, sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class $UploadRecordingImportParamCopyWith<$Res>  {
  factory $UploadRecordingImportParamCopyWith(UploadRecordingImportParam value, $Res Function(UploadRecordingImportParam) _then) = _$UploadRecordingImportParamCopyWithImpl;
@useResult
$Res call({
 String importId, String uploadPath, String filePath, String mimeType, int sizeBytes
});




}
/// @nodoc
class _$UploadRecordingImportParamCopyWithImpl<$Res>
    implements $UploadRecordingImportParamCopyWith<$Res> {
  _$UploadRecordingImportParamCopyWithImpl(this._self, this._then);

  final UploadRecordingImportParam _self;
  final $Res Function(UploadRecordingImportParam) _then;

/// Create a copy of UploadRecordingImportParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? importId = null,Object? uploadPath = null,Object? filePath = null,Object? mimeType = null,Object? sizeBytes = null,}) {
  return _then(_self.copyWith(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as String,uploadPath: null == uploadPath ? _self.uploadPath : uploadPath // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadRecordingImportParam].
extension UploadRecordingImportParamPatterns on UploadRecordingImportParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadRecordingImportParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadRecordingImportParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadRecordingImportParam value)  $default,){
final _that = this;
switch (_that) {
case _UploadRecordingImportParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadRecordingImportParam value)?  $default,){
final _that = this;
switch (_that) {
case _UploadRecordingImportParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String importId,  String uploadPath,  String filePath,  String mimeType,  int sizeBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadRecordingImportParam() when $default != null:
return $default(_that.importId,_that.uploadPath,_that.filePath,_that.mimeType,_that.sizeBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String importId,  String uploadPath,  String filePath,  String mimeType,  int sizeBytes)  $default,) {final _that = this;
switch (_that) {
case _UploadRecordingImportParam():
return $default(_that.importId,_that.uploadPath,_that.filePath,_that.mimeType,_that.sizeBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String importId,  String uploadPath,  String filePath,  String mimeType,  int sizeBytes)?  $default,) {final _that = this;
switch (_that) {
case _UploadRecordingImportParam() when $default != null:
return $default(_that.importId,_that.uploadPath,_that.filePath,_that.mimeType,_that.sizeBytes);case _:
  return null;

}
}

}

/// @nodoc


class _UploadRecordingImportParam implements UploadRecordingImportParam {
  const _UploadRecordingImportParam({required this.importId, required this.uploadPath, required this.filePath, required this.mimeType, required this.sizeBytes});
  

@override final  String importId;
@override final  String uploadPath;
@override final  String filePath;
@override final  String mimeType;
@override final  int sizeBytes;

/// Create a copy of UploadRecordingImportParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadRecordingImportParamCopyWith<_UploadRecordingImportParam> get copyWith => __$UploadRecordingImportParamCopyWithImpl<_UploadRecordingImportParam>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadRecordingImportParam&&(identical(other.importId, importId) || other.importId == importId)&&(identical(other.uploadPath, uploadPath) || other.uploadPath == uploadPath)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}


@override
int get hashCode => Object.hash(runtimeType,importId,uploadPath,filePath,mimeType,sizeBytes);

@override
String toString() {
  return 'UploadRecordingImportParam(importId: $importId, uploadPath: $uploadPath, filePath: $filePath, mimeType: $mimeType, sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class _$UploadRecordingImportParamCopyWith<$Res> implements $UploadRecordingImportParamCopyWith<$Res> {
  factory _$UploadRecordingImportParamCopyWith(_UploadRecordingImportParam value, $Res Function(_UploadRecordingImportParam) _then) = __$UploadRecordingImportParamCopyWithImpl;
@override @useResult
$Res call({
 String importId, String uploadPath, String filePath, String mimeType, int sizeBytes
});




}
/// @nodoc
class __$UploadRecordingImportParamCopyWithImpl<$Res>
    implements _$UploadRecordingImportParamCopyWith<$Res> {
  __$UploadRecordingImportParamCopyWithImpl(this._self, this._then);

  final _UploadRecordingImportParam _self;
  final $Res Function(_UploadRecordingImportParam) _then;

/// Create a copy of UploadRecordingImportParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? importId = null,Object? uploadPath = null,Object? filePath = null,Object? mimeType = null,Object? sizeBytes = null,}) {
  return _then(_UploadRecordingImportParam(
importId: null == importId ? _self.importId : importId // ignore: cast_nullable_to_non_nullable
as String,uploadPath: null == uploadPath ? _self.uploadPath : uploadPath // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
