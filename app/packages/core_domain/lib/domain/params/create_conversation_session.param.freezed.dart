// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_conversation_session.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateConversationSessionParam {

 String get callId; String get destinationNumber; String? get contactId; CoachMode? get coachModeOverride; String? get locale; String? get preparationMarkdown; Map<String, String> get context;
/// Create a copy of CreateConversationSessionParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateConversationSessionParamCopyWith<CreateConversationSessionParam> get copyWith => _$CreateConversationSessionParamCopyWithImpl<CreateConversationSessionParam>(this as CreateConversationSessionParam, _$identity);

  /// Serializes this CreateConversationSessionParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateConversationSessionParam&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.destinationNumber, destinationNumber) || other.destinationNumber == destinationNumber)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.coachModeOverride, coachModeOverride) || other.coachModeOverride == coachModeOverride)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.preparationMarkdown, preparationMarkdown) || other.preparationMarkdown == preparationMarkdown)&&const DeepCollectionEquality().equals(other.context, context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,destinationNumber,contactId,coachModeOverride,locale,preparationMarkdown,const DeepCollectionEquality().hash(context));

@override
String toString() {
  return 'CreateConversationSessionParam(callId: $callId, destinationNumber: $destinationNumber, contactId: $contactId, coachModeOverride: $coachModeOverride, locale: $locale, preparationMarkdown: $preparationMarkdown, context: $context)';
}


}

