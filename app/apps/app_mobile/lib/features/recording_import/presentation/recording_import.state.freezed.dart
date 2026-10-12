// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recording_import.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecordingImportState {

 RecordingImportStage get stage; String? get fileName; String? get filePath; String? get mimeType; int? get sizeBytes; String? get nativeImportId; RecordingImportEntity? get remoteImport; String? get selectedVoice; String? get errorMessage;
/// Create a copy of RecordingImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordingImportStateCopyWith<RecordingImportState> get copyWith => _$RecordingImportStateCopyWithImpl<RecordingImportState>(this as RecordingImportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordingImportState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.nativeImportId, nativeImportId) || other.nativeImportId == nativeImportId)&&(identical(other.remoteImport, remoteImport) || other.remoteImport == remoteImport)&&(identical(other.selectedVoice, selectedVoice) || other.selectedVoice == selectedVoice)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,stage,fileName,filePath,mimeType,sizeBytes,nativeImportId,remoteImport,selectedVoice,errorMessage);

@override
String toString() {
  return 'RecordingImportState(stage: $stage, fileName: $fileName, filePath: $filePath, mimeType: $mimeType, sizeBytes: $sizeBytes, nativeImportId: $nativeImportId, remoteImport: $remoteImport, selectedVoice: $selectedVoice, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $RecordingImportStateCopyWith<$Res>  {
  factory $RecordingImportStateCopyWith(RecordingImportState value, $Res Function(RecordingImportState) _then) = _$RecordingImportStateCopyWithImpl;
@useResult
$Res call({
 RecordingImportStage stage, String? fileName, String? filePath, String? mimeType, int? sizeBytes, String? nativeImportId, RecordingImportEntity? remoteImport, String? selectedVoice, String? errorMessage
});


$RecordingImportEntityCopyWith<$Res>? get remoteImport;

}
/// @nodoc
class _$RecordingImportStateCopyWithImpl<$Res>
    implements $RecordingImportStateCopyWith<$Res> {
  _$RecordingImportStateCopyWithImpl(this._self, this._then);

  final RecordingImportState _self;
  final $Res Function(RecordingImportState) _then;

/// Create a copy of RecordingImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? fileName = freezed,Object? filePath = freezed,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? nativeImportId = freezed,Object? remoteImport = freezed,Object? selectedVoice = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as RecordingImportStage,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,nativeImportId: freezed == nativeImportId ? _self.nativeImportId : nativeImportId // ignore: cast_nullable_to_non_nullable
as String?,remoteImport: freezed == remoteImport ? _self.remoteImport : remoteImport // ignore: cast_nullable_to_non_nullable
as RecordingImportEntity?,selectedVoice: freezed == selectedVoice ? _self.selectedVoice : selectedVoice // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RecordingImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecordingImportEntityCopyWith<$Res>? get remoteImport {
    if (_self.remoteImport == null) {
    return null;
  }

  return $RecordingImportEntityCopyWith<$Res>(_self.remoteImport!, (value) {
    return _then(_self.copyWith(remoteImport: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecordingImportState].
extension RecordingImportStatePatterns on RecordingImportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordingImportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordingImportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordingImportState value)  $default,){
final _that = this;
switch (_that) {
case _RecordingImportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordingImportState value)?  $default,){
final _that = this;
switch (_that) {
case _RecordingImportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecordingImportStage stage,  String? fileName,  String? filePath,  String? mimeType,  int? sizeBytes,  String? nativeImportId,  RecordingImportEntity? remoteImport,  String? selectedVoice,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordingImportState() when $default != null:
return $default(_that.stage,_that.fileName,_that.filePath,_that.mimeType,_that.sizeBytes,_that.nativeImportId,_that.remoteImport,_that.selectedVoice,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecordingImportStage stage,  String? fileName,  String? filePath,  String? mimeType,  int? sizeBytes,  String? nativeImportId,  RecordingImportEntity? remoteImport,  String? selectedVoice,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _RecordingImportState():
return $default(_that.stage,_that.fileName,_that.filePath,_that.mimeType,_that.sizeBytes,_that.nativeImportId,_that.remoteImport,_that.selectedVoice,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecordingImportStage stage,  String? fileName,  String? filePath,  String? mimeType,  int? sizeBytes,  String? nativeImportId,  RecordingImportEntity? remoteImport,  String? selectedVoice,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _RecordingImportState() when $default != null:
return $default(_that.stage,_that.fileName,_that.filePath,_that.mimeType,_that.sizeBytes,_that.nativeImportId,_that.remoteImport,_that.selectedVoice,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _RecordingImportState implements RecordingImportState {
  const _RecordingImportState({this.stage = RecordingImportStage.selecting, this.fileName, this.filePath, this.mimeType, this.sizeBytes, this.nativeImportId, this.remoteImport, this.selectedVoice, this.errorMessage});
  

@override@JsonKey() final  RecordingImportStage stage;
@override final  String? fileName;
@override final  String? filePath;
@override final  String? mimeType;
@override final  int? sizeBytes;
@override final  String? nativeImportId;
@override final  RecordingImportEntity? remoteImport;
@override final  String? selectedVoice;
@override final  String? errorMessage;

/// Create a copy of RecordingImportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordingImportStateCopyWith<_RecordingImportState> get copyWith => __$RecordingImportStateCopyWithImpl<_RecordingImportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordingImportState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.nativeImportId, nativeImportId) || other.nativeImportId == nativeImportId)&&(identical(other.remoteImport, remoteImport) || other.remoteImport == remoteImport)&&(identical(other.selectedVoice, selectedVoice) || other.selectedVoice == selectedVoice)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,stage,fileName,filePath,mimeType,sizeBytes,nativeImportId,remoteImport,selectedVoice,errorMessage);

@override
String toString() {
  return 'RecordingImportState(stage: $stage, fileName: $fileName, filePath: $filePath, mimeType: $mimeType, sizeBytes: $sizeBytes, nativeImportId: $nativeImportId, remoteImport: $remoteImport, selectedVoice: $selectedVoice, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$RecordingImportStateCopyWith<$Res> implements $RecordingImportStateCopyWith<$Res> {
  factory _$RecordingImportStateCopyWith(_RecordingImportState value, $Res Function(_RecordingImportState) _then) = __$RecordingImportStateCopyWithImpl;
@override @useResult
$Res call({
 RecordingImportStage stage, String? fileName, String? filePath, String? mimeType, int? sizeBytes, String? nativeImportId, RecordingImportEntity? remoteImport, String? selectedVoice, String? errorMessage
});


@override $RecordingImportEntityCopyWith<$Res>? get remoteImport;

}
/// @nodoc
class __$RecordingImportStateCopyWithImpl<$Res>
    implements _$RecordingImportStateCopyWith<$Res> {
  __$RecordingImportStateCopyWithImpl(this._self, this._then);

  final _RecordingImportState _self;
  final $Res Function(_RecordingImportState) _then;

/// Create a copy of RecordingImportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? fileName = freezed,Object? filePath = freezed,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? nativeImportId = freezed,Object? remoteImport = freezed,Object? selectedVoice = freezed,Object? errorMessage = freezed,}) {
  return _then(_RecordingImportState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as RecordingImportStage,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,filePath: freezed == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,nativeImportId: freezed == nativeImportId ? _self.nativeImportId : nativeImportId // ignore: cast_nullable_to_non_nullable
as String?,remoteImport: freezed == remoteImport ? _self.remoteImport : remoteImport // ignore: cast_nullable_to_non_nullable
as RecordingImportEntity?,selectedVoice: freezed == selectedVoice ? _self.selectedVoice : selectedVoice // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RecordingImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecordingImportEntityCopyWith<$Res>? get remoteImport {
    if (_self.remoteImport == null) {
    return null;
  }

  return $RecordingImportEntityCopyWith<$Res>(_self.remoteImport!, (value) {
    return _then(_self.copyWith(remoteImport: value));
  });
}
}

// dart format on
