// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external_conversation_session.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExternalConversationSessionRemoteModel {

 ConversationSessionRemoteModel get session; String get source; String get locale; String get mediaToken; ExternalMediaConfigurationRemoteModel get media; bool get consentRequired; String? get title;
/// Create a copy of ExternalConversationSessionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalConversationSessionRemoteModelCopyWith<ExternalConversationSessionRemoteModel> get copyWith => _$ExternalConversationSessionRemoteModelCopyWithImpl<ExternalConversationSessionRemoteModel>(this as ExternalConversationSessionRemoteModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalConversationSessionRemoteModel&&(identical(other.session, session) || other.session == session)&&(identical(other.source, source) || other.source == source)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.mediaToken, mediaToken) || other.mediaToken == mediaToken)&&(identical(other.media, media) || other.media == media)&&(identical(other.consentRequired, consentRequired) || other.consentRequired == consentRequired)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,session,source,locale,mediaToken,media,consentRequired,title);

@override
String toString() {
  return 'ExternalConversationSessionRemoteModel(session: $session, source: $source, locale: $locale, mediaToken: $mediaToken, media: $media, consentRequired: $consentRequired, title: $title)';
}


}

/// @nodoc
abstract mixin class $ExternalConversationSessionRemoteModelCopyWith<$Res>  {
  factory $ExternalConversationSessionRemoteModelCopyWith(ExternalConversationSessionRemoteModel value, $Res Function(ExternalConversationSessionRemoteModel) _then) = _$ExternalConversationSessionRemoteModelCopyWithImpl;
@useResult
$Res call({
 ConversationSessionRemoteModel session, String source, String locale, String mediaToken, ExternalMediaConfigurationRemoteModel media, bool consentRequired, String? title
});


$ConversationSessionRemoteModelCopyWith<$Res> get session;$ExternalMediaConfigurationRemoteModelCopyWith<$Res> get media;

}
/// @nodoc
class _$ExternalConversationSessionRemoteModelCopyWithImpl<$Res>
    implements $ExternalConversationSessionRemoteModelCopyWith<$Res> {
  _$ExternalConversationSessionRemoteModelCopyWithImpl(this._self, this._then);

  final ExternalConversationSessionRemoteModel _self;
  final $Res Function(ExternalConversationSessionRemoteModel) _then;

/// Create a copy of ExternalConversationSessionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? source = null,Object? locale = null,Object? mediaToken = null,Object? media = null,Object? consentRequired = null,Object? title = freezed,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as ConversationSessionRemoteModel,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,mediaToken: null == mediaToken ? _self.mediaToken : mediaToken // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ExternalMediaConfigurationRemoteModel,consentRequired: null == consentRequired ? _self.consentRequired : consentRequired // ignore: cast_nullable_to_non_nullable
as bool,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ExternalConversationSessionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationSessionRemoteModelCopyWith<$Res> get session {
  
  return $ConversationSessionRemoteModelCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of ExternalConversationSessionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExternalMediaConfigurationRemoteModelCopyWith<$Res> get media {
  
  return $ExternalMediaConfigurationRemoteModelCopyWith<$Res>(_self.media, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExternalConversationSessionRemoteModel].
extension ExternalConversationSessionRemoteModelPatterns on ExternalConversationSessionRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExternalConversationSessionRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExternalConversationSessionRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExternalConversationSessionRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _ExternalConversationSessionRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExternalConversationSessionRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExternalConversationSessionRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ConversationSessionRemoteModel session,  String source,  String locale,  String mediaToken,  ExternalMediaConfigurationRemoteModel media,  bool consentRequired,  String? title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExternalConversationSessionRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ConversationSessionRemoteModel session,  String source,  String locale,  String mediaToken,  ExternalMediaConfigurationRemoteModel media,  bool consentRequired,  String? title)  $default,) {final _that = this;
switch (_that) {
case _ExternalConversationSessionRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ConversationSessionRemoteModel session,  String source,  String locale,  String mediaToken,  ExternalMediaConfigurationRemoteModel media,  bool consentRequired,  String? title)?  $default,) {final _that = this;
switch (_that) {
case _ExternalConversationSessionRemoteModel() when $default != null:
return $default(_that.session,_that.source,_that.locale,_that.mediaToken,_that.media,_that.consentRequired,_that.title);case _:
  return null;

}
}

}

