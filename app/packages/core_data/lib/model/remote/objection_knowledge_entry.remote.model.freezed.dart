// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'objection_knowledge_entry.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ObjectionResponseRemoteModel {

 String get content; String get sourceType; String? get sourceName;
/// Create a copy of ObjectionResponseRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectionResponseRemoteModelCopyWith<ObjectionResponseRemoteModel> get copyWith => _$ObjectionResponseRemoteModelCopyWithImpl<ObjectionResponseRemoteModel>(this as ObjectionResponseRemoteModel, _$identity);

  /// Serializes this ObjectionResponseRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectionResponseRemoteModel&&(identical(other.content, content) || other.content == content)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,sourceType,sourceName);

@override
String toString() {
  return 'ObjectionResponseRemoteModel(content: $content, sourceType: $sourceType, sourceName: $sourceName)';
}


}

/// @nodoc
abstract mixin class $ObjectionResponseRemoteModelCopyWith<$Res>  {
  factory $ObjectionResponseRemoteModelCopyWith(ObjectionResponseRemoteModel value, $Res Function(ObjectionResponseRemoteModel) _then) = _$ObjectionResponseRemoteModelCopyWithImpl;
@useResult
$Res call({
 String content, String sourceType, String? sourceName
});




}
/// @nodoc
class _$ObjectionResponseRemoteModelCopyWithImpl<$Res>
    implements $ObjectionResponseRemoteModelCopyWith<$Res> {
  _$ObjectionResponseRemoteModelCopyWithImpl(this._self, this._then);

  final ObjectionResponseRemoteModel _self;
  final $Res Function(ObjectionResponseRemoteModel) _then;

/// Create a copy of ObjectionResponseRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? sourceType = null,Object? sourceName = freezed,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceName: freezed == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ObjectionResponseRemoteModel].
extension ObjectionResponseRemoteModelPatterns on ObjectionResponseRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ObjectionResponseRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ObjectionResponseRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ObjectionResponseRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _ObjectionResponseRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ObjectionResponseRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _ObjectionResponseRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String content,  String sourceType,  String? sourceName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ObjectionResponseRemoteModel() when $default != null:
return $default(_that.content,_that.sourceType,_that.sourceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String content,  String sourceType,  String? sourceName)  $default,) {final _that = this;
switch (_that) {
case _ObjectionResponseRemoteModel():
return $default(_that.content,_that.sourceType,_that.sourceName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String content,  String sourceType,  String? sourceName)?  $default,) {final _that = this;
switch (_that) {
case _ObjectionResponseRemoteModel() when $default != null:
return $default(_that.content,_that.sourceType,_that.sourceName);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ObjectionResponseRemoteModel implements ObjectionResponseRemoteModel {
  const _ObjectionResponseRemoteModel({required this.content, required this.sourceType, this.sourceName});
  factory _ObjectionResponseRemoteModel.fromJson(Map<String, dynamic> json) => _$ObjectionResponseRemoteModelFromJson(json);

@override final  String content;
@override final  String sourceType;
@override final  String? sourceName;

/// Create a copy of ObjectionResponseRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObjectionResponseRemoteModelCopyWith<_ObjectionResponseRemoteModel> get copyWith => __$ObjectionResponseRemoteModelCopyWithImpl<_ObjectionResponseRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ObjectionResponseRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ObjectionResponseRemoteModel&&(identical(other.content, content) || other.content == content)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,sourceType,sourceName);

@override
String toString() {
  return 'ObjectionResponseRemoteModel(content: $content, sourceType: $sourceType, sourceName: $sourceName)';
}


}

/// @nodoc
abstract mixin class _$ObjectionResponseRemoteModelCopyWith<$Res> implements $ObjectionResponseRemoteModelCopyWith<$Res> {
  factory _$ObjectionResponseRemoteModelCopyWith(_ObjectionResponseRemoteModel value, $Res Function(_ObjectionResponseRemoteModel) _then) = __$ObjectionResponseRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String content, String sourceType, String? sourceName
});




}
/// @nodoc
class __$ObjectionResponseRemoteModelCopyWithImpl<$Res>
    implements _$ObjectionResponseRemoteModelCopyWith<$Res> {
  __$ObjectionResponseRemoteModelCopyWithImpl(this._self, this._then);

  final _ObjectionResponseRemoteModel _self;
  final $Res Function(_ObjectionResponseRemoteModel) _then;

/// Create a copy of ObjectionResponseRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? sourceType = null,Object? sourceName = freezed,}) {
  return _then(_ObjectionResponseRemoteModel(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceName: freezed == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ObjectionKnowledgeEntryRemoteModel {

 String get id; String get category; String get text; String get reviewStatus; String get origin; int get occurrenceCount; DateTime get firstSeenAt; DateTime get lastSeenAt; ObjectionResponseRemoteModel? get response;
/// Create a copy of ObjectionKnowledgeEntryRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectionKnowledgeEntryRemoteModelCopyWith<ObjectionKnowledgeEntryRemoteModel> get copyWith => _$ObjectionKnowledgeEntryRemoteModelCopyWithImpl<ObjectionKnowledgeEntryRemoteModel>(this as ObjectionKnowledgeEntryRemoteModel, _$identity);

  /// Serializes this ObjectionKnowledgeEntryRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectionKnowledgeEntryRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.text, text) || other.text == text)&&(identical(other.reviewStatus, reviewStatus) || other.reviewStatus == reviewStatus)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.occurrenceCount, occurrenceCount) || other.occurrenceCount == occurrenceCount)&&(identical(other.firstSeenAt, firstSeenAt) || other.firstSeenAt == firstSeenAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.response, response) || other.response == response));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,text,reviewStatus,origin,occurrenceCount,firstSeenAt,lastSeenAt,response);

@override
String toString() {
  return 'ObjectionKnowledgeEntryRemoteModel(id: $id, category: $category, text: $text, reviewStatus: $reviewStatus, origin: $origin, occurrenceCount: $occurrenceCount, firstSeenAt: $firstSeenAt, lastSeenAt: $lastSeenAt, response: $response)';
}


}

/// @nodoc
abstract mixin class $ObjectionKnowledgeEntryRemoteModelCopyWith<$Res>  {
  factory $ObjectionKnowledgeEntryRemoteModelCopyWith(ObjectionKnowledgeEntryRemoteModel value, $Res Function(ObjectionKnowledgeEntryRemoteModel) _then) = _$ObjectionKnowledgeEntryRemoteModelCopyWithImpl;
@useResult
$Res call({
 String id, String category, String text, String reviewStatus, String origin, int occurrenceCount, DateTime firstSeenAt, DateTime lastSeenAt, ObjectionResponseRemoteModel? response
});


$ObjectionResponseRemoteModelCopyWith<$Res>? get response;

}
/// @nodoc
class _$ObjectionKnowledgeEntryRemoteModelCopyWithImpl<$Res>
    implements $ObjectionKnowledgeEntryRemoteModelCopyWith<$Res> {
  _$ObjectionKnowledgeEntryRemoteModelCopyWithImpl(this._self, this._then);

  final ObjectionKnowledgeEntryRemoteModel _self;
  final $Res Function(ObjectionKnowledgeEntryRemoteModel) _then;

/// Create a copy of ObjectionKnowledgeEntryRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? text = null,Object? reviewStatus = null,Object? origin = null,Object? occurrenceCount = null,Object? firstSeenAt = null,Object? lastSeenAt = null,Object? response = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reviewStatus: null == reviewStatus ? _self.reviewStatus : reviewStatus // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,occurrenceCount: null == occurrenceCount ? _self.occurrenceCount : occurrenceCount // ignore: cast_nullable_to_non_nullable
as int,firstSeenAt: null == firstSeenAt ? _self.firstSeenAt : firstSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as ObjectionResponseRemoteModel?,
  ));
}
/// Create a copy of ObjectionKnowledgeEntryRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectionResponseRemoteModelCopyWith<$Res>? get response {
    if (_self.response == null) {
    return null;
  }

  return $ObjectionResponseRemoteModelCopyWith<$Res>(_self.response!, (value) {
    return _then(_self.copyWith(response: value));
  });
}
}


