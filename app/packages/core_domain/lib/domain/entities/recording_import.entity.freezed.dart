// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recording_import.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecordingImportEntity {

 String get id; String get sessionId; RecordingImportStatus get status; bool get consentRequired; List<String> get acceptedMimeTypes; List<String> get voices; List<ProvisionalTranscriptSegmentEntity> get provisionalSegments; String? get uploadPath; int? get maxSizeBytes; int? get maxDurationSeconds; String? get failureCode; String? get failureReason; bool? get failureRetryable;
/// Create a copy of RecordingImportEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordingImportEntityCopyWith<RecordingImportEntity> get copyWith => _$RecordingImportEntityCopyWithImpl<RecordingImportEntity>(this as RecordingImportEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordingImportEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.consentRequired, consentRequired) || other.consentRequired == consentRequired)&&const DeepCollectionEquality().equals(other.acceptedMimeTypes, acceptedMimeTypes)&&const DeepCollectionEquality().equals(other.voices, voices)&&const DeepCollectionEquality().equals(other.provisionalSegments, provisionalSegments)&&(identical(other.uploadPath, uploadPath) || other.uploadPath == uploadPath)&&(identical(other.maxSizeBytes, maxSizeBytes) || other.maxSizeBytes == maxSizeBytes)&&(identical(other.maxDurationSeconds, maxDurationSeconds) || other.maxDurationSeconds == maxDurationSeconds)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.failureRetryable, failureRetryable) || other.failureRetryable == failureRetryable));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,status,consentRequired,const DeepCollectionEquality().hash(acceptedMimeTypes),const DeepCollectionEquality().hash(voices),const DeepCollectionEquality().hash(provisionalSegments),uploadPath,maxSizeBytes,maxDurationSeconds,failureCode,failureReason,failureRetryable);

@override
String toString() {
  return 'RecordingImportEntity(id: $id, sessionId: $sessionId, status: $status, consentRequired: $consentRequired, acceptedMimeTypes: $acceptedMimeTypes, voices: $voices, provisionalSegments: $provisionalSegments, uploadPath: $uploadPath, maxSizeBytes: $maxSizeBytes, maxDurationSeconds: $maxDurationSeconds, failureCode: $failureCode, failureReason: $failureReason, failureRetryable: $failureRetryable)';
}


}

