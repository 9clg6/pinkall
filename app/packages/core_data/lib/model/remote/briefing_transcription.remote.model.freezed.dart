// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'briefing_transcription.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BriefingTranscriptionRemoteModel {

/// Complete provider transcript.
 String get text;/// STT adapter and model identifier.
 String get provider;/// Provider-detected language, when available.
@JsonKey(name: 'language') String? get languageCode;
/// Create a copy of BriefingTranscriptionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BriefingTranscriptionRemoteModelCopyWith<BriefingTranscriptionRemoteModel> get copyWith => _$BriefingTranscriptionRemoteModelCopyWithImpl<BriefingTranscriptionRemoteModel>(this as BriefingTranscriptionRemoteModel, _$identity);

  /// Serializes this BriefingTranscriptionRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BriefingTranscriptionRemoteModel&&(identical(other.text, text) || other.text == text)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,provider,languageCode);

@override
String toString() {
  return 'BriefingTranscriptionRemoteModel(text: $text, provider: $provider, languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class $BriefingTranscriptionRemoteModelCopyWith<$Res>  {
  factory $BriefingTranscriptionRemoteModelCopyWith(BriefingTranscriptionRemoteModel value, $Res Function(BriefingTranscriptionRemoteModel) _then) = _$BriefingTranscriptionRemoteModelCopyWithImpl;
@useResult
$Res call({
 String text, String provider,@JsonKey(name: 'language') String? languageCode
});




}
/// @nodoc
class _$BriefingTranscriptionRemoteModelCopyWithImpl<$Res>
    implements $BriefingTranscriptionRemoteModelCopyWith<$Res> {
  _$BriefingTranscriptionRemoteModelCopyWithImpl(this._self, this._then);

  final BriefingTranscriptionRemoteModel _self;
  final $Res Function(BriefingTranscriptionRemoteModel) _then;

/// Create a copy of BriefingTranscriptionRemoteModel
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


/// Adds pattern-matching-related methods to [BriefingTranscriptionRemoteModel].
extension BriefingTranscriptionRemoteModelPatterns on BriefingTranscriptionRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BriefingTranscriptionRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BriefingTranscriptionRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BriefingTranscriptionRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _BriefingTranscriptionRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BriefingTranscriptionRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _BriefingTranscriptionRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String provider, @JsonKey(name: 'language')  String? languageCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BriefingTranscriptionRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String provider, @JsonKey(name: 'language')  String? languageCode)  $default,) {final _that = this;
switch (_that) {
case _BriefingTranscriptionRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String provider, @JsonKey(name: 'language')  String? languageCode)?  $default,) {final _that = this;
switch (_that) {
case _BriefingTranscriptionRemoteModel() when $default != null:
return $default(_that.text,_that.provider,_that.languageCode);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _BriefingTranscriptionRemoteModel implements BriefingTranscriptionRemoteModel {
  const _BriefingTranscriptionRemoteModel({required this.text, required this.provider, @JsonKey(name: 'language') this.languageCode});
  factory _BriefingTranscriptionRemoteModel.fromJson(Map<String, dynamic> json) => _$BriefingTranscriptionRemoteModelFromJson(json);

/// Complete provider transcript.
@override final  String text;
/// STT adapter and model identifier.
@override final  String provider;
/// Provider-detected language, when available.
@override@JsonKey(name: 'language') final  String? languageCode;

/// Create a copy of BriefingTranscriptionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BriefingTranscriptionRemoteModelCopyWith<_BriefingTranscriptionRemoteModel> get copyWith => __$BriefingTranscriptionRemoteModelCopyWithImpl<_BriefingTranscriptionRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BriefingTranscriptionRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BriefingTranscriptionRemoteModel&&(identical(other.text, text) || other.text == text)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,provider,languageCode);

@override
String toString() {
  return 'BriefingTranscriptionRemoteModel(text: $text, provider: $provider, languageCode: $languageCode)';
}


}

/// @nodoc
abstract mixin class _$BriefingTranscriptionRemoteModelCopyWith<$Res> implements $BriefingTranscriptionRemoteModelCopyWith<$Res> {
  factory _$BriefingTranscriptionRemoteModelCopyWith(_BriefingTranscriptionRemoteModel value, $Res Function(_BriefingTranscriptionRemoteModel) _then) = __$BriefingTranscriptionRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String text, String provider,@JsonKey(name: 'language') String? languageCode
});




}
/// @nodoc
class __$BriefingTranscriptionRemoteModelCopyWithImpl<$Res>
    implements _$BriefingTranscriptionRemoteModelCopyWith<$Res> {
  __$BriefingTranscriptionRemoteModelCopyWithImpl(this._self, this._then);

  final _BriefingTranscriptionRemoteModel _self;
  final $Res Function(_BriefingTranscriptionRemoteModel) _then;

/// Create a copy of BriefingTranscriptionRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? provider = null,Object? languageCode = freezed,}) {
  return _then(_BriefingTranscriptionRemoteModel(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,languageCode: freezed == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
