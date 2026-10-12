// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incoming_call_native_event.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IncomingCallNativeEventEntity {

 IncomingCallNativeEventType get type; String? get callId; String? get callerName; String? get callerNumber; String? get voiceSdkId;
/// Create a copy of IncomingCallNativeEventEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomingCallNativeEventEntityCopyWith<IncomingCallNativeEventEntity> get copyWith => _$IncomingCallNativeEventEntityCopyWithImpl<IncomingCallNativeEventEntity>(this as IncomingCallNativeEventEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomingCallNativeEventEntity&&(identical(other.type, type) || other.type == type)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.callerNumber, callerNumber) || other.callerNumber == callerNumber)&&(identical(other.voiceSdkId, voiceSdkId) || other.voiceSdkId == voiceSdkId));
}


@override
int get hashCode => Object.hash(runtimeType,type,callId,callerName,callerNumber,voiceSdkId);

@override
String toString() {
  return 'IncomingCallNativeEventEntity(type: $type, callId: $callId, callerName: $callerName, callerNumber: $callerNumber, voiceSdkId: $voiceSdkId)';
}


}

/// @nodoc
abstract mixin class $IncomingCallNativeEventEntityCopyWith<$Res>  {
  factory $IncomingCallNativeEventEntityCopyWith(IncomingCallNativeEventEntity value, $Res Function(IncomingCallNativeEventEntity) _then) = _$IncomingCallNativeEventEntityCopyWithImpl;
@useResult
$Res call({
 IncomingCallNativeEventType type, String? callId, String? callerName, String? callerNumber, String? voiceSdkId
});




}
/// @nodoc
class _$IncomingCallNativeEventEntityCopyWithImpl<$Res>
    implements $IncomingCallNativeEventEntityCopyWith<$Res> {
  _$IncomingCallNativeEventEntityCopyWithImpl(this._self, this._then);

  final IncomingCallNativeEventEntity _self;
  final $Res Function(IncomingCallNativeEventEntity) _then;

/// Create a copy of IncomingCallNativeEventEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? callId = freezed,Object? callerName = freezed,Object? callerNumber = freezed,Object? voiceSdkId = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as IncomingCallNativeEventType,callId: freezed == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String?,callerName: freezed == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String?,callerNumber: freezed == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String?,voiceSdkId: freezed == voiceSdkId ? _self.voiceSdkId : voiceSdkId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [IncomingCallNativeEventEntity].
extension IncomingCallNativeEventEntityPatterns on IncomingCallNativeEventEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomingCallNativeEventEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomingCallNativeEventEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomingCallNativeEventEntity value)  $default,){
final _that = this;
switch (_that) {
case _IncomingCallNativeEventEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomingCallNativeEventEntity value)?  $default,){
final _that = this;
switch (_that) {
case _IncomingCallNativeEventEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IncomingCallNativeEventType type,  String? callId,  String? callerName,  String? callerNumber,  String? voiceSdkId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomingCallNativeEventEntity() when $default != null:
return $default(_that.type,_that.callId,_that.callerName,_that.callerNumber,_that.voiceSdkId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IncomingCallNativeEventType type,  String? callId,  String? callerName,  String? callerNumber,  String? voiceSdkId)  $default,) {final _that = this;
switch (_that) {
case _IncomingCallNativeEventEntity():
return $default(_that.type,_that.callId,_that.callerName,_that.callerNumber,_that.voiceSdkId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IncomingCallNativeEventType type,  String? callId,  String? callerName,  String? callerNumber,  String? voiceSdkId)?  $default,) {final _that = this;
switch (_that) {
case _IncomingCallNativeEventEntity() when $default != null:
return $default(_that.type,_that.callId,_that.callerName,_that.callerNumber,_that.voiceSdkId);case _:
  return null;

}
}

}

/// @nodoc


class _IncomingCallNativeEventEntity implements IncomingCallNativeEventEntity {
  const _IncomingCallNativeEventEntity({required this.type, this.callId, this.callerName, this.callerNumber, this.voiceSdkId});


@override final  IncomingCallNativeEventType type;
@override final  String? callId;
@override final  String? callerName;
@override final  String? callerNumber;
@override final  String? voiceSdkId;

/// Create a copy of IncomingCallNativeEventEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomingCallNativeEventEntityCopyWith<_IncomingCallNativeEventEntity> get copyWith => __$IncomingCallNativeEventEntityCopyWithImpl<_IncomingCallNativeEventEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomingCallNativeEventEntity&&(identical(other.type, type) || other.type == type)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.callerNumber, callerNumber) || other.callerNumber == callerNumber)&&(identical(other.voiceSdkId, voiceSdkId) || other.voiceSdkId == voiceSdkId));
}


@override
int get hashCode => Object.hash(runtimeType,type,callId,callerName,callerNumber,voiceSdkId);

@override
String toString() {
  return 'IncomingCallNativeEventEntity(type: $type, callId: $callId, callerName: $callerName, callerNumber: $callerNumber, voiceSdkId: $voiceSdkId)';
}


}

/// @nodoc
abstract mixin class _$IncomingCallNativeEventEntityCopyWith<$Res> implements $IncomingCallNativeEventEntityCopyWith<$Res> {
  factory _$IncomingCallNativeEventEntityCopyWith(_IncomingCallNativeEventEntity value, $Res Function(_IncomingCallNativeEventEntity) _then) = __$IncomingCallNativeEventEntityCopyWithImpl;
@override @useResult
$Res call({
 IncomingCallNativeEventType type, String? callId, String? callerName, String? callerNumber, String? voiceSdkId
});




}
/// @nodoc
class __$IncomingCallNativeEventEntityCopyWithImpl<$Res>
    implements _$IncomingCallNativeEventEntityCopyWith<$Res> {
  __$IncomingCallNativeEventEntityCopyWithImpl(this._self, this._then);

  final _IncomingCallNativeEventEntity _self;
  final $Res Function(_IncomingCallNativeEventEntity) _then;

/// Create a copy of IncomingCallNativeEventEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? callId = freezed,Object? callerName = freezed,Object? callerNumber = freezed,Object? voiceSdkId = freezed,}) {
  return _then(_IncomingCallNativeEventEntity(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as IncomingCallNativeEventType,callId: freezed == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String?,callerName: freezed == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String?,callerNumber: freezed == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String?,voiceSdkId: freezed == voiceSdkId ? _self.voiceSdkId : voiceSdkId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