/// @nodoc
abstract mixin class $RecordingImportEntityCopyWith<$Res>  {
  factory $RecordingImportEntityCopyWith(RecordingImportEntity value, $Res Function(RecordingImportEntity) _then) = _$RecordingImportEntityCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, RecordingImportStatus status, bool consentRequired, List<String> acceptedMimeTypes, List<String> voices, List<ProvisionalTranscriptSegmentEntity> provisionalSegments, String? uploadPath, int? maxSizeBytes, int? maxDurationSeconds, String? failureCode, String? failureReason, bool? failureRetryable
});




}
/// @nodoc
class _$RecordingImportEntityCopyWithImpl<$Res>
    implements $RecordingImportEntityCopyWith<$Res> {
  _$RecordingImportEntityCopyWithImpl(this._self, this._then);

  final RecordingImportEntity _self;
  final $Res Function(RecordingImportEntity) _then;

/// Create a copy of RecordingImportEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? status = null,Object? consentRequired = null,Object? acceptedMimeTypes = null,Object? voices = null,Object? provisionalSegments = null,Object? uploadPath = freezed,Object? maxSizeBytes = freezed,Object? maxDurationSeconds = freezed,Object? failureCode = freezed,Object? failureReason = freezed,Object? failureRetryable = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecordingImportStatus,consentRequired: null == consentRequired ? _self.consentRequired : consentRequired // ignore: cast_nullable_to_non_nullable
as bool,acceptedMimeTypes: null == acceptedMimeTypes ? _self.acceptedMimeTypes : acceptedMimeTypes // ignore: cast_nullable_to_non_nullable
as List<String>,voices: null == voices ? _self.voices : voices // ignore: cast_nullable_to_non_nullable
as List<String>,provisionalSegments: null == provisionalSegments ? _self.provisionalSegments : provisionalSegments // ignore: cast_nullable_to_non_nullable
as List<ProvisionalTranscriptSegmentEntity>,uploadPath: freezed == uploadPath ? _self.uploadPath : uploadPath // ignore: cast_nullable_to_non_nullable
as String?,maxSizeBytes: freezed == maxSizeBytes ? _self.maxSizeBytes : maxSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,maxDurationSeconds: freezed == maxDurationSeconds ? _self.maxDurationSeconds : maxDurationSeconds // ignore: cast_nullable_to_non_nullable
as int?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as String?,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,failureRetryable: freezed == failureRetryable ? _self.failureRetryable : failureRetryable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordingImportEntity].
extension RecordingImportEntityPatterns on RecordingImportEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordingImportEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordingImportEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordingImportEntity value)  $default,){
final _that = this;
switch (_that) {
case _RecordingImportEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordingImportEntity value)?  $default,){
final _that = this;
switch (_that) {
case _RecordingImportEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  RecordingImportStatus status,  bool consentRequired,  List<String> acceptedMimeTypes,  List<String> voices,  List<ProvisionalTranscriptSegmentEntity> provisionalSegments,  String? uploadPath,  int? maxSizeBytes,  int? maxDurationSeconds,  String? failureCode,  String? failureReason,  bool? failureRetryable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordingImportEntity() when $default != null:
return $default(_that.id,_that.sessionId,_that.status,_that.consentRequired,_that.acceptedMimeTypes,_that.voices,_that.provisionalSegments,_that.uploadPath,_that.maxSizeBytes,_that.maxDurationSeconds,_that.failureCode,_that.failureReason,_that.failureRetryable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  RecordingImportStatus status,  bool consentRequired,  List<String> acceptedMimeTypes,  List<String> voices,  List<ProvisionalTranscriptSegmentEntity> provisionalSegments,  String? uploadPath,  int? maxSizeBytes,  int? maxDurationSeconds,  String? failureCode,  String? failureReason,  bool? failureRetryable)  $default,) {final _that = this;
switch (_that) {
case _RecordingImportEntity():
return $default(_that.id,_that.sessionId,_that.status,_that.consentRequired,_that.acceptedMimeTypes,_that.voices,_that.provisionalSegments,_that.uploadPath,_that.maxSizeBytes,_that.maxDurationSeconds,_that.failureCode,_that.failureReason,_that.failureRetryable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  RecordingImportStatus status,  bool consentRequired,  List<String> acceptedMimeTypes,  List<String> voices,  List<ProvisionalTranscriptSegmentEntity> provisionalSegments,  String? uploadPath,  int? maxSizeBytes,  int? maxDurationSeconds,  String? failureCode,  String? failureReason,  bool? failureRetryable)?  $default,) {final _that = this;
switch (_that) {
case _RecordingImportEntity() when $default != null:
return $default(_that.id,_that.sessionId,_that.status,_that.consentRequired,_that.acceptedMimeTypes,_that.voices,_that.provisionalSegments,_that.uploadPath,_that.maxSizeBytes,_that.maxDurationSeconds,_that.failureCode,_that.failureReason,_that.failureRetryable);case _:
  return null;

}
}

}

/// @nodoc


class _RecordingImportEntity implements RecordingImportEntity {
  const _RecordingImportEntity({required this.id, required this.sessionId, required this.status, this.consentRequired = true, final  List<String> acceptedMimeTypes = const <String>[], final  List<String> voices = const <String>[], final  List<ProvisionalTranscriptSegmentEntity> provisionalSegments = const <ProvisionalTranscriptSegmentEntity>[], this.uploadPath, this.maxSizeBytes, this.maxDurationSeconds, this.failureCode, this.failureReason, this.failureRetryable}): _acceptedMimeTypes = acceptedMimeTypes,_voices = voices,_provisionalSegments = provisionalSegments;
  

@override final  String id;
@override final  String sessionId;
@override final  RecordingImportStatus status;
@override@JsonKey() final  bool consentRequired;
 final  List<String> _acceptedMimeTypes;
@override@JsonKey() List<String> get acceptedMimeTypes {
  if (_acceptedMimeTypes is EqualUnmodifiableListView) return _acceptedMimeTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_acceptedMimeTypes);
}

 final  List<String> _voices;
@override@JsonKey() List<String> get voices {
  if (_voices is EqualUnmodifiableListView) return _voices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_voices);
}

 final  List<ProvisionalTranscriptSegmentEntity> _provisionalSegments;
@override@JsonKey() List<ProvisionalTranscriptSegmentEntity> get provisionalSegments {
  if (_provisionalSegments is EqualUnmodifiableListView) return _provisionalSegments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_provisionalSegments);
}

@override final  String? uploadPath;
@override final  int? maxSizeBytes;
@override final  int? maxDurationSeconds;
@override final  String? failureCode;
@override final  String? failureReason;
@override final  bool? failureRetryable;

