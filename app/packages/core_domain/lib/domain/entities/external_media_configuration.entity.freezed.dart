// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external_media_configuration.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExternalMediaConfigurationEntity {

 String get encoding; int get sampleRate; int get channels; Uri get sellerWebSocketUri; Uri get prospectWebSocketUri;
/// Create a copy of ExternalMediaConfigurationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalMediaConfigurationEntityCopyWith<ExternalMediaConfigurationEntity> get copyWith => _$ExternalMediaConfigurationEntityCopyWithImpl<ExternalMediaConfigurationEntity>(this as ExternalMediaConfigurationEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalMediaConfigurationEntity&&(identical(other.encoding, encoding) || other.encoding == encoding)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.sellerWebSocketUri, sellerWebSocketUri) || other.sellerWebSocketUri == sellerWebSocketUri)&&(identical(other.prospectWebSocketUri, prospectWebSocketUri) || other.prospectWebSocketUri == prospectWebSocketUri));
}


@override
int get hashCode => Object.hash(runtimeType,encoding,sampleRate,channels,sellerWebSocketUri,prospectWebSocketUri);

@override
String toString() {
  return 'ExternalMediaConfigurationEntity(encoding: $encoding, sampleRate: $sampleRate, channels: $channels, sellerWebSocketUri: $sellerWebSocketUri, prospectWebSocketUri: $prospectWebSocketUri)';
}


}

/// @nodoc
abstract mixin class $ExternalMediaConfigurationEntityCopyWith<$Res>  {
  factory $ExternalMediaConfigurationEntityCopyWith(ExternalMediaConfigurationEntity value, $Res Function(ExternalMediaConfigurationEntity) _then) = _$ExternalMediaConfigurationEntityCopyWithImpl;
@useResult
$Res call({
 String encoding, int sampleRate, int channels, Uri sellerWebSocketUri, Uri prospectWebSocketUri
});




}
/// @nodoc
class _$ExternalMediaConfigurationEntityCopyWithImpl<$Res>
    implements $ExternalMediaConfigurationEntityCopyWith<$Res> {
  _$ExternalMediaConfigurationEntityCopyWithImpl(this._self, this._then);

  final ExternalMediaConfigurationEntity _self;
  final $Res Function(ExternalMediaConfigurationEntity) _then;

/// Create a copy of ExternalMediaConfigurationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? encoding = null,Object? sampleRate = null,Object? channels = null,Object? sellerWebSocketUri = null,Object? prospectWebSocketUri = null,}) {
  return _then(_self.copyWith(
encoding: null == encoding ? _self.encoding : encoding // ignore: cast_nullable_to_non_nullable
as String,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,sellerWebSocketUri: null == sellerWebSocketUri ? _self.sellerWebSocketUri : sellerWebSocketUri // ignore: cast_nullable_to_non_nullable
as Uri,prospectWebSocketUri: null == prospectWebSocketUri ? _self.prospectWebSocketUri : prospectWebSocketUri // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}

}


/// Adds pattern-matching-related methods to [ExternalMediaConfigurationEntity].
extension ExternalMediaConfigurationEntityPatterns on ExternalMediaConfigurationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExternalMediaConfigurationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExternalMediaConfigurationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExternalMediaConfigurationEntity value)  $default,){
final _that = this;
switch (_that) {
case _ExternalMediaConfigurationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExternalMediaConfigurationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ExternalMediaConfigurationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String encoding,  int sampleRate,  int channels,  Uri sellerWebSocketUri,  Uri prospectWebSocketUri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExternalMediaConfigurationEntity() when $default != null:
return $default(_that.encoding,_that.sampleRate,_that.channels,_that.sellerWebSocketUri,_that.prospectWebSocketUri);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String encoding,  int sampleRate,  int channels,  Uri sellerWebSocketUri,  Uri prospectWebSocketUri)  $default,) {final _that = this;
switch (_that) {
case _ExternalMediaConfigurationEntity():
return $default(_that.encoding,_that.sampleRate,_that.channels,_that.sellerWebSocketUri,_that.prospectWebSocketUri);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String encoding,  int sampleRate,  int channels,  Uri sellerWebSocketUri,  Uri prospectWebSocketUri)?  $default,) {final _that = this;
switch (_that) {
case _ExternalMediaConfigurationEntity() when $default != null:
return $default(_that.encoding,_that.sampleRate,_that.channels,_that.sellerWebSocketUri,_that.prospectWebSocketUri);case _:
  return null;

}
}

}

