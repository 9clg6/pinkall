// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coaching_source.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoachingSourceRemoteModel {

 String get id; String get title; String get evidenceLevel; String? get author; String? get url; String? get locator;
/// Create a copy of CoachingSourceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingSourceRemoteModelCopyWith<CoachingSourceRemoteModel> get copyWith => _$CoachingSourceRemoteModelCopyWithImpl<CoachingSourceRemoteModel>(this as CoachingSourceRemoteModel, _$identity);

  /// Serializes this CoachingSourceRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingSourceRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.evidenceLevel, evidenceLevel) || other.evidenceLevel == evidenceLevel)&&(identical(other.author, author) || other.author == author)&&(identical(other.url, url) || other.url == url)&&(identical(other.locator, locator) || other.locator == locator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,evidenceLevel,author,url,locator);

@override
String toString() {
  return 'CoachingSourceRemoteModel(id: $id, title: $title, evidenceLevel: $evidenceLevel, author: $author, url: $url, locator: $locator)';
}


}

/// @nodoc
abstract mixin class $CoachingSourceRemoteModelCopyWith<$Res>  {
  factory $CoachingSourceRemoteModelCopyWith(CoachingSourceRemoteModel value, $Res Function(CoachingSourceRemoteModel) _then) = _$CoachingSourceRemoteModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String evidenceLevel, String? author, String? url, String? locator
});




}
/// @nodoc
class _$CoachingSourceRemoteModelCopyWithImpl<$Res>
    implements $CoachingSourceRemoteModelCopyWith<$Res> {
  _$CoachingSourceRemoteModelCopyWithImpl(this._self, this._then);

  final CoachingSourceRemoteModel _self;
  final $Res Function(CoachingSourceRemoteModel) _then;

/// Create a copy of CoachingSourceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? evidenceLevel = null,Object? author = freezed,Object? url = freezed,Object? locator = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,evidenceLevel: null == evidenceLevel ? _self.evidenceLevel : evidenceLevel // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,locator: freezed == locator ? _self.locator : locator // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachingSourceRemoteModel].
extension CoachingSourceRemoteModelPatterns on CoachingSourceRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingSourceRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingSourceRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingSourceRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CoachingSourceRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingSourceRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingSourceRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String evidenceLevel,  String? author,  String? url,  String? locator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingSourceRemoteModel() when $default != null:
return $default(_that.id,_that.title,_that.evidenceLevel,_that.author,_that.url,_that.locator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String evidenceLevel,  String? author,  String? url,  String? locator)  $default,) {final _that = this;
switch (_that) {
case _CoachingSourceRemoteModel():
return $default(_that.id,_that.title,_that.evidenceLevel,_that.author,_that.url,_that.locator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String evidenceLevel,  String? author,  String? url,  String? locator)?  $default,) {final _that = this;
switch (_that) {
case _CoachingSourceRemoteModel() when $default != null:
return $default(_that.id,_that.title,_that.evidenceLevel,_that.author,_that.url,_that.locator);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CoachingSourceRemoteModel implements CoachingSourceRemoteModel {
  const _CoachingSourceRemoteModel({required this.id, required this.title, required this.evidenceLevel, this.author, this.url, this.locator});
  factory _CoachingSourceRemoteModel.fromJson(Map<String, dynamic> json) => _$CoachingSourceRemoteModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String evidenceLevel;
@override final  String? author;
@override final  String? url;
@override final  String? locator;

/// Create a copy of CoachingSourceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingSourceRemoteModelCopyWith<_CoachingSourceRemoteModel> get copyWith => __$CoachingSourceRemoteModelCopyWithImpl<_CoachingSourceRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachingSourceRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingSourceRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.evidenceLevel, evidenceLevel) || other.evidenceLevel == evidenceLevel)&&(identical(other.author, author) || other.author == author)&&(identical(other.url, url) || other.url == url)&&(identical(other.locator, locator) || other.locator == locator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,evidenceLevel,author,url,locator);

@override
String toString() {
  return 'CoachingSourceRemoteModel(id: $id, title: $title, evidenceLevel: $evidenceLevel, author: $author, url: $url, locator: $locator)';
}


}

/// @nodoc
abstract mixin class _$CoachingSourceRemoteModelCopyWith<$Res> implements $CoachingSourceRemoteModelCopyWith<$Res> {
  factory _$CoachingSourceRemoteModelCopyWith(_CoachingSourceRemoteModel value, $Res Function(_CoachingSourceRemoteModel) _then) = __$CoachingSourceRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String evidenceLevel, String? author, String? url, String? locator
});




}
/// @nodoc
class __$CoachingSourceRemoteModelCopyWithImpl<$Res>
    implements _$CoachingSourceRemoteModelCopyWith<$Res> {
  __$CoachingSourceRemoteModelCopyWithImpl(this._self, this._then);

  final _CoachingSourceRemoteModel _self;
  final $Res Function(_CoachingSourceRemoteModel) _then;

/// Create a copy of CoachingSourceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? evidenceLevel = null,Object? author = freezed,Object? url = freezed,Object? locator = freezed,}) {
  return _then(_CoachingSourceRemoteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,evidenceLevel: null == evidenceLevel ? _self.evidenceLevel : evidenceLevel // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,locator: freezed == locator ? _self.locator : locator // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
