// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coaching_progress.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CoachingProgressMetricEntity {

 double? get current; double? get previous; double? get delta; int get sampleCount;
/// Create a copy of CoachingProgressMetricEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<CoachingProgressMetricEntity> get copyWith => _$CoachingProgressMetricEntityCopyWithImpl<CoachingProgressMetricEntity>(this as CoachingProgressMetricEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingProgressMetricEntity&&(identical(other.current, current) || other.current == current)&&(identical(other.previous, previous) || other.previous == previous)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}


@override
int get hashCode => Object.hash(runtimeType,current,previous,delta,sampleCount);

@override
String toString() {
  return 'CoachingProgressMetricEntity(current: $current, previous: $previous, delta: $delta, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class $CoachingProgressMetricEntityCopyWith<$Res>  {
  factory $CoachingProgressMetricEntityCopyWith(CoachingProgressMetricEntity value, $Res Function(CoachingProgressMetricEntity) _then) = _$CoachingProgressMetricEntityCopyWithImpl;
@useResult
$Res call({
 double? current, double? previous, double? delta, int sampleCount
});




}
/// @nodoc
class _$CoachingProgressMetricEntityCopyWithImpl<$Res>
    implements $CoachingProgressMetricEntityCopyWith<$Res> {
  _$CoachingProgressMetricEntityCopyWithImpl(this._self, this._then);

  final CoachingProgressMetricEntity _self;
  final $Res Function(CoachingProgressMetricEntity) _then;

/// Create a copy of CoachingProgressMetricEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = freezed,Object? previous = freezed,Object? delta = freezed,Object? sampleCount = null,}) {
  return _then(_self.copyWith(
current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as double?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as double?,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as double?,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachingProgressMetricEntity].
extension CoachingProgressMetricEntityPatterns on CoachingProgressMetricEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingProgressMetricEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingProgressMetricEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingProgressMetricEntity value)  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressMetricEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingProgressMetricEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressMetricEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? current,  double? previous,  double? delta,  int sampleCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingProgressMetricEntity() when $default != null:
return $default(_that.current,_that.previous,_that.delta,_that.sampleCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? current,  double? previous,  double? delta,  int sampleCount)  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressMetricEntity():
return $default(_that.current,_that.previous,_that.delta,_that.sampleCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? current,  double? previous,  double? delta,  int sampleCount)?  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressMetricEntity() when $default != null:
return $default(_that.current,_that.previous,_that.delta,_that.sampleCount);case _:
  return null;

}
}

}

/// @nodoc


