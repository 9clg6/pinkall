// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_home.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallHomeState {

 TelnyxConnectionStateEntity get connection; CallStateEntity? get incomingCall; CallStateEntity? get lastCall; List<ConversationSessionEntity> get activeBackendSessions; CoachMode get coachMode; bool get isBackendConfigured; bool get manualTelnyxAuthEnabled; IncomingCallCapabilityEntity get incomingCallCapability; bool get isCheckingIncomingCallCapability; bool get isOperating; String? get operationFailure; String? get backendFailure;
/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallHomeStateCopyWith<CallHomeState> get copyWith => _$CallHomeStateCopyWithImpl<CallHomeState>(this as CallHomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallHomeState&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.incomingCall, incomingCall) || other.incomingCall == incomingCall)&&(identical(other.lastCall, lastCall) || other.lastCall == lastCall)&&const DeepCollectionEquality().equals(other.activeBackendSessions, activeBackendSessions)&&(identical(other.coachMode, coachMode) || other.coachMode == coachMode)&&(identical(other.isBackendConfigured, isBackendConfigured) || other.isBackendConfigured == isBackendConfigured)&&(identical(other.manualTelnyxAuthEnabled, manualTelnyxAuthEnabled) || other.manualTelnyxAuthEnabled == manualTelnyxAuthEnabled)&&(identical(other.incomingCallCapability, incomingCallCapability) || other.incomingCallCapability == incomingCallCapability)&&(identical(other.isCheckingIncomingCallCapability, isCheckingIncomingCallCapability) || other.isCheckingIncomingCallCapability == isCheckingIncomingCallCapability)&&(identical(other.isOperating, isOperating) || other.isOperating == isOperating)&&(identical(other.operationFailure, operationFailure) || other.operationFailure == operationFailure)&&(identical(other.backendFailure, backendFailure) || other.backendFailure == backendFailure));
}


@override
int get hashCode => Object.hash(runtimeType,connection,incomingCall,lastCall,const DeepCollectionEquality().hash(activeBackendSessions),coachMode,isBackendConfigured,manualTelnyxAuthEnabled,incomingCallCapability,isCheckingIncomingCallCapability,isOperating,operationFailure,backendFailure);

@override
String toString() {
  return 'CallHomeState(connection: $connection, incomingCall: $incomingCall, lastCall: $lastCall, activeBackendSessions: $activeBackendSessions, coachMode: $coachMode, isBackendConfigured: $isBackendConfigured, manualTelnyxAuthEnabled: $manualTelnyxAuthEnabled, incomingCallCapability: $incomingCallCapability, isCheckingIncomingCallCapability: $isCheckingIncomingCallCapability, isOperating: $isOperating, operationFailure: $operationFailure, backendFailure: $backendFailure)';
}


}

