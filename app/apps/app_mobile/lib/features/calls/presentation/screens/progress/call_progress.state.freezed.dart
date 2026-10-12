// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_progress.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallProgressState {

 CoachingProgressEntity get progress; int get selectedWindow; bool get isRefreshing;
/// Create a copy of CallProgressState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallProgressStateCopyWith<CallProgressState> get copyWith => _$CallProgressStateCopyWithImpl<CallProgressState>(this as CallProgressState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallProgressState&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.selectedWindow, selectedWindow) || other.selectedWindow == selectedWindow)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing));
}


@override
int get hashCode => Object.hash(runtimeType,progress,selectedWindow,isRefreshing);

@override
String toString() {
  return 'CallProgressState(progress: $progress, selectedWindow: $selectedWindow, isRefreshing: $isRefreshing)';
}


}

/// @nodoc
abstract mixin class $CallProgressStateCopyWith<$Res>  {
  factory $CallProgressStateCopyWith(CallProgressState value, $Res Function(CallProgressState) _then) = _$CallProgressStateCopyWithImpl;
@useResult
$Res call({
 CoachingProgressEntity progress, int selectedWindow, bool isRefreshing
});


$CoachingProgressEntityCopyWith<$Res> get progress;

}
/// @nodoc
class _$CallProgressStateCopyWithImpl<$Res>
    implements $CallProgressStateCopyWith<$Res> {
  _$CallProgressStateCopyWithImpl(this._self, this._then);

  final CallProgressState _self;
  final $Res Function(CallProgressState) _then;

/// Create a copy of CallProgressState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? progress = null,Object? selectedWindow = null,Object? isRefreshing = null,}) {
  return _then(_self.copyWith(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as CoachingProgressEntity,selectedWindow: null == selectedWindow ? _self.selectedWindow : selectedWindow // ignore: cast_nullable_to_non_nullable
as int,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CallProgressState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressEntityCopyWith<$Res> get progress {

  return $CoachingProgressEntityCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [CallProgressState].
extension CallProgressStatePatterns on CallProgressState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallProgressState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallProgressState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallProgressState value)  $default,){
final _that = this;
switch (_that) {
case _CallProgressState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallProgressState value)?  $default,){
final _that = this;
switch (_that) {
case _CallProgressState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoachingProgressEntity progress,  int selectedWindow,  bool isRefreshing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallProgressState() when $default != null:
return $default(_that.progress,_that.selectedWindow,_that.isRefreshing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoachingProgressEntity progress,  int selectedWindow,  bool isRefreshing)  $default,) {final _that = this;
switch (_that) {
case _CallProgressState():
return $default(_that.progress,_that.selectedWindow,_that.isRefreshing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoachingProgressEntity progress,  int selectedWindow,  bool isRefreshing)?  $default,) {final _that = this;
switch (_that) {
case _CallProgressState() when $default != null:
return $default(_that.progress,_that.selectedWindow,_that.isRefreshing);case _:
  return null;

}
}

}

/// @nodoc


class _CallProgressState implements CallProgressState {
  const _CallProgressState({required this.progress, required this.selectedWindow, this.isRefreshing = false});


@override final  CoachingProgressEntity progress;
@override final  int selectedWindow;
@override@JsonKey() final  bool isRefreshing;

/// Create a copy of CallProgressState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallProgressStateCopyWith<_CallProgressState> get copyWith => __$CallProgressStateCopyWithImpl<_CallProgressState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallProgressState&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.selectedWindow, selectedWindow) || other.selectedWindow == selectedWindow)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing));
}


@override
int get hashCode => Object.hash(runtimeType,progress,selectedWindow,isRefreshing);

@override
String toString() {
  return 'CallProgressState(progress: $progress, selectedWindow: $selectedWindow, isRefreshing: $isRefreshing)';
}


}

/// @nodoc
abstract mixin class _$CallProgressStateCopyWith<$Res> implements $CallProgressStateCopyWith<$Res> {
  factory _$CallProgressStateCopyWith(_CallProgressState value, $Res Function(_CallProgressState) _then) = __$CallProgressStateCopyWithImpl;
@override @useResult
$Res call({
 CoachingProgressEntity progress, int selectedWindow, bool isRefreshing
});


@override $CoachingProgressEntityCopyWith<$Res> get progress;

}
/// @nodoc
class __$CallProgressStateCopyWithImpl<$Res>
    implements _$CallProgressStateCopyWith<$Res> {
  __$CallProgressStateCopyWithImpl(this._self, this._then);

  final _CallProgressState _self;
  final $Res Function(_CallProgressState) _then;

/// Create a copy of CallProgressState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? progress = null,Object? selectedWindow = null,Object? isRefreshing = null,}) {
  return _then(_CallProgressState(
progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as CoachingProgressEntity,selectedWindow: null == selectedWindow ? _self.selectedWindow : selectedWindow // ignore: cast_nullable_to_non_nullable
as int,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CallProgressState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressEntityCopyWith<$Res> get progress {

  return $CoachingProgressEntityCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

// dart format on