/// Create a copy of RecordingImportEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordingImportEntityCopyWith<_RecordingImportEntity> get copyWith => __$RecordingImportEntityCopyWithImpl<_RecordingImportEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordingImportEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.consentRequired, consentRequired) || other.consentRequired == consentRequired)&&const DeepCollectionEquality().equals(other._acceptedMimeTypes, _acceptedMimeTypes)&&const DeepCollectionEquality().equals(other._voices, _voices)&&const DeepCollectionEquality().equals(other._provisionalSegments, _provisionalSegments)&&(identical(other.uploadPath, uploadPath) || other.uploadPath == uploadPath)&&(identical(other.maxSizeBytes, maxSizeBytes) || other.maxSizeBytes == maxSizeBytes)&&(identical(other.maxDurationSeconds, maxDurationSeconds) || other.maxDurationSeconds == maxDurationSeconds)&&(identical(other.failureCode, failureCode) || other.failureCode == failureCode)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason)&&(identical(other.failureRetryable, failureRetryable) || other.failureRetryable == failureRetryable));
}


@override
int get hashCode => Object.hash(runtimeType,id,sessionId,status,consentRequired,const DeepCollectionEquality().hash(_acceptedMimeTypes),const DeepCollectionEquality().hash(_voices),const DeepCollectionEquality().hash(_provisionalSegments),uploadPath,maxSizeBytes,maxDurationSeconds,failureCode,failureReason,failureRetryable);

@override
String toString() {
  return 'RecordingImportEntity(id: $id, sessionId: $sessionId, status: $status, consentRequired: $consentRequired, acceptedMimeTypes: $acceptedMimeTypes, voices: $voices, provisionalSegments: $provisionalSegments, uploadPath: $uploadPath, maxSizeBytes: $maxSizeBytes, maxDurationSeconds: $maxDurationSeconds, failureCode: $failureCode, failureReason: $failureReason, failureRetryable: $failureRetryable)';
}


}

/// @nodoc
abstract mixin class _$RecordingImportEntityCopyWith<$Res> implements $RecordingImportEntityCopyWith<$Res> {
  factory _$RecordingImportEntityCopyWith(_RecordingImportEntity value, $Res Function(_RecordingImportEntity) _then) = __$RecordingImportEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, RecordingImportStatus status, bool consentRequired, List<String> acceptedMimeTypes, List<String> voices, List<ProvisionalTranscriptSegmentEntity> provisionalSegments, String? uploadPath, int? maxSizeBytes, int? maxDurationSeconds, String? failureCode, String? failureReason, bool? failureRetryable
});




}
/// @nodoc
class __$RecordingImportEntityCopyWithImpl<$Res>
    implements _$RecordingImportEntityCopyWith<$Res> {
  __$RecordingImportEntityCopyWithImpl(this._self, this._then);

  final _RecordingImportEntity _self;
  final $Res Function(_RecordingImportEntity) _then;

/// Create a copy of RecordingImportEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? status = null,Object? consentRequired = null,Object? acceptedMimeTypes = null,Object? voices = null,Object? provisionalSegments = null,Object? uploadPath = freezed,Object? maxSizeBytes = freezed,Object? maxDurationSeconds = freezed,Object? failureCode = freezed,Object? failureReason = freezed,Object? failureRetryable = freezed,}) {
  return _then(_RecordingImportEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecordingImportStatus,consentRequired: null == consentRequired ? _self.consentRequired : consentRequired // ignore: cast_nullable_to_non_nullable
as bool,acceptedMimeTypes: null == acceptedMimeTypes ? _self._acceptedMimeTypes : acceptedMimeTypes // ignore: cast_nullable_to_non_nullable
as List<String>,voices: null == voices ? _self._voices : voices // ignore: cast_nullable_to_non_nullable
as List<String>,provisionalSegments: null == provisionalSegments ? _self._provisionalSegments : provisionalSegments // ignore: cast_nullable_to_non_nullable
as List<ProvisionalTranscriptSegmentEntity>,uploadPath: freezed == uploadPath ? _self.uploadPath : uploadPath // ignore: cast_nullable_to_non_nullable
as String?,maxSizeBytes: freezed == maxSizeBytes ? _self.maxSizeBytes : maxSizeBytes // ignore: cast_nullable_to_non_nullable
as int?,maxDurationSeconds: freezed == maxDurationSeconds ? _self.maxDurationSeconds : maxDurationSeconds // ignore: cast_nullable_to_non_nullable
as int?,failureCode: freezed == failureCode ? _self.failureCode : failureCode // ignore: cast_nullable_to_non_nullable
as String?,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,failureRetryable: freezed == failureRetryable ? _self.failureRetryable : failureRetryable // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