/// @nodoc


class _ExternalConversationSessionRemoteModel implements ExternalConversationSessionRemoteModel {
  const _ExternalConversationSessionRemoteModel({required this.session, required this.source, required this.locale, required this.mediaToken, required this.media, this.consentRequired = true, this.title});
  

@override final  ConversationSessionRemoteModel session;
@override final  String source;
@override final  String locale;
@override final  String mediaToken;
@override final  ExternalMediaConfigurationRemoteModel media;
@override@JsonKey() final  bool consentRequired;
@override final  String? title;

/// Create a copy of ExternalConversationSessionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExternalConversationSessionRemoteModelCopyWith<_ExternalConversationSessionRemoteModel> get copyWith => __$ExternalConversationSessionRemoteModelCopyWithImpl<_ExternalConversationSessionRemoteModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExternalConversationSessionRemoteModel&&(identical(other.session, session) || other.session == session)&&(identical(other.source, source) || other.source == source)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.mediaToken, mediaToken) || other.mediaToken == mediaToken)&&(identical(other.media, media) || other.media == media)&&(identical(other.consentRequired, consentRequired) || other.consentRequired == consentRequired)&&(identical(other.title, title) || other.title == title));
}


@override
int get hashCode => Object.hash(runtimeType,session,source,locale,mediaToken,media,consentRequired,title);

@override
String toString() {
  return 'ExternalConversationSessionRemoteModel(session: $session, source: $source, locale: $locale, mediaToken: $mediaToken, media: $media, consentRequired: $consentRequired, title: $title)';
}


}

/// @nodoc
abstract mixin class _$ExternalConversationSessionRemoteModelCopyWith<$Res> implements $ExternalConversationSessionRemoteModelCopyWith<$Res> {
  factory _$ExternalConversationSessionRemoteModelCopyWith(_ExternalConversationSessionRemoteModel value, $Res Function(_ExternalConversationSessionRemoteModel) _then) = __$ExternalConversationSessionRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 ConversationSessionRemoteModel session, String source, String locale, String mediaToken, ExternalMediaConfigurationRemoteModel media, bool consentRequired, String? title
});


@override $ConversationSessionRemoteModelCopyWith<$Res> get session;@override $ExternalMediaConfigurationRemoteModelCopyWith<$Res> get media;

}
/// @nodoc
class __$ExternalConversationSessionRemoteModelCopyWithImpl<$Res>
    implements _$ExternalConversationSessionRemoteModelCopyWith<$Res> {
  __$ExternalConversationSessionRemoteModelCopyWithImpl(this._self, this._then);

  final _ExternalConversationSessionRemoteModel _self;
  final $Res Function(_ExternalConversationSessionRemoteModel) _then;

/// Create a copy of ExternalConversationSessionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? source = null,Object? locale = null,Object? mediaToken = null,Object? media = null,Object? consentRequired = null,Object? title = freezed,}) {
  return _then(_ExternalConversationSessionRemoteModel(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as ConversationSessionRemoteModel,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,mediaToken: null == mediaToken ? _self.mediaToken : mediaToken // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as ExternalMediaConfigurationRemoteModel,consentRequired: null == consentRequired ? _self.consentRequired : consentRequired // ignore: cast_nullable_to_non_nullable
as bool,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ExternalConversationSessionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ConversationSessionRemoteModelCopyWith<$Res> get session {
  
  return $ConversationSessionRemoteModelCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of ExternalConversationSessionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExternalMediaConfigurationRemoteModelCopyWith<$Res> get media {
  
  return $ExternalMediaConfigurationRemoteModelCopyWith<$Res>(_self.media, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}

// dart format on