class _CoachingProgressMetricEntity implements CoachingProgressMetricEntity {
  const _CoachingProgressMetricEntity({required this.current, required this.previous, required this.delta, required this.sampleCount});


@override final  double? current;
@override final  double? previous;
@override final  double? delta;
@override final  int sampleCount;

/// Create a copy of CoachingProgressMetricEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingProgressMetricEntityCopyWith<_CoachingProgressMetricEntity> get copyWith => __$CoachingProgressMetricEntityCopyWithImpl<_CoachingProgressMetricEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingProgressMetricEntity&&(identical(other.current, current) || other.current == current)&&(identical(other.previous, previous) || other.previous == previous)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}


@override
int get hashCode => Object.hash(runtimeType,current,previous,delta,sampleCount);

@override
String toString() {
  return 'CoachingProgressMetricEntity(current: $current, previous: $previous, delta: $delta, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class _$CoachingProgressMetricEntityCopyWith<$Res> implements $CoachingProgressMetricEntityCopyWith<$Res> {
  factory _$CoachingProgressMetricEntityCopyWith(_CoachingProgressMetricEntity value, $Res Function(_CoachingProgressMetricEntity) _then) = __$CoachingProgressMetricEntityCopyWithImpl;
@override @useResult
$Res call({
 double? current, double? previous, double? delta, int sampleCount
});




}
/// @nodoc
class __$CoachingProgressMetricEntityCopyWithImpl<$Res>
    implements _$CoachingProgressMetricEntityCopyWith<$Res> {
  __$CoachingProgressMetricEntityCopyWithImpl(this._self, this._then);

  final _CoachingProgressMetricEntity _self;
  final $Res Function(_CoachingProgressMetricEntity) _then;

/// Create a copy of CoachingProgressMetricEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = freezed,Object? previous = freezed,Object? delta = freezed,Object? sampleCount = null,}) {
  return _then(_CoachingProgressMetricEntity(
current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as double?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as double?,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as double?,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$CallObservedMetricsEntity {

 double get sellerTalkRatio; int get questionCount; double get averageSellerTurnSeconds; double get longestSellerTurnSeconds; int get hesitationCount; double get questionsPerMinute; double get hesitationsPerMinute;
/// Create a copy of CallObservedMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallObservedMetricsEntityCopyWith<CallObservedMetricsEntity> get copyWith => _$CallObservedMetricsEntityCopyWithImpl<CallObservedMetricsEntity>(this as CallObservedMetricsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallObservedMetricsEntity&&(identical(other.sellerTalkRatio, sellerTalkRatio) || other.sellerTalkRatio == sellerTalkRatio)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.averageSellerTurnSeconds, averageSellerTurnSeconds) || other.averageSellerTurnSeconds == averageSellerTurnSeconds)&&(identical(other.longestSellerTurnSeconds, longestSellerTurnSeconds) || other.longestSellerTurnSeconds == longestSellerTurnSeconds)&&(identical(other.hesitationCount, hesitationCount) || other.hesitationCount == hesitationCount)&&(identical(other.questionsPerMinute, questionsPerMinute) || other.questionsPerMinute == questionsPerMinute)&&(identical(other.hesitationsPerMinute, hesitationsPerMinute) || other.hesitationsPerMinute == hesitationsPerMinute));
}


@override
int get hashCode => Object.hash(runtimeType,sellerTalkRatio,questionCount,averageSellerTurnSeconds,longestSellerTurnSeconds,hesitationCount,questionsPerMinute,hesitationsPerMinute);

@override
String toString() {
  return 'CallObservedMetricsEntity(sellerTalkRatio: $sellerTalkRatio, questionCount: $questionCount, averageSellerTurnSeconds: $averageSellerTurnSeconds, longestSellerTurnSeconds: $longestSellerTurnSeconds, hesitationCount: $hesitationCount, questionsPerMinute: $questionsPerMinute, hesitationsPerMinute: $hesitationsPerMinute)';
}


}

/// @nodoc
abstract mixin class $CallObservedMetricsEntityCopyWith<$Res>  {
  factory $CallObservedMetricsEntityCopyWith(CallObservedMetricsEntity value, $Res Function(CallObservedMetricsEntity) _then) = _$CallObservedMetricsEntityCopyWithImpl;
@useResult
$Res call({
 double sellerTalkRatio, int questionCount, double averageSellerTurnSeconds, double longestSellerTurnSeconds, int hesitationCount, double questionsPerMinute, double hesitationsPerMinute
});




}
/// @nodoc
class _$CallObservedMetricsEntityCopyWithImpl<$Res>
    implements $CallObservedMetricsEntityCopyWith<$Res> {
  _$CallObservedMetricsEntityCopyWithImpl(this._self, this._then);

  final CallObservedMetricsEntity _self;
  final $Res Function(CallObservedMetricsEntity) _then;

/// Create a copy of CallObservedMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sellerTalkRatio = null,Object? questionCount = null,Object? averageSellerTurnSeconds = null,Object? longestSellerTurnSeconds = null,Object? hesitationCount = null,Object? questionsPerMinute = null,Object? hesitationsPerMinute = null,}) {
  return _then(_self.copyWith(
sellerTalkRatio: null == sellerTalkRatio ? _self.sellerTalkRatio : sellerTalkRatio // ignore: cast_nullable_to_non_nullable
as double,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,averageSellerTurnSeconds: null == averageSellerTurnSeconds ? _self.averageSellerTurnSeconds : averageSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as double,longestSellerTurnSeconds: null == longestSellerTurnSeconds ? _self.longestSellerTurnSeconds : longestSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as double,hesitationCount: null == hesitationCount ? _self.hesitationCount : hesitationCount // ignore: cast_nullable_to_non_nullable
as int,questionsPerMinute: null == questionsPerMinute ? _self.questionsPerMinute : questionsPerMinute // ignore: cast_nullable_to_non_nullable
as double,hesitationsPerMinute: null == hesitationsPerMinute ? _self.hesitationsPerMinute : hesitationsPerMinute // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CallObservedMetricsEntity].
extension CallObservedMetricsEntityPatterns on CallObservedMetricsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallObservedMetricsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallObservedMetricsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallObservedMetricsEntity value)  $default,){
final _that = this;
switch (_that) {
case _CallObservedMetricsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallObservedMetricsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CallObservedMetricsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double sellerTalkRatio,  int questionCount,  double averageSellerTurnSeconds,  double longestSellerTurnSeconds,  int hesitationCount,  double questionsPerMinute,  double hesitationsPerMinute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallObservedMetricsEntity() when $default != null:
return $default(_that.sellerTalkRatio,_that.questionCount,_that.averageSellerTurnSeconds,_that.longestSellerTurnSeconds,_that.hesitationCount,_that.questionsPerMinute,_that.hesitationsPerMinute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double sellerTalkRatio,  int questionCount,  double averageSellerTurnSeconds,  double longestSellerTurnSeconds,  int hesitationCount,  double questionsPerMinute,  double hesitationsPerMinute)  $default,) {final _that = this;
switch (_that) {
case _CallObservedMetricsEntity():
return $default(_that.sellerTalkRatio,_that.questionCount,_that.averageSellerTurnSeconds,_that.longestSellerTurnSeconds,_that.hesitationCount,_that.questionsPerMinute,_that.hesitationsPerMinute);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double sellerTalkRatio,  int questionCount,  double averageSellerTurnSeconds,  double longestSellerTurnSeconds,  int hesitationCount,  double questionsPerMinute,  double hesitationsPerMinute)?  $default,) {final _that = this;
switch (_that) {
case _CallObservedMetricsEntity() when $default != null:
return $default(_that.sellerTalkRatio,_that.questionCount,_that.averageSellerTurnSeconds,_that.longestSellerTurnSeconds,_that.hesitationCount,_that.questionsPerMinute,_that.hesitationsPerMinute);case _:
  return null;

}
}

}

/// @nodoc


class _CallObservedMetricsEntity implements CallObservedMetricsEntity {
  const _CallObservedMetricsEntity({required this.sellerTalkRatio, required this.questionCount, required this.averageSellerTurnSeconds, required this.longestSellerTurnSeconds, required this.hesitationCount, required this.questionsPerMinute, required this.hesitationsPerMinute});


@override final  double sellerTalkRatio;
@override final  int questionCount;
@override final  double averageSellerTurnSeconds;
@override final  double longestSellerTurnSeconds;
@override final  int hesitationCount;
@override final  double questionsPerMinute;
@override final  double hesitationsPerMinute;

/// Create a copy of CallObservedMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallObservedMetricsEntityCopyWith<_CallObservedMetricsEntity> get copyWith => __$CallObservedMetricsEntityCopyWithImpl<_CallObservedMetricsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallObservedMetricsEntity&&(identical(other.sellerTalkRatio, sellerTalkRatio) || other.sellerTalkRatio == sellerTalkRatio)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.averageSellerTurnSeconds, averageSellerTurnSeconds) || other.averageSellerTurnSeconds == averageSellerTurnSeconds)&&(identical(other.longestSellerTurnSeconds, longestSellerTurnSeconds) || other.longestSellerTurnSeconds == longestSellerTurnSeconds)&&(identical(other.hesitationCount, hesitationCount) || other.hesitationCount == hesitationCount)&&(identical(other.questionsPerMinute, questionsPerMinute) || other.questionsPerMinute == questionsPerMinute)&&(identical(other.hesitationsPerMinute, hesitationsPerMinute) || other.hesitationsPerMinute == hesitationsPerMinute));
}


@override
int get hashCode => Object.hash(runtimeType,sellerTalkRatio,questionCount,averageSellerTurnSeconds,longestSellerTurnSeconds,hesitationCount,questionsPerMinute,hesitationsPerMinute);

@override
String toString() {
  return 'CallObservedMetricsEntity(sellerTalkRatio: $sellerTalkRatio, questionCount: $questionCount, averageSellerTurnSeconds: $averageSellerTurnSeconds, longestSellerTurnSeconds: $longestSellerTurnSeconds, hesitationCount: $hesitationCount, questionsPerMinute: $questionsPerMinute, hesitationsPerMinute: $hesitationsPerMinute)';
}


}

/// @nodoc
abstract mixin class _$CallObservedMetricsEntityCopyWith<$Res> implements $CallObservedMetricsEntityCopyWith<$Res> {
  factory _$CallObservedMetricsEntityCopyWith(_CallObservedMetricsEntity value, $Res Function(_CallObservedMetricsEntity) _then) = __$CallObservedMetricsEntityCopyWithImpl;
@override @useResult
$Res call({
 double sellerTalkRatio, int questionCount, double averageSellerTurnSeconds, double longestSellerTurnSeconds, int hesitationCount, double questionsPerMinute, double hesitationsPerMinute
});




}
/// @nodoc
class __$CallObservedMetricsEntityCopyWithImpl<$Res>
    implements _$CallObservedMetricsEntityCopyWith<$Res> {
  __$CallObservedMetricsEntityCopyWithImpl(this._self, this._then);

  final _CallObservedMetricsEntity _self;
  final $Res Function(_CallObservedMetricsEntity) _then;

/// Create a copy of CallObservedMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sellerTalkRatio = null,Object? questionCount = null,Object? averageSellerTurnSeconds = null,Object? longestSellerTurnSeconds = null,Object? hesitationCount = null,Object? questionsPerMinute = null,Object? hesitationsPerMinute = null,}) {
  return _then(_CallObservedMetricsEntity(
sellerTalkRatio: null == sellerTalkRatio ? _self.sellerTalkRatio : sellerTalkRatio // ignore: cast_nullable_to_non_nullable
as double,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,averageSellerTurnSeconds: null == averageSellerTurnSeconds ? _self.averageSellerTurnSeconds : averageSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as double,longestSellerTurnSeconds: null == longestSellerTurnSeconds ? _self.longestSellerTurnSeconds : longestSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as double,hesitationCount: null == hesitationCount ? _self.hesitationCount : hesitationCount // ignore: cast_nullable_to_non_nullable
as int,questionsPerMinute: null == questionsPerMinute ? _self.questionsPerMinute : questionsPerMinute // ignore: cast_nullable_to_non_nullable
as double,hesitationsPerMinute: null == hesitationsPerMinute ? _self.hesitationsPerMinute : hesitationsPerMinute // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$CoachingProgressMetricsEntity {

 CoachingProgressMetricEntity get sellerTalkRatio; CoachingProgressMetricEntity get questionCount; CoachingProgressMetricEntity get averageSellerTurnSeconds; CoachingProgressMetricEntity get longestSellerTurnSeconds; CoachingProgressMetricEntity get hesitationCount; CoachingProgressMetricEntity get questionsPerMinute; CoachingProgressMetricEntity get hesitationsPerMinute;
/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingProgressMetricsEntityCopyWith<CoachingProgressMetricsEntity> get copyWith => _$CoachingProgressMetricsEntityCopyWithImpl<CoachingProgressMetricsEntity>(this as CoachingProgressMetricsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingProgressMetricsEntity&&(identical(other.sellerTalkRatio, sellerTalkRatio) || other.sellerTalkRatio == sellerTalkRatio)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.averageSellerTurnSeconds, averageSellerTurnSeconds) || other.averageSellerTurnSeconds == averageSellerTurnSeconds)&&(identical(other.longestSellerTurnSeconds, longestSellerTurnSeconds) || other.longestSellerTurnSeconds == longestSellerTurnSeconds)&&(identical(other.hesitationCount, hesitationCount) || other.hesitationCount == hesitationCount)&&(identical(other.questionsPerMinute, questionsPerMinute) || other.questionsPerMinute == questionsPerMinute)&&(identical(other.hesitationsPerMinute, hesitationsPerMinute) || other.hesitationsPerMinute == hesitationsPerMinute));
}


@override
int get hashCode => Object.hash(runtimeType,sellerTalkRatio,questionCount,averageSellerTurnSeconds,longestSellerTurnSeconds,hesitationCount,questionsPerMinute,hesitationsPerMinute);

@override
String toString() {
  return 'CoachingProgressMetricsEntity(sellerTalkRatio: $sellerTalkRatio, questionCount: $questionCount, averageSellerTurnSeconds: $averageSellerTurnSeconds, longestSellerTurnSeconds: $longestSellerTurnSeconds, hesitationCount: $hesitationCount, questionsPerMinute: $questionsPerMinute, hesitationsPerMinute: $hesitationsPerMinute)';
}


}

/// @nodoc
abstract mixin class $CoachingProgressMetricsEntityCopyWith<$Res>  {
  factory $CoachingProgressMetricsEntityCopyWith(CoachingProgressMetricsEntity value, $Res Function(CoachingProgressMetricsEntity) _then) = _$CoachingProgressMetricsEntityCopyWithImpl;
@useResult
$Res call({
 CoachingProgressMetricEntity sellerTalkRatio, CoachingProgressMetricEntity questionCount, CoachingProgressMetricEntity averageSellerTurnSeconds, CoachingProgressMetricEntity longestSellerTurnSeconds, CoachingProgressMetricEntity hesitationCount, CoachingProgressMetricEntity questionsPerMinute, CoachingProgressMetricEntity hesitationsPerMinute
});


$CoachingProgressMetricEntityCopyWith<$Res> get sellerTalkRatio;$CoachingProgressMetricEntityCopyWith<$Res> get questionCount;$CoachingProgressMetricEntityCopyWith<$Res> get averageSellerTurnSeconds;$CoachingProgressMetricEntityCopyWith<$Res> get longestSellerTurnSeconds;$CoachingProgressMetricEntityCopyWith<$Res> get hesitationCount;$CoachingProgressMetricEntityCopyWith<$Res> get questionsPerMinute;$CoachingProgressMetricEntityCopyWith<$Res> get hesitationsPerMinute;

}
/// @nodoc
class _$CoachingProgressMetricsEntityCopyWithImpl<$Res>
    implements $CoachingProgressMetricsEntityCopyWith<$Res> {
  _$CoachingProgressMetricsEntityCopyWithImpl(this._self, this._then);

  final CoachingProgressMetricsEntity _self;
  final $Res Function(CoachingProgressMetricsEntity) _then;

/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sellerTalkRatio = null,Object? questionCount = null,Object? averageSellerTurnSeconds = null,Object? longestSellerTurnSeconds = null,Object? hesitationCount = null,Object? questionsPerMinute = null,Object? hesitationsPerMinute = null,}) {
  return _then(_self.copyWith(
sellerTalkRatio: null == sellerTalkRatio ? _self.sellerTalkRatio : sellerTalkRatio // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,averageSellerTurnSeconds: null == averageSellerTurnSeconds ? _self.averageSellerTurnSeconds : averageSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,longestSellerTurnSeconds: null == longestSellerTurnSeconds ? _self.longestSellerTurnSeconds : longestSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,hesitationCount: null == hesitationCount ? _self.hesitationCount : hesitationCount // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,questionsPerMinute: null == questionsPerMinute ? _self.questionsPerMinute : questionsPerMinute // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,hesitationsPerMinute: null == hesitationsPerMinute ? _self.hesitationsPerMinute : hesitationsPerMinute // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,
  ));
}
/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get sellerTalkRatio {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.sellerTalkRatio, (value) {
    return _then(_self.copyWith(sellerTalkRatio: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get questionCount {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.questionCount, (value) {
    return _then(_self.copyWith(questionCount: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get averageSellerTurnSeconds {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.averageSellerTurnSeconds, (value) {
    return _then(_self.copyWith(averageSellerTurnSeconds: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get longestSellerTurnSeconds {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.longestSellerTurnSeconds, (value) {
    return _then(_self.copyWith(longestSellerTurnSeconds: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get hesitationCount {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.hesitationCount, (value) {
    return _then(_self.copyWith(hesitationCount: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get questionsPerMinute {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.questionsPerMinute, (value) {
    return _then(_self.copyWith(questionsPerMinute: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get hesitationsPerMinute {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.hesitationsPerMinute, (value) {
    return _then(_self.copyWith(hesitationsPerMinute: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoachingProgressMetricsEntity].
extension CoachingProgressMetricsEntityPatterns on CoachingProgressMetricsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingProgressMetricsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingProgressMetricsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingProgressMetricsEntity value)  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressMetricsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingProgressMetricsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressMetricsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoachingProgressMetricEntity sellerTalkRatio,  CoachingProgressMetricEntity questionCount,  CoachingProgressMetricEntity averageSellerTurnSeconds,  CoachingProgressMetricEntity longestSellerTurnSeconds,  CoachingProgressMetricEntity hesitationCount,  CoachingProgressMetricEntity questionsPerMinute,  CoachingProgressMetricEntity hesitationsPerMinute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingProgressMetricsEntity() when $default != null:
return $default(_that.sellerTalkRatio,_that.questionCount,_that.averageSellerTurnSeconds,_that.longestSellerTurnSeconds,_that.hesitationCount,_that.questionsPerMinute,_that.hesitationsPerMinute);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoachingProgressMetricEntity sellerTalkRatio,  CoachingProgressMetricEntity questionCount,  CoachingProgressMetricEntity averageSellerTurnSeconds,  CoachingProgressMetricEntity longestSellerTurnSeconds,  CoachingProgressMetricEntity hesitationCount,  CoachingProgressMetricEntity questionsPerMinute,  CoachingProgressMetricEntity hesitationsPerMinute)  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressMetricsEntity():
return $default(_that.sellerTalkRatio,_that.questionCount,_that.averageSellerTurnSeconds,_that.longestSellerTurnSeconds,_that.hesitationCount,_that.questionsPerMinute,_that.hesitationsPerMinute);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoachingProgressMetricEntity sellerTalkRatio,  CoachingProgressMetricEntity questionCount,  CoachingProgressMetricEntity averageSellerTurnSeconds,  CoachingProgressMetricEntity longestSellerTurnSeconds,  CoachingProgressMetricEntity hesitationCount,  CoachingProgressMetricEntity questionsPerMinute,  CoachingProgressMetricEntity hesitationsPerMinute)?  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressMetricsEntity() when $default != null:
return $default(_that.sellerTalkRatio,_that.questionCount,_that.averageSellerTurnSeconds,_that.longestSellerTurnSeconds,_that.hesitationCount,_that.questionsPerMinute,_that.hesitationsPerMinute);case _:
  return null;

}
}

}

/// @nodoc


class _CoachingProgressMetricsEntity implements CoachingProgressMetricsEntity {
  const _CoachingProgressMetricsEntity({required this.sellerTalkRatio, required this.questionCount, required this.averageSellerTurnSeconds, required this.longestSellerTurnSeconds, required this.hesitationCount, required this.questionsPerMinute, required this.hesitationsPerMinute});


@override final  CoachingProgressMetricEntity sellerTalkRatio;
@override final  CoachingProgressMetricEntity questionCount;
@override final  CoachingProgressMetricEntity averageSellerTurnSeconds;
@override final  CoachingProgressMetricEntity longestSellerTurnSeconds;
@override final  CoachingProgressMetricEntity hesitationCount;
@override final  CoachingProgressMetricEntity questionsPerMinute;
@override final  CoachingProgressMetricEntity hesitationsPerMinute;

/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingProgressMetricsEntityCopyWith<_CoachingProgressMetricsEntity> get copyWith => __$CoachingProgressMetricsEntityCopyWithImpl<_CoachingProgressMetricsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingProgressMetricsEntity&&(identical(other.sellerTalkRatio, sellerTalkRatio) || other.sellerTalkRatio == sellerTalkRatio)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.averageSellerTurnSeconds, averageSellerTurnSeconds) || other.averageSellerTurnSeconds == averageSellerTurnSeconds)&&(identical(other.longestSellerTurnSeconds, longestSellerTurnSeconds) || other.longestSellerTurnSeconds == longestSellerTurnSeconds)&&(identical(other.hesitationCount, hesitationCount) || other.hesitationCount == hesitationCount)&&(identical(other.questionsPerMinute, questionsPerMinute) || other.questionsPerMinute == questionsPerMinute)&&(identical(other.hesitationsPerMinute, hesitationsPerMinute) || other.hesitationsPerMinute == hesitationsPerMinute));
}


@override
int get hashCode => Object.hash(runtimeType,sellerTalkRatio,questionCount,averageSellerTurnSeconds,longestSellerTurnSeconds,hesitationCount,questionsPerMinute,hesitationsPerMinute);

@override
String toString() {
  return 'CoachingProgressMetricsEntity(sellerTalkRatio: $sellerTalkRatio, questionCount: $questionCount, averageSellerTurnSeconds: $averageSellerTurnSeconds, longestSellerTurnSeconds: $longestSellerTurnSeconds, hesitationCount: $hesitationCount, questionsPerMinute: $questionsPerMinute, hesitationsPerMinute: $hesitationsPerMinute)';
}


}

/// @nodoc
abstract mixin class _$CoachingProgressMetricsEntityCopyWith<$Res> implements $CoachingProgressMetricsEntityCopyWith<$Res> {
  factory _$CoachingProgressMetricsEntityCopyWith(_CoachingProgressMetricsEntity value, $Res Function(_CoachingProgressMetricsEntity) _then) = __$CoachingProgressMetricsEntityCopyWithImpl;
@override @useResult
$Res call({
 CoachingProgressMetricEntity sellerTalkRatio, CoachingProgressMetricEntity questionCount, CoachingProgressMetricEntity averageSellerTurnSeconds, CoachingProgressMetricEntity longestSellerTurnSeconds, CoachingProgressMetricEntity hesitationCount, CoachingProgressMetricEntity questionsPerMinute, CoachingProgressMetricEntity hesitationsPerMinute
});


@override $CoachingProgressMetricEntityCopyWith<$Res> get sellerTalkRatio;@override $CoachingProgressMetricEntityCopyWith<$Res> get questionCount;@override $CoachingProgressMetricEntityCopyWith<$Res> get averageSellerTurnSeconds;@override $CoachingProgressMetricEntityCopyWith<$Res> get longestSellerTurnSeconds;@override $CoachingProgressMetricEntityCopyWith<$Res> get hesitationCount;@override $CoachingProgressMetricEntityCopyWith<$Res> get questionsPerMinute;@override $CoachingProgressMetricEntityCopyWith<$Res> get hesitationsPerMinute;

}
/// @nodoc
class __$CoachingProgressMetricsEntityCopyWithImpl<$Res>
    implements _$CoachingProgressMetricsEntityCopyWith<$Res> {
  __$CoachingProgressMetricsEntityCopyWithImpl(this._self, this._then);

  final _CoachingProgressMetricsEntity _self;
  final $Res Function(_CoachingProgressMetricsEntity) _then;

/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sellerTalkRatio = null,Object? questionCount = null,Object? averageSellerTurnSeconds = null,Object? longestSellerTurnSeconds = null,Object? hesitationCount = null,Object? questionsPerMinute = null,Object? hesitationsPerMinute = null,}) {
  return _then(_CoachingProgressMetricsEntity(
sellerTalkRatio: null == sellerTalkRatio ? _self.sellerTalkRatio : sellerTalkRatio // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,averageSellerTurnSeconds: null == averageSellerTurnSeconds ? _self.averageSellerTurnSeconds : averageSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,longestSellerTurnSeconds: null == longestSellerTurnSeconds ? _self.longestSellerTurnSeconds : longestSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,hesitationCount: null == hesitationCount ? _self.hesitationCount : hesitationCount // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,questionsPerMinute: null == questionsPerMinute ? _self.questionsPerMinute : questionsPerMinute // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,hesitationsPerMinute: null == hesitationsPerMinute ? _self.hesitationsPerMinute : hesitationsPerMinute // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricEntity,
  ));
}

/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get sellerTalkRatio {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.sellerTalkRatio, (value) {
    return _then(_self.copyWith(sellerTalkRatio: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get questionCount {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.questionCount, (value) {
    return _then(_self.copyWith(questionCount: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get averageSellerTurnSeconds {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.averageSellerTurnSeconds, (value) {
    return _then(_self.copyWith(averageSellerTurnSeconds: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get longestSellerTurnSeconds {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.longestSellerTurnSeconds, (value) {
    return _then(_self.copyWith(longestSellerTurnSeconds: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get hesitationCount {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.hesitationCount, (value) {
    return _then(_self.copyWith(hesitationCount: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get questionsPerMinute {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.questionsPerMinute, (value) {
    return _then(_self.copyWith(questionsPerMinute: value));
  });
}/// Create a copy of CoachingProgressMetricsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricEntityCopyWith<$Res> get hesitationsPerMinute {

  return $CoachingProgressMetricEntityCopyWith<$Res>(_self.hesitationsPerMinute, (value) {
    return _then(_self.copyWith(hesitationsPerMinute: value));
  });
}
}

/// @nodoc
mixin _$CoachingProgressAxisEntity {

 CallPerformanceAxis get axis; int get currentScore; int? get previousScore; int? get delta; CallPerformanceSignal get signal; String get observation; int get sampleCount;
/// Create a copy of CoachingProgressAxisEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingProgressAxisEntityCopyWith<CoachingProgressAxisEntity> get copyWith => _$CoachingProgressAxisEntityCopyWithImpl<CoachingProgressAxisEntity>(this as CoachingProgressAxisEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingProgressAxisEntity&&(identical(other.axis, axis) || other.axis == axis)&&(identical(other.currentScore, currentScore) || other.currentScore == currentScore)&&(identical(other.previousScore, previousScore) || other.previousScore == previousScore)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.signal, signal) || other.signal == signal)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}


@override
int get hashCode => Object.hash(runtimeType,axis,currentScore,previousScore,delta,signal,observation,sampleCount);

@override
String toString() {
  return 'CoachingProgressAxisEntity(axis: $axis, currentScore: $currentScore, previousScore: $previousScore, delta: $delta, signal: $signal, observation: $observation, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class $CoachingProgressAxisEntityCopyWith<$Res>  {
  factory $CoachingProgressAxisEntityCopyWith(CoachingProgressAxisEntity value, $Res Function(CoachingProgressAxisEntity) _then) = _$CoachingProgressAxisEntityCopyWithImpl;
@useResult
$Res call({
 CallPerformanceAxis axis, int currentScore, int? previousScore, int? delta, CallPerformanceSignal signal, String observation, int sampleCount
});




}
/// @nodoc
class _$CoachingProgressAxisEntityCopyWithImpl<$Res>
    implements $CoachingProgressAxisEntityCopyWith<$Res> {
  _$CoachingProgressAxisEntityCopyWithImpl(this._self, this._then);

  final CoachingProgressAxisEntity _self;
  final $Res Function(CoachingProgressAxisEntity) _then;

/// Create a copy of CoachingProgressAxisEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? axis = null,Object? currentScore = null,Object? previousScore = freezed,Object? delta = freezed,Object? signal = null,Object? observation = null,Object? sampleCount = null,}) {
  return _then(_self.copyWith(
axis: null == axis ? _self.axis : axis // ignore: cast_nullable_to_non_nullable
as CallPerformanceAxis,currentScore: null == currentScore ? _self.currentScore : currentScore // ignore: cast_nullable_to_non_nullable
as int,previousScore: freezed == previousScore ? _self.previousScore : previousScore // ignore: cast_nullable_to_non_nullable
as int?,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int?,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as CallPerformanceSignal,observation: null == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachingProgressAxisEntity].
extension CoachingProgressAxisEntityPatterns on CoachingProgressAxisEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingProgressAxisEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingProgressAxisEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingProgressAxisEntity value)  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressAxisEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingProgressAxisEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressAxisEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CallPerformanceAxis axis,  int currentScore,  int? previousScore,  int? delta,  CallPerformanceSignal signal,  String observation,  int sampleCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingProgressAxisEntity() when $default != null:
return $default(_that.axis,_that.currentScore,_that.previousScore,_that.delta,_that.signal,_that.observation,_that.sampleCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CallPerformanceAxis axis,  int currentScore,  int? previousScore,  int? delta,  CallPerformanceSignal signal,  String observation,  int sampleCount)  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressAxisEntity():
return $default(_that.axis,_that.currentScore,_that.previousScore,_that.delta,_that.signal,_that.observation,_that.sampleCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CallPerformanceAxis axis,  int currentScore,  int? previousScore,  int? delta,  CallPerformanceSignal signal,  String observation,  int sampleCount)?  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressAxisEntity() when $default != null:
return $default(_that.axis,_that.currentScore,_that.previousScore,_that.delta,_that.signal,_that.observation,_that.sampleCount);case _:
  return null;

}
}

}

/// @nodoc


class _CoachingProgressAxisEntity implements CoachingProgressAxisEntity {
  const _CoachingProgressAxisEntity({required this.axis, required this.currentScore, required this.previousScore, required this.delta, required this.signal, required this.observation, required this.sampleCount});


@override final  CallPerformanceAxis axis;
@override final  int currentScore;
@override final  int? previousScore;
@override final  int? delta;
@override final  CallPerformanceSignal signal;
@override final  String observation;
@override final  int sampleCount;

/// Create a copy of CoachingProgressAxisEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingProgressAxisEntityCopyWith<_CoachingProgressAxisEntity> get copyWith => __$CoachingProgressAxisEntityCopyWithImpl<_CoachingProgressAxisEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingProgressAxisEntity&&(identical(other.axis, axis) || other.axis == axis)&&(identical(other.currentScore, currentScore) || other.currentScore == currentScore)&&(identical(other.previousScore, previousScore) || other.previousScore == previousScore)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.signal, signal) || other.signal == signal)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}


@override
int get hashCode => Object.hash(runtimeType,axis,currentScore,previousScore,delta,signal,observation,sampleCount);

@override
String toString() {
  return 'CoachingProgressAxisEntity(axis: $axis, currentScore: $currentScore, previousScore: $previousScore, delta: $delta, signal: $signal, observation: $observation, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class _$CoachingProgressAxisEntityCopyWith<$Res> implements $CoachingProgressAxisEntityCopyWith<$Res> {
  factory _$CoachingProgressAxisEntityCopyWith(_CoachingProgressAxisEntity value, $Res Function(_CoachingProgressAxisEntity) _then) = __$CoachingProgressAxisEntityCopyWithImpl;
@override @useResult
$Res call({
 CallPerformanceAxis axis, int currentScore, int? previousScore, int? delta, CallPerformanceSignal signal, String observation, int sampleCount
});




}
/// @nodoc
class __$CoachingProgressAxisEntityCopyWithImpl<$Res>
    implements _$CoachingProgressAxisEntityCopyWith<$Res> {
  __$CoachingProgressAxisEntityCopyWithImpl(this._self, this._then);

  final _CoachingProgressAxisEntity _self;
  final $Res Function(_CoachingProgressAxisEntity) _then;

/// Create a copy of CoachingProgressAxisEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? axis = null,Object? currentScore = null,Object? previousScore = freezed,Object? delta = freezed,Object? signal = null,Object? observation = null,Object? sampleCount = null,}) {
  return _then(_CoachingProgressAxisEntity(
axis: null == axis ? _self.axis : axis // ignore: cast_nullable_to_non_nullable
as CallPerformanceAxis,currentScore: null == currentScore ? _self.currentScore : currentScore // ignore: cast_nullable_to_non_nullable
as int,previousScore: freezed == previousScore ? _self.previousScore : previousScore // ignore: cast_nullable_to_non_nullable
as int?,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int?,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as CallPerformanceSignal,observation: null == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$CoachingProgressCallEntity {

 String get callId; String get sessionId; DateTime get occurredAt; String get destinationNumber; List<CallPerformanceAxisEntity> get performanceAxes; String? get outcome; CallObservedMetricsEntity? get observedMetrics;
/// Create a copy of CoachingProgressCallEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingProgressCallEntityCopyWith<CoachingProgressCallEntity> get copyWith => _$CoachingProgressCallEntityCopyWithImpl<CoachingProgressCallEntity>(this as CoachingProgressCallEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingProgressCallEntity&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.destinationNumber, destinationNumber) || other.destinationNumber == destinationNumber)&&const DeepCollectionEquality().equals(other.performanceAxes, performanceAxes)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.observedMetrics, observedMetrics) || other.observedMetrics == observedMetrics));
}


@override
int get hashCode => Object.hash(runtimeType,callId,sessionId,occurredAt,destinationNumber,const DeepCollectionEquality().hash(performanceAxes),outcome,observedMetrics);

@override
String toString() {
  return 'CoachingProgressCallEntity(callId: $callId, sessionId: $sessionId, occurredAt: $occurredAt, destinationNumber: $destinationNumber, performanceAxes: $performanceAxes, outcome: $outcome, observedMetrics: $observedMetrics)';
}


}

/// @nodoc
abstract mixin class $CoachingProgressCallEntityCopyWith<$Res>  {
  factory $CoachingProgressCallEntityCopyWith(CoachingProgressCallEntity value, $Res Function(CoachingProgressCallEntity) _then) = _$CoachingProgressCallEntityCopyWithImpl;
@useResult
$Res call({
 String callId, String sessionId, DateTime occurredAt, String destinationNumber, List<CallPerformanceAxisEntity> performanceAxes, String? outcome, CallObservedMetricsEntity? observedMetrics
});


$CallObservedMetricsEntityCopyWith<$Res>? get observedMetrics;

}
/// @nodoc
class _$CoachingProgressCallEntityCopyWithImpl<$Res>
    implements $CoachingProgressCallEntityCopyWith<$Res> {
  _$CoachingProgressCallEntityCopyWithImpl(this._self, this._then);

  final CoachingProgressCallEntity _self;
  final $Res Function(CoachingProgressCallEntity) _then;

/// Create a copy of CoachingProgressCallEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? sessionId = null,Object? occurredAt = null,Object? destinationNumber = null,Object? performanceAxes = null,Object? outcome = freezed,Object? observedMetrics = freezed,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,destinationNumber: null == destinationNumber ? _self.destinationNumber : destinationNumber // ignore: cast_nullable_to_non_nullable
as String,performanceAxes: null == performanceAxes ? _self.performanceAxes : performanceAxes // ignore: cast_nullable_to_non_nullable
as List<CallPerformanceAxisEntity>,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,observedMetrics: freezed == observedMetrics ? _self.observedMetrics : observedMetrics // ignore: cast_nullable_to_non_nullable
as CallObservedMetricsEntity?,
  ));
}
/// Create a copy of CoachingProgressCallEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallObservedMetricsEntityCopyWith<$Res>? get observedMetrics {
    if (_self.observedMetrics == null) {
    return null;
  }

  return $CallObservedMetricsEntityCopyWith<$Res>(_self.observedMetrics!, (value) {
    return _then(_self.copyWith(observedMetrics: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoachingProgressCallEntity].
extension CoachingProgressCallEntityPatterns on CoachingProgressCallEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingProgressCallEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingProgressCallEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingProgressCallEntity value)  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressCallEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingProgressCallEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressCallEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String sessionId,  DateTime occurredAt,  String destinationNumber,  List<CallPerformanceAxisEntity> performanceAxes,  String? outcome,  CallObservedMetricsEntity? observedMetrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingProgressCallEntity() when $default != null:
return $default(_that.callId,_that.sessionId,_that.occurredAt,_that.destinationNumber,_that.performanceAxes,_that.outcome,_that.observedMetrics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String sessionId,  DateTime occurredAt,  String destinationNumber,  List<CallPerformanceAxisEntity> performanceAxes,  String? outcome,  CallObservedMetricsEntity? observedMetrics)  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressCallEntity():
return $default(_that.callId,_that.sessionId,_that.occurredAt,_that.destinationNumber,_that.performanceAxes,_that.outcome,_that.observedMetrics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String sessionId,  DateTime occurredAt,  String destinationNumber,  List<CallPerformanceAxisEntity> performanceAxes,  String? outcome,  CallObservedMetricsEntity? observedMetrics)?  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressCallEntity() when $default != null:
return $default(_that.callId,_that.sessionId,_that.occurredAt,_that.destinationNumber,_that.performanceAxes,_that.outcome,_that.observedMetrics);case _:
  return null;

}
}

}

/// @nodoc


class _CoachingProgressCallEntity implements CoachingProgressCallEntity {
  const _CoachingProgressCallEntity({required this.callId, required this.sessionId, required this.occurredAt, required this.destinationNumber, required final  List<CallPerformanceAxisEntity> performanceAxes, this.outcome, this.observedMetrics}): _performanceAxes = performanceAxes;


@override final  String callId;
@override final  String sessionId;
@override final  DateTime occurredAt;
@override final  String destinationNumber;
 final  List<CallPerformanceAxisEntity> _performanceAxes;
@override List<CallPerformanceAxisEntity> get performanceAxes {
  if (_performanceAxes is EqualUnmodifiableListView) return _performanceAxes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_performanceAxes);
}

@override final  String? outcome;
@override final  CallObservedMetricsEntity? observedMetrics;

/// Create a copy of CoachingProgressCallEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingProgressCallEntityCopyWith<_CoachingProgressCallEntity> get copyWith => __$CoachingProgressCallEntityCopyWithImpl<_CoachingProgressCallEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingProgressCallEntity&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.destinationNumber, destinationNumber) || other.destinationNumber == destinationNumber)&&const DeepCollectionEquality().equals(other._performanceAxes, _performanceAxes)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.observedMetrics, observedMetrics) || other.observedMetrics == observedMetrics));
}


@override
int get hashCode => Object.hash(runtimeType,callId,sessionId,occurredAt,destinationNumber,const DeepCollectionEquality().hash(_performanceAxes),outcome,observedMetrics);

@override
String toString() {
  return 'CoachingProgressCallEntity(callId: $callId, sessionId: $sessionId, occurredAt: $occurredAt, destinationNumber: $destinationNumber, performanceAxes: $performanceAxes, outcome: $outcome, observedMetrics: $observedMetrics)';
}


}

/// @nodoc
abstract mixin class _$CoachingProgressCallEntityCopyWith<$Res> implements $CoachingProgressCallEntityCopyWith<$Res> {
  factory _$CoachingProgressCallEntityCopyWith(_CoachingProgressCallEntity value, $Res Function(_CoachingProgressCallEntity) _then) = __$CoachingProgressCallEntityCopyWithImpl;
@override @useResult
$Res call({
 String callId, String sessionId, DateTime occurredAt, String destinationNumber, List<CallPerformanceAxisEntity> performanceAxes, String? outcome, CallObservedMetricsEntity? observedMetrics
});


@override $CallObservedMetricsEntityCopyWith<$Res>? get observedMetrics;

}
/// @nodoc
class __$CoachingProgressCallEntityCopyWithImpl<$Res>
    implements _$CoachingProgressCallEntityCopyWith<$Res> {
  __$CoachingProgressCallEntityCopyWithImpl(this._self, this._then);

  final _CoachingProgressCallEntity _self;
  final $Res Function(_CoachingProgressCallEntity) _then;

/// Create a copy of CoachingProgressCallEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? sessionId = null,Object? occurredAt = null,Object? destinationNumber = null,Object? performanceAxes = null,Object? outcome = freezed,Object? observedMetrics = freezed,}) {
  return _then(_CoachingProgressCallEntity(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,destinationNumber: null == destinationNumber ? _self.destinationNumber : destinationNumber // ignore: cast_nullable_to_non_nullable
as String,performanceAxes: null == performanceAxes ? _self._performanceAxes : performanceAxes // ignore: cast_nullable_to_non_nullable
as List<CallPerformanceAxisEntity>,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,observedMetrics: freezed == observedMetrics ? _self.observedMetrics : observedMetrics // ignore: cast_nullable_to_non_nullable
as CallObservedMetricsEntity?,
  ));
}

/// Create a copy of CoachingProgressCallEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallObservedMetricsEntityCopyWith<$Res>? get observedMetrics {
    if (_self.observedMetrics == null) {
    return null;
  }

  return $CallObservedMetricsEntityCopyWith<$Res>(_self.observedMetrics!, (value) {
    return _then(_self.copyWith(observedMetrics: value));
  });
}
}

/// @nodoc
mixin _$CoachingProgressEntity {

 DateTime get generatedAt; int get sessionCount; int get analyzedCallCount; int get currentWindowSize; int get previousWindowSize; bool get hasComparison; String get rubricVersion; List<CoachingProgressAxisEntity> get axes; CoachingProgressMetricsEntity get observedMetrics; List<CoachingProgressCallEntity> get recentCalls; CoachingProgressAxisEntity? get focus; CoachingProgressAxisEntity? get strength;
/// Create a copy of CoachingProgressEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingProgressEntityCopyWith<CoachingProgressEntity> get copyWith => _$CoachingProgressEntityCopyWithImpl<CoachingProgressEntity>(this as CoachingProgressEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingProgressEntity&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.analyzedCallCount, analyzedCallCount) || other.analyzedCallCount == analyzedCallCount)&&(identical(other.currentWindowSize, currentWindowSize) || other.currentWindowSize == currentWindowSize)&&(identical(other.previousWindowSize, previousWindowSize) || other.previousWindowSize == previousWindowSize)&&(identical(other.hasComparison, hasComparison) || other.hasComparison == hasComparison)&&(identical(other.rubricVersion, rubricVersion) || other.rubricVersion == rubricVersion)&&const DeepCollectionEquality().equals(other.axes, axes)&&(identical(other.observedMetrics, observedMetrics) || other.observedMetrics == observedMetrics)&&const DeepCollectionEquality().equals(other.recentCalls, recentCalls)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.strength, strength) || other.strength == strength));
}


@override
int get hashCode => Object.hash(runtimeType,generatedAt,sessionCount,analyzedCallCount,currentWindowSize,previousWindowSize,hasComparison,rubricVersion,const DeepCollectionEquality().hash(axes),observedMetrics,const DeepCollectionEquality().hash(recentCalls),focus,strength);

@override
String toString() {
  return 'CoachingProgressEntity(generatedAt: $generatedAt, sessionCount: $sessionCount, analyzedCallCount: $analyzedCallCount, currentWindowSize: $currentWindowSize, previousWindowSize: $previousWindowSize, hasComparison: $hasComparison, rubricVersion: $rubricVersion, axes: $axes, observedMetrics: $observedMetrics, recentCalls: $recentCalls, focus: $focus, strength: $strength)';
}


}

/// @nodoc
abstract mixin class $CoachingProgressEntityCopyWith<$Res>  {
  factory $CoachingProgressEntityCopyWith(CoachingProgressEntity value, $Res Function(CoachingProgressEntity) _then) = _$CoachingProgressEntityCopyWithImpl;
@useResult
$Res call({
 DateTime generatedAt, int sessionCount, int analyzedCallCount, int currentWindowSize, int previousWindowSize, bool hasComparison, String rubricVersion, List<CoachingProgressAxisEntity> axes, CoachingProgressMetricsEntity observedMetrics, List<CoachingProgressCallEntity> recentCalls, CoachingProgressAxisEntity? focus, CoachingProgressAxisEntity? strength
});


$CoachingProgressMetricsEntityCopyWith<$Res> get observedMetrics;$CoachingProgressAxisEntityCopyWith<$Res>? get focus;$CoachingProgressAxisEntityCopyWith<$Res>? get strength;

}
/// @nodoc
class _$CoachingProgressEntityCopyWithImpl<$Res>
    implements $CoachingProgressEntityCopyWith<$Res> {
  _$CoachingProgressEntityCopyWithImpl(this._self, this._then);

  final CoachingProgressEntity _self;
  final $Res Function(CoachingProgressEntity) _then;

/// Create a copy of CoachingProgressEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? generatedAt = null,Object? sessionCount = null,Object? analyzedCallCount = null,Object? currentWindowSize = null,Object? previousWindowSize = null,Object? hasComparison = null,Object? rubricVersion = null,Object? axes = null,Object? observedMetrics = null,Object? recentCalls = null,Object? focus = freezed,Object? strength = freezed,}) {
  return _then(_self.copyWith(
generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,analyzedCallCount: null == analyzedCallCount ? _self.analyzedCallCount : analyzedCallCount // ignore: cast_nullable_to_non_nullable
as int,currentWindowSize: null == currentWindowSize ? _self.currentWindowSize : currentWindowSize // ignore: cast_nullable_to_non_nullable
as int,previousWindowSize: null == previousWindowSize ? _self.previousWindowSize : previousWindowSize // ignore: cast_nullable_to_non_nullable
as int,hasComparison: null == hasComparison ? _self.hasComparison : hasComparison // ignore: cast_nullable_to_non_nullable
as bool,rubricVersion: null == rubricVersion ? _self.rubricVersion : rubricVersion // ignore: cast_nullable_to_non_nullable
as String,axes: null == axes ? _self.axes : axes // ignore: cast_nullable_to_non_nullable
as List<CoachingProgressAxisEntity>,observedMetrics: null == observedMetrics ? _self.observedMetrics : observedMetrics // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricsEntity,recentCalls: null == recentCalls ? _self.recentCalls : recentCalls // ignore: cast_nullable_to_non_nullable
as List<CoachingProgressCallEntity>,focus: freezed == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as CoachingProgressAxisEntity?,strength: freezed == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as CoachingProgressAxisEntity?,
  ));
}
/// Create a copy of CoachingProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricsEntityCopyWith<$Res> get observedMetrics {

  return $CoachingProgressMetricsEntityCopyWith<$Res>(_self.observedMetrics, (value) {
    return _then(_self.copyWith(observedMetrics: value));
  });
}/// Create a copy of CoachingProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressAxisEntityCopyWith<$Res>? get focus {
    if (_self.focus == null) {
    return null;
  }

  return $CoachingProgressAxisEntityCopyWith<$Res>(_self.focus!, (value) {
    return _then(_self.copyWith(focus: value));
  });
}/// Create a copy of CoachingProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressAxisEntityCopyWith<$Res>? get strength {
    if (_self.strength == null) {
    return null;
  }

  return $CoachingProgressAxisEntityCopyWith<$Res>(_self.strength!, (value) {
    return _then(_self.copyWith(strength: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoachingProgressEntity].
extension CoachingProgressEntityPatterns on CoachingProgressEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingProgressEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingProgressEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingProgressEntity value)  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingProgressEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime generatedAt,  int sessionCount,  int analyzedCallCount,  int currentWindowSize,  int previousWindowSize,  bool hasComparison,  String rubricVersion,  List<CoachingProgressAxisEntity> axes,  CoachingProgressMetricsEntity observedMetrics,  List<CoachingProgressCallEntity> recentCalls,  CoachingProgressAxisEntity? focus,  CoachingProgressAxisEntity? strength)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingProgressEntity() when $default != null:
return $default(_that.generatedAt,_that.sessionCount,_that.analyzedCallCount,_that.currentWindowSize,_that.previousWindowSize,_that.hasComparison,_that.rubricVersion,_that.axes,_that.observedMetrics,_that.recentCalls,_that.focus,_that.strength);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime generatedAt,  int sessionCount,  int analyzedCallCount,  int currentWindowSize,  int previousWindowSize,  bool hasComparison,  String rubricVersion,  List<CoachingProgressAxisEntity> axes,  CoachingProgressMetricsEntity observedMetrics,  List<CoachingProgressCallEntity> recentCalls,  CoachingProgressAxisEntity? focus,  CoachingProgressAxisEntity? strength)  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressEntity():
return $default(_that.generatedAt,_that.sessionCount,_that.analyzedCallCount,_that.currentWindowSize,_that.previousWindowSize,_that.hasComparison,_that.rubricVersion,_that.axes,_that.observedMetrics,_that.recentCalls,_that.focus,_that.strength);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime generatedAt,  int sessionCount,  int analyzedCallCount,  int currentWindowSize,  int previousWindowSize,  bool hasComparison,  String rubricVersion,  List<CoachingProgressAxisEntity> axes,  CoachingProgressMetricsEntity observedMetrics,  List<CoachingProgressCallEntity> recentCalls,  CoachingProgressAxisEntity? focus,  CoachingProgressAxisEntity? strength)?  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressEntity() when $default != null:
return $default(_that.generatedAt,_that.sessionCount,_that.analyzedCallCount,_that.currentWindowSize,_that.previousWindowSize,_that.hasComparison,_that.rubricVersion,_that.axes,_that.observedMetrics,_that.recentCalls,_that.focus,_that.strength);case _:
  return null;

}
}

}

/// @nodoc


class _CoachingProgressEntity implements CoachingProgressEntity {
  const _CoachingProgressEntity({required this.generatedAt, required this.sessionCount, required this.analyzedCallCount, required this.currentWindowSize, required this.previousWindowSize, required this.hasComparison, required this.rubricVersion, required final  List<CoachingProgressAxisEntity> axes, required this.observedMetrics, required final  List<CoachingProgressCallEntity> recentCalls, this.focus, this.strength}): _axes = axes,_recentCalls = recentCalls;


@override final  DateTime generatedAt;
@override final  int sessionCount;
@override final  int analyzedCallCount;
@override final  int currentWindowSize;
@override final  int previousWindowSize;
@override final  bool hasComparison;
@override final  String rubricVersion;
 final  List<CoachingProgressAxisEntity> _axes;
@override List<CoachingProgressAxisEntity> get axes {
  if (_axes is EqualUnmodifiableListView) return _axes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_axes);
}

@override final  CoachingProgressMetricsEntity observedMetrics;
 final  List<CoachingProgressCallEntity> _recentCalls;
@override List<CoachingProgressCallEntity> get recentCalls {
  if (_recentCalls is EqualUnmodifiableListView) return _recentCalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentCalls);
}

@override final  CoachingProgressAxisEntity? focus;
@override final  CoachingProgressAxisEntity? strength;

/// Create a copy of CoachingProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingProgressEntityCopyWith<_CoachingProgressEntity> get copyWith => __$CoachingProgressEntityCopyWithImpl<_CoachingProgressEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingProgressEntity&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.analyzedCallCount, analyzedCallCount) || other.analyzedCallCount == analyzedCallCount)&&(identical(other.currentWindowSize, currentWindowSize) || other.currentWindowSize == currentWindowSize)&&(identical(other.previousWindowSize, previousWindowSize) || other.previousWindowSize == previousWindowSize)&&(identical(other.hasComparison, hasComparison) || other.hasComparison == hasComparison)&&(identical(other.rubricVersion, rubricVersion) || other.rubricVersion == rubricVersion)&&const DeepCollectionEquality().equals(other._axes, _axes)&&(identical(other.observedMetrics, observedMetrics) || other.observedMetrics == observedMetrics)&&const DeepCollectionEquality().equals(other._recentCalls, _recentCalls)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.strength, strength) || other.strength == strength));
}


@override
int get hashCode => Object.hash(runtimeType,generatedAt,sessionCount,analyzedCallCount,currentWindowSize,previousWindowSize,hasComparison,rubricVersion,const DeepCollectionEquality().hash(_axes),observedMetrics,const DeepCollectionEquality().hash(_recentCalls),focus,strength);

@override
String toString() {
  return 'CoachingProgressEntity(generatedAt: $generatedAt, sessionCount: $sessionCount, analyzedCallCount: $analyzedCallCount, currentWindowSize: $currentWindowSize, previousWindowSize: $previousWindowSize, hasComparison: $hasComparison, rubricVersion: $rubricVersion, axes: $axes, observedMetrics: $observedMetrics, recentCalls: $recentCalls, focus: $focus, strength: $strength)';
}


}

/// @nodoc
abstract mixin class _$CoachingProgressEntityCopyWith<$Res> implements $CoachingProgressEntityCopyWith<$Res> {
  factory _$CoachingProgressEntityCopyWith(_CoachingProgressEntity value, $Res Function(_CoachingProgressEntity) _then) = __$CoachingProgressEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime generatedAt, int sessionCount, int analyzedCallCount, int currentWindowSize, int previousWindowSize, bool hasComparison, String rubricVersion, List<CoachingProgressAxisEntity> axes, CoachingProgressMetricsEntity observedMetrics, List<CoachingProgressCallEntity> recentCalls, CoachingProgressAxisEntity? focus, CoachingProgressAxisEntity? strength
});


@override $CoachingProgressMetricsEntityCopyWith<$Res> get observedMetrics;@override $CoachingProgressAxisEntityCopyWith<$Res>? get focus;@override $CoachingProgressAxisEntityCopyWith<$Res>? get strength;

}
/// @nodoc
class __$CoachingProgressEntityCopyWithImpl<$Res>
    implements _$CoachingProgressEntityCopyWith<$Res> {
  __$CoachingProgressEntityCopyWithImpl(this._self, this._then);

  final _CoachingProgressEntity _self;
  final $Res Function(_CoachingProgressEntity) _then;

/// Create a copy of CoachingProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatedAt = null,Object? sessionCount = null,Object? analyzedCallCount = null,Object? currentWindowSize = null,Object? previousWindowSize = null,Object? hasComparison = null,Object? rubricVersion = null,Object? axes = null,Object? observedMetrics = null,Object? recentCalls = null,Object? focus = freezed,Object? strength = freezed,}) {
  return _then(_CoachingProgressEntity(
generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,analyzedCallCount: null == analyzedCallCount ? _self.analyzedCallCount : analyzedCallCount // ignore: cast_nullable_to_non_nullable
as int,currentWindowSize: null == currentWindowSize ? _self.currentWindowSize : currentWindowSize // ignore: cast_nullable_to_non_nullable
as int,previousWindowSize: null == previousWindowSize ? _self.previousWindowSize : previousWindowSize // ignore: cast_nullable_to_non_nullable
as int,hasComparison: null == hasComparison ? _self.hasComparison : hasComparison // ignore: cast_nullable_to_non_nullable
as bool,rubricVersion: null == rubricVersion ? _self.rubricVersion : rubricVersion // ignore: cast_nullable_to_non_nullable
as String,axes: null == axes ? _self._axes : axes // ignore: cast_nullable_to_non_nullable
as List<CoachingProgressAxisEntity>,observedMetrics: null == observedMetrics ? _self.observedMetrics : observedMetrics // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricsEntity,recentCalls: null == recentCalls ? _self._recentCalls : recentCalls // ignore: cast_nullable_to_non_nullable
as List<CoachingProgressCallEntity>,focus: freezed == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as CoachingProgressAxisEntity?,strength: freezed == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as CoachingProgressAxisEntity?,
  ));
}

/// Create a copy of CoachingProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricsEntityCopyWith<$Res> get observedMetrics {

  return $CoachingProgressMetricsEntityCopyWith<$Res>(_self.observedMetrics, (value) {
    return _then(_self.copyWith(observedMetrics: value));
  });
}/// Create a copy of CoachingProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressAxisEntityCopyWith<$Res>? get focus {
    if (_self.focus == null) {
    return null;
  }

  return $CoachingProgressAxisEntityCopyWith<$Res>(_self.focus!, (value) {
    return _then(_self.copyWith(focus: value));
  });
}/// Create a copy of CoachingProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressAxisEntityCopyWith<$Res>? get strength {
    if (_self.strength == null) {
    return null;
  }

  return $CoachingProgressAxisEntityCopyWith<$Res>(_self.strength!, (value) {
    return _then(_self.copyWith(strength: value));
  });
}
}

// dart format on