/// Adds pattern-matching-related methods to [ObjectionKnowledgeEntryRemoteModel].
extension ObjectionKnowledgeEntryRemoteModelPatterns on ObjectionKnowledgeEntryRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ObjectionKnowledgeEntryRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ObjectionKnowledgeEntryRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ObjectionKnowledgeEntryRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category,  String text,  String reviewStatus,  String origin,  int occurrenceCount,  DateTime firstSeenAt,  DateTime lastSeenAt,  ObjectionResponseRemoteModel? response)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryRemoteModel() when $default != null:
return $default(_that.id,_that.category,_that.text,_that.reviewStatus,_that.origin,_that.occurrenceCount,_that.firstSeenAt,_that.lastSeenAt,_that.response);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category,  String text,  String reviewStatus,  String origin,  int occurrenceCount,  DateTime firstSeenAt,  DateTime lastSeenAt,  ObjectionResponseRemoteModel? response)  $default,) {final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryRemoteModel():
return $default(_that.id,_that.category,_that.text,_that.reviewStatus,_that.origin,_that.occurrenceCount,_that.firstSeenAt,_that.lastSeenAt,_that.response);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category,  String text,  String reviewStatus,  String origin,  int occurrenceCount,  DateTime firstSeenAt,  DateTime lastSeenAt,  ObjectionResponseRemoteModel? response)?  $default,) {final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryRemoteModel() when $default != null:
return $default(_that.id,_that.category,_that.text,_that.reviewStatus,_that.origin,_that.occurrenceCount,_that.firstSeenAt,_that.lastSeenAt,_that.response);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ObjectionKnowledgeEntryRemoteModel implements ObjectionKnowledgeEntryRemoteModel {
  const _ObjectionKnowledgeEntryRemoteModel({required this.id, required this.category, required this.text, required this.reviewStatus, required this.origin, required this.occurrenceCount, required this.firstSeenAt, required this.lastSeenAt, this.response});
  factory _ObjectionKnowledgeEntryRemoteModel.fromJson(Map<String, dynamic> json) => _$ObjectionKnowledgeEntryRemoteModelFromJson(json);

@override final  String id;
@override final  String category;
@override final  String text;
@override final  String reviewStatus;
@override final  String origin;
@override final  int occurrenceCount;
@override final  DateTime firstSeenAt;
@override final  DateTime lastSeenAt;
@override final  ObjectionResponseRemoteModel? response;

/// Create a copy of ObjectionKnowledgeEntryRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObjectionKnowledgeEntryRemoteModelCopyWith<_ObjectionKnowledgeEntryRemoteModel> get copyWith => __$ObjectionKnowledgeEntryRemoteModelCopyWithImpl<_ObjectionKnowledgeEntryRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ObjectionKnowledgeEntryRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ObjectionKnowledgeEntryRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.text, text) || other.text == text)&&(identical(other.reviewStatus, reviewStatus) || other.reviewStatus == reviewStatus)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.occurrenceCount, occurrenceCount) || other.occurrenceCount == occurrenceCount)&&(identical(other.firstSeenAt, firstSeenAt) || other.firstSeenAt == firstSeenAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.response, response) || other.response == response));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,text,reviewStatus,origin,occurrenceCount,firstSeenAt,lastSeenAt,response);

@override
String toString() {
  return 'ObjectionKnowledgeEntryRemoteModel(id: $id, category: $category, text: $text, reviewStatus: $reviewStatus, origin: $origin, occurrenceCount: $occurrenceCount, firstSeenAt: $firstSeenAt, lastSeenAt: $lastSeenAt, response: $response)';
}


}

/// @nodoc
abstract mixin class _$ObjectionKnowledgeEntryRemoteModelCopyWith<$Res> implements $ObjectionKnowledgeEntryRemoteModelCopyWith<$Res> {
  factory _$ObjectionKnowledgeEntryRemoteModelCopyWith(_ObjectionKnowledgeEntryRemoteModel value, $Res Function(_ObjectionKnowledgeEntryRemoteModel) _then) = __$ObjectionKnowledgeEntryRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String category, String text, String reviewStatus, String origin, int occurrenceCount, DateTime firstSeenAt, DateTime lastSeenAt, ObjectionResponseRemoteModel? response
});


