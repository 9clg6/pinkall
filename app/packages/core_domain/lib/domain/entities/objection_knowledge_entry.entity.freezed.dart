// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'objection_knowledge_entry.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ObjectionKnowledgeEntryEntity {

 String get id; String get category; String get text; String get reviewStatus; String get origin; int get occurrenceCount; DateTime get firstSeenAt; DateTime get lastSeenAt; String? get responseContent; String? get responseSourceType; String? get responseSourceName;
/// Create a copy of ObjectionKnowledgeEntryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectionKnowledgeEntryEntityCopyWith<ObjectionKnowledgeEntryEntity> get copyWith => _$ObjectionKnowledgeEntryEntityCopyWithImpl<ObjectionKnowledgeEntryEntity>(this as ObjectionKnowledgeEntryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectionKnowledgeEntryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.text, text) || other.text == text)&&(identical(other.reviewStatus, reviewStatus) || other.reviewStatus == reviewStatus)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.occurrenceCount, occurrenceCount) || other.occurrenceCount == occurrenceCount)&&(identical(other.firstSeenAt, firstSeenAt) || other.firstSeenAt == firstSeenAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.responseContent, responseContent) || other.responseContent == responseContent)&&(identical(other.responseSourceType, responseSourceType) || other.responseSourceType == responseSourceType)&&(identical(other.responseSourceName, responseSourceName) || other.responseSourceName == responseSourceName));
}


@override
int get hashCode => Object.hash(runtimeType,id,category,text,reviewStatus,origin,occurrenceCount,firstSeenAt,lastSeenAt,responseContent,responseSourceType,responseSourceName);

@override
String toString() {
  return 'ObjectionKnowledgeEntryEntity(id: $id, category: $category, text: $text, reviewStatus: $reviewStatus, origin: $origin, occurrenceCount: $occurrenceCount, firstSeenAt: $firstSeenAt, lastSeenAt: $lastSeenAt, responseContent: $responseContent, responseSourceType: $responseSourceType, responseSourceName: $responseSourceName)';
}


}

/// @nodoc
abstract mixin class $ObjectionKnowledgeEntryEntityCopyWith<$Res>  {
  factory $ObjectionKnowledgeEntryEntityCopyWith(ObjectionKnowledgeEntryEntity value, $Res Function(ObjectionKnowledgeEntryEntity) _then) = _$ObjectionKnowledgeEntryEntityCopyWithImpl;
@useResult
$Res call({
 String id, String category, String text, String reviewStatus, String origin, int occurrenceCount, DateTime firstSeenAt, DateTime lastSeenAt, String? responseContent, String? responseSourceType, String? responseSourceName
});




}
/// @nodoc
class _$ObjectionKnowledgeEntryEntityCopyWithImpl<$Res>
    implements $ObjectionKnowledgeEntryEntityCopyWith<$Res> {
  _$ObjectionKnowledgeEntryEntityCopyWithImpl(this._self, this._then);

  final ObjectionKnowledgeEntryEntity _self;
  final $Res Function(ObjectionKnowledgeEntryEntity) _then;

/// Create a copy of ObjectionKnowledgeEntryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? text = null,Object? reviewStatus = null,Object? origin = null,Object? occurrenceCount = null,Object? firstSeenAt = null,Object? lastSeenAt = null,Object? responseContent = freezed,Object? responseSourceType = freezed,Object? responseSourceName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reviewStatus: null == reviewStatus ? _self.reviewStatus : reviewStatus // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,occurrenceCount: null == occurrenceCount ? _self.occurrenceCount : occurrenceCount // ignore: cast_nullable_to_non_nullable
as int,firstSeenAt: null == firstSeenAt ? _self.firstSeenAt : firstSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,responseContent: freezed == responseContent ? _self.responseContent : responseContent // ignore: cast_nullable_to_non_nullable
as String?,responseSourceType: freezed == responseSourceType ? _self.responseSourceType : responseSourceType // ignore: cast_nullable_to_non_nullable
as String?,responseSourceName: freezed == responseSourceName ? _self.responseSourceName : responseSourceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ObjectionKnowledgeEntryEntity].
extension ObjectionKnowledgeEntryEntityPatterns on ObjectionKnowledgeEntryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ObjectionKnowledgeEntryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ObjectionKnowledgeEntryEntity value)  $default,){
final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ObjectionKnowledgeEntryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String category,  String text,  String reviewStatus,  String origin,  int occurrenceCount,  DateTime firstSeenAt,  DateTime lastSeenAt,  String? responseContent,  String? responseSourceType,  String? responseSourceName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryEntity() when $default != null:
return $default(_that.id,_that.category,_that.text,_that.reviewStatus,_that.origin,_that.occurrenceCount,_that.firstSeenAt,_that.lastSeenAt,_that.responseContent,_that.responseSourceType,_that.responseSourceName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String category,  String text,  String reviewStatus,  String origin,  int occurrenceCount,  DateTime firstSeenAt,  DateTime lastSeenAt,  String? responseContent,  String? responseSourceType,  String? responseSourceName)  $default,) {final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryEntity():
return $default(_that.id,_that.category,_that.text,_that.reviewStatus,_that.origin,_that.occurrenceCount,_that.firstSeenAt,_that.lastSeenAt,_that.responseContent,_that.responseSourceType,_that.responseSourceName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String category,  String text,  String reviewStatus,  String origin,  int occurrenceCount,  DateTime firstSeenAt,  DateTime lastSeenAt,  String? responseContent,  String? responseSourceType,  String? responseSourceName)?  $default,) {final _that = this;
switch (_that) {
case _ObjectionKnowledgeEntryEntity() when $default != null:
return $default(_that.id,_that.category,_that.text,_that.reviewStatus,_that.origin,_that.occurrenceCount,_that.firstSeenAt,_that.lastSeenAt,_that.responseContent,_that.responseSourceType,_that.responseSourceName);case _:
  return null;

}
}

}