/// @nodoc
abstract mixin class $CallHomeStateCopyWith<$Res>  {
  factory $CallHomeStateCopyWith(CallHomeState value, $Res Function(CallHomeState) _then) = _$CallHomeStateCopyWithImpl;
@useResult
$Res call({
 TelnyxConnectionStateEntity connection, CallStateEntity? incomingCall, CallStateEntity? lastCall, List<ConversationSessionEntity> activeBackendSessions, CoachMode coachMode, bool isBackendConfigured, bool manualTelnyxAuthEnabled, IncomingCallCapabilityEntity incomingCallCapability, bool isCheckingIncomingCallCapability, bool isOperating, String? operationFailure, String? backendFailure
});


$TelnyxConnectionStateEntityCopyWith<$Res> get connection;$CallStateEntityCopyWith<$Res>? get incomingCall;$CallStateEntityCopyWith<$Res>? get lastCall;$IncomingCallCapabilityEntityCopyWith<$Res> get incomingCallCapability;

}
/// @nodoc
class _$CallHomeStateCopyWithImpl<$Res>
    implements $CallHomeStateCopyWith<$Res> {
  _$CallHomeStateCopyWithImpl(this._self, this._then);

  final CallHomeState _self;
  final $Res Function(CallHomeState) _then;

/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connection = null,Object? incomingCall = freezed,Object? lastCall = freezed,Object? activeBackendSessions = null,Object? coachMode = null,Object? isBackendConfigured = null,Object? manualTelnyxAuthEnabled = null,Object? incomingCallCapability = null,Object? isCheckingIncomingCallCapability = null,Object? isOperating = null,Object? operationFailure = freezed,Object? backendFailure = freezed,}) {
  return _then(_self.copyWith(
connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as TelnyxConnectionStateEntity,incomingCall: freezed == incomingCall ? _self.incomingCall : incomingCall // ignore: cast_nullable_to_non_nullable
as CallStateEntity?,lastCall: freezed == lastCall ? _self.lastCall : lastCall // ignore: cast_nullable_to_non_nullable
as CallStateEntity?,activeBackendSessions: null == activeBackendSessions ? _self.activeBackendSessions : activeBackendSessions // ignore: cast_nullable_to_non_nullable
as List<ConversationSessionEntity>,coachMode: null == coachMode ? _self.coachMode : coachMode // ignore: cast_nullable_to_non_nullable
as CoachMode,isBackendConfigured: null == isBackendConfigured ? _self.isBackendConfigured : isBackendConfigured // ignore: cast_nullable_to_non_nullable
as bool,manualTelnyxAuthEnabled: null == manualTelnyxAuthEnabled ? _self.manualTelnyxAuthEnabled : manualTelnyxAuthEnabled // ignore: cast_nullable_to_non_nullable
as bool,incomingCallCapability: null == incomingCallCapability ? _self.incomingCallCapability : incomingCallCapability // ignore: cast_nullable_to_non_nullable
as IncomingCallCapabilityEntity,isCheckingIncomingCallCapability: null == isCheckingIncomingCallCapability ? _self.isCheckingIncomingCallCapability : isCheckingIncomingCallCapability // ignore: cast_nullable_to_non_nullable
as bool,isOperating: null == isOperating ? _self.isOperating : isOperating // ignore: cast_nullable_to_non_nullable
as bool,operationFailure: freezed == operationFailure ? _self.operationFailure : operationFailure // ignore: cast_nullable_to_non_nullable
as String?,backendFailure: freezed == backendFailure ? _self.backendFailure : backendFailure // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TelnyxConnectionStateEntityCopyWith<$Res> get connection {

  return $TelnyxConnectionStateEntityCopyWith<$Res>(_self.connection, (value) {
    return _then(_self.copyWith(connection: value));
  });
}/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallStateEntityCopyWith<$Res>? get incomingCall {
    if (_self.incomingCall == null) {
    return null;
  }

  return $CallStateEntityCopyWith<$Res>(_self.incomingCall!, (value) {
    return _then(_self.copyWith(incomingCall: value));
  });
}/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallStateEntityCopyWith<$Res>? get lastCall {
    if (_self.lastCall == null) {
    return null;
  }

  return $CallStateEntityCopyWith<$Res>(_self.lastCall!, (value) {
    return _then(_self.copyWith(lastCall: value));
  });
}/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IncomingCallCapabilityEntityCopyWith<$Res> get incomingCallCapability {

  return $IncomingCallCapabilityEntityCopyWith<$Res>(_self.incomingCallCapability, (value) {
    return _then(_self.copyWith(incomingCallCapability: value));
  });
}
}


/// Adds pattern-matching-related methods to [CallHomeState].
extension CallHomeStatePatterns on CallHomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallHomeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallHomeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallHomeState value)  $default,){
final _that = this;
switch (_that) {
case _CallHomeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallHomeState value)?  $default,){
final _that = this;
switch (_that) {
case _CallHomeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TelnyxConnectionStateEntity connection,  CallStateEntity? incomingCall,  CallStateEntity? lastCall,  List<ConversationSessionEntity> activeBackendSessions,  CoachMode coachMode,  bool isBackendConfigured,  bool manualTelnyxAuthEnabled,  IncomingCallCapabilityEntity incomingCallCapability,  bool isCheckingIncomingCallCapability,  bool isOperating,  String? operationFailure,  String? backendFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallHomeState() when $default != null:
return $default(_that.connection,_that.incomingCall,_that.lastCall,_that.activeBackendSessions,_that.coachMode,_that.isBackendConfigured,_that.manualTelnyxAuthEnabled,_that.incomingCallCapability,_that.isCheckingIncomingCallCapability,_that.isOperating,_that.operationFailure,_that.backendFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TelnyxConnectionStateEntity connection,  CallStateEntity? incomingCall,  CallStateEntity? lastCall,  List<ConversationSessionEntity> activeBackendSessions,  CoachMode coachMode,  bool isBackendConfigured,  bool manualTelnyxAuthEnabled,  IncomingCallCapabilityEntity incomingCallCapability,  bool isCheckingIncomingCallCapability,  bool isOperating,  String? operationFailure,  String? backendFailure)  $default,) {final _that = this;
switch (_that) {
case _CallHomeState():
return $default(_that.connection,_that.incomingCall,_that.lastCall,_that.activeBackendSessions,_that.coachMode,_that.isBackendConfigured,_that.manualTelnyxAuthEnabled,_that.incomingCallCapability,_that.isCheckingIncomingCallCapability,_that.isOperating,_that.operationFailure,_that.backendFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TelnyxConnectionStateEntity connection,  CallStateEntity? incomingCall,  CallStateEntity? lastCall,  List<ConversationSessionEntity> activeBackendSessions,  CoachMode coachMode,  bool isBackendConfigured,  bool manualTelnyxAuthEnabled,  IncomingCallCapabilityEntity incomingCallCapability,  bool isCheckingIncomingCallCapability,  bool isOperating,  String? operationFailure,  String? backendFailure)?  $default,) {final _that = this;
switch (_that) {
case _CallHomeState() when $default != null:
return $default(_that.connection,_that.incomingCall,_that.lastCall,_that.activeBackendSessions,_that.coachMode,_that.isBackendConfigured,_that.manualTelnyxAuthEnabled,_that.incomingCallCapability,_that.isCheckingIncomingCallCapability,_that.isOperating,_that.operationFailure,_that.backendFailure);case _:
  return null;

}
}

}

/// @nodoc


class _CallHomeState implements CallHomeState {
  const _CallHomeState({required this.connection, required this.incomingCall, required this.lastCall, required final  List<ConversationSessionEntity> activeBackendSessions, required this.coachMode, required this.isBackendConfigured, required this.manualTelnyxAuthEnabled, required this.incomingCallCapability, required this.isCheckingIncomingCallCapability, required this.isOperating, required this.operationFailure, required this.backendFailure}): _activeBackendSessions = activeBackendSessions;


@override final  TelnyxConnectionStateEntity connection;
@override final  CallStateEntity? incomingCall;
@override final  CallStateEntity? lastCall;
 final  List<ConversationSessionEntity> _activeBackendSessions;
@override List<ConversationSessionEntity> get activeBackendSessions {
  if (_activeBackendSessions is EqualUnmodifiableListView) return _activeBackendSessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activeBackendSessions);
}

@override final  CoachMode coachMode;
@override final  bool isBackendConfigured;
@override final  bool manualTelnyxAuthEnabled;
@override final  IncomingCallCapabilityEntity incomingCallCapability;
@override final  bool isCheckingIncomingCallCapability;
@override final  bool isOperating;
@override final  String? operationFailure;
@override final  String? backendFailure;

/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallHomeStateCopyWith<_CallHomeState> get copyWith => __$CallHomeStateCopyWithImpl<_CallHomeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallHomeState&&(identical(other.connection, connection) || other.connection == connection)&&(identical(other.incomingCall, incomingCall) || other.incomingCall == incomingCall)&&(identical(other.lastCall, lastCall) || other.lastCall == lastCall)&&const DeepCollectionEquality().equals(other._activeBackendSessions, _activeBackendSessions)&&(identical(other.coachMode, coachMode) || other.coachMode == coachMode)&&(identical(other.isBackendConfigured, isBackendConfigured) || other.isBackendConfigured == isBackendConfigured)&&(identical(other.manualTelnyxAuthEnabled, manualTelnyxAuthEnabled) || other.manualTelnyxAuthEnabled == manualTelnyxAuthEnabled)&&(identical(other.incomingCallCapability, incomingCallCapability) || other.incomingCallCapability == incomingCallCapability)&&(identical(other.isCheckingIncomingCallCapability, isCheckingIncomingCallCapability) || other.isCheckingIncomingCallCapability == isCheckingIncomingCallCapability)&&(identical(other.isOperating, isOperating) || other.isOperating == isOperating)&&(identical(other.operationFailure, operationFailure) || other.operationFailure == operationFailure)&&(identical(other.backendFailure, backendFailure) || other.backendFailure == backendFailure));
}


