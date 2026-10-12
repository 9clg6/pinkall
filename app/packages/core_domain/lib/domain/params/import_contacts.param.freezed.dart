// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_contacts.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContactImportRowParam {

 String get phoneNumber; ContactMarket get market; String? get firstName; String? get lastName; String? get company; String? get jobTitle; String? get email; bool? get hasPriorConsent; bool? get hasOptedOut; bool? get professionalRelevanceConfirmed; Map<String, String> get customFields;
/// Create a copy of ContactImportRowParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContactImportRowParamCopyWith<ContactImportRowParam> get copyWith => _$ContactImportRowParamCopyWithImpl<ContactImportRowParam>(this as ContactImportRowParam, _$identity);

  /// Serializes this ContactImportRowParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContactImportRowParam&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.market, market) || other.market == market)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.company, company) || other.company == company)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.email, email) || other.email == email)&&(identical(other.hasPriorConsent, hasPriorConsent) || other.hasPriorConsent == hasPriorConsent)&&(identical(other.hasOptedOut, hasOptedOut) || other.hasOptedOut == hasOptedOut)&&(identical(other.professionalRelevanceConfirmed, professionalRelevanceConfirmed) || other.professionalRelevanceConfirmed == professionalRelevanceConfirmed)&&const DeepCollectionEquality().equals(other.customFields, customFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phoneNumber,market,firstName,lastName,company,jobTitle,email,hasPriorConsent,hasOptedOut,professionalRelevanceConfirmed,const DeepCollectionEquality().hash(customFields));

@override
String toString() {
  return 'ContactImportRowParam(phoneNumber: $phoneNumber, market: $market, firstName: $firstName, lastName: $lastName, company: $company, jobTitle: $jobTitle, email: $email, hasPriorConsent: $hasPriorConsent, hasOptedOut: $hasOptedOut, professionalRelevanceConfirmed: $professionalRelevanceConfirmed, customFields: $customFields)';
}


}

