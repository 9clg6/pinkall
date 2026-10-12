// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contact.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactRemoteModel {

 String get id; String get phoneNumber; String get market; DateTime get createdAt; DateTime get updatedAt; String? get firstName; String? get lastName; String? get company; String? get jobTitle; String? get email; bool? get hasPriorConsent; bool? get hasOptedOut; bool? get professionalRelevanceConfirmed; Map<String, String> get customFields;
/// Create a copy of ContactRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactRemoteModelCopyWith<ContactRemoteModel> get copyWith => _$ContactRemoteModelCopyWithImpl<ContactRemoteModel>(this as ContactRemoteModel, _$identity);

  /// Serializes this ContactRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.market, market) || other.market == market)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.company, company) || other.company == company)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.email, email) || other.email == email)&&(identical(other.hasPriorConsent, hasPriorConsent) || other.hasPriorConsent == hasPriorConsent)&&(identical(other.hasOptedOut, hasOptedOut) || other.hasOptedOut == hasOptedOut)&&(identical(other.professionalRelevanceConfirmed, professionalRelevanceConfirmed) || other.professionalRelevanceConfirmed == professionalRelevanceConfirmed)&&const DeepCollectionEquality().equals(other.customFields, customFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,phoneNumber,market,createdAt,updatedAt,firstName,lastName,company,jobTitle,email,hasPriorConsent,hasOptedOut,professionalRelevanceConfirmed,const DeepCollectionEquality().hash(customFields));

@override
String toString() {
  return 'ContactRemoteModel(id: $id, phoneNumber: $phoneNumber, market: $market, createdAt: $createdAt, updatedAt: $updatedAt, firstName: $firstName, lastName: $lastName, company: $company, jobTitle: $jobTitle, email: $email, hasPriorConsent: $hasPriorConsent, hasOptedOut: $hasOptedOut, professionalRelevanceConfirmed: $professionalRelevanceConfirmed, customFields: $customFields)';
}


}

