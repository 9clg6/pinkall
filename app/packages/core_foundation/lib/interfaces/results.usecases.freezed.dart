// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'results.usecases.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResultState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResultState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResultState<$T>()';
}


}

/// @nodoc
class $ResultStateCopyWith<T,$Res>  {
$ResultStateCopyWith(ResultState<T> _, $Res Function(ResultState<T>) __);
}


/// Adds pattern-matching-related methods to [ResultState].
extension ResultStatePatterns<T> on ResultState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ResultSuccess<T> value)?  success,TResult Function( ResultFailure<T> value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ResultSuccess() when success != null:
return success(_that);case ResultFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ResultSuccess<T> value)  success,required TResult Function( ResultFailure<T> value)  failure,}){
final _that = this;
switch (_that) {
case ResultSuccess():
return success(_that);case ResultFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ResultSuccess<T> value)?  success,TResult? Function( ResultFailure<T> value)?  failure,}){
final _that = this;
switch (_that) {
case ResultSuccess() when success != null:
return success(_that);case ResultFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( T data)?  success,TResult Function( Exception exception)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ResultSuccess() when success != null:
return success(_that.data);case ResultFailure() when failure != null:
return failure(_that.exception);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( T data)  success,required TResult Function( Exception exception)  failure,}) {final _that = this;
switch (_that) {
case ResultSuccess():
return success(_that.data);case ResultFailure():
return failure(_that.exception);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( T data)?  success,TResult? Function( Exception exception)?  failure,}) {final _that = this;
switch (_that) {
case ResultSuccess() when success != null:
return success(_that.data);case ResultFailure() when failure != null:
return failure(_that.exception);case _:
  return null;

}
}

}

/// @nodoc


class ResultSuccess<T> implements ResultState<T> {
  const ResultSuccess(this.data);
  

 final  T data;

/// Create a copy of ResultState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultSuccessCopyWith<T, ResultSuccess<T>> get copyWith => _$ResultSuccessCopyWithImpl<T, ResultSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResultSuccess<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ResultState<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $ResultSuccessCopyWith<T,$Res> implements $ResultStateCopyWith<T, $Res> {
  factory $ResultSuccessCopyWith(ResultSuccess<T> value, $Res Function(ResultSuccess<T>) _then) = _$ResultSuccessCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$ResultSuccessCopyWithImpl<T,$Res>
    implements $ResultSuccessCopyWith<T, $Res> {
  _$ResultSuccessCopyWithImpl(this._self, this._then);

  final ResultSuccess<T> _self;
  final $Res Function(ResultSuccess<T>) _then;

/// Create a copy of ResultState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(ResultSuccess<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class ResultFailure<T> implements ResultState<T> {
  const ResultFailure(this.exception);
  

 final  Exception exception;

/// Create a copy of ResultState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultFailureCopyWith<T, ResultFailure<T>> get copyWith => _$ResultFailureCopyWithImpl<T, ResultFailure<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResultFailure<T>&&(identical(other.exception, exception) || other.exception == exception));
}


@override
int get hashCode => Object.hash(runtimeType,exception);

@override
String toString() {
  return 'ResultState<$T>.failure(exception: $exception)';
}


}

/// @nodoc
abstract mixin class $ResultFailureCopyWith<T,$Res> implements $ResultStateCopyWith<T, $Res> {
  factory $ResultFailureCopyWith(ResultFailure<T> value, $Res Function(ResultFailure<T>) _then) = _$ResultFailureCopyWithImpl;
@useResult
$Res call({
 Exception exception
});




}
/// @nodoc
class _$ResultFailureCopyWithImpl<T,$Res>
    implements $ResultFailureCopyWith<T, $Res> {
  _$ResultFailureCopyWithImpl(this._self, this._then);

  final ResultFailure<T> _self;
  final $Res Function(ResultFailure<T>) _then;

/// Create a copy of ResultState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? exception = null,}) {
  return _then(ResultFailure<T>(
null == exception ? _self.exception : exception // ignore: cast_nullable_to_non_nullable
as Exception,
  ));
}


}

// dart format on
