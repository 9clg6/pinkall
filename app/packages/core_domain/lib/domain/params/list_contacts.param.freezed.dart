// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_contacts.param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListContactsParam {

 String? get query; String? get cursor; int get limit;
/// Create a copy of ListContactsParam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListContactsParamCopyWith<ListContactsParam> get copyWith => _$ListContactsParamCopyWithImpl<ListContactsParam>(this as ListContactsParam, _$identity);

  /// Serializes this ListContactsParam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListContactsParam&&(identical(other.query, query) || other.query == query)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,cursor,limit);

@override
String toString() {
  return 'ListContactsParam(query: $query, cursor: $cursor, limit: $limit)';
}


}

/// @nodoc
abstract mixin class $ListContactsParamCopyWith<$Res>  {
  factory $ListContactsParamCopyWith(ListContactsParam value, $Res Function(ListContactsParam) _then) = _$ListContactsParamCopyWithImpl;
@useResult
$Res call({
 String? query, String? cursor, int limit
});




}
/// @nodoc
class _$ListContactsParamCopyWithImpl<$Res>
    implements $ListContactsParamCopyWith<$Res> {
  _$ListContactsParamCopyWithImpl(this._self, this._then);

  final ListContactsParam _self;
  final $Res Function(ListContactsParam) _then;

/// Create a copy of ListContactsParam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = freezed,Object? cursor = freezed,Object? limit = null,}) {
  return _then(_self.copyWith(
query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ListContactsParam].
extension ListContactsParamPatterns on ListContactsParam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListContactsParam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListContactsParam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListContactsParam value)  $default,){
final _that = this;
switch (_that) {
case _ListContactsParam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListContactsParam value)?  $default,){
final _that = this;
switch (_that) {
case _ListContactsParam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? query,  String? cursor,  int limit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListContactsParam() when $default != null:
return $default(_that.query,_that.cursor,_that.limit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? query,  String? cursor,  int limit)  $default,) {final _that = this;
switch (_that) {
case _ListContactsParam():
return $default(_that.query,_that.cursor,_that.limit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? query,  String? cursor,  int limit)?  $default,) {final _that = this;
switch (_that) {
case _ListContactsParam() when $default != null:
return $default(_that.query,_that.cursor,_that.limit);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ListContactsParam implements ListContactsParam {
  const _ListContactsParam({this.query, this.cursor, this.limit = 50});
  factory _ListContactsParam.fromJson(Map<String, dynamic> json) => _$ListContactsParamFromJson(json);

@override final  String? query;
@override final  String? cursor;
@override@JsonKey() final  int limit;

/// Create a copy of ListContactsParam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListContactsParamCopyWith<_ListContactsParam> get copyWith => __$ListContactsParamCopyWithImpl<_ListContactsParam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListContactsParamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListContactsParam&&(identical(other.query, query) || other.query == query)&&(identical(other.cursor, cursor) || other.cursor == cursor)&&(identical(other.limit, limit) || other.limit == limit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,query,cursor,limit);

@override
String toString() {
  return 'ListContactsParam(query: $query, cursor: $cursor, limit: $limit)';
}


}

/// @nodoc
abstract mixin class _$ListContactsParamCopyWith<$Res> implements $ListContactsParamCopyWith<$Res> {
  factory _$ListContactsParamCopyWith(_ListContactsParam value, $Res Function(_ListContactsParam) _then) = __$ListContactsParamCopyWithImpl;
@override @useResult
$Res call({
 String? query, String? cursor, int limit
});




}
/// @nodoc
class __$ListContactsParamCopyWithImpl<$Res>
    implements _$ListContactsParamCopyWith<$Res> {
  __$ListContactsParamCopyWithImpl(this._self, this._then);

  final _ListContactsParam _self;
  final $Res Function(_ListContactsParam) _then;

/// Create a copy of ListContactsParam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = freezed,Object? cursor = freezed,Object? limit = null,}) {
  return _then(_ListContactsParam(
query: freezed == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String?,cursor: freezed == cursor ? _self.cursor : cursor // ignore: cast_nullable_to_non_nullable
as String?,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
