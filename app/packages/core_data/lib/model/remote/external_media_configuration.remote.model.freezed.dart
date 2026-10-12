// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'external_media_configuration.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExternalMediaConfigurationRemoteModel {

 String get encoding; int get sampleRate; int get channels; String get sellerWebsocketUrl; String get prospectWebsocketUrl;
/// Create a copy of ExternalMediaConfigurationRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExternalMediaConfigurationRemoteModelCopyWith<ExternalMediaConfigurationRemoteModel> get copyWith => _$ExternalMediaConfigurationRemoteModelCopyWithImpl<ExternalMediaConfigurationRemoteModel>(this as ExternalMediaConfigurationRemoteModel, _$identity);

  /// Serializes this ExternalMediaConfigurationRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExternalMediaConfigurationRemoteModel&&(identical(other.encoding, encoding) || other.encoding == encoding)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.sellerWebsocketUrl, sellerWebsocketUrl) || other.sellerWebsocketUrl == sellerWebsocketUrl)&&(identical(other.prospectWebsocketUrl, prospectWebsocketUrl) || other.prospectWebsocketUrl == prospectWebsocketUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,encoding,sampleRate,channels,sellerWebsocketUrl,prospectWebsocketUrl);

@override
String toString() {
  return 'ExternalMediaConfigurationRemoteModel(encoding: $encoding, sampleRate: $sampleRate, channels: $channels, sellerWebsocketUrl: $sellerWebsocketUrl, prospectWebsocketUrl: $prospectWebsocketUrl)';
}


}

