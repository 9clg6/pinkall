// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'incoming_call_capability.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$IncomingCallCapabilityEntity {

 IncomingCallCapabilityStatus get status; IncomingCallPlatform get platform; IncomingCallTransport get transport; bool get tokenAvailable; bool get backgroundDeliveryReady; bool get nativeCallUiReady; List<String> get missingRequirements; String? get detail;
/// Create a copy of IncomingCallCapabilityEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomingCallCapabilityEntityCopyWith<IncomingCallCapabilityEntity> get copyWith => _$IncomingCallCapabilityEntityCopyWithImpl<IncomingCallCapabilityEntity>(this as IncomingCallCapabilityEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomingCallCapabilityEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.transport, transport) || other.transport == transport)&&(identical(other.tokenAvailable, tokenAvailable) || other.tokenAvailable == tokenAvailable)&&(identical(other.backgroundDeliveryReady, backgroundDeliveryReady) || other.backgroundDeliveryReady == backgroundDeliveryReady)&&(identical(other.nativeCallUiReady, nativeCallUiReady) || other.nativeCallUiReady == nativeCallUiReady)&&const DeepCollectionEquality().equals(other.missingRequirements, missingRequirements)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,status,platform,transport,tokenAvailable,backgroundDeliveryReady,nativeCallUiReady,const DeepCollectionEquality().hash(missingRequirements),detail);



}

