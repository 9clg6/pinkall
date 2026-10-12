// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'telnyx_call.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TelnyxCallRemoteModel {

 String get callId; String get direction; String get status; String? get remoteName; String? get remoteNumber; bool get isMuted; bool get isSpeakerEnabled; String? get failureReason;
/// Create a copy of TelnyxCallRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TelnyxCallRemoteModelCopyWith<TelnyxCallRemoteModel> get copyWith => _$TelnyxCallRemoteModelCopyWithImpl<TelnyxCallRemoteModel>(this as TelnyxCallRemoteModel, _$identity);

  /// Serializes this TelnyxCallRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TelnyxCallRemoteModel&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.remoteName, remoteName) || other.remoteName == remoteName)&&(identical(other.remoteNumber, remoteNumber) || other.remoteNumber == remoteNumber)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isSpeakerEnabled, isSpeakerEnabled) || other.isSpeakerEnabled == isSpeakerEnabled)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,direction,status,remoteName,remoteNumber,isMuted,isSpeakerEnabled,failureReason);

@override
String toString() {
  return 'TelnyxCallRemoteModel(callId: $callId, direction: $direction, status: $status, remoteName: $remoteName, remoteNumber: $remoteNumber, isMuted: $isMuted, isSpeakerEnabled: $isSpeakerEnabled, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class $TelnyxCallRemoteModelCopyWith<$Res>  {
  factory $TelnyxCallRemoteModelCopyWith(TelnyxCallRemoteModel value, $Res Function(TelnyxCallRemoteModel) _then) = _$TelnyxCallRemoteModelCopyWithImpl;
@useResult
$Res call({
 String callId, String direction, String status, String? remoteName, String? remoteNumber, bool isMuted, bool isSpeakerEnabled, String? failureReason
});




}
/// @nodoc
class _$TelnyxCallRemoteModelCopyWithImpl<$Res>
    implements $TelnyxCallRemoteModelCopyWith<$Res> {
  _$TelnyxCallRemoteModelCopyWithImpl(this._self, this._then);

  final TelnyxCallRemoteModel _self;
  final $Res Function(TelnyxCallRemoteModel) _then;

/// Create a copy of TelnyxCallRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? direction = null,Object? status = null,Object? remoteName = freezed,Object? remoteNumber = freezed,Object? isMuted = null,Object? isSpeakerEnabled = null,Object? failureReason = freezed,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,remoteName: freezed == remoteName ? _self.remoteName : remoteName // ignore: cast_nullable_to_non_nullable
as String?,remoteNumber: freezed == remoteNumber ? _self.remoteNumber : remoteNumber // ignore: cast_nullable_to_non_nullable
as String?,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isSpeakerEnabled: null == isSpeakerEnabled ? _self.isSpeakerEnabled : isSpeakerEnabled // ignore: cast_nullable_to_non_nullable
as bool,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TelnyxCallRemoteModel].
extension TelnyxCallRemoteModelPatterns on TelnyxCallRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TelnyxCallRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TelnyxCallRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TelnyxCallRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _TelnyxCallRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TelnyxCallRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _TelnyxCallRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String direction,  String status,  String? remoteName,  String? remoteNumber,  bool isMuted,  bool isSpeakerEnabled,  String? failureReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TelnyxCallRemoteModel() when $default != null:
return $default(_that.callId,_that.direction,_that.status,_that.remoteName,_that.remoteNumber,_that.isMuted,_that.isSpeakerEnabled,_that.failureReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String direction,  String status,  String? remoteName,  String? remoteNumber,  bool isMuted,  bool isSpeakerEnabled,  String? failureReason)  $default,) {final _that = this;
switch (_that) {
case _TelnyxCallRemoteModel():
return $default(_that.callId,_that.direction,_that.status,_that.remoteName,_that.remoteNumber,_that.isMuted,_that.isSpeakerEnabled,_that.failureReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String direction,  String status,  String? remoteName,  String? remoteNumber,  bool isMuted,  bool isSpeakerEnabled,  String? failureReason)?  $default,) {final _that = this;
switch (_that) {
case _TelnyxCallRemoteModel() when $default != null:
return $default(_that.callId,_that.direction,_that.status,_that.remoteName,_that.remoteNumber,_that.isMuted,_that.isSpeakerEnabled,_that.failureReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TelnyxCallRemoteModel implements TelnyxCallRemoteModel {
  const _TelnyxCallRemoteModel({required this.callId, required this.direction, required this.status, this.remoteName, this.remoteNumber, this.isMuted = false, this.isSpeakerEnabled = false, this.failureReason});
  factory _TelnyxCallRemoteModel.fromJson(Map<String, dynamic> json) => _$TelnyxCallRemoteModelFromJson(json);

@override final  String callId;
@override final  String direction;
@override final  String status;
@override final  String? remoteName;
@override final  String? remoteNumber;
@override@JsonKey() final  bool isMuted;
@override@JsonKey() final  bool isSpeakerEnabled;
@override final  String? failureReason;

/// Create a copy of TelnyxCallRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TelnyxCallRemoteModelCopyWith<_TelnyxCallRemoteModel> get copyWith => __$TelnyxCallRemoteModelCopyWithImpl<_TelnyxCallRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TelnyxCallRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TelnyxCallRemoteModel&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.remoteName, remoteName) || other.remoteName == remoteName)&&(identical(other.remoteNumber, remoteNumber) || other.remoteNumber == remoteNumber)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isSpeakerEnabled, isSpeakerEnabled) || other.isSpeakerEnabled == isSpeakerEnabled)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,direction,status,remoteName,remoteNumber,isMuted,isSpeakerEnabled,failureReason);

@override
String toString() {
  return 'TelnyxCallRemoteModel(callId: $callId, direction: $direction, status: $status, remoteName: $remoteName, remoteNumber: $remoteNumber, isMuted: $isMuted, isSpeakerEnabled: $isSpeakerEnabled, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class _$TelnyxCallRemoteModelCopyWith<$Res> implements $TelnyxCallRemoteModelCopyWith<$Res> {
  factory _$TelnyxCallRemoteModelCopyWith(_TelnyxCallRemoteModel value, $Res Function(_TelnyxCallRemoteModel) _then) = __$TelnyxCallRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String callId, String direction, String status, String? remoteName, String? remoteNumber, bool isMuted, bool isSpeakerEnabled, String? failureReason
});




}
/// @nodoc
class __$TelnyxCallRemoteModelCopyWithImpl<$Res>
    implements _$TelnyxCallRemoteModelCopyWith<$Res> {
  __$TelnyxCallRemoteModelCopyWithImpl(this._self, this._then);

  final _TelnyxCallRemoteModel _self;
  final $Res Function(_TelnyxCallRemoteModel) _then;

/// Create a copy of TelnyxCallRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? direction = null,Object? status = null,Object? remoteName = freezed,Object? remoteNumber = freezed,Object? isMuted = null,Object? isSpeakerEnabled = null,Object? failureReason = freezed,}) {
  return _then(_TelnyxCallRemoteModel(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,remoteName: freezed == remoteName ? _self.remoteName : remoteName // ignore: cast_nullable_to_non_nullable
as String?,remoteNumber: freezed == remoteNumber ? _self.remoteNumber : remoteNumber // ignore: cast_nullable_to_non_nullable
as String?,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isSpeakerEnabled: null == isSpeakerEnabled ? _self.isSpeakerEnabled : isSpeakerEnabled // ignore: cast_nullable_to_non_nullable
as bool,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