@override
int get hashCode => Object.hash(runtimeType,connection,incomingCall,lastCall,const DeepCollectionEquality().hash(_activeBackendSessions),coachMode,isBackendConfigured,manualTelnyxAuthEnabled,incomingCallCapability,isCheckingIncomingCallCapability,isOperating,operationFailure,backendFailure);

@override
String toString() {
  return 'CallHomeState(connection: $connection, incomingCall: $incomingCall, lastCall: $lastCall, activeBackendSessions: $activeBackendSessions, coachMode: $coachMode, isBackendConfigured: $isBackendConfigured, manualTelnyxAuthEnabled: $manualTelnyxAuthEnabled, incomingCallCapability: $incomingCallCapability, isCheckingIncomingCallCapability: $isCheckingIncomingCallCapability, isOperating: $isOperating, operationFailure: $operationFailure, backendFailure: $backendFailure)';
}


}

/// @nodoc
abstract mixin class _$CallHomeStateCopyWith<$Res> implements $CallHomeStateCopyWith<$Res> {
  factory _$CallHomeStateCopyWith(_CallHomeState value, $Res Function(_CallHomeState) _then) = __$CallHomeStateCopyWithImpl;
@override @useResult
$Res call({
 TelnyxConnectionStateEntity connection, CallStateEntity? incomingCall, CallStateEntity? lastCall, List<ConversationSessionEntity> activeBackendSessions, CoachMode coachMode, bool isBackendConfigured, bool manualTelnyxAuthEnabled, IncomingCallCapabilityEntity incomingCallCapability, bool isCheckingIncomingCallCapability, bool isOperating, String? operationFailure, String? backendFailure
});


@override $TelnyxConnectionStateEntityCopyWith<$Res> get connection;@override $CallStateEntityCopyWith<$Res>? get incomingCall;@override $CallStateEntityCopyWith<$Res>? get lastCall;@override $IncomingCallCapabilityEntityCopyWith<$Res> get incomingCallCapability;

}
/// @nodoc
class __$CallHomeStateCopyWithImpl<$Res>
    implements _$CallHomeStateCopyWith<$Res> {
  __$CallHomeStateCopyWithImpl(this._self, this._then);

  final _CallHomeState _self;
  final $Res Function(_CallHomeState) _then;

/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connection = null,Object? incomingCall = freezed,Object? lastCall = freezed,Object? activeBackendSessions = null,Object? coachMode = null,Object? isBackendConfigured = null,Object? manualTelnyxAuthEnabled = null,Object? incomingCallCapability = null,Object? isCheckingIncomingCallCapability = null,Object? isOperating = null,Object? operationFailure = freezed,Object? backendFailure = freezed,}) {
  return _then(_CallHomeState(
connection: null == connection ? _self.connection : connection // ignore: cast_nullable_to_non_nullable
as TelnyxConnectionStateEntity,incomingCall: freezed == incomingCall ? _self.incomingCall : incomingCall // ignore: cast_nullable_to_non_nullable
as CallStateEntity?,lastCall: freezed == lastCall ? _self.lastCall : lastCall // ignore: cast_nullable_to_non_nullable
as CallStateEntity?,activeBackendSessions: null == activeBackendSessions ? _self._activeBackendSessions : activeBackendSessions // ignore: cast_nullable_to_non_nullable
as List<ConversationSessionEntity>,coachMode: null == coachMode ? _self.coachMode : coachMode // ignore: cast_nullable_to_non_nullable
as CoachMode,isBackendConfigured: null == isBackendConfigured ? _self.isBackendConfigured : isBackendConfigured // ignore: cast_nullable_to_non_nullable
as bool,manualTelnyxAuthEnabled: null == manualTelnyxAuthEnabled ? _self.manualTelnyxAuthEnabled : manualTelnyxAuthEnabled // ignore: cast_nullable_to_non_nullable
as bool,incomingCallCapability: null == incomingCallCapability ? _self.incomingCallCapability : incomingCallCapability // ignore: cast_nullable_to_non_nullable
as IncomingCallCapabilityEntity,isCheckingIncomingCallCapability: null == isCheckingIncomingCallCapability ? _self.isCheckingIncomingCallCapability : isCheckingIncomingCallCapability // ignore: cast_nullable_to_non_nullable
as bool,isOperating: null == isOperating ? _self.isOperating : isOperating // ignore: cast_nullable_to_non_nullable
as bool,operationFailure: freezed == operationFailure ? _self.operationFailure : operationFailure // ignore: cast_nullable_to_non_nullable
as String?,backendFailure: freezed == backendFailure ? _self.backendFailure : backendFailure // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TelnyxConnectionStateEntityCopyWith<$Res> get connection {

  return $TelnyxConnectionStateEntityCopyWith<$Res>(_self.connection, (value) {
    return _then(_self.copyWith(connection: value));
  });
}/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallStateEntityCopyWith<$Res>? get incomingCall {
    if (_self.incomingCall == null) {
    return null;
  }

  return $CallStateEntityCopyWith<$Res>(_self.incomingCall!, (value) {
    return _then(_self.copyWith(incomingCall: value));
  });
}/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallStateEntityCopyWith<$Res>? get lastCall {
    if (_self.lastCall == null) {
    return null;
  }

  return $CallStateEntityCopyWith<$Res>(_self.lastCall!, (value) {
    return _then(_self.copyWith(lastCall: value));
  });
}/// Create a copy of CallHomeState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IncomingCallCapabilityEntityCopyWith<$Res> get incomingCallCapability {

  return $IncomingCallCapabilityEntityCopyWith<$Res>(_self.incomingCallCapability, (value) {
    return _then(_self.copyWith(incomingCallCapability: value));
  });
}
}

// dart format on
