// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_custom_objection.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateCustomObjectionParam {

 String get category; String get text; String get responseContent; String get responseSourceType; String? get responseSourceName;
/// Create a copy of CreateCustomObjectionParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateCustomObjectionParamCopyWith<CreateCustomObjectionParam> get copyWith => _$CreateCustomObjectionParamCopyWithImpl<CreateCustomObjectionParam>(this as CreateCustomObjectionParam, _$identity);

  /// Serializes this CreateCustomObjectionParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateCustomObjectionParam&&(identical(other.category, category) || other.category == category)&&(identical(other.text, text) || other.text == text)&&(identical(other.responseContent, responseContent) || other.responseContent == responseContent)&&(identical(other.responseSourceType, responseSourceType) || other.responseSourceType == responseSourceType)&&(identical(other.responseSourceName, responseSourceName) || other.responseSourceName == responseSourceName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,text,responseContent,responseSourceType,responseSourceName);

@override
String toString() {
  return 'CreateCustomObjectionParam(category: $category, text: $text, responseContent: $responseContent, responseSourceType: $responseSourceType, responseSourceName: $responseSourceName)';
}


}

/// @nodoc
abstract mixin class $CreateCustomObjectionParamCopyWith<$Res>  {
  factory $CreateCustomObjectionParamCopyWith(CreateCustomObjectionParam value, $Res Function(CreateCustomObjectionParam) _then) = _$CreateCustomObjectionParamCopyWithImpl;
@useResult
$Res call({
 String category, String text, String responseContent, String responseSourceType, String? responseSourceName
});




}
/// @nodoc
class _$CreateCustomObjectionParamCopyWithImpl<$Res>
    implements $CreateCustomObjectionParamCopyWith<$Res> {
  _$CreateCustomObjectionParamCopyWithImpl(this._self, this._then);

  final CreateCustomObjectionParam _self;
  final $Res Function(CreateCustomObjectionParam) _then;

/// Create a copy of CreateCustomObjectionParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? text = null,Object? responseContent = null,Object? responseSourceType = null,Object? responseSourceName = freezed,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,responseContent: null == responseContent ? _self.responseContent : responseContent // ignore: cast_nullable_to_non_nullable
as String,responseSourceType: null == responseSourceType ? _self.responseSourceType : responseSourceType // ignore: cast_nullable_to_non_nullable
as String,responseSourceName: freezed == responseSourceName ? _self.responseSourceName : responseSourceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateCustomObjectionParam].
extension CreateCustomObjectionParamPatterns on CreateCustomObjectionParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateCustomObjectionParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateCustomObjectionParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateCustomObjectionParam value)  $default,){
final _that = this;
switch (_that) {
case _CreateCustomObjectionParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateCustomObjectionParam value)?  $default,){
final _that = this;
switch (_that) {
case _CreateCustomObjectionParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  String text,  String responseContent,  String responseSourceType,  String? responseSourceName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateCustomObjectionParam() when $default != null:
return $default(_that.category,_that.text,_that.responseContent,_that.responseSourceType,_that.responseSourceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  String text,  String responseContent,  String responseSourceType,  String? responseSourceName)  $default,) {final _that = this;
switch (_that) {
case _CreateCustomObjectionParam():
return $default(_that.category,_that.text,_that.responseContent,_that.responseSourceType,_that.responseSourceName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  String text,  String responseContent,  String responseSourceType,  String? responseSourceName)?  $default,) {final _that = this;
switch (_that) {
case _CreateCustomObjectionParam() when $default != null:
return $default(_that.category,_that.text,_that.responseContent,_that.responseSourceType,_that.responseSourceName);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CreateCustomObjectionParam implements CreateCustomObjectionParam {
  const _CreateCustomObjectionParam({required this.category, required this.text, required this.responseContent, this.responseSourceType = 'text', this.responseSourceName});
  factory _CreateCustomObjectionParam.fromJson(Map<String, dynamic> json) => _$CreateCustomObjectionParamFromJson(json);

@override final  String category;
@override final  String text;
@override final  String responseContent;
@override@JsonKey() final  String responseSourceType;
@override final  String? responseSourceName;

/// Create a copy of CreateCustomObjectionParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCustomObjectionParamCopyWith<_CreateCustomObjectionParam> get copyWith => __$CreateCustomObjectionParamCopyWithImpl<_CreateCustomObjectionParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateCustomObjectionParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateCustomObjectionParam&&(identical(other.category, category) || other.category == category)&&(identical(other.text, text) || other.text == text)&&(identical(other.responseContent, responseContent) || other.responseContent == responseContent)&&(identical(other.responseSourceType, responseSourceType) || other.responseSourceType == responseSourceType)&&(identical(other.responseSourceName, responseSourceName) || other.responseSourceName == responseSourceName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,text,responseContent,responseSourceType,responseSourceName);

@override
String toString() {
  return 'CreateCustomObjectionParam(category: $category, text: $text, responseContent: $responseContent, responseSourceType: $responseSourceType, responseSourceName: $responseSourceName)';
}


}

/// @nodoc
abstract mixin class _$CreateCustomObjectionParamCopyWith<$Res> implements $CreateCustomObjectionParamCopyWith<$Res> {
  factory _$CreateCustomObjectionParamCopyWith(_CreateCustomObjectionParam value, $Res Function(_CreateCustomObjectionParam) _then) = __$CreateCustomObjectionParamCopyWithImpl;
@override @useResult
$Res call({
 String category, String text, String responseContent, String responseSourceType, String? responseSourceName
});




}
/// @nodoc
class __$CreateCustomObjectionParamCopyWithImpl<$Res>
    implements _$CreateCustomObjectionParamCopyWith<$Res> {
  __$CreateCustomObjectionParamCopyWithImpl(this._self, this._then);

  final _CreateCustomObjectionParam _self;
  final $Res Function(_CreateCustomObjectionParam) _then;

/// Create a copy of CreateCustomObjectionParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? text = null,Object? responseContent = null,Object? responseSourceType = null,Object? responseSourceName = freezed,}) {
  return _then(_CreateCustomObjectionParam(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,responseContent: null == responseContent ? _self.responseContent : responseContent // ignore: cast_nullable_to_non_nullable
as String,responseSourceType: null == responseSourceType ? _self.responseSourceType : responseSourceType // ignore: cast_nullable_to_non_nullable
as String,responseSourceName: freezed == responseSourceName ? _self.responseSourceName : responseSourceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
