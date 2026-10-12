// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_external_conversation_session.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateExternalConversationSessionParam {

 ExternalConversationSource get source; String? get title; String? get preparationMarkdown; CoachMode? get coachModeOverride; String get locale;
/// Create a copy of CreateExternalConversationSessionParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateExternalConversationSessionParamCopyWith<CreateExternalConversationSessionParam> get copyWith => _$CreateExternalConversationSessionParamCopyWithImpl<CreateExternalConversationSessionParam>(this as CreateExternalConversationSessionParam, _$identity);

  /// Serializes this CreateExternalConversationSessionParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateExternalConversationSessionParam&&(identical(other.source, source) || other.source == source)&&(identical(other.title, title) || other.title == title)&&(identical(other.preparationMarkdown, preparationMarkdown) || other.preparationMarkdown == preparationMarkdown)&&(identical(other.coachModeOverride, coachModeOverride) || other.coachModeOverride == coachModeOverride)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,title,preparationMarkdown,coachModeOverride,locale);

@override
String toString() {
  return 'CreateExternalConversationSessionParam(source: $source, title: $title, preparationMarkdown: $preparationMarkdown, coachModeOverride: $coachModeOverride, locale: $locale)';
}


}

/// @nodoc
abstract mixin class $CreateExternalConversationSessionParamCopyWith<$Res>  {
  factory $CreateExternalConversationSessionParamCopyWith(CreateExternalConversationSessionParam value, $Res Function(CreateExternalConversationSessionParam) _then) = _$CreateExternalConversationSessionParamCopyWithImpl;
@useResult
$Res call({
 ExternalConversationSource source, String? title, String? preparationMarkdown, CoachMode? coachModeOverride, String locale
});




}
/// @nodoc
class _$CreateExternalConversationSessionParamCopyWithImpl<$Res>
    implements $CreateExternalConversationSessionParamCopyWith<$Res> {
  _$CreateExternalConversationSessionParamCopyWithImpl(this._self, this._then);

  final CreateExternalConversationSessionParam _self;
  final $Res Function(CreateExternalConversationSessionParam) _then;

/// Create a copy of CreateExternalConversationSessionParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? source = null,Object? title = freezed,Object? preparationMarkdown = freezed,Object? coachModeOverride = freezed,Object? locale = null,}) {
  return _then(_self.copyWith(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ExternalConversationSource,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,preparationMarkdown: freezed == preparationMarkdown ? _self.preparationMarkdown : preparationMarkdown // ignore: cast_nullable_to_non_nullable
as String?,coachModeOverride: freezed == coachModeOverride ? _self.coachModeOverride : coachModeOverride // ignore: cast_nullable_to_non_nullable
as CoachMode?,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateExternalConversationSessionParam].
extension CreateExternalConversationSessionParamPatterns on CreateExternalConversationSessionParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateExternalConversationSessionParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateExternalConversationSessionParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateExternalConversationSessionParam value)  $default,){
final _that = this;
switch (_that) {
case _CreateExternalConversationSessionParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateExternalConversationSessionParam value)?  $default,){
final _that = this;
switch (_that) {
case _CreateExternalConversationSessionParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExternalConversationSource source,  String? title,  String? preparationMarkdown,  CoachMode? coachModeOverride,  String locale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateExternalConversationSessionParam() when $default != null:
return $default(_that.source,_that.title,_that.preparationMarkdown,_that.coachModeOverride,_that.locale);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExternalConversationSource source,  String? title,  String? preparationMarkdown,  CoachMode? coachModeOverride,  String locale)  $default,) {final _that = this;
switch (_that) {
case _CreateExternalConversationSessionParam():
return $default(_that.source,_that.title,_that.preparationMarkdown,_that.coachModeOverride,_that.locale);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExternalConversationSource source,  String? title,  String? preparationMarkdown,  CoachMode? coachModeOverride,  String locale)?  $default,) {final _that = this;
switch (_that) {
case _CreateExternalConversationSessionParam() when $default != null:
return $default(_that.source,_that.title,_that.preparationMarkdown,_that.coachModeOverride,_that.locale);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CreateExternalConversationSessionParam implements CreateExternalConversationSessionParam {
  const _CreateExternalConversationSessionParam({this.source = ExternalConversationSource.macosMeeting, this.title, this.preparationMarkdown, this.coachModeOverride, this.locale = 'fr-FR'});
  factory _CreateExternalConversationSessionParam.fromJson(Map<String, dynamic> json) => _$CreateExternalConversationSessionParamFromJson(json);

@override@JsonKey() final  ExternalConversationSource source;
@override final  String? title;
@override final  String? preparationMarkdown;
@override final  CoachMode? coachModeOverride;
@override@JsonKey() final  String locale;

/// Create a copy of CreateExternalConversationSessionParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateExternalConversationSessionParamCopyWith<_CreateExternalConversationSessionParam> get copyWith => __$CreateExternalConversationSessionParamCopyWithImpl<_CreateExternalConversationSessionParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateExternalConversationSessionParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateExternalConversationSessionParam&&(identical(other.source, source) || other.source == source)&&(identical(other.title, title) || other.title == title)&&(identical(other.preparationMarkdown, preparationMarkdown) || other.preparationMarkdown == preparationMarkdown)&&(identical(other.coachModeOverride, coachModeOverride) || other.coachModeOverride == coachModeOverride)&&(identical(other.locale, locale) || other.locale == locale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,source,title,preparationMarkdown,coachModeOverride,locale);

@override
String toString() {
  return 'CreateExternalConversationSessionParam(source: $source, title: $title, preparationMarkdown: $preparationMarkdown, coachModeOverride: $coachModeOverride, locale: $locale)';
}


}

/// @nodoc
abstract mixin class _$CreateExternalConversationSessionParamCopyWith<$Res> implements $CreateExternalConversationSessionParamCopyWith<$Res> {
  factory _$CreateExternalConversationSessionParamCopyWith(_CreateExternalConversationSessionParam value, $Res Function(_CreateExternalConversationSessionParam) _then) = __$CreateExternalConversationSessionParamCopyWithImpl;
@override @useResult
$Res call({
 ExternalConversationSource source, String? title, String? preparationMarkdown, CoachMode? coachModeOverride, String locale
});




}
/// @nodoc
class __$CreateExternalConversationSessionParamCopyWithImpl<$Res>
    implements _$CreateExternalConversationSessionParamCopyWith<$Res> {
  __$CreateExternalConversationSessionParamCopyWithImpl(this._self, this._then);

  final _CreateExternalConversationSessionParam _self;
  final $Res Function(_CreateExternalConversationSessionParam) _then;

/// Create a copy of CreateExternalConversationSessionParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? source = null,Object? title = freezed,Object? preparationMarkdown = freezed,Object? coachModeOverride = freezed,Object? locale = null,}) {
  return _then(_CreateExternalConversationSessionParam(
source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ExternalConversationSource,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,preparationMarkdown: freezed == preparationMarkdown ? _self.preparationMarkdown : preparationMarkdown // ignore: cast_nullable_to_non_nullable
as String?,coachModeOverride: freezed == coachModeOverride ? _self.coachModeOverride : coachModeOverride // ignore: cast_nullable_to_non_nullable
as CoachMode?,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