/// @nodoc
abstract mixin class $ContactRemoteModelCopyWith<$Res>  {
  factory $ContactRemoteModelCopyWith(ContactRemoteModel value, $Res Function(ContactRemoteModel) _then) = _$ContactRemoteModelCopyWithImpl;
@useResult
$Res call({
 String id, String phoneNumber, String market, DateTime createdAt, DateTime updatedAt, String? firstName, String? lastName, String? company, String? jobTitle, String? email, bool? hasPriorConsent, bool? hasOptedOut, bool? professionalRelevanceConfirmed, Map<String, String> customFields
});




}
/// @nodoc
class _$ContactRemoteModelCopyWithImpl<$Res>
    implements $ContactRemoteModelCopyWith<$Res> {
  _$ContactRemoteModelCopyWithImpl(this._self, this._then);

  final ContactRemoteModel _self;
  final $Res Function(ContactRemoteModel) _then;

/// Create a copy of ContactRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? phoneNumber = null,Object? market = null,Object? createdAt = null,Object? updatedAt = null,Object? firstName = freezed,Object? lastName = freezed,Object? company = freezed,Object? jobTitle = freezed,Object? email = freezed,Object? hasPriorConsent = freezed,Object? hasOptedOut = freezed,Object? professionalRelevanceConfirmed = freezed,Object? customFields = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,jobTitle: freezed == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,hasPriorConsent: freezed == hasPriorConsent ? _self.hasPriorConsent : hasPriorConsent // ignore: cast_nullable_to_non_nullable
as bool?,hasOptedOut: freezed == hasOptedOut ? _self.hasOptedOut : hasOptedOut // ignore: cast_nullable_to_non_nullable
as bool?,professionalRelevanceConfirmed: freezed == professionalRelevanceConfirmed ? _self.professionalRelevanceConfirmed : professionalRelevanceConfirmed // ignore: cast_nullable_to_non_nullable
as bool?,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContactRemoteModel].
extension ContactRemoteModelPatterns on ContactRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _ContactRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _ContactRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String phoneNumber,  String market,  DateTime createdAt,  DateTime updatedAt,  String? firstName,  String? lastName,  String? company,  String? jobTitle,  String? email,  bool? hasPriorConsent,  bool? hasOptedOut,  bool? professionalRelevanceConfirmed,  Map<String, String> customFields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactRemoteModel() when $default != null:
return $default(_that.id,_that.phoneNumber,_that.market,_that.createdAt,_that.updatedAt,_that.firstName,_that.lastName,_that.company,_that.jobTitle,_that.email,_that.hasPriorConsent,_that.hasOptedOut,_that.professionalRelevanceConfirmed,_that.customFields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String phoneNumber,  String market,  DateTime createdAt,  DateTime updatedAt,  String? firstName,  String? lastName,  String? company,  String? jobTitle,  String? email,  bool? hasPriorConsent,  bool? hasOptedOut,  bool? professionalRelevanceConfirmed,  Map<String, String> customFields)  $default,) {final _that = this;
switch (_that) {
case _ContactRemoteModel():
return $default(_that.id,_that.phoneNumber,_that.market,_that.createdAt,_that.updatedAt,_that.firstName,_that.lastName,_that.company,_that.jobTitle,_that.email,_that.hasPriorConsent,_that.hasOptedOut,_that.professionalRelevanceConfirmed,_that.customFields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String phoneNumber,  String market,  DateTime createdAt,  DateTime updatedAt,  String? firstName,  String? lastName,  String? company,  String? jobTitle,  String? email,  bool? hasPriorConsent,  bool? hasOptedOut,  bool? professionalRelevanceConfirmed,  Map<String, String> customFields)?  $default,) {final _that = this;
switch (_that) {
case _ContactRemoteModel() when $default != null:
return $default(_that.id,_that.phoneNumber,_that.market,_that.createdAt,_that.updatedAt,_that.firstName,_that.lastName,_that.company,_that.jobTitle,_that.email,_that.hasPriorConsent,_that.hasOptedOut,_that.professionalRelevanceConfirmed,_that.customFields);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ContactRemoteModel implements ContactRemoteModel {
  const _ContactRemoteModel({required this.id, required this.phoneNumber, required this.market, required this.createdAt, required this.updatedAt, this.firstName, this.lastName, this.company, this.jobTitle, this.email, this.hasPriorConsent, this.hasOptedOut, this.professionalRelevanceConfirmed, final  Map<String, String> customFields = const <String, String>{}}): _customFields = customFields;
  factory _ContactRemoteModel.fromJson(Map<String, dynamic> json) => _$ContactRemoteModelFromJson(json);

@override final  String id;
@override final  String phoneNumber;
@override final  String market;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? company;
@override final  String? jobTitle;
@override final  String? email;
@override final  bool? hasPriorConsent;
@override final  bool? hasOptedOut;
@override final  bool? professionalRelevanceConfirmed;
 final  Map<String, String> _customFields;
@override@JsonKey() Map<String, String> get customFields {
  if (_customFields is EqualUnmodifiableMapView) return _customFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_customFields);
}


/// Create a copy of ContactRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactRemoteModelCopyWith<_ContactRemoteModel> get copyWith => __$ContactRemoteModelCopyWithImpl<_ContactRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactRemoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.market, market) || other.market == market)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.company, company) || other.company == company)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.email, email) || other.email == email)&&(identical(other.hasPriorConsent, hasPriorConsent) || other.hasPriorConsent == hasPriorConsent)&&(identical(other.hasOptedOut, hasOptedOut) || other.hasOptedOut == hasOptedOut)&&(identical(other.professionalRelevanceConfirmed, professionalRelevanceConfirmed) || other.professionalRelevanceConfirmed == professionalRelevanceConfirmed)&&const DeepCollectionEquality().equals(other._customFields, _customFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,phoneNumber,market,createdAt,updatedAt,firstName,lastName,company,jobTitle,email,hasPriorConsent,hasOptedOut,professionalRelevanceConfirmed,const DeepCollectionEquality().hash(_customFields));

@override
String toString() {
  return 'ContactRemoteModel(id: $id, phoneNumber: $phoneNumber, market: $market, createdAt: $createdAt, updatedAt: $updatedAt, firstName: $firstName, lastName: $lastName, company: $company, jobTitle: $jobTitle, email: $email, hasPriorConsent: $hasPriorConsent, hasOptedOut: $hasOptedOut, professionalRelevanceConfirmed: $professionalRelevanceConfirmed, customFields: $customFields)';
}


}

/// @nodoc
abstract mixin class _$ContactRemoteModelCopyWith<$Res> implements $ContactRemoteModelCopyWith<$Res> {
  factory _$ContactRemoteModelCopyWith(_ContactRemoteModel value, $Res Function(_ContactRemoteModel) _then) = __$ContactRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String phoneNumber, String market, DateTime createdAt, DateTime updatedAt, String? firstName, String? lastName, String? company, String? jobTitle, String? email, bool? hasPriorConsent, bool? hasOptedOut, bool? professionalRelevanceConfirmed, Map<String, String> customFields
});




}
/// @nodoc
class __$ContactRemoteModelCopyWithImpl<$Res>
    implements _$ContactRemoteModelCopyWith<$Res> {
  __$ContactRemoteModelCopyWithImpl(this._self, this._then);

  final _ContactRemoteModel _self;
  final $Res Function(_ContactRemoteModel) _then;

/// Create a copy of ContactRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? phoneNumber = null,Object? market = null,Object? createdAt = null,Object? updatedAt = null,Object? firstName = freezed,Object? lastName = freezed,Object? company = freezed,Object? jobTitle = freezed,Object? email = freezed,Object? hasPriorConsent = freezed,Object? hasOptedOut = freezed,Object? professionalRelevanceConfirmed = freezed,Object? customFields = null,}) {
  return _then(_ContactRemoteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,company: freezed == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String?,jobTitle: freezed == jobTitle ? _self.jobTitle : jobTitle // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,hasPriorConsent: freezed == hasPriorConsent ? _self.hasPriorConsent : hasPriorConsent // ignore: cast_nullable_to_non_nullable
as bool?,hasOptedOut: freezed == hasOptedOut ? _self.hasOptedOut : hasOptedOut // ignore: cast_nullable_to_non_nullable
as bool?,professionalRelevanceConfirmed: freezed == professionalRelevanceConfirmed ? _self.professionalRelevanceConfirmed : professionalRelevanceConfirmed // ignore: cast_nullable_to_non_nullable
as bool?,customFields: null == customFields ? _self._customFields : customFields // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