/// @nodoc


class _ExternalMediaConfigurationEntity implements ExternalMediaConfigurationEntity {
  const _ExternalMediaConfigurationEntity({required this.encoding, required this.sampleRate, required this.channels, required this.sellerWebSocketUri, required this.prospectWebSocketUri});
  

@override final  String encoding;
@override final  int sampleRate;
@override final  int channels;
@override final  Uri sellerWebSocketUri;
@override final  Uri prospectWebSocketUri;

/// Create a copy of ExternalMediaConfigurationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExternalMediaConfigurationEntityCopyWith<_ExternalMediaConfigurationEntity> get copyWith => __$ExternalMediaConfigurationEntityCopyWithImpl<_ExternalMediaConfigurationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExternalMediaConfigurationEntity&&(identical(other.encoding, encoding) || other.encoding == encoding)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.sellerWebSocketUri, sellerWebSocketUri) || other.sellerWebSocketUri == sellerWebSocketUri)&&(identical(other.prospectWebSocketUri, prospectWebSocketUri) || other.prospectWebSocketUri == prospectWebSocketUri));
}


@override
int get hashCode => Object.hash(runtimeType,encoding,sampleRate,channels,sellerWebSocketUri,prospectWebSocketUri);

@override
String toString() {
  return 'ExternalMediaConfigurationEntity(encoding: $encoding, sampleRate: $sampleRate, channels: $channels, sellerWebSocketUri: $sellerWebSocketUri, prospectWebSocketUri: $prospectWebSocketUri)';
}


}

/// @nodoc
abstract mixin class _$ExternalMediaConfigurationEntityCopyWith<$Res> implements $ExternalMediaConfigurationEntityCopyWith<$Res> {
  factory _$ExternalMediaConfigurationEntityCopyWith(_ExternalMediaConfigurationEntity value, $Res Function(_ExternalMediaConfigurationEntity) _then) = __$ExternalMediaConfigurationEntityCopyWithImpl;
@override @useResult
$Res call({
 String encoding, int sampleRate, int channels, Uri sellerWebSocketUri, Uri prospectWebSocketUri
});




}
/// @nodoc
class __$ExternalMediaConfigurationEntityCopyWithImpl<$Res>
    implements _$ExternalMediaConfigurationEntityCopyWith<$Res> {
  __$ExternalMediaConfigurationEntityCopyWithImpl(this._self, this._then);

  final _ExternalMediaConfigurationEntity _self;
  final $Res Function(_ExternalMediaConfigurationEntity) _then;

/// Create a copy of ExternalMediaConfigurationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? encoding = null,Object? sampleRate = null,Object? channels = null,Object? sellerWebSocketUri = null,Object? prospectWebSocketUri = null,}) {
  return _then(_ExternalMediaConfigurationEntity(
encoding: null == encoding ? _self.encoding : encoding // ignore: cast_nullable_to_non_nullable
as String,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,sellerWebSocketUri: null == sellerWebSocketUri ? _self.sellerWebSocketUri : sellerWebSocketUri // ignore: cast_nullable_to_non_nullable
as Uri,prospectWebSocketUri: null == prospectWebSocketUri ? _self.prospectWebSocketUri : prospectWebSocketUri // ignore: cast_nullable_to_non_nullable
as Uri,
  ));
}


}

// dart format on
