// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provisional_transcript_segment.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProvisionalTranscriptSegmentEntity {

 String get id; String get voice; String get text; double get startSeconds; double get endSeconds; double get confidence;
/// Create a copy of ProvisionalTranscriptSegmentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProvisionalTranscriptSegmentEntityCopyWith<ProvisionalTranscriptSegmentEntity> get copyWith => _$ProvisionalTranscriptSegmentEntityCopyWithImpl<ProvisionalTranscriptSegmentEntity>(this as ProvisionalTranscriptSegmentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProvisionalTranscriptSegmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.voice, voice) || other.voice == voice)&&(identical(other.text, text) || other.text == text)&&(identical(other.startSeconds, startSeconds) || other.startSeconds == startSeconds)&&(identical(other.endSeconds, endSeconds) || other.endSeconds == endSeconds)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode => Object.hash(runtimeType,id,voice,text,startSeconds,endSeconds,confidence);

@override
String toString() {
  return 'ProvisionalTranscriptSegmentEntity(id: $id, voice: $voice, text: $text, startSeconds: $startSeconds, endSeconds: $endSeconds, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $ProvisionalTranscriptSegmentEntityCopyWith<$Res>  {
  factory $ProvisionalTranscriptSegmentEntityCopyWith(ProvisionalTranscriptSegmentEntity value, $Res Function(ProvisionalTranscriptSegmentEntity) _then) = _$ProvisionalTranscriptSegmentEntityCopyWithImpl;
@useResult
$Res call({
 String id, String voice, String text, double startSeconds, double endSeconds, double confidence
});




}
/// @nodoc
class _$ProvisionalTranscriptSegmentEntityCopyWithImpl<$Res>
    implements $ProvisionalTranscriptSegmentEntityCopyWith<$Res> {
  _$ProvisionalTranscriptSegmentEntityCopyWithImpl(this._self, this._then);

  final ProvisionalTranscriptSegmentEntity _self;
  final $Res Function(ProvisionalTranscriptSegmentEntity) _then;

/// Create a copy of ProvisionalTranscriptSegmentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? voice = null,Object? text = null,Object? startSeconds = null,Object? endSeconds = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,voice: null == voice ? _self.voice : voice // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,startSeconds: null == startSeconds ? _self.startSeconds : startSeconds // ignore: cast_nullable_to_non_nullable
as double,endSeconds: null == endSeconds ? _self.endSeconds : endSeconds // ignore: cast_nullable_to_non_nullable
as double,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ProvisionalTranscriptSegmentEntity].
extension ProvisionalTranscriptSegmentEntityPatterns on ProvisionalTranscriptSegmentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProvisionalTranscriptSegmentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProvisionalTranscriptSegmentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProvisionalTranscriptSegmentEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProvisionalTranscriptSegmentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProvisionalTranscriptSegmentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProvisionalTranscriptSegmentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String voice,  String text,  double startSeconds,  double endSeconds,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProvisionalTranscriptSegmentEntity() when $default != null:
return $default(_that.id,_that.voice,_that.text,_that.startSeconds,_that.endSeconds,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String voice,  String text,  double startSeconds,  double endSeconds,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _ProvisionalTranscriptSegmentEntity():
return $default(_that.id,_that.voice,_that.text,_that.startSeconds,_that.endSeconds,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String voice,  String text,  double startSeconds,  double endSeconds,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _ProvisionalTranscriptSegmentEntity() when $default != null:
return $default(_that.id,_that.voice,_that.text,_that.startSeconds,_that.endSeconds,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc


class _ProvisionalTranscriptSegmentEntity implements ProvisionalTranscriptSegmentEntity {
  const _ProvisionalTranscriptSegmentEntity({required this.id, required this.voice, required this.text, required this.startSeconds, required this.endSeconds, required this.confidence});
  

@override final  String id;
@override final  String voice;
@override final  String text;
@override final  double startSeconds;
@override final  double endSeconds;
@override final  double confidence;

/// Create a copy of ProvisionalTranscriptSegmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProvisionalTranscriptSegmentEntityCopyWith<_ProvisionalTranscriptSegmentEntity> get copyWith => __$ProvisionalTranscriptSegmentEntityCopyWithImpl<_ProvisionalTranscriptSegmentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProvisionalTranscriptSegmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.voice, voice) || other.voice == voice)&&(identical(other.text, text) || other.text == text)&&(identical(other.startSeconds, startSeconds) || other.startSeconds == startSeconds)&&(identical(other.endSeconds, endSeconds) || other.endSeconds == endSeconds)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode => Object.hash(runtimeType,id,voice,text,startSeconds,endSeconds,confidence);

@override
String toString() {
  return 'ProvisionalTranscriptSegmentEntity(id: $id, voice: $voice, text: $text, startSeconds: $startSeconds, endSeconds: $endSeconds, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$ProvisionalTranscriptSegmentEntityCopyWith<$Res> implements $ProvisionalTranscriptSegmentEntityCopyWith<$Res> {
  factory _$ProvisionalTranscriptSegmentEntityCopyWith(_ProvisionalTranscriptSegmentEntity value, $Res Function(_ProvisionalTranscriptSegmentEntity) _then) = __$ProvisionalTranscriptSegmentEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String voice, String text, double startSeconds, double endSeconds, double confidence
});




}
/// @nodoc
class __$ProvisionalTranscriptSegmentEntityCopyWithImpl<$Res>
    implements _$ProvisionalTranscriptSegmentEntityCopyWith<$Res> {
  __$ProvisionalTranscriptSegmentEntityCopyWithImpl(this._self, this._then);

  final _ProvisionalTranscriptSegmentEntity _self;
  final $Res Function(_ProvisionalTranscriptSegmentEntity) _then;

/// Create a copy of ProvisionalTranscriptSegmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? voice = null,Object? text = null,Object? startSeconds = null,Object? endSeconds = null,Object? confidence = null,}) {
  return _then(_ProvisionalTranscriptSegmentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,voice: null == voice ? _self.voice : voice // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,startSeconds: null == startSeconds ? _self.startSeconds : startSeconds // ignore: cast_nullable_to_non_nullable
as double,endSeconds: null == endSeconds ? _self.endSeconds : endSeconds // ignore: cast_nullable_to_non_nullable
as double,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