/// @nodoc
abstract mixin class $ContactImportRowParamCopyWith<$Res>  {
  factory $ContactImportRowParamCopyWith(ContactImportRowParam value, $Res Function(ContactImportRowParam) _then) = _$ContactImportRowParamCopyWithImpl;
@useResult
$Res call({
 String phoneNumber, ContactMarket market, String? firstName, String? lastName, String? company, String? jobTitle, String? email, bool? hasPriorConsent, bool? hasOptedOut, bool? professionalRelevanceConfirmed, Map<String, String> customFields
});




}
/// @nodoc
class _$ContactImportRowParamCopyWithImpl<$Res>
    implements $ContactImportRowParamCopyWith<$Res> {
  _$ContactImportRowParamCopyWithImpl(this._self, this._then);

  final ContactImportRowParam _self;
  final $Res Function(ContactImportRowParam) _then;

/// Create a copy of ContactImportRowParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phoneNumber = null,Object? market = null,Object? firstName = freezed,Object? lastName = freezed,Object? company = freezed,Object? jobTitle = freezed,Object? email = freezed,Object? hasPriorConsent = freezed,Object? hasOptedOut = freezed,Object? professionalRelevanceConfirmed = freezed,Object? customFields = null,}) {
  return _then(_self.copyWith(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as ContactMarket,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [ContactImportRowParam].
extension ContactImportRowParamPatterns on ContactImportRowParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContactImportRowParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContactImportRowParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContactImportRowParam value)  $default,){
final _that = this;
switch (_that) {
case _ContactImportRowParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContactImportRowParam value)?  $default,){
final _that = this;
switch (_that) {
case _ContactImportRowParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String phoneNumber,  ContactMarket market,  String? firstName,  String? lastName,  String? company,  String? jobTitle,  String? email,  bool? hasPriorConsent,  bool? hasOptedOut,  bool? professionalRelevanceConfirmed,  Map<String, String> customFields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContactImportRowParam() when $default != null:
return $default(_that.phoneNumber,_that.market,_that.firstName,_that.lastName,_that.company,_that.jobTitle,_that.email,_that.hasPriorConsent,_that.hasOptedOut,_that.professionalRelevanceConfirmed,_that.customFields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String phoneNumber,  ContactMarket market,  String? firstName,  String? lastName,  String? company,  String? jobTitle,  String? email,  bool? hasPriorConsent,  bool? hasOptedOut,  bool? professionalRelevanceConfirmed,  Map<String, String> customFields)  $default,) {final _that = this;
switch (_that) {
case _ContactImportRowParam():
return $default(_that.phoneNumber,_that.market,_that.firstName,_that.lastName,_that.company,_that.jobTitle,_that.email,_that.hasPriorConsent,_that.hasOptedOut,_that.professionalRelevanceConfirmed,_that.customFields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String phoneNumber,  ContactMarket market,  String? firstName,  String? lastName,  String? company,  String? jobTitle,  String? email,  bool? hasPriorConsent,  bool? hasOptedOut,  bool? professionalRelevanceConfirmed,  Map<String, String> customFields)?  $default,) {final _that = this;
switch (_that) {
case _ContactImportRowParam() when $default != null:
return $default(_that.phoneNumber,_that.market,_that.firstName,_that.lastName,_that.company,_that.jobTitle,_that.email,_that.hasPriorConsent,_that.hasOptedOut,_that.professionalRelevanceConfirmed,_that.customFields);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ContactImportRowParam implements ContactImportRowParam {
  const _ContactImportRowParam({required this.phoneNumber, this.market = ContactMarket.unknown, this.firstName, this.lastName, this.company, this.jobTitle, this.email, this.hasPriorConsent, this.hasOptedOut, this.professionalRelevanceConfirmed, final  Map<String, String> customFields = const <String, String>{}}): _customFields = customFields;
  factory _ContactImportRowParam.fromJson(Map<String, dynamic> json) => _$ContactImportRowParamFromJson(json);

@override final  String phoneNumber;
@override@JsonKey() final  ContactMarket market;
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


/// Create a copy of ContactImportRowParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContactImportRowParamCopyWith<_ContactImportRowParam> get copyWith => __$ContactImportRowParamCopyWithImpl<_ContactImportRowParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContactImportRowParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContactImportRowParam&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.market, market) || other.market == market)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.company, company) || other.company == company)&&(identical(other.jobTitle, jobTitle) || other.jobTitle == jobTitle)&&(identical(other.email, email) || other.email == email)&&(identical(other.hasPriorConsent, hasPriorConsent) || other.hasPriorConsent == hasPriorConsent)&&(identical(other.hasOptedOut, hasOptedOut) || other.hasOptedOut == hasOptedOut)&&(identical(other.professionalRelevanceConfirmed, professionalRelevanceConfirmed) || other.professionalRelevanceConfirmed == professionalRelevanceConfirmed)&&const DeepCollectionEquality().equals(other._customFields, _customFields));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phoneNumber,market,firstName,lastName,company,jobTitle,email,hasPriorConsent,hasOptedOut,professionalRelevanceConfirmed,const DeepCollectionEquality().hash(_customFields));

@override
String toString() {
  return 'ContactImportRowParam(phoneNumber: $phoneNumber, market: $market, firstName: $firstName, lastName: $lastName, company: $company, jobTitle: $jobTitle, email: $email, hasPriorConsent: $hasPriorConsent, hasOptedOut: $hasOptedOut, professionalRelevanceConfirmed: $professionalRelevanceConfirmed, customFields: $customFields)';
}


}

/// @nodoc
abstract mixin class _$ContactImportRowParamCopyWith<$Res> implements $ContactImportRowParamCopyWith<$Res> {
  factory _$ContactImportRowParamCopyWith(_ContactImportRowParam value, $Res Function(_ContactImportRowParam) _then) = __$ContactImportRowParamCopyWithImpl;
@override @useResult
$Res call({
 String phoneNumber, ContactMarket market, String? firstName, String? lastName, String? company, String? jobTitle, String? email, bool? hasPriorConsent, bool? hasOptedOut, bool? professionalRelevanceConfirmed, Map<String, String> customFields
});




}
/// @nodoc
class __$ContactImportRowParamCopyWithImpl<$Res>
    implements _$ContactImportRowParamCopyWith<$Res> {
  __$ContactImportRowParamCopyWithImpl(this._self, this._then);

  final _ContactImportRowParam _self;
  final $Res Function(_ContactImportRowParam) _then;

/// Create a copy of ContactImportRowParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phoneNumber = null,Object? market = null,Object? firstName = freezed,Object? lastName = freezed,Object? company = freezed,Object? jobTitle = freezed,Object? email = freezed,Object? hasPriorConsent = freezed,Object? hasOptedOut = freezed,Object? professionalRelevanceConfirmed = freezed,Object? customFields = null,}) {
  return _then(_ContactImportRowParam(
phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,market: null == market ? _self.market : market // ignore: cast_nullable_to_non_nullable
as ContactMarket,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
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


/// @nodoc
mixin _$ImportContactsParam {

 String get sourceName; List<ContactImportRowParam> get rows;
/// Create a copy of ImportContactsParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportContactsParamCopyWith<ImportContactsParam> get copyWith => _$ImportContactsParamCopyWithImpl<ImportContactsParam>(this as ImportContactsParam, _$identity);

  /// Serializes this ImportContactsParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportContactsParam&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&const DeepCollectionEquality().equals(other.rows, rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceName,const DeepCollectionEquality().hash(rows));

@override
String toString() {
  return 'ImportContactsParam(sourceName: $sourceName, rows: $rows)';
}


}

/// @nodoc
abstract mixin class $ImportContactsParamCopyWith<$Res>  {
  factory $ImportContactsParamCopyWith(ImportContactsParam value, $Res Function(ImportContactsParam) _then) = _$ImportContactsParamCopyWithImpl;
@useResult
$Res call({
 String sourceName, List<ContactImportRowParam> rows
});




}
/// @nodoc
class _$ImportContactsParamCopyWithImpl<$Res>
    implements $ImportContactsParamCopyWith<$Res> {
  _$ImportContactsParamCopyWithImpl(this._self, this._then);

  final ImportContactsParam _self;
  final $Res Function(ImportContactsParam) _then;

/// Create a copy of ImportContactsParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceName = null,Object? rows = null,}) {
  return _then(_self.copyWith(
sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,rows: null == rows ? _self.rows : rows // ignore: cast_nullable_to_non_nullable
as List<ContactImportRowParam>,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportContactsParam].
extension ImportContactsParamPatterns on ImportContactsParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportContactsParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportContactsParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportContactsParam value)  $default,){
final _that = this;
switch (_that) {
case _ImportContactsParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportContactsParam value)?  $default,){
final _that = this;
switch (_that) {
case _ImportContactsParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceName,  List<ContactImportRowParam> rows)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportContactsParam() when $default != null:
return $default(_that.sourceName,_that.rows);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceName,  List<ContactImportRowParam> rows)  $default,) {final _that = this;
switch (_that) {
case _ImportContactsParam():
return $default(_that.sourceName,_that.rows);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceName,  List<ContactImportRowParam> rows)?  $default,) {final _that = this;
switch (_that) {
case _ImportContactsParam() when $default != null:
return $default(_that.sourceName,_that.rows);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _ImportContactsParam implements ImportContactsParam {
  const _ImportContactsParam({required this.sourceName, required final  List<ContactImportRowParam> rows}): _rows = rows;
  factory _ImportContactsParam.fromJson(Map<String, dynamic> json) => _$ImportContactsParamFromJson(json);

@override final  String sourceName;
 final  List<ContactImportRowParam> _rows;
@override List<ContactImportRowParam> get rows {
  if (_rows is EqualUnmodifiableListView) return _rows;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rows);
}


/// Create a copy of ImportContactsParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportContactsParamCopyWith<_ImportContactsParam> get copyWith => __$ImportContactsParamCopyWithImpl<_ImportContactsParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ImportContactsParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportContactsParam&&(identical(other.sourceName, sourceName) || other.sourceName == sourceName)&&const DeepCollectionEquality().equals(other._rows, _rows));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sourceName,const DeepCollectionEquality().hash(_rows));

@override
String toString() {
  return 'ImportContactsParam(sourceName: $sourceName, rows: $rows)';
}


}

/// @nodoc
abstract mixin class _$ImportContactsParamCopyWith<$Res> implements $ImportContactsParamCopyWith<$Res> {
  factory _$ImportContactsParamCopyWith(_ImportContactsParam value, $Res Function(_ImportContactsParam) _then) = __$ImportContactsParamCopyWithImpl;
@override @useResult
$Res call({
 String sourceName, List<ContactImportRowParam> rows
});




}
/// @nodoc
class __$ImportContactsParamCopyWithImpl<$Res>
    implements _$ImportContactsParamCopyWith<$Res> {
  __$ImportContactsParamCopyWithImpl(this._self, this._then);

  final _ImportContactsParam _self;
  final $Res Function(_ImportContactsParam) _then;

/// Create a copy of ImportContactsParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceName = null,Object? rows = null,}) {
  return _then(_ImportContactsParam(
sourceName: null == sourceName ? _self.sourceName : sourceName // ignore: cast_nullable_to_non_nullable
as String,rows: null == rows ? _self._rows : rows // ignore: cast_nullable_to_non_nullable
as List<ContactImportRowParam>,
  ));
}


}

// dart format on
