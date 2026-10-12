// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evaluate_call_eligibility.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EvaluateCallEligibilityParam {

 String get phoneNumber; ContactMarket get market; String? get contactId; bool? get hasPriorConsent; bool? get hasOptedOut; bool? get professionalRelevanceConfirmed; String? get countryCode;
/// Create a copy of EvaluateCallEligibilityParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvaluateCallEligibilityParamCopyWith<EvaluateCallEligibilityParam> get copyWith => _$EvaluateCallEligibilityParamCopyWithImpl<EvaluateCallEligibilityParam>(this as EvaluateCallEligibilityParam, _$identity);

  /// Serializes this EvaluateCallEligibilityParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EvaluateCallEligibilityParam&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.market, market) || other.market == market)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.hasPriorConsent, hasPriorConsent) || other.hasPriorConsent == hasPriorConsent)&&(identical(other.hasOptedOut, hasOptedOut) || other.hasOptedOut == hasOptedOut)&&(identical(other.professionalRelevanceConfirmed, professionalRelevanceConfirmed) || other.professionalRelevanceConfirmed == professionalRelevanceConfirmed)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phoneNumber,market,contactId,hasPriorConsent,hasOptedOut,professionalRelevanceConfirmed,countryCode);

@override
String toString() {
  return 'EvaluateCallEligibilityParam(phoneNumber: $phoneNumber, market: $market, contactId: $contactId, hasPriorConsent: $hasPriorConsent, hasOptedOut: $hasOptedOut, professionalRelevanceConfirmed: $professionalRelevanceConfirmed, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class $EvaluateCallEligibilityParamCopyWith<$Res>  {
  factory $EvaluateCallEligibilityParamCopyWith(EvaluateCallEligibilityParam value, $Res Function(EvaluateCallEligibilityParam) _then) = _$EvaluateCallEligibilityParamCopyWithImpl;
@useResult
$Res call({
 String phoneNumber, ContactMarket market, String? contactId, bool? hasPriorConsent, bool? hasOptedOut, bool? professionalRelevanceConfirmed, String? countryCode
});




}
/// @nodoc
class _$EvaluateCallEligibilityParamCopyWithImpl<$Res>
    implements $EvaluateCallEligibilityParamCopyWith<$Res> {
  _$EvaluateCallEligibilityParamCopyWithImpl(this._self, this._then);

  final EvaluateCallEligibilityParam _self;
  final $Res Function(EvaluateCallEligibilityParam) _then;

/// Create a copy of EvaluateCallEligibilityParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phoneNumber = null,Object? market = null,Object? contactId = freezed,Object? hasPriorConsent = freezed,Object? hasOptedOut = freezed,Object? professionalRelevanceConfirmed = freezed,Object? countryCode = freezed,}) {
  return _then(_self.copyWith(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as ContactMarket,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,hasPriorConsent: freezed == hasPriorConsent ? _self.hasPriorConsent : hasPriorConsent // ignore: cast_nullable_to_non_nullable
as bool?,hasOptedOut: freezed == hasOptedOut ? _self.hasOptedOut : hasOptedOut // ignore: cast_nullable_to_non_nullable
as bool?,professionalRelevanceConfirmed: freezed == professionalRelevanceConfirmed ? _self.professionalRelevanceConfirmed : professionalRelevanceConfirmed // ignore: cast_nullable_to_non_nullable
as bool?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EvaluateCallEligibilityParam].
extension EvaluateCallEligibilityParamPatterns on EvaluateCallEligibilityParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EvaluateCallEligibilityParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EvaluateCallEligibilityParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EvaluateCallEligibilityParam value)  $default,){
final _that = this;
switch (_that) {
case _EvaluateCallEligibilityParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EvaluateCallEligibilityParam value)?  $default,){
final _that = this;
switch (_that) {
case _EvaluateCallEligibilityParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phoneNumber,  ContactMarket market,  String? contactId,  bool? hasPriorConsent,  bool? hasOptedOut,  bool? professionalRelevanceConfirmed,  String? countryCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EvaluateCallEligibilityParam() when $default != null:
return $default(_that.phoneNumber,_that.market,_that.contactId,_that.hasPriorConsent,_that.hasOptedOut,_that.professionalRelevanceConfirmed,_that.countryCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phoneNumber,  ContactMarket market,  String? contactId,  bool? hasPriorConsent,  bool? hasOptedOut,  bool? professionalRelevanceConfirmed,  String? countryCode)  $default,) {final _that = this;
switch (_that) {
case _EvaluateCallEligibilityParam():
return $default(_that.phoneNumber,_that.market,_that.contactId,_that.hasPriorConsent,_that.hasOptedOut,_that.professionalRelevanceConfirmed,_that.countryCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phoneNumber,  ContactMarket market,  String? contactId,  bool? hasPriorConsent,  bool? hasOptedOut,  bool? professionalRelevanceConfirmed,  String? countryCode)?  $default,) {final _that = this;
switch (_that) {
case _EvaluateCallEligibilityParam() when $default != null:
return $default(_that.phoneNumber,_that.market,_that.contactId,_that.hasPriorConsent,_that.hasOptedOut,_that.professionalRelevanceConfirmed,_that.countryCode);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _EvaluateCallEligibilityParam implements EvaluateCallEligibilityParam {
  const _EvaluateCallEligibilityParam({required this.phoneNumber, required this.market, this.contactId, this.hasPriorConsent, this.hasOptedOut, this.professionalRelevanceConfirmed, this.countryCode});
  factory _EvaluateCallEligibilityParam.fromJson(Map<String, dynamic> json) => _$EvaluateCallEligibilityParamFromJson(json);

@override final  String phoneNumber;
@override final  ContactMarket market;
@override final  String? contactId;
@override final  bool? hasPriorConsent;
@override final  bool? hasOptedOut;
@override final  bool? professionalRelevanceConfirmed;
@override final  String? countryCode;

/// Create a copy of EvaluateCallEligibilityParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvaluateCallEligibilityParamCopyWith<_EvaluateCallEligibilityParam> get copyWith => __$EvaluateCallEligibilityParamCopyWithImpl<_EvaluateCallEligibilityParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EvaluateCallEligibilityParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EvaluateCallEligibilityParam&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.market, market) || other.market == market)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.hasPriorConsent, hasPriorConsent) || other.hasPriorConsent == hasPriorConsent)&&(identical(other.hasOptedOut, hasOptedOut) || other.hasOptedOut == hasOptedOut)&&(identical(other.professionalRelevanceConfirmed, professionalRelevanceConfirmed) || other.professionalRelevanceConfirmed == professionalRelevanceConfirmed)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phoneNumber,market,contactId,hasPriorConsent,hasOptedOut,professionalRelevanceConfirmed,countryCode);

@override
String toString() {
  return 'EvaluateCallEligibilityParam(phoneNumber: $phoneNumber, market: $market, contactId: $contactId, hasPriorConsent: $hasPriorConsent, hasOptedOut: $hasOptedOut, professionalRelevanceConfirmed: $professionalRelevanceConfirmed, countryCode: $countryCode)';
}


}

/// @nodoc
abstract mixin class _$EvaluateCallEligibilityParamCopyWith<$Res> implements $EvaluateCallEligibilityParamCopyWith<$Res> {
  factory _$EvaluateCallEligibilityParamCopyWith(_EvaluateCallEligibilityParam value, $Res Function(_EvaluateCallEligibilityParam) _then) = __$EvaluateCallEligibilityParamCopyWithImpl;
@override @useResult
$Res call({
 String phoneNumber, ContactMarket market, String? contactId, bool? hasPriorConsent, bool? hasOptedOut, bool? professionalRelevanceConfirmed, String? countryCode
});




}
/// @nodoc
class __$EvaluateCallEligibilityParamCopyWithImpl<$Res>
    implements _$EvaluateCallEligibilityParamCopyWith<$Res> {
  __$EvaluateCallEligibilityParamCopyWithImpl(this._self, this._then);

  final _EvaluateCallEligibilityParam _self;
  final $Res Function(_EvaluateCallEligibilityParam) _then;

/// Create a copy of EvaluateCallEligibilityParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,Object? market = null,Object? contactId = freezed,Object? hasPriorConsent = freezed,Object? hasOptedOut = freezed,Object? professionalRelevanceConfirmed = freezed,Object? countryCode = freezed,}) {
  return _then(_EvaluateCallEligibilityParam(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as ContactMarket,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,hasPriorConsent: freezed == hasPriorConsent ? _self.hasPriorConsent : hasPriorConsent // ignore: cast_nullable_to_non_nullable
as bool?,hasOptedOut: freezed == hasOptedOut ? _self.hasOptedOut : hasOptedOut // ignore: cast_nullable_to_non_nullable
as bool?,professionalRelevanceConfirmed: freezed == professionalRelevanceConfirmed ? _self.professionalRelevanceConfirmed : professionalRelevanceConfirmed // ignore: cast_nullable_to_non_nullable
as bool?,countryCode: freezed == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
