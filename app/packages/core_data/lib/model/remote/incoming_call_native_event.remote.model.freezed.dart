// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incoming_call_native_event.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IncomingCallNativeEventRemoteModel {

 String get type; String? get callId; String? get callerName; String? get callerNumber; String? get voiceSdkId;
/// Create a copy of IncomingCallNativeEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomingCallNativeEventRemoteModelCopyWith<IncomingCallNativeEventRemoteModel> get copyWith => _$IncomingCallNativeEventRemoteModelCopyWithImpl<IncomingCallNativeEventRemoteModel>(this as IncomingCallNativeEventRemoteModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomingCallNativeEventRemoteModel&&(identical(other.type, type) || other.type == type)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.callerNumber, callerNumber) || other.callerNumber == callerNumber)&&(identical(other.voiceSdkId, voiceSdkId) || other.voiceSdkId == voiceSdkId));
}


@override
int get hashCode => Object.hash(runtimeType,type,callId,callerName,callerNumber,voiceSdkId);

@override
String toString() {
  return 'IncomingCallNativeEventRemoteModel(type: $type, callId: $callId, callerName: $callerName, callerNumber: $callerNumber, voiceSdkId: $voiceSdkId)';
}


}

/// @nodoc
abstract mixin class $IncomingCallNativeEventRemoteModelCopyWith<$Res>  {
  factory $IncomingCallNativeEventRemoteModelCopyWith(IncomingCallNativeEventRemoteModel value, $Res Function(IncomingCallNativeEventRemoteModel) _then) = _$IncomingCallNativeEventRemoteModelCopyWithImpl;
@useResult
$Res call({
 String type, String? callId, String? callerName, String? callerNumber, String? voiceSdkId
});




}
/// @nodoc
class _$IncomingCallNativeEventRemoteModelCopyWithImpl<$Res>
    implements $IncomingCallNativeEventRemoteModelCopyWith<$Res> {
  _$IncomingCallNativeEventRemoteModelCopyWithImpl(this._self, this._then);

  final IncomingCallNativeEventRemoteModel _self;
  final $Res Function(IncomingCallNativeEventRemoteModel) _then;

/// Create a copy of IncomingCallNativeEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? callId = freezed,Object? callerName = freezed,Object? callerNumber = freezed,Object? voiceSdkId = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,callId: freezed == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String?,callerName: freezed == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String?,callerNumber: freezed == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String?,voiceSdkId: freezed == voiceSdkId ? _self.voiceSdkId : voiceSdkId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [IncomingCallNativeEventRemoteModel].
extension IncomingCallNativeEventRemoteModelPatterns on IncomingCallNativeEventRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomingCallNativeEventRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomingCallNativeEventRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomingCallNativeEventRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _IncomingCallNativeEventRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomingCallNativeEventRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _IncomingCallNativeEventRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String? callId,  String? callerName,  String? callerNumber,  String? voiceSdkId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomingCallNativeEventRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String? callId,  String? callerName,  String? callerNumber,  String? voiceSdkId)  $default,) {final _that = this;
switch (_that) {
case _IncomingCallNativeEventRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String? callId,  String? callerName,  String? callerNumber,  String? voiceSdkId)?  $default,) {final _that = this;
switch (_that) {
case _IncomingCallNativeEventRemoteModel() when $default != null:
return $default(_that.type,_that.callId,_that.callerName,_that.callerNumber,_that.voiceSdkId);case _:
  return null;

}
}

}

/// @nodoc


class _IncomingCallNativeEventRemoteModel implements IncomingCallNativeEventRemoteModel {
  const _IncomingCallNativeEventRemoteModel({required this.type, this.callId, this.callerName, this.callerNumber, this.voiceSdkId});


@override final  String type;
@override final  String? callId;
@override final  String? callerName;
@override final  String? callerNumber;
@override final  String? voiceSdkId;

/// Create a copy of IncomingCallNativeEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomingCallNativeEventRemoteModelCopyWith<_IncomingCallNativeEventRemoteModel> get copyWith => __$IncomingCallNativeEventRemoteModelCopyWithImpl<_IncomingCallNativeEventRemoteModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomingCallNativeEventRemoteModel&&(identical(other.type, type) || other.type == type)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.callerName, callerName) || other.callerName == callerName)&&(identical(other.callerNumber, callerNumber) || other.callerNumber == callerNumber)&&(identical(other.voiceSdkId, voiceSdkId) || other.voiceSdkId == voiceSdkId));
}


@override
int get hashCode => Object.hash(runtimeType,type,callId,callerName,callerNumber,voiceSdkId);

@override
String toString() {
  return 'IncomingCallNativeEventRemoteModel(type: $type, callId: $callId, callerName: $callerName, callerNumber: $callerNumber, voiceSdkId: $voiceSdkId)';
}


}

/// @nodoc
abstract mixin class _$IncomingCallNativeEventRemoteModelCopyWith<$Res> implements $IncomingCallNativeEventRemoteModelCopyWith<$Res> {
  factory _$IncomingCallNativeEventRemoteModelCopyWith(_IncomingCallNativeEventRemoteModel value, $Res Function(_IncomingCallNativeEventRemoteModel) _then) = __$IncomingCallNativeEventRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String type, String? callId, String? callerName, String? callerNumber, String? voiceSdkId
});




}
/// @nodoc
class __$IncomingCallNativeEventRemoteModelCopyWithImpl<$Res>
    implements _$IncomingCallNativeEventRemoteModelCopyWith<$Res> {
  __$IncomingCallNativeEventRemoteModelCopyWithImpl(this._self, this._then);

  final _IncomingCallNativeEventRemoteModel _self;
  final $Res Function(_IncomingCallNativeEventRemoteModel) _then;

/// Create a copy of IncomingCallNativeEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? callId = freezed,Object? callerName = freezed,Object? callerNumber = freezed,Object? voiceSdkId = freezed,}) {
  return _then(_IncomingCallNativeEventRemoteModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,callId: freezed == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String?,callerName: freezed == callerName ? _self.callerName : callerName // ignore: cast_nullable_to_non_nullable
as String?,callerNumber: freezed == callerNumber ? _self.callerNumber : callerNumber // ignore: cast_nullable_to_non_nullable
as String?,voiceSdkId: freezed == voiceSdkId ? _self.voiceSdkId : voiceSdkId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
