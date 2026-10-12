// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_session.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConversationSessionEntity {

 String get id; String get callId; ConversationSessionStatus get status; CoachMode get coachMode; DateTime get createdAt; bool get transcriptionConsentAcknowledged; String? get destinationNumber; String? get contactId; String? get preparationMarkdown; DateTime? get startedAt; DateTime? get endedAt; String? get failureReason;
/// Create a copy of ConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationSessionEntityCopyWith<ConversationSessionEntity> get copyWith => _$ConversationSessionEntityCopyWithImpl<ConversationSessionEntity>(this as ConversationSessionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationSessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.status, status) || other.status == status)&&(identical(other.coachMode, coachMode) || other.coachMode == coachMode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.transcriptionConsentAcknowledged, transcriptionConsentAcknowledged) || other.transcriptionConsentAcknowledged == transcriptionConsentAcknowledged)&&(identical(other.destinationNumber, destinationNumber) || other.destinationNumber == destinationNumber)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.preparationMarkdown, preparationMarkdown) || other.preparationMarkdown == preparationMarkdown)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,callId,status,coachMode,createdAt,transcriptionConsentAcknowledged,destinationNumber,contactId,preparationMarkdown,startedAt,endedAt,failureReason);

@override
String toString() {
  return 'ConversationSessionEntity(id: $id, callId: $callId, status: $status, coachMode: $coachMode, createdAt: $createdAt, transcriptionConsentAcknowledged: $transcriptionConsentAcknowledged, destinationNumber: $destinationNumber, contactId: $contactId, preparationMarkdown: $preparationMarkdown, startedAt: $startedAt, endedAt: $endedAt, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class $ConversationSessionEntityCopyWith<$Res>  {
  factory $ConversationSessionEntityCopyWith(ConversationSessionEntity value, $Res Function(ConversationSessionEntity) _then) = _$ConversationSessionEntityCopyWithImpl;
@useResult
$Res call({
 String id, String callId, ConversationSessionStatus status, CoachMode coachMode, DateTime createdAt, bool transcriptionConsentAcknowledged, String? destinationNumber, String? contactId, String? preparationMarkdown, DateTime? startedAt, DateTime? endedAt, String? failureReason
});




}
/// @nodoc
class _$ConversationSessionEntityCopyWithImpl<$Res>
    implements $ConversationSessionEntityCopyWith<$Res> {
  _$ConversationSessionEntityCopyWithImpl(this._self, this._then);

  final ConversationSessionEntity _self;
  final $Res Function(ConversationSessionEntity) _then;

/// Create a copy of ConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? callId = null,Object? status = null,Object? coachMode = null,Object? createdAt = null,Object? transcriptionConsentAcknowledged = null,Object? destinationNumber = freezed,Object? contactId = freezed,Object? preparationMarkdown = freezed,Object? startedAt = freezed,Object? endedAt = freezed,Object? failureReason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConversationSessionStatus,coachMode: null == coachMode ? _self.coachMode : coachMode // ignore: cast_nullable_to_non_nullable
as CoachMode,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,transcriptionConsentAcknowledged: null == transcriptionConsentAcknowledged ? _self.transcriptionConsentAcknowledged : transcriptionConsentAcknowledged // ignore: cast_nullable_to_non_nullable
as bool,destinationNumber: freezed == destinationNumber ? _self.destinationNumber : destinationNumber // ignore: cast_nullable_to_non_nullable
as String?,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,preparationMarkdown: freezed == preparationMarkdown ? _self.preparationMarkdown : preparationMarkdown // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConversationSessionEntity].
extension ConversationSessionEntityPatterns on ConversationSessionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationSessionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationSessionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationSessionEntity value)  $default,){
final _that = this;
switch (_that) {
case _ConversationSessionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationSessionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationSessionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String callId,  ConversationSessionStatus status,  CoachMode coachMode,  DateTime createdAt,  bool transcriptionConsentAcknowledged,  String? destinationNumber,  String? contactId,  String? preparationMarkdown,  DateTime? startedAt,  DateTime? endedAt,  String? failureReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationSessionEntity() when $default != null:
return $default(_that.id,_that.callId,_that.status,_that.coachMode,_that.createdAt,_that.transcriptionConsentAcknowledged,_that.destinationNumber,_that.contactId,_that.preparationMarkdown,_that.startedAt,_that.endedAt,_that.failureReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String callId,  ConversationSessionStatus status,  CoachMode coachMode,  DateTime createdAt,  bool transcriptionConsentAcknowledged,  String? destinationNumber,  String? contactId,  String? preparationMarkdown,  DateTime? startedAt,  DateTime? endedAt,  String? failureReason)  $default,) {final _that = this;
switch (_that) {
case _ConversationSessionEntity():
return $default(_that.id,_that.callId,_that.status,_that.coachMode,_that.createdAt,_that.transcriptionConsentAcknowledged,_that.destinationNumber,_that.contactId,_that.preparationMarkdown,_that.startedAt,_that.endedAt,_that.failureReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String callId,  ConversationSessionStatus status,  CoachMode coachMode,  DateTime createdAt,  bool transcriptionConsentAcknowledged,  String? destinationNumber,  String? contactId,  String? preparationMarkdown,  DateTime? startedAt,  DateTime? endedAt,  String? failureReason)?  $default,) {final _that = this;
switch (_that) {
case _ConversationSessionEntity() when $default != null:
return $default(_that.id,_that.callId,_that.status,_that.coachMode,_that.createdAt,_that.transcriptionConsentAcknowledged,_that.destinationNumber,_that.contactId,_that.preparationMarkdown,_that.startedAt,_that.endedAt,_that.failureReason);case _:
  return null;

}
}

}

/// @nodoc


class _ConversationSessionEntity implements ConversationSessionEntity {
  const _ConversationSessionEntity({required this.id, required this.callId, required this.status, required this.coachMode, required this.createdAt, this.transcriptionConsentAcknowledged = false, this.destinationNumber, this.contactId, this.preparationMarkdown, this.startedAt, this.endedAt, this.failureReason});
  

@override final  String id;
@override final  String callId;
@override final  ConversationSessionStatus status;
@override final  CoachMode coachMode;
@override final  DateTime createdAt;
@override@JsonKey() final  bool transcriptionConsentAcknowledged;
@override final  String? destinationNumber;
@override final  String? contactId;
@override final  String? preparationMarkdown;
@override final  DateTime? startedAt;
@override final  DateTime? endedAt;
@override final  String? failureReason;

/// Create a copy of ConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationSessionEntityCopyWith<_ConversationSessionEntity> get copyWith => __$ConversationSessionEntityCopyWithImpl<_ConversationSessionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationSessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.status, status) || other.status == status)&&(identical(other.coachMode, coachMode) || other.coachMode == coachMode)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.transcriptionConsentAcknowledged, transcriptionConsentAcknowledged) || other.transcriptionConsentAcknowledged == transcriptionConsentAcknowledged)&&(identical(other.destinationNumber, destinationNumber) || other.destinationNumber == destinationNumber)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.preparationMarkdown, preparationMarkdown) || other.preparationMarkdown == preparationMarkdown)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.failureReason, failureReason) || other.failureReason == failureReason));
}


@override
int get hashCode => Object.hash(runtimeType,id,callId,status,coachMode,createdAt,transcriptionConsentAcknowledged,destinationNumber,contactId,preparationMarkdown,startedAt,endedAt,failureReason);

@override
String toString() {
  return 'ConversationSessionEntity(id: $id, callId: $callId, status: $status, coachMode: $coachMode, createdAt: $createdAt, transcriptionConsentAcknowledged: $transcriptionConsentAcknowledged, destinationNumber: $destinationNumber, contactId: $contactId, preparationMarkdown: $preparationMarkdown, startedAt: $startedAt, endedAt: $endedAt, failureReason: $failureReason)';
}


}