/// @nodoc
abstract mixin class $IncomingCallCapabilityEntityCopyWith<$Res>  {
  factory $IncomingCallCapabilityEntityCopyWith(IncomingCallCapabilityEntity value, $Res Function(IncomingCallCapabilityEntity) _then) = _$IncomingCallCapabilityEntityCopyWithImpl;
@useResult
$Res call({
 IncomingCallCapabilityStatus status, IncomingCallPlatform platform, IncomingCallTransport transport, bool tokenAvailable, bool backgroundDeliveryReady, bool nativeCallUiReady, List<String> missingRequirements, String? detail
});




}
/// @nodoc
class _$IncomingCallCapabilityEntityCopyWithImpl<$Res>
    implements $IncomingCallCapabilityEntityCopyWith<$Res> {
  _$IncomingCallCapabilityEntityCopyWithImpl(this._self, this._then);

  final IncomingCallCapabilityEntity _self;
  final $Res Function(IncomingCallCapabilityEntity) _then;

/// Create a copy of IncomingCallCapabilityEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? platform = null,Object? transport = null,Object? tokenAvailable = null,Object? backgroundDeliveryReady = null,Object? nativeCallUiReady = null,Object? missingRequirements = null,Object? detail = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IncomingCallCapabilityStatus,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as IncomingCallPlatform,transport: null == transport ? _self.transport : transport // ignore: cast_nullable_to_non_nullable
as IncomingCallTransport,tokenAvailable: null == tokenAvailable ? _self.tokenAvailable : tokenAvailable // ignore: cast_nullable_to_non_nullable
as bool,backgroundDeliveryReady: null == backgroundDeliveryReady ? _self.backgroundDeliveryReady : backgroundDeliveryReady // ignore: cast_nullable_to_non_nullable
as bool,nativeCallUiReady: null == nativeCallUiReady ? _self.nativeCallUiReady : nativeCallUiReady // ignore: cast_nullable_to_non_nullable
as bool,missingRequirements: null == missingRequirements ? _self.missingRequirements : missingRequirements // ignore: cast_nullable_to_non_nullable
as List<String>,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [IncomingCallCapabilityEntity].
extension IncomingCallCapabilityEntityPatterns on IncomingCallCapabilityEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomingCallCapabilityEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomingCallCapabilityEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomingCallCapabilityEntity value)  $default,){
final _that = this;
switch (_that) {
case _IncomingCallCapabilityEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomingCallCapabilityEntity value)?  $default,){
final _that = this;
switch (_that) {
case _IncomingCallCapabilityEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( IncomingCallCapabilityStatus status,  IncomingCallPlatform platform,  IncomingCallTransport transport,  bool tokenAvailable,  bool backgroundDeliveryReady,  bool nativeCallUiReady,  List<String> missingRequirements,  String? detail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomingCallCapabilityEntity() when $default != null:
return $default(_that.status,_that.platform,_that.transport,_that.tokenAvailable,_that.backgroundDeliveryReady,_that.nativeCallUiReady,_that.missingRequirements,_that.detail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( IncomingCallCapabilityStatus status,  IncomingCallPlatform platform,  IncomingCallTransport transport,  bool tokenAvailable,  bool backgroundDeliveryReady,  bool nativeCallUiReady,  List<String> missingRequirements,  String? detail)  $default,) {final _that = this;
switch (_that) {
case _IncomingCallCapabilityEntity():
return $default(_that.status,_that.platform,_that.transport,_that.tokenAvailable,_that.backgroundDeliveryReady,_that.nativeCallUiReady,_that.missingRequirements,_that.detail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( IncomingCallCapabilityStatus status,  IncomingCallPlatform platform,  IncomingCallTransport transport,  bool tokenAvailable,  bool backgroundDeliveryReady,  bool nativeCallUiReady,  List<String> missingRequirements,  String? detail)?  $default,) {final _that = this;
switch (_that) {
case _IncomingCallCapabilityEntity() when $default != null:
return $default(_that.status,_that.platform,_that.transport,_that.tokenAvailable,_that.backgroundDeliveryReady,_that.nativeCallUiReady,_that.missingRequirements,_that.detail);case _:
  return null;

}
}

}

/// @nodoc


class _IncomingCallCapabilityEntity extends IncomingCallCapabilityEntity {
  const _IncomingCallCapabilityEntity({required this.status, required this.platform, required this.transport, required this.tokenAvailable, required this.backgroundDeliveryReady, required this.nativeCallUiReady, required final  List<String> missingRequirements, this.detail}): _missingRequirements = missingRequirements,super._();


@override final  IncomingCallCapabilityStatus status;
@override final  IncomingCallPlatform platform;
@override final  IncomingCallTransport transport;
@override final  bool tokenAvailable;
@override final  bool backgroundDeliveryReady;
@override final  bool nativeCallUiReady;
 final  List<String> _missingRequirements;
@override List<String> get missingRequirements {
  if (_missingRequirements is EqualUnmodifiableListView) return _missingRequirements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missingRequirements);
}

@override final  String? detail;

/// Create a copy of IncomingCallCapabilityEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomingCallCapabilityEntityCopyWith<_IncomingCallCapabilityEntity> get copyWith => __$IncomingCallCapabilityEntityCopyWithImpl<_IncomingCallCapabilityEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomingCallCapabilityEntity&&(identical(other.status, status) || other.status == status)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.transport, transport) || other.transport == transport)&&(identical(other.tokenAvailable, tokenAvailable) || other.tokenAvailable == tokenAvailable)&&(identical(other.backgroundDeliveryReady, backgroundDeliveryReady) || other.backgroundDeliveryReady == backgroundDeliveryReady)&&(identical(other.nativeCallUiReady, nativeCallUiReady) || other.nativeCallUiReady == nativeCallUiReady)&&const DeepCollectionEquality().equals(other._missingRequirements, _missingRequirements)&&(identical(other.detail, detail) || other.detail == detail));
}


@override
int get hashCode => Object.hash(runtimeType,status,platform,transport,tokenAvailable,backgroundDeliveryReady,nativeCallUiReady,const DeepCollectionEquality().hash(_missingRequirements),detail);



}

/// @nodoc
abstract mixin class _$IncomingCallCapabilityEntityCopyWith<$Res> implements $IncomingCallCapabilityEntityCopyWith<$Res> {
  factory _$IncomingCallCapabilityEntityCopyWith(_IncomingCallCapabilityEntity value, $Res Function(_IncomingCallCapabilityEntity) _then) = __$IncomingCallCapabilityEntityCopyWithImpl;
@override @useResult
$Res call({
 IncomingCallCapabilityStatus status, IncomingCallPlatform platform, IncomingCallTransport transport, bool tokenAvailable, bool backgroundDeliveryReady, bool nativeCallUiReady, List<String> missingRequirements, String? detail
});




}
/// @nodoc
class __$IncomingCallCapabilityEntityCopyWithImpl<$Res>
    implements _$IncomingCallCapabilityEntityCopyWith<$Res> {
  __$IncomingCallCapabilityEntityCopyWithImpl(this._self, this._then);

  final _IncomingCallCapabilityEntity _self;
  final $Res Function(_IncomingCallCapabilityEntity) _then;

/// Create a copy of IncomingCallCapabilityEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? platform = null,Object? transport = null,Object? tokenAvailable = null,Object? backgroundDeliveryReady = null,Object? nativeCallUiReady = null,Object? missingRequirements = null,Object? detail = freezed,}) {
  return _then(_IncomingCallCapabilityEntity(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IncomingCallCapabilityStatus,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as IncomingCallPlatform,transport: null == transport ? _self.transport : transport // ignore: cast_nullable_to_non_nullable
as IncomingCallTransport,tokenAvailable: null == tokenAvailable ? _self.tokenAvailable : tokenAvailable // ignore: cast_nullable_to_non_nullable
as bool,backgroundDeliveryReady: null == backgroundDeliveryReady ? _self.backgroundDeliveryReady : backgroundDeliveryReady // ignore: cast_nullable_to_non_nullable
as bool,nativeCallUiReady: null == nativeCallUiReady ? _self.nativeCallUiReady : nativeCallUiReady // ignore: cast_nullable_to_non_nullable
as bool,missingRequirements: null == missingRequirements ? _self._missingRequirements : missingRequirements // ignore: cast_nullable_to_non_nullable
as List<String>,detail: freezed == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
