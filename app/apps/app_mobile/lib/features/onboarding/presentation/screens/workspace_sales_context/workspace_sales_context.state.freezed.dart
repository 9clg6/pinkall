// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workspace_sales_context.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkspaceSalesContextState {

 WorkspaceSalesContextEntity? get context; bool get isSaving; String? get operationFailure;
/// Create a copy of WorkspaceSalesContextState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkspaceSalesContextStateCopyWith<WorkspaceSalesContextState> get copyWith => _$WorkspaceSalesContextStateCopyWithImpl<WorkspaceSalesContextState>(this as WorkspaceSalesContextState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkspaceSalesContextState&&(identical(other.context, context) || other.context == context)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.operationFailure, operationFailure) || other.operationFailure == operationFailure));
}


@override
int get hashCode => Object.hash(runtimeType,context,isSaving,operationFailure);

@override
String toString() {
  return 'WorkspaceSalesContextState(context: $context, isSaving: $isSaving, operationFailure: $operationFailure)';
}


}

/// @nodoc
abstract mixin class $WorkspaceSalesContextStateCopyWith<$Res>  {
  factory $WorkspaceSalesContextStateCopyWith(WorkspaceSalesContextState value, $Res Function(WorkspaceSalesContextState) _then) = _$WorkspaceSalesContextStateCopyWithImpl;
@useResult
$Res call({
 WorkspaceSalesContextEntity? context, bool isSaving, String? operationFailure
});


$WorkspaceSalesContextEntityCopyWith<$Res>? get context;

}
/// @nodoc
class _$WorkspaceSalesContextStateCopyWithImpl<$Res>
    implements $WorkspaceSalesContextStateCopyWith<$Res> {
  _$WorkspaceSalesContextStateCopyWithImpl(this._self, this._then);

  final WorkspaceSalesContextState _self;
  final $Res Function(WorkspaceSalesContextState) _then;

/// Create a copy of WorkspaceSalesContextState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? context = freezed,Object? isSaving = null,Object? operationFailure = freezed,}) {
  return _then(_self.copyWith(
context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as WorkspaceSalesContextEntity?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,operationFailure: freezed == operationFailure ? _self.operationFailure : operationFailure // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of WorkspaceSalesContextState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkspaceSalesContextEntityCopyWith<$Res>? get context {
    if (_self.context == null) {
    return null;
  }

  return $WorkspaceSalesContextEntityCopyWith<$Res>(_self.context!, (value) {
    return _then(_self.copyWith(context: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkspaceSalesContextState].
extension WorkspaceSalesContextStatePatterns on WorkspaceSalesContextState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkspaceSalesContextState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkspaceSalesContextState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkspaceSalesContextState value)  $default,){
final _that = this;
switch (_that) {
case _WorkspaceSalesContextState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkspaceSalesContextState value)?  $default,){
final _that = this;
switch (_that) {
case _WorkspaceSalesContextState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WorkspaceSalesContextEntity? context,  bool isSaving,  String? operationFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkspaceSalesContextState() when $default != null:
return $default(_that.context,_that.isSaving,_that.operationFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WorkspaceSalesContextEntity? context,  bool isSaving,  String? operationFailure)  $default,) {final _that = this;
switch (_that) {
case _WorkspaceSalesContextState():
return $default(_that.context,_that.isSaving,_that.operationFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WorkspaceSalesContextEntity? context,  bool isSaving,  String? operationFailure)?  $default,) {final _that = this;
switch (_that) {
case _WorkspaceSalesContextState() when $default != null:
return $default(_that.context,_that.isSaving,_that.operationFailure);case _:
  return null;

}
}

}

/// @nodoc


class _WorkspaceSalesContextState implements WorkspaceSalesContextState {
  const _WorkspaceSalesContextState({required this.context, required this.isSaving, required this.operationFailure});
  

@override final  WorkspaceSalesContextEntity? context;
@override final  bool isSaving;
@override final  String? operationFailure;

/// Create a copy of WorkspaceSalesContextState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkspaceSalesContextStateCopyWith<_WorkspaceSalesContextState> get copyWith => __$WorkspaceSalesContextStateCopyWithImpl<_WorkspaceSalesContextState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkspaceSalesContextState&&(identical(other.context, context) || other.context == context)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.operationFailure, operationFailure) || other.operationFailure == operationFailure));
}


@override
int get hashCode => Object.hash(runtimeType,context,isSaving,operationFailure);

@override
String toString() {
  return 'WorkspaceSalesContextState(context: $context, isSaving: $isSaving, operationFailure: $operationFailure)';
}


}

/// @nodoc
abstract mixin class _$WorkspaceSalesContextStateCopyWith<$Res> implements $WorkspaceSalesContextStateCopyWith<$Res> {
  factory _$WorkspaceSalesContextStateCopyWith(_WorkspaceSalesContextState value, $Res Function(_WorkspaceSalesContextState) _then) = __$WorkspaceSalesContextStateCopyWithImpl;
@override @useResult
$Res call({
 WorkspaceSalesContextEntity? context, bool isSaving, String? operationFailure
});


@override $WorkspaceSalesContextEntityCopyWith<$Res>? get context;

}
/// @nodoc
class __$WorkspaceSalesContextStateCopyWithImpl<$Res>
    implements _$WorkspaceSalesContextStateCopyWith<$Res> {
  __$WorkspaceSalesContextStateCopyWithImpl(this._self, this._then);

  final _WorkspaceSalesContextState _self;
  final $Res Function(_WorkspaceSalesContextState) _then;

/// Create a copy of WorkspaceSalesContextState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? context = freezed,Object? isSaving = null,Object? operationFailure = freezed,}) {
  return _then(_WorkspaceSalesContextState(
context: freezed == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as WorkspaceSalesContextEntity?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,operationFailure: freezed == operationFailure ? _self.operationFailure : operationFailure // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of WorkspaceSalesContextState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkspaceSalesContextEntityCopyWith<$Res>? get context {
    if (_self.context == null) {
    return null;
  }

  return $WorkspaceSalesContextEntityCopyWith<$Res>(_self.context!, (value) {
    return _then(_self.copyWith(context: value));
  });
}
}

// dart format on
