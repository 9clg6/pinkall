// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_eligibility.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CallEligibilityRemoteModel {

 String get status; List<String> get reasons; DateTime get checkedAt; String get policyVersion; String? get contactId;
/// Create a copy of CallEligibilityRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallEligibilityRemoteModelCopyWith<CallEligibilityRemoteModel> get copyWith => _$CallEligibilityRemoteModelCopyWithImpl<CallEligibilityRemoteModel>(this as CallEligibilityRemoteModel, _$identity);

  /// Serializes this CallEligibilityRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallEligibilityRemoteModel&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion)&&(identical(other.contactId, contactId) || other.contactId == contactId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(reasons),checkedAt,policyVersion,contactId);

@override
String toString() {
  return 'CallEligibilityRemoteModel(status: $status, reasons: $reasons, checkedAt: $checkedAt, policyVersion: $policyVersion, contactId: $contactId)';
}


}

/// @nodoc
abstract mixin class $CallEligibilityRemoteModelCopyWith<$Res>  {
  factory $CallEligibilityRemoteModelCopyWith(CallEligibilityRemoteModel value, $Res Function(CallEligibilityRemoteModel) _then) = _$CallEligibilityRemoteModelCopyWithImpl;
@useResult
$Res call({
 String status, List<String> reasons, DateTime checkedAt, String policyVersion, String? contactId
});




}
/// @nodoc
class _$CallEligibilityRemoteModelCopyWithImpl<$Res>
    implements $CallEligibilityRemoteModelCopyWith<$Res> {
  _$CallEligibilityRemoteModelCopyWithImpl(this._self, this._then);

  final CallEligibilityRemoteModel _self;
  final $Res Function(CallEligibilityRemoteModel) _then;

/// Create a copy of CallEligibilityRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? reasons = null,Object? checkedAt = null,Object? policyVersion = null,Object? contactId = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<String>,checkedAt: null == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallEligibilityRemoteModel].
extension CallEligibilityRemoteModelPatterns on CallEligibilityRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallEligibilityRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallEligibilityRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallEligibilityRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CallEligibilityRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallEligibilityRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CallEligibilityRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status,  List<String> reasons,  DateTime checkedAt,  String policyVersion,  String? contactId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallEligibilityRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status,  List<String> reasons,  DateTime checkedAt,  String policyVersion,  String? contactId)  $default,) {final _that = this;
switch (_that) {
case _CallEligibilityRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status,  List<String> reasons,  DateTime checkedAt,  String policyVersion,  String? contactId)?  $default,) {final _that = this;
switch (_that) {
case _CallEligibilityRemoteModel() when $default != null:
return $default(_that.status,_that.reasons,_that.checkedAt,_that.policyVersion,_that.contactId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CallEligibilityRemoteModel implements CallEligibilityRemoteModel {
  const _CallEligibilityRemoteModel({required this.status, required final  List<String> reasons, required this.checkedAt, required this.policyVersion, this.contactId}): _reasons = reasons;
  factory _CallEligibilityRemoteModel.fromJson(Map<String, dynamic> json) => _$CallEligibilityRemoteModelFromJson(json);

@override final  String status;
 final  List<String> _reasons;
@override List<String> get reasons {
  if (_reasons is EqualUnmodifiableListView) return _reasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reasons);
}

@override final  DateTime checkedAt;
@override final  String policyVersion;
@override final  String? contactId;

/// Create a copy of CallEligibilityRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallEligibilityRemoteModelCopyWith<_CallEligibilityRemoteModel> get copyWith => __$CallEligibilityRemoteModelCopyWithImpl<_CallEligibilityRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallEligibilityRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallEligibilityRemoteModel&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._reasons, _reasons)&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.policyVersion, policyVersion) || other.policyVersion == policyVersion)&&(identical(other.contactId, contactId) || other.contactId == contactId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_reasons),checkedAt,policyVersion,contactId);

@override
String toString() {
  return 'CallEligibilityRemoteModel(status: $status, reasons: $reasons, checkedAt: $checkedAt, policyVersion: $policyVersion, contactId: $contactId)';
}


}

/// @nodoc
abstract mixin class _$CallEligibilityRemoteModelCopyWith<$Res> implements $CallEligibilityRemoteModelCopyWith<$Res> {
  factory _$CallEligibilityRemoteModelCopyWith(_CallEligibilityRemoteModel value, $Res Function(_CallEligibilityRemoteModel) _then) = __$CallEligibilityRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String status, List<String> reasons, DateTime checkedAt, String policyVersion, String? contactId
});




}
/// @nodoc
class __$CallEligibilityRemoteModelCopyWithImpl<$Res>
    implements _$CallEligibilityRemoteModelCopyWith<$Res> {
  __$CallEligibilityRemoteModelCopyWithImpl(this._self, this._then);

  final _CallEligibilityRemoteModel _self;
  final $Res Function(_CallEligibilityRemoteModel) _then;

/// Create a copy of CallEligibilityRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? reasons = null,Object? checkedAt = null,Object? policyVersion = null,Object? contactId = freezed,}) {
  return _then(_CallEligibilityRemoteModel(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reasons: null == reasons ? _self._reasons : reasons // ignore: cast_nullable_to_non_nullable
as List<String>,checkedAt: null == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,policyVersion: null == policyVersion ? _self.policyVersion : policyVersion // ignore: cast_nullable_to_non_nullable
as String,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
