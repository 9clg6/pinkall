// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_realtime_event.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionRealtimeEventRemoteModel {

 String get type; Map<String, dynamic> get payload;
/// Create a copy of SessionRealtimeEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionRealtimeEventRemoteModelCopyWith<SessionRealtimeEventRemoteModel> get copyWith => _$SessionRealtimeEventRemoteModelCopyWithImpl<SessionRealtimeEventRemoteModel>(this as SessionRealtimeEventRemoteModel, _$identity);

  /// Serializes this SessionRealtimeEventRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionRealtimeEventRemoteModel&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.payload, payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(payload));

@override
String toString() {
  return 'SessionRealtimeEventRemoteModel(type: $type, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $SessionRealtimeEventRemoteModelCopyWith<$Res>  {
  factory $SessionRealtimeEventRemoteModelCopyWith(SessionRealtimeEventRemoteModel value, $Res Function(SessionRealtimeEventRemoteModel) _then) = _$SessionRealtimeEventRemoteModelCopyWithImpl;
@useResult
$Res call({
 String type, Map<String, dynamic> payload
});




}
/// @nodoc
class _$SessionRealtimeEventRemoteModelCopyWithImpl<$Res>
    implements $SessionRealtimeEventRemoteModelCopyWith<$Res> {
  _$SessionRealtimeEventRemoteModelCopyWithImpl(this._self, this._then);

  final SessionRealtimeEventRemoteModel _self;
  final $Res Function(SessionRealtimeEventRemoteModel) _then;

/// Create a copy of SessionRealtimeEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? payload = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionRealtimeEventRemoteModel].
extension SessionRealtimeEventRemoteModelPatterns on SessionRealtimeEventRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionRealtimeEventRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionRealtimeEventRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionRealtimeEventRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _SessionRealtimeEventRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionRealtimeEventRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _SessionRealtimeEventRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  Map<String, dynamic> payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionRealtimeEventRemoteModel() when $default != null:
return $default(_that.type,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  Map<String, dynamic> payload)  $default,) {final _that = this;
switch (_that) {
case _SessionRealtimeEventRemoteModel():
return $default(_that.type,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  Map<String, dynamic> payload)?  $default,) {final _that = this;
switch (_that) {
case _SessionRealtimeEventRemoteModel() when $default != null:
return $default(_that.type,_that.payload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionRealtimeEventRemoteModel implements SessionRealtimeEventRemoteModel {
  const _SessionRealtimeEventRemoteModel({required this.type, required final  Map<String, dynamic> payload}): _payload = payload;
  factory _SessionRealtimeEventRemoteModel.fromJson(Map<String, dynamic> json) => _$SessionRealtimeEventRemoteModelFromJson(json);

@override final  String type;
 final  Map<String, dynamic> _payload;
@override Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}


/// Create a copy of SessionRealtimeEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionRealtimeEventRemoteModelCopyWith<_SessionRealtimeEventRemoteModel> get copyWith => __$SessionRealtimeEventRemoteModelCopyWithImpl<_SessionRealtimeEventRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionRealtimeEventRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionRealtimeEventRemoteModel&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._payload, _payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,const DeepCollectionEquality().hash(_payload));

@override
String toString() {
  return 'SessionRealtimeEventRemoteModel(type: $type, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$SessionRealtimeEventRemoteModelCopyWith<$Res> implements $SessionRealtimeEventRemoteModelCopyWith<$Res> {
  factory _$SessionRealtimeEventRemoteModelCopyWith(_SessionRealtimeEventRemoteModel value, $Res Function(_SessionRealtimeEventRemoteModel) _then) = __$SessionRealtimeEventRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String type, Map<String, dynamic> payload
});




}
/// @nodoc
class __$SessionRealtimeEventRemoteModelCopyWithImpl<$Res>
    implements _$SessionRealtimeEventRemoteModelCopyWith<$Res> {
  __$SessionRealtimeEventRemoteModelCopyWithImpl(this._self, this._then);

  final _SessionRealtimeEventRemoteModel _self;
  final $Res Function(_SessionRealtimeEventRemoteModel) _then;

/// Create a copy of SessionRealtimeEventRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? payload = null,}) {
  return _then(_SessionRealtimeEventRemoteModel(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
