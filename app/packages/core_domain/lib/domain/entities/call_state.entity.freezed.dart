// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_state.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallStateEntity {

 String get callId; CallDirection get direction; CallLifecycleStatus get status; String? get remoteName; String? get remoteNumber; bool get isMuted; bool get isSpeakerEnabled; String? get failureReason;
/// Create a copy of CallStateEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStateEntityCopyWith<CallStateEntity> get copyWith => _$CallStateEntityCopyWithImpl<CallStateEntity>(this as CallStateEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallStateEntity&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.remoteName, remoteName) || other.remoteName == remoteName)&&(identical(other.remoteNumber, remoteNumber) || other.remoteNumber == remoteNumber)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isSpeakerEnabled, isSpeakerEnabled) || other.isSpeakerEnabled == isSpeakerEnabled)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}


@override
int get hashCode => Object.hash(runtimeType,callId,direction,status,remoteName,remoteNumber,isMuted,isSpeakerEnabled,failureReason);

@override
String toString() {
  return 'CallStateEntity(callId: $callId, direction: $direction, status: $status, remoteName: $remoteName, remoteNumber: $remoteNumber, isMuted: $isMuted, isSpeakerEnabled: $isSpeakerEnabled, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class $CallStateEntityCopyWith<$Res>  {
  factory $CallStateEntityCopyWith(CallStateEntity value, $Res Function(CallStateEntity) _then) = _$CallStateEntityCopyWithImpl;
@useResult
$Res call({
 String callId, CallDirection direction, CallLifecycleStatus status, String? remoteName, String? remoteNumber, bool isMuted, bool isSpeakerEnabled, String? failureReason
});




}
/// @nodoc
class _$CallStateEntityCopyWithImpl<$Res>
    implements $CallStateEntityCopyWith<$Res> {
  _$CallStateEntityCopyWithImpl(this._self, this._then);

  final CallStateEntity _self;
  final $Res Function(CallStateEntity) _then;

/// Create a copy of CallStateEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? direction = null,Object? status = null,Object? remoteName = freezed,Object? remoteNumber = freezed,Object? isMuted = null,Object? isSpeakerEnabled = null,Object? failureReason = freezed,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as CallDirection,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CallLifecycleStatus,remoteName: freezed == remoteName ? _self.remoteName : remoteName // ignore: cast_nullable_to_non_nullable
as String?,remoteNumber: freezed == remoteNumber ? _self.remoteNumber : remoteNumber // ignore: cast_nullable_to_non_nullable
as String?,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isSpeakerEnabled: null == isSpeakerEnabled ? _self.isSpeakerEnabled : isSpeakerEnabled // ignore: cast_nullable_to_non_nullable
as bool,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallStateEntity].
extension CallStateEntityPatterns on CallStateEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallStateEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallStateEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallStateEntity value)  $default,){
final _that = this;
switch (_that) {
case _CallStateEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallStateEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CallStateEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  CallDirection direction,  CallLifecycleStatus status,  String? remoteName,  String? remoteNumber,  bool isMuted,  bool isSpeakerEnabled,  String? failureReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallStateEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  CallDirection direction,  CallLifecycleStatus status,  String? remoteName,  String? remoteNumber,  bool isMuted,  bool isSpeakerEnabled,  String? failureReason)  $default,) {final _that = this;
switch (_that) {
case _CallStateEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  CallDirection direction,  CallLifecycleStatus status,  String? remoteName,  String? remoteNumber,  bool isMuted,  bool isSpeakerEnabled,  String? failureReason)?  $default,) {final _that = this;
switch (_that) {
case _CallStateEntity() when $default != null:
return $default(_that.callId,_that.direction,_that.status,_that.remoteName,_that.remoteNumber,_that.isMuted,_that.isSpeakerEnabled,_that.failureReason);case _:
  return null;

}
}

}

/// @nodoc


class _CallStateEntity implements CallStateEntity {
  const _CallStateEntity({required this.callId, required this.direction, required this.status, this.remoteName, this.remoteNumber, this.isMuted = false, this.isSpeakerEnabled = false, this.failureReason});
  

@override final  String callId;
@override final  CallDirection direction;
@override final  CallLifecycleStatus status;
@override final  String? remoteName;
@override final  String? remoteNumber;
@override@JsonKey() final  bool isMuted;
@override@JsonKey() final  bool isSpeakerEnabled;
@override final  String? failureReason;

/// Create a copy of CallStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallStateEntityCopyWith<_CallStateEntity> get copyWith => __$CallStateEntityCopyWithImpl<_CallStateEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallStateEntity&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.remoteName, remoteName) || other.remoteName == remoteName)&&(identical(other.remoteNumber, remoteNumber) || other.remoteNumber == remoteNumber)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isSpeakerEnabled, isSpeakerEnabled) || other.isSpeakerEnabled == isSpeakerEnabled)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}


@override
int get hashCode => Object.hash(runtimeType,callId,direction,status,remoteName,remoteNumber,isMuted,isSpeakerEnabled,failureReason);

@override
String toString() {
  return 'CallStateEntity(callId: $callId, direction: $direction, status: $status, remoteName: $remoteName, remoteNumber: $remoteNumber, isMuted: $isMuted, isSpeakerEnabled: $isSpeakerEnabled, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class _$CallStateEntityCopyWith<$Res> implements $CallStateEntityCopyWith<$Res> {
  factory _$CallStateEntityCopyWith(_CallStateEntity value, $Res Function(_CallStateEntity) _then) = __$CallStateEntityCopyWithImpl;
@override @useResult
$Res call({
 String callId, CallDirection direction, CallLifecycleStatus status, String? remoteName, String? remoteNumber, bool isMuted, bool isSpeakerEnabled, String? failureReason
});




}
/// @nodoc
class __$CallStateEntityCopyWithImpl<$Res>
    implements _$CallStateEntityCopyWith<$Res> {
  __$CallStateEntityCopyWithImpl(this._self, this._then);

  final _CallStateEntity _self;
  final $Res Function(_CallStateEntity) _then;

/// Create a copy of CallStateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? direction = null,Object? status = null,Object? remoteName = freezed,Object? remoteNumber = freezed,Object? isMuted = null,Object? isSpeakerEnabled = null,Object? failureReason = freezed,}) {
  return _then(_CallStateEntity(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as CallDirection,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CallLifecycleStatus,remoteName: freezed == remoteName ? _self.remoteName : remoteName // ignore: cast_nullable_to_non_nullable
as String?,remoteNumber: freezed == remoteNumber ? _self.remoteNumber : remoteNumber // ignore: cast_nullable_to_non_nullable
as String?,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isSpeakerEnabled: null == isSpeakerEnabled ? _self.isSpeakerEnabled : isSpeakerEnabled // ignore: cast_nullable_to_non_nullable
as bool,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