@override $ObjectionResponseRemoteModelCopyWith<$Res>? get response;

}
/// @nodoc
class __$ObjectionKnowledgeEntryRemoteModelCopyWithImpl<$Res>
    implements _$ObjectionKnowledgeEntryRemoteModelCopyWith<$Res> {
  __$ObjectionKnowledgeEntryRemoteModelCopyWithImpl(this._self, this._then);

  final _ObjectionKnowledgeEntryRemoteModel _self;
  final $Res Function(_ObjectionKnowledgeEntryRemoteModel) _then;

/// Create a copy of ObjectionKnowledgeEntryRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? text = null,Object? reviewStatus = null,Object? origin = null,Object? occurrenceCount = null,Object? firstSeenAt = null,Object? lastSeenAt = null,Object? response = freezed,}) {
  return _then(_ObjectionKnowledgeEntryRemoteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reviewStatus: null == reviewStatus ? _self.reviewStatus : reviewStatus // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,occurrenceCount: null == occurrenceCount ? _self.occurrenceCount : occurrenceCount // ignore: cast_nullable_to_non_nullable
as int,firstSeenAt: null == firstSeenAt ? _self.firstSeenAt : firstSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,response: freezed == response ? _self.response : response // ignore: cast_nullable_to_non_nullable
as ObjectionResponseRemoteModel?,
  ));
}

/// Create a copy of ObjectionKnowledgeEntryRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ObjectionResponseRemoteModelCopyWith<$Res>? get response {
    if (_self.response == null) {
    return null;
  }

  return $ObjectionResponseRemoteModelCopyWith<$Res>(_self.response!, (value) {
    return _then(_self.copyWith(response: value));
  });
}
}


