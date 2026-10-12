// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external_conversation_session.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExternalConversationSessionEntity {

 ConversationSessionEntity get session; ExternalConversationSource get source; String get locale; String get mediaToken; ExternalMediaConfigurationEntity get media; bool get consentRequired; String? get title;
/// Create a copy of ExternalConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalConversationSessionEntityCopyWith<ExternalConversationSessionEntity> get copyWith => _$ExternalConversationSessionEntityCopyWithImpl<ExternalConversationSessionEntity>(this as ExternalConversationSessionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalConversationSessionEntity&&(identical(other.session, session) || other.session == session)&&(identical(other.source, source) || other.source == source)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.mediaToken, mediaToken) || other.mediaToken == mediaToken)&&(identical(other.media, media) || other.media == media)&&(identical(other.consentRequired, consentRequired) || other.consentRequired == consentRequired)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,session,source,locale,mediaToken,media,consentRequired,title);

@override
String toString() {
  return 'ExternalConversationSessionEntity(session: $session, source: $source, locale: $locale, mediaToken: $mediaToken, media: $media, consentRequired: $consentRequired, title: $title)';
}


}

/// @nodoc
abstract mixin class $ExternalConversationSessionEntityCopyWith<$Res>  {
  factory $ExternalConversationSessionEntityCopyWith(ExternalConversationSessionEntity value, $Res Function(ExternalConversationSessionEntity) _then) = _$ExternalConversationSessionEntityCopyWithImpl;
@useResult
$Res call({
 ConversationSessionEntity session, ExternalConversationSource source, String locale, String mediaToken, ExternalMediaConfigurationEntity media, bool consentRequired, String? title
});


$ConversationSessionEntityCopyWith<$Res> get session;$ExternalMediaConfigurationEntityCopyWith<$Res> get media;

}
/// @nodoc
class _$ExternalConversationSessionEntityCopyWithImpl<$Res>
    implements $ExternalConversationSessionEntityCopyWith<$Res> {
  _$ExternalConversationSessionEntityCopyWithImpl(this._self, this._then);

  final ExternalConversationSessionEntity _self;
  final $Res Function(ExternalConversationSessionEntity) _then;

/// Create a copy of ExternalConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? source = null,Object? locale = null,Object? mediaToken = null,Object? media = null,Object? consentRequired = null,Object? title = freezed,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as ConversationSessionEntity,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ExternalConversationSource,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,mediaToken: null == mediaToken ? _self.mediaToken : mediaToken // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ExternalMediaConfigurationEntity,consentRequired: null == consentRequired ? _self.consentRequired : consentRequired // ignore: cast_nullable_to_non_nullable
as bool,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ExternalConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationSessionEntityCopyWith<$Res> get session {
  
  return $ConversationSessionEntityCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of ExternalConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExternalMediaConfigurationEntityCopyWith<$Res> get media {
  
  return $ExternalMediaConfigurationEntityCopyWith<$Res>(_self.media, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExternalConversationSessionEntity].
extension ExternalConversationSessionEntityPatterns on ExternalConversationSessionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExternalConversationSessionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExternalConversationSessionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExternalConversationSessionEntity value)  $default,){
final _that = this;
switch (_that) {
case _ExternalConversationSessionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExternalConversationSessionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ExternalConversationSessionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConversationSessionEntity session,  ExternalConversationSource source,  String locale,  String mediaToken,  ExternalMediaConfigurationEntity media,  bool consentRequired,  String? title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExternalConversationSessionEntity() when $default != null:
return $default(_that.session,_that.source,_that.locale,_that.mediaToken,_that.media,_that.consentRequired,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConversationSessionEntity session,  ExternalConversationSource source,  String locale,  String mediaToken,  ExternalMediaConfigurationEntity media,  bool consentRequired,  String? title)  $default,) {final _that = this;
switch (_that) {
case _ExternalConversationSessionEntity():
return $default(_that.session,_that.source,_that.locale,_that.mediaToken,_that.media,_that.consentRequired,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConversationSessionEntity session,  ExternalConversationSource source,  String locale,  String mediaToken,  ExternalMediaConfigurationEntity media,  bool consentRequired,  String? title)?  $default,) {final _that = this;
switch (_that) {
case _ExternalConversationSessionEntity() when $default != null:
return $default(_that.session,_that.source,_that.locale,_that.mediaToken,_that.media,_that.consentRequired,_that.title);case _:
  return null;

}
}

}

/// @nodoc


class _ExternalConversationSessionEntity implements ExternalConversationSessionEntity {
  const _ExternalConversationSessionEntity({required this.session, required this.source, required this.locale, required this.mediaToken, required this.media, this.consentRequired = true, this.title});
  

@override final  ConversationSessionEntity session;
@override final  ExternalConversationSource source;
@override final  String locale;
@override final  String mediaToken;
@override final  ExternalMediaConfigurationEntity media;
@override@JsonKey() final  bool consentRequired;
@override final  String? title;

/// Create a copy of ExternalConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExternalConversationSessionEntityCopyWith<_ExternalConversationSessionEntity> get copyWith => __$ExternalConversationSessionEntityCopyWithImpl<_ExternalConversationSessionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExternalConversationSessionEntity&&(identical(other.session, session) || other.session == session)&&(identical(other.source, source) || other.source == source)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.mediaToken, mediaToken) || other.mediaToken == mediaToken)&&(identical(other.media, media) || other.media == media)&&(identical(other.consentRequired, consentRequired) || other.consentRequired == consentRequired)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,session,source,locale,mediaToken,media,consentRequired,title);

@override
String toString() {
  return 'ExternalConversationSessionEntity(session: $session, source: $source, locale: $locale, mediaToken: $mediaToken, media: $media, consentRequired: $consentRequired, title: $title)';
}


}

/// @nodoc
abstract mixin class _$ExternalConversationSessionEntityCopyWith<$Res> implements $ExternalConversationSessionEntityCopyWith<$Res> {
  factory _$ExternalConversationSessionEntityCopyWith(_ExternalConversationSessionEntity value, $Res Function(_ExternalConversationSessionEntity) _then) = __$ExternalConversationSessionEntityCopyWithImpl;
@override @useResult
$Res call({
 ConversationSessionEntity session, ExternalConversationSource source, String locale, String mediaToken, ExternalMediaConfigurationEntity media, bool consentRequired, String? title
});


@override $ConversationSessionEntityCopyWith<$Res> get session;@override $ExternalMediaConfigurationEntityCopyWith<$Res> get media;

}
/// @nodoc
class __$ExternalConversationSessionEntityCopyWithImpl<$Res>
    implements _$ExternalConversationSessionEntityCopyWith<$Res> {
  __$ExternalConversationSessionEntityCopyWithImpl(this._self, this._then);

  final _ExternalConversationSessionEntity _self;
  final $Res Function(_ExternalConversationSessionEntity) _then;

/// Create a copy of ExternalConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? source = null,Object? locale = null,Object? mediaToken = null,Object? media = null,Object? consentRequired = null,Object? title = freezed,}) {
  return _then(_ExternalConversationSessionEntity(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as ConversationSessionEntity,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ExternalConversationSource,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,mediaToken: null == mediaToken ? _self.mediaToken : mediaToken // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ExternalMediaConfigurationEntity,consentRequired: null == consentRequired ? _self.consentRequired : consentRequired // ignore: cast_nullable_to_non_nullable
as bool,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ExternalConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationSessionEntityCopyWith<$Res> get session {
  
  return $ConversationSessionEntityCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of ExternalConversationSessionEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExternalMediaConfigurationEntityCopyWith<$Res> get media {
  
  return $ExternalMediaConfigurationEntityCopyWith<$Res>(_self.media, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}

// dart format on
