// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_recording_import.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateRecordingImportParam {

 String get source; String get fileName; String get mimeType; int get sizeBytes; String? get title; String get locale; String? get preparationMarkdown;
/// Create a copy of CreateRecordingImportParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateRecordingImportParamCopyWith<CreateRecordingImportParam> get copyWith => _$CreateRecordingImportParamCopyWithImpl<CreateRecordingImportParam>(this as CreateRecordingImportParam, _$identity);

  /// Serializes this CreateRecordingImportParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateRecordingImportParam&&(identical(other.source, source) || other.source == source)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.title, title) || other.title == title)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.preparationMarkdown, preparationMarkdown) || other.preparationMarkdown == preparationMarkdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,fileName,mimeType,sizeBytes,title,locale,preparationMarkdown);

@override
String toString() {
  return 'CreateRecordingImportParam(source: $source, fileName: $fileName, mimeType: $mimeType, sizeBytes: $sizeBytes, title: $title, locale: $locale, preparationMarkdown: $preparationMarkdown)';
}


}

/// @nodoc
abstract mixin class $CreateRecordingImportParamCopyWith<$Res>  {
  factory $CreateRecordingImportParamCopyWith(CreateRecordingImportParam value, $Res Function(CreateRecordingImportParam) _then) = _$CreateRecordingImportParamCopyWithImpl;
@useResult
$Res call({
 String source, String fileName, String mimeType, int sizeBytes, String? title, String locale, String? preparationMarkdown
});




}
/// @nodoc
class _$CreateRecordingImportParamCopyWithImpl<$Res>
    implements $CreateRecordingImportParamCopyWith<$Res> {
  _$CreateRecordingImportParamCopyWithImpl(this._self, this._then);

  final CreateRecordingImportParam _self;
  final $Res Function(CreateRecordingImportParam) _then;

/// Create a copy of CreateRecordingImportParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? fileName = null,Object? mimeType = null,Object? sizeBytes = null,Object? title = freezed,Object? locale = null,Object? preparationMarkdown = freezed,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,preparationMarkdown: freezed == preparationMarkdown ? _self.preparationMarkdown : preparationMarkdown // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateRecordingImportParam].
extension CreateRecordingImportParamPatterns on CreateRecordingImportParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateRecordingImportParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateRecordingImportParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateRecordingImportParam value)  $default,){
final _that = this;
switch (_that) {
case _CreateRecordingImportParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateRecordingImportParam value)?  $default,){
final _that = this;
switch (_that) {
case _CreateRecordingImportParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String source,  String fileName,  String mimeType,  int sizeBytes,  String? title,  String locale,  String? preparationMarkdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateRecordingImportParam() when $default != null:
return $default(_that.source,_that.fileName,_that.mimeType,_that.sizeBytes,_that.title,_that.locale,_that.preparationMarkdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String source,  String fileName,  String mimeType,  int sizeBytes,  String? title,  String locale,  String? preparationMarkdown)  $default,) {final _that = this;
switch (_that) {
case _CreateRecordingImportParam():
return $default(_that.source,_that.fileName,_that.mimeType,_that.sizeBytes,_that.title,_that.locale,_that.preparationMarkdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String source,  String fileName,  String mimeType,  int sizeBytes,  String? title,  String locale,  String? preparationMarkdown)?  $default,) {final _that = this;
switch (_that) {
case _CreateRecordingImportParam() when $default != null:
return $default(_that.source,_that.fileName,_that.mimeType,_that.sizeBytes,_that.title,_that.locale,_that.preparationMarkdown);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CreateRecordingImportParam implements CreateRecordingImportParam {
  const _CreateRecordingImportParam({this.source = 'recording_import', required this.fileName, required this.mimeType, required this.sizeBytes, this.title, this.locale = 'fr-FR', this.preparationMarkdown});
  factory _CreateRecordingImportParam.fromJson(Map<String, dynamic> json) => _$CreateRecordingImportParamFromJson(json);

@override@JsonKey() final  String source;
@override final  String fileName;
@override final  String mimeType;
@override final  int sizeBytes;
@override final  String? title;
@override@JsonKey() final  String locale;
@override final  String? preparationMarkdown;

/// Create a copy of CreateRecordingImportParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateRecordingImportParamCopyWith<_CreateRecordingImportParam> get copyWith => __$CreateRecordingImportParamCopyWithImpl<_CreateRecordingImportParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateRecordingImportParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateRecordingImportParam&&(identical(other.source, source) || other.source == source)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.title, title) || other.title == title)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.preparationMarkdown, preparationMarkdown) || other.preparationMarkdown == preparationMarkdown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,fileName,mimeType,sizeBytes,title,locale,preparationMarkdown);

@override
String toString() {
  return 'CreateRecordingImportParam(source: $source, fileName: $fileName, mimeType: $mimeType, sizeBytes: $sizeBytes, title: $title, locale: $locale, preparationMarkdown: $preparationMarkdown)';
}


}

/// @nodoc
abstract mixin class _$CreateRecordingImportParamCopyWith<$Res> implements $CreateRecordingImportParamCopyWith<$Res> {
  factory _$CreateRecordingImportParamCopyWith(_CreateRecordingImportParam value, $Res Function(_CreateRecordingImportParam) _then) = __$CreateRecordingImportParamCopyWithImpl;
@override @useResult
$Res call({
 String source, String fileName, String mimeType, int sizeBytes, String? title, String locale, String? preparationMarkdown
});




}
/// @nodoc
class __$CreateRecordingImportParamCopyWithImpl<$Res>
    implements _$CreateRecordingImportParamCopyWith<$Res> {
  __$CreateRecordingImportParamCopyWithImpl(this._self, this._then);

  final _CreateRecordingImportParam _self;
  final $Res Function(_CreateRecordingImportParam) _then;

/// Create a copy of CreateRecordingImportParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? fileName = null,Object? mimeType = null,Object? sizeBytes = null,Object? title = freezed,Object? locale = null,Object? preparationMarkdown = freezed,}) {
  return _then(_CreateRecordingImportParam(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,preparationMarkdown: freezed == preparationMarkdown ? _self.preparationMarkdown : preparationMarkdown // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