/// @nodoc


class _ObjectionKnowledgeEntryEntity implements ObjectionKnowledgeEntryEntity {
  const _ObjectionKnowledgeEntryEntity({required this.id, required this.category, required this.text, required this.reviewStatus, required this.origin, required this.occurrenceCount, required this.firstSeenAt, required this.lastSeenAt, this.responseContent, this.responseSourceType, this.responseSourceName});
  

@override final  String id;
@override final  String category;
@override final  String text;
@override final  String reviewStatus;
@override final  String origin;
@override final  int occurrenceCount;
@override final  DateTime firstSeenAt;
@override final  DateTime lastSeenAt;
@override final  String? responseContent;
@override final  String? responseSourceType;
@override final  String? responseSourceName;

/// Create a copy of ObjectionKnowledgeEntryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ObjectionKnowledgeEntryEntityCopyWith<_ObjectionKnowledgeEntryEntity> get copyWith => __$ObjectionKnowledgeEntryEntityCopyWithImpl<_ObjectionKnowledgeEntryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ObjectionKnowledgeEntryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.text, text) || other.text == text)&&(identical(other.reviewStatus, reviewStatus) || other.reviewStatus == reviewStatus)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.occurrenceCount, occurrenceCount) || other.occurrenceCount == occurrenceCount)&&(identical(other.firstSeenAt, firstSeenAt) || other.firstSeenAt == firstSeenAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.responseContent, responseContent) || other.responseContent == responseContent)&&(identical(other.responseSourceType, responseSourceType) || other.responseSourceType == responseSourceType)&&(identical(other.responseSourceName, responseSourceName) || other.responseSourceName == responseSourceName));
}


@override
int get hashCode => Object.hash(runtimeType,id,category,text,reviewStatus,origin,occurrenceCount,firstSeenAt,lastSeenAt,responseContent,responseSourceType,responseSourceName);

@override
String toString() {
  return 'ObjectionKnowledgeEntryEntity(id: $id, category: $category, text: $text, reviewStatus: $reviewStatus, origin: $origin, occurrenceCount: $occurrenceCount, firstSeenAt: $firstSeenAt, lastSeenAt: $lastSeenAt, responseContent: $responseContent, responseSourceType: $responseSourceType, responseSourceName: $responseSourceName)';
}


}

/// @nodoc
abstract mixin class _$ObjectionKnowledgeEntryEntityCopyWith<$Res> implements $ObjectionKnowledgeEntryEntityCopyWith<$Res> {
  factory _$ObjectionKnowledgeEntryEntityCopyWith(_ObjectionKnowledgeEntryEntity value, $Res Function(_ObjectionKnowledgeEntryEntity) _then) = __$ObjectionKnowledgeEntryEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String category, String text, String reviewStatus, String origin, int occurrenceCount, DateTime firstSeenAt, DateTime lastSeenAt, String? responseContent, String? responseSourceType, String? responseSourceName
});




}
/// @nodoc
class __$ObjectionKnowledgeEntryEntityCopyWithImpl<$Res>
    implements _$ObjectionKnowledgeEntryEntityCopyWith<$Res> {
  __$ObjectionKnowledgeEntryEntityCopyWithImpl(this._self, this._then);

  final _ObjectionKnowledgeEntryEntity _self;
  final $Res Function(_ObjectionKnowledgeEntryEntity) _then;

/// Create a copy of ObjectionKnowledgeEntryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? text = null,Object? reviewStatus = null,Object? origin = null,Object? occurrenceCount = null,Object? firstSeenAt = null,Object? lastSeenAt = null,Object? responseContent = freezed,Object? responseSourceType = freezed,Object? responseSourceName = freezed,}) {
  return _then(_ObjectionKnowledgeEntryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,reviewStatus: null == reviewStatus ? _self.reviewStatus : reviewStatus // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,occurrenceCount: null == occurrenceCount ? _self.occurrenceCount : occurrenceCount // ignore: cast_nullable_to_non_nullable
as int,firstSeenAt: null == firstSeenAt ? _self.firstSeenAt : firstSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,responseContent: freezed == responseContent ? _self.responseContent : responseContent // ignore: cast_nullable_to_non_nullable
as String?,responseSourceType: freezed == responseSourceType ? _self.responseSourceType : responseSourceType // ignore: cast_nullable_to_non_nullable
as String?,responseSourceName: freezed == responseSourceName ? _self.responseSourceName : responseSourceName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