/// @nodoc
abstract mixin class _$ConversationSessionEntityCopyWith<$Res> implements $ConversationSessionEntityCopyWith<$Res> {
  factory _$ConversationSessionEntityCopyWith(_ConversationSessionEntity value, $Res Function(_ConversationSessionEntity) _then) = __$ConversationSessionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String callId, ConversationSessionStatus status, CoachMode coachMode, DateTime createdAt, bool transcriptionConsentAcknowledged, String? destinationNumber, String? contactId, String? preparationMarkdown, DateTime? startedAt, DateTime? endedAt, String? failureReason
});




}
/// @nodoc
class __$ConversationSessionEntityCopyWithImpl<$Res>
    implements _$ConversationSessionEntityCopyWith<$Res> {
  __$ConversationSessionEntityCopyWithImpl(this._self, this._then);

  final _ConversationSessionEntity _self;
  final $Res Function(_ConversationSessionEntity) _then;

/// Create a copy of ConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? callId = null,Object? status = null,Object? coachMode = null,Object? createdAt = null,Object? transcriptionConsentAcknowledged = null,Object? destinationNumber = freezed,Object? contactId = freezed,Object? preparationMarkdown = freezed,Object? startedAt = freezed,Object? endedAt = freezed,Object? failureReason = freezed,}) {
  return _then(_ConversationSessionEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ConversationSessionStatus,coachMode: null == coachMode ? _self.coachMode : coachMode // ignore: cast_nullable_to_non_nullable
as CoachMode,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,transcriptionConsentAcknowledged: null == transcriptionConsentAcknowledged ? _self.transcriptionConsentAcknowledged : transcriptionConsentAcknowledged // ignore: cast_nullable_to_non_nullable
as bool,destinationNumber: freezed == destinationNumber ? _self.destinationNumber : destinationNumber // ignore: cast_nullable_to_non_nullable
as String?,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,preparationMarkdown: freezed == preparationMarkdown ? _self.preparationMarkdown : preparationMarkdown // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,failureReason: freezed == failureReason ? _self.failureReason : failureReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