/// @nodoc
abstract mixin class $CreateConversationSessionParamCopyWith<$Res>  {
  factory $CreateConversationSessionParamCopyWith(CreateConversationSessionParam value, $Res Function(CreateConversationSessionParam) _then) = _$CreateConversationSessionParamCopyWithImpl;
@useResult
$Res call({
 String callId, String destinationNumber, String? contactId, CoachMode? coachModeOverride, String? locale, String? preparationMarkdown, Map<String, String> context
});




}
/// @nodoc
class _$CreateConversationSessionParamCopyWithImpl<$Res>
    implements $CreateConversationSessionParamCopyWith<$Res> {
  _$CreateConversationSessionParamCopyWithImpl(this._self, this._then);

  final CreateConversationSessionParam _self;
  final $Res Function(CreateConversationSessionParam) _then;

/// Create a copy of CreateConversationSessionParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? destinationNumber = null,Object? contactId = freezed,Object? coachModeOverride = freezed,Object? locale = freezed,Object? preparationMarkdown = freezed,Object? context = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,destinationNumber: null == destinationNumber ? _self.destinationNumber : destinationNumber // ignore: cast_nullable_to_non_nullable
as String,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,coachModeOverride: freezed == coachModeOverride ? _self.coachModeOverride : coachModeOverride // ignore: cast_nullable_to_non_nullable
as CoachMode?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,preparationMarkdown: freezed == preparationMarkdown ? _self.preparationMarkdown : preparationMarkdown // ignore: cast_nullable_to_non_nullable
as String?,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateConversationSessionParam].
extension CreateConversationSessionParamPatterns on CreateConversationSessionParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateConversationSessionParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateConversationSessionParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateConversationSessionParam value)  $default,){
final _that = this;
switch (_that) {
case _CreateConversationSessionParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateConversationSessionParam value)?  $default,){
final _that = this;
switch (_that) {
case _CreateConversationSessionParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String destinationNumber,  String? contactId,  CoachMode? coachModeOverride,  String? locale,  String? preparationMarkdown,  Map<String, String> context)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateConversationSessionParam() when $default != null:
return $default(_that.callId,_that.destinationNumber,_that.contactId,_that.coachModeOverride,_that.locale,_that.preparationMarkdown,_that.context);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String destinationNumber,  String? contactId,  CoachMode? coachModeOverride,  String? locale,  String? preparationMarkdown,  Map<String, String> context)  $default,) {final _that = this;
switch (_that) {
case _CreateConversationSessionParam():
return $default(_that.callId,_that.destinationNumber,_that.contactId,_that.coachModeOverride,_that.locale,_that.preparationMarkdown,_that.context);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String destinationNumber,  String? contactId,  CoachMode? coachModeOverride,  String? locale,  String? preparationMarkdown,  Map<String, String> context)?  $default,) {final _that = this;
switch (_that) {
case _CreateConversationSessionParam() when $default != null:
return $default(_that.callId,_that.destinationNumber,_that.contactId,_that.coachModeOverride,_that.locale,_that.preparationMarkdown,_that.context);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CreateConversationSessionParam implements CreateConversationSessionParam {
  const _CreateConversationSessionParam({required this.callId, required this.destinationNumber, this.contactId, this.coachModeOverride, this.locale, this.preparationMarkdown, final  Map<String, String> context = const <String, String>{}}): _context = context;
  factory _CreateConversationSessionParam.fromJson(Map<String, dynamic> json) => _$CreateConversationSessionParamFromJson(json);

@override final  String callId;
@override final  String destinationNumber;
@override final  String? contactId;
@override final  CoachMode? coachModeOverride;
@override final  String? locale;
@override final  String? preparationMarkdown;
 final  Map<String, String> _context;
@override@JsonKey() Map<String, String> get context {
  if (_context is EqualUnmodifiableMapView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_context);
}


/// Create a copy of CreateConversationSessionParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateConversationSessionParamCopyWith<_CreateConversationSessionParam> get copyWith => __$CreateConversationSessionParamCopyWithImpl<_CreateConversationSessionParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateConversationSessionParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateConversationSessionParam&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.destinationNumber, destinationNumber) || other.destinationNumber == destinationNumber)&&(identical(other.contactId, contactId) || other.contactId == contactId)&&(identical(other.coachModeOverride, coachModeOverride) || other.coachModeOverride == coachModeOverride)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.preparationMarkdown, preparationMarkdown) || other.preparationMarkdown == preparationMarkdown)&&const DeepCollectionEquality().equals(other._context, _context));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,destinationNumber,contactId,coachModeOverride,locale,preparationMarkdown,const DeepCollectionEquality().hash(_context));

@override
String toString() {
  return 'CreateConversationSessionParam(callId: $callId, destinationNumber: $destinationNumber, contactId: $contactId, coachModeOverride: $coachModeOverride, locale: $locale, preparationMarkdown: $preparationMarkdown, context: $context)';
}


}

/// @nodoc
abstract mixin class _$CreateConversationSessionParamCopyWith<$Res> implements $CreateConversationSessionParamCopyWith<$Res> {
  factory _$CreateConversationSessionParamCopyWith(_CreateConversationSessionParam value, $Res Function(_CreateConversationSessionParam) _then) = __$CreateConversationSessionParamCopyWithImpl;
@override @useResult
$Res call({
 String callId, String destinationNumber, String? contactId, CoachMode? coachModeOverride, String? locale, String? preparationMarkdown, Map<String, String> context
});




}
/// @nodoc
class __$CreateConversationSessionParamCopyWithImpl<$Res>
    implements _$CreateConversationSessionParamCopyWith<$Res> {
  __$CreateConversationSessionParamCopyWithImpl(this._self, this._then);

  final _CreateConversationSessionParam _self;
  final $Res Function(_CreateConversationSessionParam) _then;

/// Create a copy of CreateConversationSessionParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? destinationNumber = null,Object? contactId = freezed,Object? coachModeOverride = freezed,Object? locale = freezed,Object? preparationMarkdown = freezed,Object? context = null,}) {
  return _then(_CreateConversationSessionParam(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,destinationNumber: null == destinationNumber ? _self.destinationNumber : destinationNumber // ignore: cast_nullable_to_non_nullable
as String,contactId: freezed == contactId ? _self.contactId : contactId // ignore: cast_nullable_to_non_nullable
as String?,coachModeOverride: freezed == coachModeOverride ? _self.coachModeOverride : coachModeOverride // ignore: cast_nullable_to_non_nullable
as CoachMode?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,preparationMarkdown: freezed == preparationMarkdown ? _self.preparationMarkdown : preparationMarkdown // ignore: cast_nullable_to_non_nullable
as String?,context: null == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
