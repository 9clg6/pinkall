// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_eligibility.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallEligibilityEntity {

 CallEligibilityStatus get status; List<CallEligibilityReason> get reasons; DateTime get checkedAt; String get policyVersion; String? get contactId;
/// Create a copy of CallEligibilityEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallEligibilityEntityCopyWith<CallEligibilityEntity> get copyWith => _$CallEligibilityEntityCopyWithImpl<CallEligibilityEntity>(this as CallEligibilityEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallEligibilityEntity&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion)&&(identical(other.contactId, contactId) || other.contactId == contactId));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(reasons),checkedAt,policyVersion,contactId);

@override
String toString() {
  return 'CallEligibilityEntity(status: $status, reasons: $reasons, checkedAt: $checkedAt, policyVersion: $policyVersion, contactId: $contactId)';
}


}

/// @nodoc
abstract mixin class $CallEligibilityEntityCopyWith<$Res>  {
  factory $CallEligibilityEntityCopyWith(CallEligibilityEntity value, $Res Function(CallEligibilityEntity) _then) = _$CallEligibilityEntityCopyWithImpl;
@useResult
$Res call({
 CallEligibilityStatus status, List<CallEligibilityReason> reasons, DateTime checkedAt, String policyVersion, String? contactId
});




}
/// @nodoc
class _$CallEligibilityEntityCopyWithImpl<$Res>
    implements $CallEligibilityEntityCopyWith<$Res> {
  _$CallEligibilityEntityCopyWithImpl(this._self, this._then);

  final CallEligibilityEntity _self;
  final $Res Function(CallEligibilityEntity) _then;

/// Create a copy of CallEligibilityEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? reasons = null,Object? checkedAt = null,Object? policyVersion = null,Object? contactId = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CallEligibilityStatus,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<CallEligibilityReason>,checkedAt: null == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallEligibilityEntity].
extension CallEligibilityEntityPatterns on CallEligibilityEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallEligibilityEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallEligibilityEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallEligibilityEntity value)  $default,){
final _that = this;
switch (_that) {
case _CallEligibilityEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallEligibilityEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CallEligibilityEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CallEligibilityStatus status,  List<CallEligibilityReason> reasons,  DateTime checkedAt,  String policyVersion,  String? contactId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallEligibilityEntity() when $default != null:
return $default(_that.status,_that.reasons,_that.checkedAt,_that.policyVersion,_that.contactId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CallEligibilityStatus status,  List<CallEligibilityReason> reasons,  DateTime checkedAt,  String policyVersion,  String? contactId)  $default,) {final _that = this;
switch (_that) {
case _CallEligibilityEntity():
return $default(_that.status,_that.reasons,_that.checkedAt,_that.policyVersion,_that.contactId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CallEligibilityStatus status,  List<CallEligibilityReason> reasons,  DateTime checkedAt,  String policyVersion,  String? contactId)?  $default,) {final _that = this;
switch (_that) {
case _CallEligibilityEntity() when $default != null:
return $default(_that.status,_that.reasons,_that.checkedAt,_that.policyVersion,_that.contactId);case _:
  return null;

}
}

}

/// @nodoc


class _CallEligibilityEntity implements CallEligibilityEntity {
  const _CallEligibilityEntity({required this.status, required final  List<CallEligibilityReason> reasons, required this.checkedAt, required this.policyVersion, this.contactId}): _reasons = reasons;
  

@override final  CallEligibilityStatus status;
 final  List<CallEligibilityReason> _reasons;
@override List<CallEligibilityReason> get reasons {
  if (_reasons is EqualUnmodifiableListView) return _reasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reasons);
}

@override final  DateTime checkedAt;
@override final  String policyVersion;
@override final  String? contactId;

/// Create a copy of CallEligibilityEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallEligibilityEntityCopyWith<_CallEligibilityEntity> get copyWith => __$CallEligibilityEntityCopyWithImpl<_CallEligibilityEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallEligibilityEntity&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._reasons, _reasons)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion)&&(identical(other.contactId, contactId) || other.contactId == contactId));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_reasons),checkedAt,policyVersion,contactId);

@override
String toString() {
  return 'CallEligibilityEntity(status: $status, reasons: $reasons, checkedAt: $checkedAt, policyVersion: $policyVersion, contactId: $contactId)';
}


}

/// @nodoc
abstract mixin class _$CallEligibilityEntityCopyWith<$Res> implements $CallEligibilityEntityCopyWith<$Res> {
  factory _$CallEligibilityEntityCopyWith(_CallEligibilityEntity value, $Res Function(_CallEligibilityEntity) _then) = __$CallEligibilityEntityCopyWithImpl;
@override @useResult
$Res call({
 CallEligibilityStatus status, List<CallEligibilityReason> reasons, DateTime checkedAt, String policyVersion, String? contactId
});




}
/// @nodoc
class __$CallEligibilityEntityCopyWithImpl<$Res>
    implements _$CallEligibilityEntityCopyWith<$Res> {
  __$CallEligibilityEntityCopyWithImpl(this._self, this._then);

  final _CallEligibilityEntity _self;
  final $Res Function(_CallEligibilityEntity) _then;

/// Create a copy of CallEligibilityEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? reasons = null,Object? checkedAt = null,Object? policyVersion = null,Object? contactId = freezed,}) {
  return _then(_CallEligibilityEntity(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CallEligibilityStatus,reasons: null == reasons ? _self._reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<CallEligibilityReason>,checkedAt: null == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