/// @nodoc
mixin _$ObjectionKnowledgeListRemoteModel {

 List<ObjectionKnowledgeEntryRemoteModel> get items;
/// Create a copy of ObjectionKnowledgeListRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectionKnowledgeListRemoteModelCopyWith<ObjectionKnowledgeListRemoteModel> get copyWith => _$ObjectionKnowledgeListRemoteModelCopyWithImpl<ObjectionKnowledgeListRemoteModel>(this as ObjectionKnowledgeListRemoteModel, _$identity);

  /// Serializes this ObjectionKnowledgeListRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectionKnowledgeListRemoteModel&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ObjectionKnowledgeListRemoteModel(items: $items)';
}


}

/// @nodoc
abstract mixin class $ObjectionKnowledgeListRemoteModelCopyWith<$Res>  {
  factory $ObjectionKnowledgeListRemoteModelCopyWith(ObjectionKnowledgeListRemoteModel value, $Res Function(ObjectionKnowledgeListRemoteModel) _then) = _$ObjectionKnowledgeListRemoteModelCopyWithImpl;
@useResult
$Res call({
 List<ObjectionKnowledgeEntryRemoteModel> items
});




}
/// @nodoc
class _$ObjectionKnowledgeListRemoteModelCopyWithImpl<$Res>
    implements $ObjectionKnowledgeListRemoteModelCopyWith<$Res> {
  _$ObjectionKnowledgeListRemoteModelCopyWithImpl(this._self, this._then);

  final ObjectionKnowledgeListRemoteModel _self;
  final $Res Function(ObjectionKnowledgeListRemoteModel) _then;

/// Create a copy of ObjectionKnowledgeListRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ObjectionKnowledgeEntryRemoteModel>,
  ));
}

}


/// Adds pattern-matching-related methods to [ObjectionKnowledgeListRemoteModel].
extension ObjectionKnowledgeListRemoteModelPatterns on ObjectionKnowledgeListRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ObjectionKnowledgeListRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ObjectionKnowledgeListRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ObjectionKnowledgeListRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _ObjectionKnowledgeListRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ObjectionKnowledgeListRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _ObjectionKnowledgeListRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ObjectionKnowledgeEntryRemoteModel> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ObjectionKnowledgeListRemoteModel() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ObjectionKnowledgeEntryRemoteModel> items)  $default,) {final _that = this;
switch (_that) {
case _ObjectionKnowledgeListRemoteModel():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ObjectionKnowledgeEntryRemoteModel> items)?  $default,) {final _that = this;
switch (_that) {
case _ObjectionKnowledgeListRemoteModel() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ObjectionKnowledgeListRemoteModel implements ObjectionKnowledgeListRemoteModel {
  const _ObjectionKnowledgeListRemoteModel({required final  List<ObjectionKnowledgeEntryRemoteModel> items}): _items = items;
  factory _ObjectionKnowledgeListRemoteModel.fromJson(Map<String, dynamic> json) => _$ObjectionKnowledgeListRemoteModelFromJson(json);

 final  List<ObjectionKnowledgeEntryRemoteModel> _items;
@override List<ObjectionKnowledgeEntryRemoteModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ObjectionKnowledgeListRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObjectionKnowledgeListRemoteModelCopyWith<_ObjectionKnowledgeListRemoteModel> get copyWith => __$ObjectionKnowledgeListRemoteModelCopyWithImpl<_ObjectionKnowledgeListRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ObjectionKnowledgeListRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ObjectionKnowledgeListRemoteModel&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ObjectionKnowledgeListRemoteModel(items: $items)';
}


}

/// @nodoc
abstract mixin class _$ObjectionKnowledgeListRemoteModelCopyWith<$Res> implements $ObjectionKnowledgeListRemoteModelCopyWith<$Res> {
  factory _$ObjectionKnowledgeListRemoteModelCopyWith(_ObjectionKnowledgeListRemoteModel value, $Res Function(_ObjectionKnowledgeListRemoteModel) _then) = __$ObjectionKnowledgeListRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 List<ObjectionKnowledgeEntryRemoteModel> items
});




}
/// @nodoc
class __$ObjectionKnowledgeListRemoteModelCopyWithImpl<$Res>
    implements _$ObjectionKnowledgeListRemoteModelCopyWith<$Res> {
  __$ObjectionKnowledgeListRemoteModelCopyWithImpl(this._self, this._then);

  final _ObjectionKnowledgeListRemoteModel _self;
  final $Res Function(_ObjectionKnowledgeListRemoteModel) _then;

/// Create a copy of ObjectionKnowledgeListRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_ObjectionKnowledgeListRemoteModel(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ObjectionKnowledgeEntryRemoteModel>,
  ));
}


}

// dart format on
