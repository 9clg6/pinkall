// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'briefing_transcription.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BriefingTranscriptionEntity {

/// Complete transcript ready to insert into the briefing field.
 String get text;/// STT adapter and model that produced the transcript.
 String get provider;/// Provider-detected language, when available.
 String? get languageCode;
/// Create a copy of BriefingTranscriptionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BriefingTranscriptionEntityCopyWith<BriefingTranscriptionEntity> get copyWith => _$BriefingTranscriptionEntityCopyWithImpl<BriefingTranscriptionEntity>(this as BriefingTranscriptionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BriefingTranscriptionEntity&&(identical(other.text, text) || other.text == text)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode => Object.hash(runtimeType,text,provider,languageCode);

@override
String toString() {
  return 'BriefingTranscriptionEntity(text: $text, provider: $provider, languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class $BriefingTranscriptionEntityCopyWith<$Res>  {
  factory $BriefingTranscriptionEntityCopyWith(BriefingTranscriptionEntity value, $Res Function(BriefingTranscriptionEntity) _then) = _$BriefingTranscriptionEntityCopyWithImpl;
@useResult
$Res call({
 String text, String provider, String? languageCode
});




}
/// @nodoc
class _$BriefingTranscriptionEntityCopyWithImpl<$Res>
    implements $BriefingTranscriptionEntityCopyWith<$Res> {
  _$BriefingTranscriptionEntityCopyWithImpl(this._self, this._then);

  final BriefingTranscriptionEntity _self;
  final $Res Function(BriefingTranscriptionEntity) _then;

/// Create a copy of BriefingTranscriptionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? provider = null,Object? languageCode = freezed,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BriefingTranscriptionEntity].
extension BriefingTranscriptionEntityPatterns on BriefingTranscriptionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BriefingTranscriptionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BriefingTranscriptionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BriefingTranscriptionEntity value)  $default,){
final _that = this;
switch (_that) {
case _BriefingTranscriptionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BriefingTranscriptionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BriefingTranscriptionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String provider,  String? languageCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BriefingTranscriptionEntity() when $default != null:
return $default(_that.text,_that.provider,_that.languageCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String provider,  String? languageCode)  $default,) {final _that = this;
switch (_that) {
case _BriefingTranscriptionEntity():
return $default(_that.text,_that.provider,_that.languageCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String provider,  String? languageCode)?  $default,) {final _that = this;
switch (_that) {
case _BriefingTranscriptionEntity() when $default != null:
return $default(_that.text,_that.provider,_that.languageCode);case _:
  return null;

}
}

}

/// @nodoc


class _BriefingTranscriptionEntity implements BriefingTranscriptionEntity {
  const _BriefingTranscriptionEntity({required this.text, required this.provider, this.languageCode});
  

/// Complete transcript ready to insert into the briefing field.
@override final  String text;
/// STT adapter and model that produced the transcript.
@override final  String provider;
/// Provider-detected language, when available.
@override final  String? languageCode;

/// Create a copy of BriefingTranscriptionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BriefingTranscriptionEntityCopyWith<_BriefingTranscriptionEntity> get copyWith => __$BriefingTranscriptionEntityCopyWithImpl<_BriefingTranscriptionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BriefingTranscriptionEntity&&(identical(other.text, text) || other.text == text)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}


@override
int get hashCode => Object.hash(runtimeType,text,provider,languageCode);

@override
String toString() {
  return 'BriefingTranscriptionEntity(text: $text, provider: $provider, languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class _$BriefingTranscriptionEntityCopyWith<$Res> implements $BriefingTranscriptionEntityCopyWith<$Res> {
  factory _$BriefingTranscriptionEntityCopyWith(_BriefingTranscriptionEntity value, $Res Function(_BriefingTranscriptionEntity) _then) = __$BriefingTranscriptionEntityCopyWithImpl;
@override @useResult
$Res call({
 String text, String provider, String? languageCode
});




}
/// @nodoc
class __$BriefingTranscriptionEntityCopyWithImpl<$Res>
    implements _$BriefingTranscriptionEntityCopyWith<$Res> {
  __$BriefingTranscriptionEntityCopyWithImpl(this._self, this._then);

  final _BriefingTranscriptionEntity _self;
  final $Res Function(_BriefingTranscriptionEntity) _then;

/// Create a copy of BriefingTranscriptionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? provider = null,Object? languageCode = freezed,}) {
  return _then(_BriefingTranscriptionEntity(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
