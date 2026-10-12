// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transcript_segment.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TranscriptSegmentRemoteModel {

 String get id; String get sessionId; int get sequence; String get speaker; String get text; DateTime get startedAt; bool get isFinal; DateTime? get endedAt; double? get confidence;
/// Create a copy of TranscriptSegmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptSegmentRemoteModelCopyWith<TranscriptSegmentRemoteModel> get copyWith => _$TranscriptSegmentRemoteModelCopyWithImpl<TranscriptSegmentRemoteModel>(this as TranscriptSegmentRemoteModel, _$identity);

  /// Serializes this TranscriptSegmentRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptSegmentRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.text, text) || other.text == text)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.isFinal, isFinal) || other.isFinal == isFinal)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,sequence,speaker,text,startedAt,isFinal,endedAt,confidence);

@override
String toString() {
  return 'TranscriptSegmentRemoteModel(id: $id, sessionId: $sessionId, sequence: $sequence, speaker: $speaker, text: $text, startedAt: $startedAt, isFinal: $isFinal, endedAt: $endedAt, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $TranscriptSegmentRemoteModelCopyWith<$Res>  {
  factory $TranscriptSegmentRemoteModelCopyWith(TranscriptSegmentRemoteModel value, $Res Function(TranscriptSegmentRemoteModel) _then) = _$TranscriptSegmentRemoteModelCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, int sequence, String speaker, String text, DateTime startedAt, bool isFinal, DateTime? endedAt, double? confidence
});




}
/// @nodoc
class _$TranscriptSegmentRemoteModelCopyWithImpl<$Res>
    implements $TranscriptSegmentRemoteModelCopyWith<$Res> {
  _$TranscriptSegmentRemoteModelCopyWithImpl(this._self, this._then);

  final TranscriptSegmentRemoteModel _self;
  final $Res Function(TranscriptSegmentRemoteModel) _then;

/// Create a copy of TranscriptSegmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? sequence = null,Object? speaker = null,Object? text = null,Object? startedAt = null,Object? isFinal = null,Object? endedAt = freezed,Object? confidence = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isFinal: null == isFinal ? _self.isFinal : isFinal // ignore: cast_nullable_to_non_nullable
as bool,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptSegmentRemoteModel].
extension TranscriptSegmentRemoteModelPatterns on TranscriptSegmentRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptSegmentRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptSegmentRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptSegmentRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptSegmentRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptSegmentRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptSegmentRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  int sequence,  String speaker,  String text,  DateTime startedAt,  bool isFinal,  DateTime? endedAt,  double? confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptSegmentRemoteModel() when $default != null:
return $default(_that.id,_that.sessionId,_that.sequence,_that.speaker,_that.text,_that.startedAt,_that.isFinal,_that.endedAt,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  int sequence,  String speaker,  String text,  DateTime startedAt,  bool isFinal,  DateTime? endedAt,  double? confidence)  $default,) {final _that = this;
switch (_that) {
case _TranscriptSegmentRemoteModel():
return $default(_that.id,_that.sessionId,_that.sequence,_that.speaker,_that.text,_that.startedAt,_that.isFinal,_that.endedAt,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  int sequence,  String speaker,  String text,  DateTime startedAt,  bool isFinal,  DateTime? endedAt,  double? confidence)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptSegmentRemoteModel() when $default != null:
return $default(_that.id,_that.sessionId,_that.sequence,_that.speaker,_that.text,_that.startedAt,_that.isFinal,_that.endedAt,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TranscriptSegmentRemoteModel implements TranscriptSegmentRemoteModel {
  const _TranscriptSegmentRemoteModel({required this.id, required this.sessionId, required this.sequence, required this.speaker, required this.text, required this.startedAt, required this.isFinal, this.endedAt, this.confidence});
  factory _TranscriptSegmentRemoteModel.fromJson(Map<String, dynamic> json) => _$TranscriptSegmentRemoteModelFromJson(json);

@override final  String id;
@override final  String sessionId;
@override final  int sequence;
@override final  String speaker;
@override final  String text;
@override final  DateTime startedAt;
@override final  bool isFinal;
@override final  DateTime? endedAt;
@override final  double? confidence;

/// Create a copy of TranscriptSegmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptSegmentRemoteModelCopyWith<_TranscriptSegmentRemoteModel> get copyWith => __$TranscriptSegmentRemoteModelCopyWithImpl<_TranscriptSegmentRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranscriptSegmentRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptSegmentRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.speaker, speaker) || other.speaker == speaker)&&(identical(other.text, text) || other.text == text)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.isFinal, isFinal) || other.isFinal == isFinal)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sessionId,sequence,speaker,text,startedAt,isFinal,endedAt,confidence);

@override
String toString() {
  return 'TranscriptSegmentRemoteModel(id: $id, sessionId: $sessionId, sequence: $sequence, speaker: $speaker, text: $text, startedAt: $startedAt, isFinal: $isFinal, endedAt: $endedAt, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$TranscriptSegmentRemoteModelCopyWith<$Res> implements $TranscriptSegmentRemoteModelCopyWith<$Res> {
  factory _$TranscriptSegmentRemoteModelCopyWith(_TranscriptSegmentRemoteModel value, $Res Function(_TranscriptSegmentRemoteModel) _then) = __$TranscriptSegmentRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, int sequence, String speaker, String text, DateTime startedAt, bool isFinal, DateTime? endedAt, double? confidence
});




}
/// @nodoc
class __$TranscriptSegmentRemoteModelCopyWithImpl<$Res>
    implements _$TranscriptSegmentRemoteModelCopyWith<$Res> {
  __$TranscriptSegmentRemoteModelCopyWithImpl(this._self, this._then);

  final _TranscriptSegmentRemoteModel _self;
  final $Res Function(_TranscriptSegmentRemoteModel) _then;

/// Create a copy of TranscriptSegmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? sequence = null,Object? speaker = null,Object? text = null,Object? startedAt = null,Object? isFinal = null,Object? endedAt = freezed,Object? confidence = freezed,}) {
  return _then(_TranscriptSegmentRemoteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,speaker: null == speaker ? _self.speaker : speaker // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isFinal: null == isFinal ? _self.isFinal : isFinal // ignore: cast_nullable_to_non_nullable
as bool,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
