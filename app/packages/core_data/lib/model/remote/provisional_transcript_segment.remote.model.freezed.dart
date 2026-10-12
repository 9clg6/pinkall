// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provisional_transcript_segment.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProvisionalTranscriptSegmentRemoteModel {

 String get id; String get voice; String get text; double get startSeconds; double get endSeconds; double get confidence;
/// Create a copy of ProvisionalTranscriptSegmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProvisionalTranscriptSegmentRemoteModelCopyWith<ProvisionalTranscriptSegmentRemoteModel> get copyWith => _$ProvisionalTranscriptSegmentRemoteModelCopyWithImpl<ProvisionalTranscriptSegmentRemoteModel>(this as ProvisionalTranscriptSegmentRemoteModel, _$identity);

  /// Serializes this ProvisionalTranscriptSegmentRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProvisionalTranscriptSegmentRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.voice, voice) || other.voice == voice)&&(identical(other.text, text) || other.text == text)&&(identical(other.startSeconds, startSeconds) || other.startSeconds == startSeconds)&&(identical(other.endSeconds, endSeconds) || other.endSeconds == endSeconds)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,voice,text,startSeconds,endSeconds,confidence);

@override
String toString() {
  return 'ProvisionalTranscriptSegmentRemoteModel(id: $id, voice: $voice, text: $text, startSeconds: $startSeconds, endSeconds: $endSeconds, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $ProvisionalTranscriptSegmentRemoteModelCopyWith<$Res>  {
  factory $ProvisionalTranscriptSegmentRemoteModelCopyWith(ProvisionalTranscriptSegmentRemoteModel value, $Res Function(ProvisionalTranscriptSegmentRemoteModel) _then) = _$ProvisionalTranscriptSegmentRemoteModelCopyWithImpl;
@useResult
$Res call({
 String id, String voice, String text, double startSeconds, double endSeconds, double confidence
});




}
/// @nodoc
class _$ProvisionalTranscriptSegmentRemoteModelCopyWithImpl<$Res>
    implements $ProvisionalTranscriptSegmentRemoteModelCopyWith<$Res> {
  _$ProvisionalTranscriptSegmentRemoteModelCopyWithImpl(this._self, this._then);

  final ProvisionalTranscriptSegmentRemoteModel _self;
  final $Res Function(ProvisionalTranscriptSegmentRemoteModel) _then;

/// Create a copy of ProvisionalTranscriptSegmentRemoteModel
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


/// Adds pattern-matching-related methods to [ProvisionalTranscriptSegmentRemoteModel].
extension ProvisionalTranscriptSegmentRemoteModelPatterns on ProvisionalTranscriptSegmentRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProvisionalTranscriptSegmentRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProvisionalTranscriptSegmentRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProvisionalTranscriptSegmentRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _ProvisionalTranscriptSegmentRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProvisionalTranscriptSegmentRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProvisionalTranscriptSegmentRemoteModel() when $default != null:
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
case _ProvisionalTranscriptSegmentRemoteModel() when $default != null:
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
case _ProvisionalTranscriptSegmentRemoteModel():
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
case _ProvisionalTranscriptSegmentRemoteModel() when $default != null:
return $default(_that.id,_that.voice,_that.text,_that.startSeconds,_that.endSeconds,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ProvisionalTranscriptSegmentRemoteModel implements ProvisionalTranscriptSegmentRemoteModel {
  const _ProvisionalTranscriptSegmentRemoteModel({required this.id, required this.voice, required this.text, required this.startSeconds, required this.endSeconds, required this.confidence});
  factory _ProvisionalTranscriptSegmentRemoteModel.fromJson(Map<String, dynamic> json) => _$ProvisionalTranscriptSegmentRemoteModelFromJson(json);

@override final  String id;
@override final  String voice;
@override final  String text;
@override final  double startSeconds;
@override final  double endSeconds;
@override final  double confidence;

/// Create a copy of ProvisionalTranscriptSegmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProvisionalTranscriptSegmentRemoteModelCopyWith<_ProvisionalTranscriptSegmentRemoteModel> get copyWith => __$ProvisionalTranscriptSegmentRemoteModelCopyWithImpl<_ProvisionalTranscriptSegmentRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProvisionalTranscriptSegmentRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProvisionalTranscriptSegmentRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.voice, voice) || other.voice == voice)&&(identical(other.text, text) || other.text == text)&&(identical(other.startSeconds, startSeconds) || other.startSeconds == startSeconds)&&(identical(other.endSeconds, endSeconds) || other.endSeconds == endSeconds)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,voice,text,startSeconds,endSeconds,confidence);

@override
String toString() {
  return 'ProvisionalTranscriptSegmentRemoteModel(id: $id, voice: $voice, text: $text, startSeconds: $startSeconds, endSeconds: $endSeconds, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$ProvisionalTranscriptSegmentRemoteModelCopyWith<$Res> implements $ProvisionalTranscriptSegmentRemoteModelCopyWith<$Res> {
  factory _$ProvisionalTranscriptSegmentRemoteModelCopyWith(_ProvisionalTranscriptSegmentRemoteModel value, $Res Function(_ProvisionalTranscriptSegmentRemoteModel) _then) = __$ProvisionalTranscriptSegmentRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String voice, String text, double startSeconds, double endSeconds, double confidence
});




}
/// @nodoc
class __$ProvisionalTranscriptSegmentRemoteModelCopyWithImpl<$Res>
    implements _$ProvisionalTranscriptSegmentRemoteModelCopyWith<$Res> {
  __$ProvisionalTranscriptSegmentRemoteModelCopyWithImpl(this._self, this._then);

  final _ProvisionalTranscriptSegmentRemoteModel _self;
  final $Res Function(_ProvisionalTranscriptSegmentRemoteModel) _then;

/// Create a copy of ProvisionalTranscriptSegmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? voice = null,Object? text = null,Object? startSeconds = null,Object? endSeconds = null,Object? confidence = null,}) {
  return _then(_ProvisionalTranscriptSegmentRemoteModel(
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