/// @nodoc
abstract mixin class $ExternalMediaConfigurationRemoteModelCopyWith<$Res>  {
  factory $ExternalMediaConfigurationRemoteModelCopyWith(ExternalMediaConfigurationRemoteModel value, $Res Function(ExternalMediaConfigurationRemoteModel) _then) = _$ExternalMediaConfigurationRemoteModelCopyWithImpl;
@useResult
$Res call({
 String encoding, int sampleRate, int channels, String sellerWebsocketUrl, String prospectWebsocketUrl
});




}
/// @nodoc
class _$ExternalMediaConfigurationRemoteModelCopyWithImpl<$Res>
    implements $ExternalMediaConfigurationRemoteModelCopyWith<$Res> {
  _$ExternalMediaConfigurationRemoteModelCopyWithImpl(this._self, this._then);

  final ExternalMediaConfigurationRemoteModel _self;
  final $Res Function(ExternalMediaConfigurationRemoteModel) _then;

/// Create a copy of ExternalMediaConfigurationRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? encoding = null,Object? sampleRate = null,Object? channels = null,Object? sellerWebsocketUrl = null,Object? prospectWebsocketUrl = null,}) {
  return _then(_self.copyWith(
encoding: null == encoding ? _self.encoding : encoding // ignore: cast_nullable_to_non_nullable
as String,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,sellerWebsocketUrl: null == sellerWebsocketUrl ? _self.sellerWebsocketUrl : sellerWebsocketUrl // ignore: cast_nullable_to_non_nullable
as String,prospectWebsocketUrl: null == prospectWebsocketUrl ? _self.prospectWebsocketUrl : prospectWebsocketUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExternalMediaConfigurationRemoteModel].
extension ExternalMediaConfigurationRemoteModelPatterns on ExternalMediaConfigurationRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExternalMediaConfigurationRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExternalMediaConfigurationRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExternalMediaConfigurationRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _ExternalMediaConfigurationRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExternalMediaConfigurationRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExternalMediaConfigurationRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String encoding,  int sampleRate,  int channels,  String sellerWebsocketUrl,  String prospectWebsocketUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExternalMediaConfigurationRemoteModel() when $default != null:
return $default(_that.encoding,_that.sampleRate,_that.channels,_that.sellerWebsocketUrl,_that.prospectWebsocketUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String encoding,  int sampleRate,  int channels,  String sellerWebsocketUrl,  String prospectWebsocketUrl)  $default,) {final _that = this;
switch (_that) {
case _ExternalMediaConfigurationRemoteModel():
return $default(_that.encoding,_that.sampleRate,_that.channels,_that.sellerWebsocketUrl,_that.prospectWebsocketUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String encoding,  int sampleRate,  int channels,  String sellerWebsocketUrl,  String prospectWebsocketUrl)?  $default,) {final _that = this;
switch (_that) {
case _ExternalMediaConfigurationRemoteModel() when $default != null:
return $default(_that.encoding,_that.sampleRate,_that.channels,_that.sellerWebsocketUrl,_that.prospectWebsocketUrl);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ExternalMediaConfigurationRemoteModel implements ExternalMediaConfigurationRemoteModel {
  const _ExternalMediaConfigurationRemoteModel({required this.encoding, required this.sampleRate, required this.channels, required this.sellerWebsocketUrl, required this.prospectWebsocketUrl});
  factory _ExternalMediaConfigurationRemoteModel.fromJson(Map<String, dynamic> json) => _$ExternalMediaConfigurationRemoteModelFromJson(json);

@override final  String encoding;
@override final  int sampleRate;
@override final  int channels;
@override final  String sellerWebsocketUrl;
@override final  String prospectWebsocketUrl;

/// Create a copy of ExternalMediaConfigurationRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExternalMediaConfigurationRemoteModelCopyWith<_ExternalMediaConfigurationRemoteModel> get copyWith => __$ExternalMediaConfigurationRemoteModelCopyWithImpl<_ExternalMediaConfigurationRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExternalMediaConfigurationRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExternalMediaConfigurationRemoteModel&&(identical(other.encoding, encoding) || other.encoding == encoding)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.sellerWebsocketUrl, sellerWebsocketUrl) || other.sellerWebsocketUrl == sellerWebsocketUrl)&&(identical(other.prospectWebsocketUrl, prospectWebsocketUrl) || other.prospectWebsocketUrl == prospectWebsocketUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,encoding,sampleRate,channels,sellerWebsocketUrl,prospectWebsocketUrl);

@override
String toString() {
  return 'ExternalMediaConfigurationRemoteModel(encoding: $encoding, sampleRate: $sampleRate, channels: $channels, sellerWebsocketUrl: $sellerWebsocketUrl, prospectWebsocketUrl: $prospectWebsocketUrl)';
}


}

/// @nodoc
abstract mixin class _$ExternalMediaConfigurationRemoteModelCopyWith<$Res> implements $ExternalMediaConfigurationRemoteModelCopyWith<$Res> {
  factory _$ExternalMediaConfigurationRemoteModelCopyWith(_ExternalMediaConfigurationRemoteModel value, $Res Function(_ExternalMediaConfigurationRemoteModel) _then) = __$ExternalMediaConfigurationRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String encoding, int sampleRate, int channels, String sellerWebsocketUrl, String prospectWebsocketUrl
});




}
/// @nodoc
class __$ExternalMediaConfigurationRemoteModelCopyWithImpl<$Res>
    implements _$ExternalMediaConfigurationRemoteModelCopyWith<$Res> {
  __$ExternalMediaConfigurationRemoteModelCopyWithImpl(this._self, this._then);

  final _ExternalMediaConfigurationRemoteModel _self;
  final $Res Function(_ExternalMediaConfigurationRemoteModel) _then;

/// Create a copy of ExternalMediaConfigurationRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? encoding = null,Object? sampleRate = null,Object? channels = null,Object? sellerWebsocketUrl = null,Object? prospectWebsocketUrl = null,}) {
  return _then(_ExternalMediaConfigurationRemoteModel(
encoding: null == encoding ? _self.encoding : encoding // ignore: cast_nullable_to_non_nullable
as String,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,sellerWebsocketUrl: null == sellerWebsocketUrl ? _self.sellerWebsocketUrl : sellerWebsocketUrl // ignore: cast_nullable_to_non_nullable
as String,prospectWebsocketUrl: null == prospectWebsocketUrl ? _self.prospectWebsocketUrl : prospectWebsocketUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
