// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coaching_progress.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CoachingProgressMetricRemoteModel {

 double? get current; double? get previous; double? get delta; int get sampleCount;
/// Create a copy of CoachingProgressMetricRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<CoachingProgressMetricRemoteModel> get copyWith => _$CoachingProgressMetricRemoteModelCopyWithImpl<CoachingProgressMetricRemoteModel>(this as CoachingProgressMetricRemoteModel, _$identity);

  /// Serializes this CoachingProgressMetricRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingProgressMetricRemoteModel&&(identical(other.current, current) || other.current == current)&&(identical(other.previous, previous) || other.previous == previous)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current,previous,delta,sampleCount);

@override
String toString() {
  return 'CoachingProgressMetricRemoteModel(current: $current, previous: $previous, delta: $delta, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class $CoachingProgressMetricRemoteModelCopyWith<$Res>  {
  factory $CoachingProgressMetricRemoteModelCopyWith(CoachingProgressMetricRemoteModel value, $Res Function(CoachingProgressMetricRemoteModel) _then) = _$CoachingProgressMetricRemoteModelCopyWithImpl;
@useResult
$Res call({
 double? current, double? previous, double? delta, int sampleCount
});




}
/// @nodoc
class _$CoachingProgressMetricRemoteModelCopyWithImpl<$Res>
    implements $CoachingProgressMetricRemoteModelCopyWith<$Res> {
  _$CoachingProgressMetricRemoteModelCopyWithImpl(this._self, this._then);

  final CoachingProgressMetricRemoteModel _self;
  final $Res Function(CoachingProgressMetricRemoteModel) _then;

/// Create a copy of CoachingProgressMetricRemoteModel
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


/// Adds pattern-matching-related methods to [CoachingProgressMetricRemoteModel].
extension CoachingProgressMetricRemoteModelPatterns on CoachingProgressMetricRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingProgressMetricRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingProgressMetricRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingProgressMetricRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressMetricRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingProgressMetricRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressMetricRemoteModel() when $default != null:
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
case _CoachingProgressMetricRemoteModel() when $default != null:
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
case _CoachingProgressMetricRemoteModel():
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
case _CoachingProgressMetricRemoteModel() when $default != null:
return $default(_that.current,_that.previous,_that.delta,_that.sampleCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CoachingProgressMetricRemoteModel implements CoachingProgressMetricRemoteModel {
  const _CoachingProgressMetricRemoteModel({required this.current, required this.previous, required this.delta, required this.sampleCount});
  factory _CoachingProgressMetricRemoteModel.fromJson(Map<String, dynamic> json) => _$CoachingProgressMetricRemoteModelFromJson(json);

@override final  double? current;
@override final  double? previous;
@override final  double? delta;
@override final  int sampleCount;

/// Create a copy of CoachingProgressMetricRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingProgressMetricRemoteModelCopyWith<_CoachingProgressMetricRemoteModel> get copyWith => __$CoachingProgressMetricRemoteModelCopyWithImpl<_CoachingProgressMetricRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachingProgressMetricRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingProgressMetricRemoteModel&&(identical(other.current, current) || other.current == current)&&(identical(other.previous, previous) || other.previous == previous)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,current,previous,delta,sampleCount);

@override
String toString() {
  return 'CoachingProgressMetricRemoteModel(current: $current, previous: $previous, delta: $delta, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class _$CoachingProgressMetricRemoteModelCopyWith<$Res> implements $CoachingProgressMetricRemoteModelCopyWith<$Res> {
  factory _$CoachingProgressMetricRemoteModelCopyWith(_CoachingProgressMetricRemoteModel value, $Res Function(_CoachingProgressMetricRemoteModel) _then) = __$CoachingProgressMetricRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 double? current, double? previous, double? delta, int sampleCount
});




}
/// @nodoc
class __$CoachingProgressMetricRemoteModelCopyWithImpl<$Res>
    implements _$CoachingProgressMetricRemoteModelCopyWith<$Res> {
  __$CoachingProgressMetricRemoteModelCopyWithImpl(this._self, this._then);

  final _CoachingProgressMetricRemoteModel _self;
  final $Res Function(_CoachingProgressMetricRemoteModel) _then;

/// Create a copy of CoachingProgressMetricRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = freezed,Object? previous = freezed,Object? delta = freezed,Object? sampleCount = null,}) {
  return _then(_CoachingProgressMetricRemoteModel(
current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as double?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as double?,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as double?,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CallObservedMetricsRemoteModel {

 double get sellerTalkRatio; int get questionCount; double get averageSellerTurnSeconds; double get longestSellerTurnSeconds; int get hesitationCount; double get questionsPerMinute; double get hesitationsPerMinute;
/// Create a copy of CallObservedMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallObservedMetricsRemoteModelCopyWith<CallObservedMetricsRemoteModel> get copyWith => _$CallObservedMetricsRemoteModelCopyWithImpl<CallObservedMetricsRemoteModel>(this as CallObservedMetricsRemoteModel, _$identity);

  /// Serializes this CallObservedMetricsRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallObservedMetricsRemoteModel&&(identical(other.sellerTalkRatio, sellerTalkRatio) || other.sellerTalkRatio == sellerTalkRatio)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.averageSellerTurnSeconds, averageSellerTurnSeconds) || other.averageSellerTurnSeconds == averageSellerTurnSeconds)&&(identical(other.longestSellerTurnSeconds, longestSellerTurnSeconds) || other.longestSellerTurnSeconds == longestSellerTurnSeconds)&&(identical(other.hesitationCount, hesitationCount) || other.hesitationCount == hesitationCount)&&(identical(other.questionsPerMinute, questionsPerMinute) || other.questionsPerMinute == questionsPerMinute)&&(identical(other.hesitationsPerMinute, hesitationsPerMinute) || other.hesitationsPerMinute == hesitationsPerMinute));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sellerTalkRatio,questionCount,averageSellerTurnSeconds,longestSellerTurnSeconds,hesitationCount,questionsPerMinute,hesitationsPerMinute);

@override
String toString() {
  return 'CallObservedMetricsRemoteModel(sellerTalkRatio: $sellerTalkRatio, questionCount: $questionCount, averageSellerTurnSeconds: $averageSellerTurnSeconds, longestSellerTurnSeconds: $longestSellerTurnSeconds, hesitationCount: $hesitationCount, questionsPerMinute: $questionsPerMinute, hesitationsPerMinute: $hesitationsPerMinute)';
}


}

/// @nodoc
abstract mixin class $CallObservedMetricsRemoteModelCopyWith<$Res>  {
  factory $CallObservedMetricsRemoteModelCopyWith(CallObservedMetricsRemoteModel value, $Res Function(CallObservedMetricsRemoteModel) _then) = _$CallObservedMetricsRemoteModelCopyWithImpl;
@useResult
$Res call({
 double sellerTalkRatio, int questionCount, double averageSellerTurnSeconds, double longestSellerTurnSeconds, int hesitationCount, double questionsPerMinute, double hesitationsPerMinute
});




}
/// @nodoc
class _$CallObservedMetricsRemoteModelCopyWithImpl<$Res>
    implements $CallObservedMetricsRemoteModelCopyWith<$Res> {
  _$CallObservedMetricsRemoteModelCopyWithImpl(this._self, this._then);

  final CallObservedMetricsRemoteModel _self;
  final $Res Function(CallObservedMetricsRemoteModel) _then;

/// Create a copy of CallObservedMetricsRemoteModel
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


/// Adds pattern-matching-related methods to [CallObservedMetricsRemoteModel].
extension CallObservedMetricsRemoteModelPatterns on CallObservedMetricsRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallObservedMetricsRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallObservedMetricsRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallObservedMetricsRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CallObservedMetricsRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallObservedMetricsRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CallObservedMetricsRemoteModel() when $default != null:
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
case _CallObservedMetricsRemoteModel() when $default != null:
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
case _CallObservedMetricsRemoteModel():
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
case _CallObservedMetricsRemoteModel() when $default != null:
return $default(_that.sellerTalkRatio,_that.questionCount,_that.averageSellerTurnSeconds,_that.longestSellerTurnSeconds,_that.hesitationCount,_that.questionsPerMinute,_that.hesitationsPerMinute);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CallObservedMetricsRemoteModel implements CallObservedMetricsRemoteModel {
  const _CallObservedMetricsRemoteModel({required this.sellerTalkRatio, required this.questionCount, required this.averageSellerTurnSeconds, required this.longestSellerTurnSeconds, required this.hesitationCount, required this.questionsPerMinute, required this.hesitationsPerMinute});
  factory _CallObservedMetricsRemoteModel.fromJson(Map<String, dynamic> json) => _$CallObservedMetricsRemoteModelFromJson(json);

@override final  double sellerTalkRatio;
@override final  int questionCount;
@override final  double averageSellerTurnSeconds;
@override final  double longestSellerTurnSeconds;
@override final  int hesitationCount;
@override final  double questionsPerMinute;
@override final  double hesitationsPerMinute;

/// Create a copy of CallObservedMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallObservedMetricsRemoteModelCopyWith<_CallObservedMetricsRemoteModel> get copyWith => __$CallObservedMetricsRemoteModelCopyWithImpl<_CallObservedMetricsRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallObservedMetricsRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallObservedMetricsRemoteModel&&(identical(other.sellerTalkRatio, sellerTalkRatio) || other.sellerTalkRatio == sellerTalkRatio)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.averageSellerTurnSeconds, averageSellerTurnSeconds) || other.averageSellerTurnSeconds == averageSellerTurnSeconds)&&(identical(other.longestSellerTurnSeconds, longestSellerTurnSeconds) || other.longestSellerTurnSeconds == longestSellerTurnSeconds)&&(identical(other.hesitationCount, hesitationCount) || other.hesitationCount == hesitationCount)&&(identical(other.questionsPerMinute, questionsPerMinute) || other.questionsPerMinute == questionsPerMinute)&&(identical(other.hesitationsPerMinute, hesitationsPerMinute) || other.hesitationsPerMinute == hesitationsPerMinute));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sellerTalkRatio,questionCount,averageSellerTurnSeconds,longestSellerTurnSeconds,hesitationCount,questionsPerMinute,hesitationsPerMinute);

@override
String toString() {
  return 'CallObservedMetricsRemoteModel(sellerTalkRatio: $sellerTalkRatio, questionCount: $questionCount, averageSellerTurnSeconds: $averageSellerTurnSeconds, longestSellerTurnSeconds: $longestSellerTurnSeconds, hesitationCount: $hesitationCount, questionsPerMinute: $questionsPerMinute, hesitationsPerMinute: $hesitationsPerMinute)';
}


}

/// @nodoc
abstract mixin class _$CallObservedMetricsRemoteModelCopyWith<$Res> implements $CallObservedMetricsRemoteModelCopyWith<$Res> {
  factory _$CallObservedMetricsRemoteModelCopyWith(_CallObservedMetricsRemoteModel value, $Res Function(_CallObservedMetricsRemoteModel) _then) = __$CallObservedMetricsRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 double sellerTalkRatio, int questionCount, double averageSellerTurnSeconds, double longestSellerTurnSeconds, int hesitationCount, double questionsPerMinute, double hesitationsPerMinute
});




}
/// @nodoc
class __$CallObservedMetricsRemoteModelCopyWithImpl<$Res>
    implements _$CallObservedMetricsRemoteModelCopyWith<$Res> {
  __$CallObservedMetricsRemoteModelCopyWithImpl(this._self, this._then);

  final _CallObservedMetricsRemoteModel _self;
  final $Res Function(_CallObservedMetricsRemoteModel) _then;

/// Create a copy of CallObservedMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sellerTalkRatio = null,Object? questionCount = null,Object? averageSellerTurnSeconds = null,Object? longestSellerTurnSeconds = null,Object? hesitationCount = null,Object? questionsPerMinute = null,Object? hesitationsPerMinute = null,}) {
  return _then(_CallObservedMetricsRemoteModel(
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
mixin _$CoachingProgressMetricsRemoteModel {

 CoachingProgressMetricRemoteModel get sellerTalkRatio; CoachingProgressMetricRemoteModel get questionCount; CoachingProgressMetricRemoteModel get averageSellerTurnSeconds; CoachingProgressMetricRemoteModel get longestSellerTurnSeconds; CoachingProgressMetricRemoteModel get hesitationCount; CoachingProgressMetricRemoteModel get questionsPerMinute; CoachingProgressMetricRemoteModel get hesitationsPerMinute;
/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingProgressMetricsRemoteModelCopyWith<CoachingProgressMetricsRemoteModel> get copyWith => _$CoachingProgressMetricsRemoteModelCopyWithImpl<CoachingProgressMetricsRemoteModel>(this as CoachingProgressMetricsRemoteModel, _$identity);

  /// Serializes this CoachingProgressMetricsRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingProgressMetricsRemoteModel&&(identical(other.sellerTalkRatio, sellerTalkRatio) || other.sellerTalkRatio == sellerTalkRatio)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.averageSellerTurnSeconds, averageSellerTurnSeconds) || other.averageSellerTurnSeconds == averageSellerTurnSeconds)&&(identical(other.longestSellerTurnSeconds, longestSellerTurnSeconds) || other.longestSellerTurnSeconds == longestSellerTurnSeconds)&&(identical(other.hesitationCount, hesitationCount) || other.hesitationCount == hesitationCount)&&(identical(other.questionsPerMinute, questionsPerMinute) || other.questionsPerMinute == questionsPerMinute)&&(identical(other.hesitationsPerMinute, hesitationsPerMinute) || other.hesitationsPerMinute == hesitationsPerMinute));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sellerTalkRatio,questionCount,averageSellerTurnSeconds,longestSellerTurnSeconds,hesitationCount,questionsPerMinute,hesitationsPerMinute);

@override
String toString() {
  return 'CoachingProgressMetricsRemoteModel(sellerTalkRatio: $sellerTalkRatio, questionCount: $questionCount, averageSellerTurnSeconds: $averageSellerTurnSeconds, longestSellerTurnSeconds: $longestSellerTurnSeconds, hesitationCount: $hesitationCount, questionsPerMinute: $questionsPerMinute, hesitationsPerMinute: $hesitationsPerMinute)';
}


}

/// @nodoc
abstract mixin class $CoachingProgressMetricsRemoteModelCopyWith<$Res>  {
  factory $CoachingProgressMetricsRemoteModelCopyWith(CoachingProgressMetricsRemoteModel value, $Res Function(CoachingProgressMetricsRemoteModel) _then) = _$CoachingProgressMetricsRemoteModelCopyWithImpl;
@useResult
$Res call({
 CoachingProgressMetricRemoteModel sellerTalkRatio, CoachingProgressMetricRemoteModel questionCount, CoachingProgressMetricRemoteModel averageSellerTurnSeconds, CoachingProgressMetricRemoteModel longestSellerTurnSeconds, CoachingProgressMetricRemoteModel hesitationCount, CoachingProgressMetricRemoteModel questionsPerMinute, CoachingProgressMetricRemoteModel hesitationsPerMinute
});


$CoachingProgressMetricRemoteModelCopyWith<$Res> get sellerTalkRatio;$CoachingProgressMetricRemoteModelCopyWith<$Res> get questionCount;$CoachingProgressMetricRemoteModelCopyWith<$Res> get averageSellerTurnSeconds;$CoachingProgressMetricRemoteModelCopyWith<$Res> get longestSellerTurnSeconds;$CoachingProgressMetricRemoteModelCopyWith<$Res> get hesitationCount;$CoachingProgressMetricRemoteModelCopyWith<$Res> get questionsPerMinute;$CoachingProgressMetricRemoteModelCopyWith<$Res> get hesitationsPerMinute;

}
/// @nodoc
class _$CoachingProgressMetricsRemoteModelCopyWithImpl<$Res>
    implements $CoachingProgressMetricsRemoteModelCopyWith<$Res> {
  _$CoachingProgressMetricsRemoteModelCopyWithImpl(this._self, this._then);

  final CoachingProgressMetricsRemoteModel _self;
  final $Res Function(CoachingProgressMetricsRemoteModel) _then;

/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sellerTalkRatio = null,Object? questionCount = null,Object? averageSellerTurnSeconds = null,Object? longestSellerTurnSeconds = null,Object? hesitationCount = null,Object? questionsPerMinute = null,Object? hesitationsPerMinute = null,}) {
  return _then(_self.copyWith(
sellerTalkRatio: null == sellerTalkRatio ? _self.sellerTalkRatio : sellerTalkRatio // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,averageSellerTurnSeconds: null == averageSellerTurnSeconds ? _self.averageSellerTurnSeconds : averageSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,longestSellerTurnSeconds: null == longestSellerTurnSeconds ? _self.longestSellerTurnSeconds : longestSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,hesitationCount: null == hesitationCount ? _self.hesitationCount : hesitationCount // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,questionsPerMinute: null == questionsPerMinute ? _self.questionsPerMinute : questionsPerMinute // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,hesitationsPerMinute: null == hesitationsPerMinute ? _self.hesitationsPerMinute : hesitationsPerMinute // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,
  ));
}
/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get sellerTalkRatio {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.sellerTalkRatio, (value) {
    return _then(_self.copyWith(sellerTalkRatio: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get questionCount {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.questionCount, (value) {
    return _then(_self.copyWith(questionCount: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get averageSellerTurnSeconds {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.averageSellerTurnSeconds, (value) {
    return _then(_self.copyWith(averageSellerTurnSeconds: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get longestSellerTurnSeconds {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.longestSellerTurnSeconds, (value) {
    return _then(_self.copyWith(longestSellerTurnSeconds: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get hesitationCount {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.hesitationCount, (value) {
    return _then(_self.copyWith(hesitationCount: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get questionsPerMinute {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.questionsPerMinute, (value) {
    return _then(_self.copyWith(questionsPerMinute: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get hesitationsPerMinute {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.hesitationsPerMinute, (value) {
    return _then(_self.copyWith(hesitationsPerMinute: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoachingProgressMetricsRemoteModel].
extension CoachingProgressMetricsRemoteModelPatterns on CoachingProgressMetricsRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingProgressMetricsRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingProgressMetricsRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingProgressMetricsRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressMetricsRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingProgressMetricsRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressMetricsRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CoachingProgressMetricRemoteModel sellerTalkRatio,  CoachingProgressMetricRemoteModel questionCount,  CoachingProgressMetricRemoteModel averageSellerTurnSeconds,  CoachingProgressMetricRemoteModel longestSellerTurnSeconds,  CoachingProgressMetricRemoteModel hesitationCount,  CoachingProgressMetricRemoteModel questionsPerMinute,  CoachingProgressMetricRemoteModel hesitationsPerMinute)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingProgressMetricsRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CoachingProgressMetricRemoteModel sellerTalkRatio,  CoachingProgressMetricRemoteModel questionCount,  CoachingProgressMetricRemoteModel averageSellerTurnSeconds,  CoachingProgressMetricRemoteModel longestSellerTurnSeconds,  CoachingProgressMetricRemoteModel hesitationCount,  CoachingProgressMetricRemoteModel questionsPerMinute,  CoachingProgressMetricRemoteModel hesitationsPerMinute)  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressMetricsRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CoachingProgressMetricRemoteModel sellerTalkRatio,  CoachingProgressMetricRemoteModel questionCount,  CoachingProgressMetricRemoteModel averageSellerTurnSeconds,  CoachingProgressMetricRemoteModel longestSellerTurnSeconds,  CoachingProgressMetricRemoteModel hesitationCount,  CoachingProgressMetricRemoteModel questionsPerMinute,  CoachingProgressMetricRemoteModel hesitationsPerMinute)?  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressMetricsRemoteModel() when $default != null:
return $default(_that.sellerTalkRatio,_that.questionCount,_that.averageSellerTurnSeconds,_that.longestSellerTurnSeconds,_that.hesitationCount,_that.questionsPerMinute,_that.hesitationsPerMinute);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _CoachingProgressMetricsRemoteModel implements CoachingProgressMetricsRemoteModel {
  const _CoachingProgressMetricsRemoteModel({required this.sellerTalkRatio, required this.questionCount, required this.averageSellerTurnSeconds, required this.longestSellerTurnSeconds, required this.hesitationCount, required this.questionsPerMinute, required this.hesitationsPerMinute});
  factory _CoachingProgressMetricsRemoteModel.fromJson(Map<String, dynamic> json) => _$CoachingProgressMetricsRemoteModelFromJson(json);

@override final  CoachingProgressMetricRemoteModel sellerTalkRatio;
@override final  CoachingProgressMetricRemoteModel questionCount;
@override final  CoachingProgressMetricRemoteModel averageSellerTurnSeconds;
@override final  CoachingProgressMetricRemoteModel longestSellerTurnSeconds;
@override final  CoachingProgressMetricRemoteModel hesitationCount;
@override final  CoachingProgressMetricRemoteModel questionsPerMinute;
@override final  CoachingProgressMetricRemoteModel hesitationsPerMinute;

/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingProgressMetricsRemoteModelCopyWith<_CoachingProgressMetricsRemoteModel> get copyWith => __$CoachingProgressMetricsRemoteModelCopyWithImpl<_CoachingProgressMetricsRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachingProgressMetricsRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingProgressMetricsRemoteModel&&(identical(other.sellerTalkRatio, sellerTalkRatio) || other.sellerTalkRatio == sellerTalkRatio)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.averageSellerTurnSeconds, averageSellerTurnSeconds) || other.averageSellerTurnSeconds == averageSellerTurnSeconds)&&(identical(other.longestSellerTurnSeconds, longestSellerTurnSeconds) || other.longestSellerTurnSeconds == longestSellerTurnSeconds)&&(identical(other.hesitationCount, hesitationCount) || other.hesitationCount == hesitationCount)&&(identical(other.questionsPerMinute, questionsPerMinute) || other.questionsPerMinute == questionsPerMinute)&&(identical(other.hesitationsPerMinute, hesitationsPerMinute) || other.hesitationsPerMinute == hesitationsPerMinute));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sellerTalkRatio,questionCount,averageSellerTurnSeconds,longestSellerTurnSeconds,hesitationCount,questionsPerMinute,hesitationsPerMinute);

@override
String toString() {
  return 'CoachingProgressMetricsRemoteModel(sellerTalkRatio: $sellerTalkRatio, questionCount: $questionCount, averageSellerTurnSeconds: $averageSellerTurnSeconds, longestSellerTurnSeconds: $longestSellerTurnSeconds, hesitationCount: $hesitationCount, questionsPerMinute: $questionsPerMinute, hesitationsPerMinute: $hesitationsPerMinute)';
}


}

/// @nodoc
abstract mixin class _$CoachingProgressMetricsRemoteModelCopyWith<$Res> implements $CoachingProgressMetricsRemoteModelCopyWith<$Res> {
  factory _$CoachingProgressMetricsRemoteModelCopyWith(_CoachingProgressMetricsRemoteModel value, $Res Function(_CoachingProgressMetricsRemoteModel) _then) = __$CoachingProgressMetricsRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 CoachingProgressMetricRemoteModel sellerTalkRatio, CoachingProgressMetricRemoteModel questionCount, CoachingProgressMetricRemoteModel averageSellerTurnSeconds, CoachingProgressMetricRemoteModel longestSellerTurnSeconds, CoachingProgressMetricRemoteModel hesitationCount, CoachingProgressMetricRemoteModel questionsPerMinute, CoachingProgressMetricRemoteModel hesitationsPerMinute
});


@override $CoachingProgressMetricRemoteModelCopyWith<$Res> get sellerTalkRatio;@override $CoachingProgressMetricRemoteModelCopyWith<$Res> get questionCount;@override $CoachingProgressMetricRemoteModelCopyWith<$Res> get averageSellerTurnSeconds;@override $CoachingProgressMetricRemoteModelCopyWith<$Res> get longestSellerTurnSeconds;@override $CoachingProgressMetricRemoteModelCopyWith<$Res> get hesitationCount;@override $CoachingProgressMetricRemoteModelCopyWith<$Res> get questionsPerMinute;@override $CoachingProgressMetricRemoteModelCopyWith<$Res> get hesitationsPerMinute;

}
/// @nodoc
class __$CoachingProgressMetricsRemoteModelCopyWithImpl<$Res>
    implements _$CoachingProgressMetricsRemoteModelCopyWith<$Res> {
  __$CoachingProgressMetricsRemoteModelCopyWithImpl(this._self, this._then);

  final _CoachingProgressMetricsRemoteModel _self;
  final $Res Function(_CoachingProgressMetricsRemoteModel) _then;

/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sellerTalkRatio = null,Object? questionCount = null,Object? averageSellerTurnSeconds = null,Object? longestSellerTurnSeconds = null,Object? hesitationCount = null,Object? questionsPerMinute = null,Object? hesitationsPerMinute = null,}) {
  return _then(_CoachingProgressMetricsRemoteModel(
sellerTalkRatio: null == sellerTalkRatio ? _self.sellerTalkRatio : sellerTalkRatio // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,averageSellerTurnSeconds: null == averageSellerTurnSeconds ? _self.averageSellerTurnSeconds : averageSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,longestSellerTurnSeconds: null == longestSellerTurnSeconds ? _self.longestSellerTurnSeconds : longestSellerTurnSeconds // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,hesitationCount: null == hesitationCount ? _self.hesitationCount : hesitationCount // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,questionsPerMinute: null == questionsPerMinute ? _self.questionsPerMinute : questionsPerMinute // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,hesitationsPerMinute: null == hesitationsPerMinute ? _self.hesitationsPerMinute : hesitationsPerMinute // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricRemoteModel,
  ));
}

/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get sellerTalkRatio {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.sellerTalkRatio, (value) {
    return _then(_self.copyWith(sellerTalkRatio: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get questionCount {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.questionCount, (value) {
    return _then(_self.copyWith(questionCount: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get averageSellerTurnSeconds {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.averageSellerTurnSeconds, (value) {
    return _then(_self.copyWith(averageSellerTurnSeconds: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get longestSellerTurnSeconds {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.longestSellerTurnSeconds, (value) {
    return _then(_self.copyWith(longestSellerTurnSeconds: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get hesitationCount {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.hesitationCount, (value) {
    return _then(_self.copyWith(hesitationCount: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get questionsPerMinute {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.questionsPerMinute, (value) {
    return _then(_self.copyWith(questionsPerMinute: value));
  });
}/// Create a copy of CoachingProgressMetricsRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricRemoteModelCopyWith<$Res> get hesitationsPerMinute {

  return $CoachingProgressMetricRemoteModelCopyWith<$Res>(_self.hesitationsPerMinute, (value) {
    return _then(_self.copyWith(hesitationsPerMinute: value));
  });
}
}


/// @nodoc
mixin _$CoachingProgressAxisRemoteModel {

 String get axis; int get currentScore; int? get previousScore; int? get delta; String get signal; String get observation; int get sampleCount;
/// Create a copy of CoachingProgressAxisRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingProgressAxisRemoteModelCopyWith<CoachingProgressAxisRemoteModel> get copyWith => _$CoachingProgressAxisRemoteModelCopyWithImpl<CoachingProgressAxisRemoteModel>(this as CoachingProgressAxisRemoteModel, _$identity);

  /// Serializes this CoachingProgressAxisRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingProgressAxisRemoteModel&&(identical(other.axis, axis) || other.axis == axis)&&(identical(other.currentScore, currentScore) || other.currentScore == currentScore)&&(identical(other.previousScore, previousScore) || other.previousScore == previousScore)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.signal, signal) || other.signal == signal)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,axis,currentScore,previousScore,delta,signal,observation,sampleCount);

@override
String toString() {
  return 'CoachingProgressAxisRemoteModel(axis: $axis, currentScore: $currentScore, previousScore: $previousScore, delta: $delta, signal: $signal, observation: $observation, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class $CoachingProgressAxisRemoteModelCopyWith<$Res>  {
  factory $CoachingProgressAxisRemoteModelCopyWith(CoachingProgressAxisRemoteModel value, $Res Function(CoachingProgressAxisRemoteModel) _then) = _$CoachingProgressAxisRemoteModelCopyWithImpl;
@useResult
$Res call({
 String axis, int currentScore, int? previousScore, int? delta, String signal, String observation, int sampleCount
});




}
/// @nodoc
class _$CoachingProgressAxisRemoteModelCopyWithImpl<$Res>
    implements $CoachingProgressAxisRemoteModelCopyWith<$Res> {
  _$CoachingProgressAxisRemoteModelCopyWithImpl(this._self, this._then);

  final CoachingProgressAxisRemoteModel _self;
  final $Res Function(CoachingProgressAxisRemoteModel) _then;

/// Create a copy of CoachingProgressAxisRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? axis = null,Object? currentScore = null,Object? previousScore = freezed,Object? delta = freezed,Object? signal = null,Object? observation = null,Object? sampleCount = null,}) {
  return _then(_self.copyWith(
axis: null == axis ? _self.axis : axis // ignore: cast_nullable_to_non_nullable
as String,currentScore: null == currentScore ? _self.currentScore : currentScore // ignore: cast_nullable_to_non_nullable
as int,previousScore: freezed == previousScore ? _self.previousScore : previousScore // ignore: cast_nullable_to_non_nullable
as int?,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int?,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as String,observation: null == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CoachingProgressAxisRemoteModel].
extension CoachingProgressAxisRemoteModelPatterns on CoachingProgressAxisRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingProgressAxisRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingProgressAxisRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingProgressAxisRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressAxisRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingProgressAxisRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressAxisRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String axis,  int currentScore,  int? previousScore,  int? delta,  String signal,  String observation,  int sampleCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingProgressAxisRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String axis,  int currentScore,  int? previousScore,  int? delta,  String signal,  String observation,  int sampleCount)  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressAxisRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String axis,  int currentScore,  int? previousScore,  int? delta,  String signal,  String observation,  int sampleCount)?  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressAxisRemoteModel() when $default != null:
return $default(_that.axis,_that.currentScore,_that.previousScore,_that.delta,_that.signal,_that.observation,_that.sampleCount);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CoachingProgressAxisRemoteModel implements CoachingProgressAxisRemoteModel {
  const _CoachingProgressAxisRemoteModel({required this.axis, required this.currentScore, required this.previousScore, required this.delta, required this.signal, required this.observation, required this.sampleCount});
  factory _CoachingProgressAxisRemoteModel.fromJson(Map<String, dynamic> json) => _$CoachingProgressAxisRemoteModelFromJson(json);

@override final  String axis;
@override final  int currentScore;
@override final  int? previousScore;
@override final  int? delta;
@override final  String signal;
@override final  String observation;
@override final  int sampleCount;

/// Create a copy of CoachingProgressAxisRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingProgressAxisRemoteModelCopyWith<_CoachingProgressAxisRemoteModel> get copyWith => __$CoachingProgressAxisRemoteModelCopyWithImpl<_CoachingProgressAxisRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachingProgressAxisRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingProgressAxisRemoteModel&&(identical(other.axis, axis) || other.axis == axis)&&(identical(other.currentScore, currentScore) || other.currentScore == currentScore)&&(identical(other.previousScore, previousScore) || other.previousScore == previousScore)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.signal, signal) || other.signal == signal)&&(identical(other.observation, observation) || other.observation == observation)&&(identical(other.sampleCount, sampleCount) || other.sampleCount == sampleCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,axis,currentScore,previousScore,delta,signal,observation,sampleCount);

@override
String toString() {
  return 'CoachingProgressAxisRemoteModel(axis: $axis, currentScore: $currentScore, previousScore: $previousScore, delta: $delta, signal: $signal, observation: $observation, sampleCount: $sampleCount)';
}


}

/// @nodoc
abstract mixin class _$CoachingProgressAxisRemoteModelCopyWith<$Res> implements $CoachingProgressAxisRemoteModelCopyWith<$Res> {
  factory _$CoachingProgressAxisRemoteModelCopyWith(_CoachingProgressAxisRemoteModel value, $Res Function(_CoachingProgressAxisRemoteModel) _then) = __$CoachingProgressAxisRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String axis, int currentScore, int? previousScore, int? delta, String signal, String observation, int sampleCount
});




}
/// @nodoc
class __$CoachingProgressAxisRemoteModelCopyWithImpl<$Res>
    implements _$CoachingProgressAxisRemoteModelCopyWith<$Res> {
  __$CoachingProgressAxisRemoteModelCopyWithImpl(this._self, this._then);

  final _CoachingProgressAxisRemoteModel _self;
  final $Res Function(_CoachingProgressAxisRemoteModel) _then;

/// Create a copy of CoachingProgressAxisRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? axis = null,Object? currentScore = null,Object? previousScore = freezed,Object? delta = freezed,Object? signal = null,Object? observation = null,Object? sampleCount = null,}) {
  return _then(_CoachingProgressAxisRemoteModel(
axis: null == axis ? _self.axis : axis // ignore: cast_nullable_to_non_nullable
as String,currentScore: null == currentScore ? _self.currentScore : currentScore // ignore: cast_nullable_to_non_nullable
as int,previousScore: freezed == previousScore ? _self.previousScore : previousScore // ignore: cast_nullable_to_non_nullable
as int?,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as int?,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as String,observation: null == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String,sampleCount: null == sampleCount ? _self.sampleCount : sampleCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CoachingProgressCallRemoteModel {

 String get callId; String get sessionId; DateTime get occurredAt; String get destinationNumber; List<CallPerformanceAxisRemoteModel> get performanceAxes; String? get outcome; CallObservedMetricsRemoteModel? get observedMetrics;
/// Create a copy of CoachingProgressCallRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingProgressCallRemoteModelCopyWith<CoachingProgressCallRemoteModel> get copyWith => _$CoachingProgressCallRemoteModelCopyWithImpl<CoachingProgressCallRemoteModel>(this as CoachingProgressCallRemoteModel, _$identity);

  /// Serializes this CoachingProgressCallRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingProgressCallRemoteModel&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.destinationNumber, destinationNumber) || other.destinationNumber == destinationNumber)&&const DeepCollectionEquality().equals(other.performanceAxes, performanceAxes)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.observedMetrics, observedMetrics) || other.observedMetrics == observedMetrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,sessionId,occurredAt,destinationNumber,const DeepCollectionEquality().hash(performanceAxes),outcome,observedMetrics);

@override
String toString() {
  return 'CoachingProgressCallRemoteModel(callId: $callId, sessionId: $sessionId, occurredAt: $occurredAt, destinationNumber: $destinationNumber, performanceAxes: $performanceAxes, outcome: $outcome, observedMetrics: $observedMetrics)';
}


}

/// @nodoc
abstract mixin class $CoachingProgressCallRemoteModelCopyWith<$Res>  {
  factory $CoachingProgressCallRemoteModelCopyWith(CoachingProgressCallRemoteModel value, $Res Function(CoachingProgressCallRemoteModel) _then) = _$CoachingProgressCallRemoteModelCopyWithImpl;
@useResult
$Res call({
 String callId, String sessionId, DateTime occurredAt, String destinationNumber, List<CallPerformanceAxisRemoteModel> performanceAxes, String? outcome, CallObservedMetricsRemoteModel? observedMetrics
});


$CallObservedMetricsRemoteModelCopyWith<$Res>? get observedMetrics;

}
/// @nodoc
class _$CoachingProgressCallRemoteModelCopyWithImpl<$Res>
    implements $CoachingProgressCallRemoteModelCopyWith<$Res> {
  _$CoachingProgressCallRemoteModelCopyWithImpl(this._self, this._then);

  final CoachingProgressCallRemoteModel _self;
  final $Res Function(CoachingProgressCallRemoteModel) _then;

/// Create a copy of CoachingProgressCallRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? sessionId = null,Object? occurredAt = null,Object? destinationNumber = null,Object? performanceAxes = null,Object? outcome = freezed,Object? observedMetrics = freezed,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,destinationNumber: null == destinationNumber ? _self.destinationNumber : destinationNumber // ignore: cast_nullable_to_non_nullable
as String,performanceAxes: null == performanceAxes ? _self.performanceAxes : performanceAxes // ignore: cast_nullable_to_non_nullable
as List<CallPerformanceAxisRemoteModel>,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,observedMetrics: freezed == observedMetrics ? _self.observedMetrics : observedMetrics // ignore: cast_nullable_to_non_nullable
as CallObservedMetricsRemoteModel?,
  ));
}
/// Create a copy of CoachingProgressCallRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallObservedMetricsRemoteModelCopyWith<$Res>? get observedMetrics {
    if (_self.observedMetrics == null) {
    return null;
  }

  return $CallObservedMetricsRemoteModelCopyWith<$Res>(_self.observedMetrics!, (value) {
    return _then(_self.copyWith(observedMetrics: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoachingProgressCallRemoteModel].
extension CoachingProgressCallRemoteModelPatterns on CoachingProgressCallRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingProgressCallRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingProgressCallRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingProgressCallRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressCallRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingProgressCallRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressCallRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String sessionId,  DateTime occurredAt,  String destinationNumber,  List<CallPerformanceAxisRemoteModel> performanceAxes,  String? outcome,  CallObservedMetricsRemoteModel? observedMetrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingProgressCallRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String sessionId,  DateTime occurredAt,  String destinationNumber,  List<CallPerformanceAxisRemoteModel> performanceAxes,  String? outcome,  CallObservedMetricsRemoteModel? observedMetrics)  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressCallRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String sessionId,  DateTime occurredAt,  String destinationNumber,  List<CallPerformanceAxisRemoteModel> performanceAxes,  String? outcome,  CallObservedMetricsRemoteModel? observedMetrics)?  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressCallRemoteModel() when $default != null:
return $default(_that.callId,_that.sessionId,_that.occurredAt,_that.destinationNumber,_that.performanceAxes,_that.outcome,_that.observedMetrics);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _CoachingProgressCallRemoteModel implements CoachingProgressCallRemoteModel {
  const _CoachingProgressCallRemoteModel({required this.callId, required this.sessionId, required this.occurredAt, required this.destinationNumber, required final  List<CallPerformanceAxisRemoteModel> performanceAxes, this.outcome, this.observedMetrics}): _performanceAxes = performanceAxes;
  factory _CoachingProgressCallRemoteModel.fromJson(Map<String, dynamic> json) => _$CoachingProgressCallRemoteModelFromJson(json);

@override final  String callId;
@override final  String sessionId;
@override final  DateTime occurredAt;
@override final  String destinationNumber;
 final  List<CallPerformanceAxisRemoteModel> _performanceAxes;
@override List<CallPerformanceAxisRemoteModel> get performanceAxes {
  if (_performanceAxes is EqualUnmodifiableListView) return _performanceAxes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_performanceAxes);
}

@override final  String? outcome;
@override final  CallObservedMetricsRemoteModel? observedMetrics;

/// Create a copy of CoachingProgressCallRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingProgressCallRemoteModelCopyWith<_CoachingProgressCallRemoteModel> get copyWith => __$CoachingProgressCallRemoteModelCopyWithImpl<_CoachingProgressCallRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachingProgressCallRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingProgressCallRemoteModel&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.destinationNumber, destinationNumber) || other.destinationNumber == destinationNumber)&&const DeepCollectionEquality().equals(other._performanceAxes, _performanceAxes)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.observedMetrics, observedMetrics) || other.observedMetrics == observedMetrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,sessionId,occurredAt,destinationNumber,const DeepCollectionEquality().hash(_performanceAxes),outcome,observedMetrics);

@override
String toString() {
  return 'CoachingProgressCallRemoteModel(callId: $callId, sessionId: $sessionId, occurredAt: $occurredAt, destinationNumber: $destinationNumber, performanceAxes: $performanceAxes, outcome: $outcome, observedMetrics: $observedMetrics)';
}


}

/// @nodoc
abstract mixin class _$CoachingProgressCallRemoteModelCopyWith<$Res> implements $CoachingProgressCallRemoteModelCopyWith<$Res> {
  factory _$CoachingProgressCallRemoteModelCopyWith(_CoachingProgressCallRemoteModel value, $Res Function(_CoachingProgressCallRemoteModel) _then) = __$CoachingProgressCallRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String callId, String sessionId, DateTime occurredAt, String destinationNumber, List<CallPerformanceAxisRemoteModel> performanceAxes, String? outcome, CallObservedMetricsRemoteModel? observedMetrics
});


@override $CallObservedMetricsRemoteModelCopyWith<$Res>? get observedMetrics;

}
/// @nodoc
class __$CoachingProgressCallRemoteModelCopyWithImpl<$Res>
    implements _$CoachingProgressCallRemoteModelCopyWith<$Res> {
  __$CoachingProgressCallRemoteModelCopyWithImpl(this._self, this._then);

  final _CoachingProgressCallRemoteModel _self;
  final $Res Function(_CoachingProgressCallRemoteModel) _then;

/// Create a copy of CoachingProgressCallRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? sessionId = null,Object? occurredAt = null,Object? destinationNumber = null,Object? performanceAxes = null,Object? outcome = freezed,Object? observedMetrics = freezed,}) {
  return _then(_CoachingProgressCallRemoteModel(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,destinationNumber: null == destinationNumber ? _self.destinationNumber : destinationNumber // ignore: cast_nullable_to_non_nullable
as String,performanceAxes: null == performanceAxes ? _self._performanceAxes : performanceAxes // ignore: cast_nullable_to_non_nullable
as List<CallPerformanceAxisRemoteModel>,outcome: freezed == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String?,observedMetrics: freezed == observedMetrics ? _self.observedMetrics : observedMetrics // ignore: cast_nullable_to_non_nullable
as CallObservedMetricsRemoteModel?,
  ));
}

/// Create a copy of CoachingProgressCallRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallObservedMetricsRemoteModelCopyWith<$Res>? get observedMetrics {
    if (_self.observedMetrics == null) {
    return null;
  }

  return $CallObservedMetricsRemoteModelCopyWith<$Res>(_self.observedMetrics!, (value) {
    return _then(_self.copyWith(observedMetrics: value));
  });
}
}


/// @nodoc
mixin _$CoachingProgressRemoteModel {

 DateTime get generatedAt; int get sessionCount; int get analyzedCallCount; int get currentWindowSize; int get previousWindowSize; bool get hasComparison; String get rubricVersion; List<CoachingProgressAxisRemoteModel> get axes; CoachingProgressMetricsRemoteModel get observedMetrics; List<CoachingProgressCallRemoteModel> get recentCalls; CoachingProgressAxisRemoteModel? get focus; CoachingProgressAxisRemoteModel? get strength;
/// Create a copy of CoachingProgressRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CoachingProgressRemoteModelCopyWith<CoachingProgressRemoteModel> get copyWith => _$CoachingProgressRemoteModelCopyWithImpl<CoachingProgressRemoteModel>(this as CoachingProgressRemoteModel, _$identity);

  /// Serializes this CoachingProgressRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CoachingProgressRemoteModel&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.analyzedCallCount, analyzedCallCount) || other.analyzedCallCount == analyzedCallCount)&&(identical(other.currentWindowSize, currentWindowSize) || other.currentWindowSize == currentWindowSize)&&(identical(other.previousWindowSize, previousWindowSize) || other.previousWindowSize == previousWindowSize)&&(identical(other.hasComparison, hasComparison) || other.hasComparison == hasComparison)&&(identical(other.rubricVersion, rubricVersion) || other.rubricVersion == rubricVersion)&&const DeepCollectionEquality().equals(other.axes, axes)&&(identical(other.observedMetrics, observedMetrics) || other.observedMetrics == observedMetrics)&&const DeepCollectionEquality().equals(other.recentCalls, recentCalls)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.strength, strength) || other.strength == strength));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAt,sessionCount,analyzedCallCount,currentWindowSize,previousWindowSize,hasComparison,rubricVersion,const DeepCollectionEquality().hash(axes),observedMetrics,const DeepCollectionEquality().hash(recentCalls),focus,strength);

@override
String toString() {
  return 'CoachingProgressRemoteModel(generatedAt: $generatedAt, sessionCount: $sessionCount, analyzedCallCount: $analyzedCallCount, currentWindowSize: $currentWindowSize, previousWindowSize: $previousWindowSize, hasComparison: $hasComparison, rubricVersion: $rubricVersion, axes: $axes, observedMetrics: $observedMetrics, recentCalls: $recentCalls, focus: $focus, strength: $strength)';
}


}

/// @nodoc
abstract mixin class $CoachingProgressRemoteModelCopyWith<$Res>  {
  factory $CoachingProgressRemoteModelCopyWith(CoachingProgressRemoteModel value, $Res Function(CoachingProgressRemoteModel) _then) = _$CoachingProgressRemoteModelCopyWithImpl;
@useResult
$Res call({
 DateTime generatedAt, int sessionCount, int analyzedCallCount, int currentWindowSize, int previousWindowSize, bool hasComparison, String rubricVersion, List<CoachingProgressAxisRemoteModel> axes, CoachingProgressMetricsRemoteModel observedMetrics, List<CoachingProgressCallRemoteModel> recentCalls, CoachingProgressAxisRemoteModel? focus, CoachingProgressAxisRemoteModel? strength
});


$CoachingProgressMetricsRemoteModelCopyWith<$Res> get observedMetrics;$CoachingProgressAxisRemoteModelCopyWith<$Res>? get focus;$CoachingProgressAxisRemoteModelCopyWith<$Res>? get strength;

}
/// @nodoc
class _$CoachingProgressRemoteModelCopyWithImpl<$Res>
    implements $CoachingProgressRemoteModelCopyWith<$Res> {
  _$CoachingProgressRemoteModelCopyWithImpl(this._self, this._then);

  final CoachingProgressRemoteModel _self;
  final $Res Function(CoachingProgressRemoteModel) _then;

/// Create a copy of CoachingProgressRemoteModel
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
as List<CoachingProgressAxisRemoteModel>,observedMetrics: null == observedMetrics ? _self.observedMetrics : observedMetrics // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricsRemoteModel,recentCalls: null == recentCalls ? _self.recentCalls : recentCalls // ignore: cast_nullable_to_non_nullable
as List<CoachingProgressCallRemoteModel>,focus: freezed == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as CoachingProgressAxisRemoteModel?,strength: freezed == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as CoachingProgressAxisRemoteModel?,
  ));
}
/// Create a copy of CoachingProgressRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricsRemoteModelCopyWith<$Res> get observedMetrics {

  return $CoachingProgressMetricsRemoteModelCopyWith<$Res>(_self.observedMetrics, (value) {
    return _then(_self.copyWith(observedMetrics: value));
  });
}/// Create a copy of CoachingProgressRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressAxisRemoteModelCopyWith<$Res>? get focus {
    if (_self.focus == null) {
    return null;
  }

  return $CoachingProgressAxisRemoteModelCopyWith<$Res>(_self.focus!, (value) {
    return _then(_self.copyWith(focus: value));
  });
}/// Create a copy of CoachingProgressRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressAxisRemoteModelCopyWith<$Res>? get strength {
    if (_self.strength == null) {
    return null;
  }

  return $CoachingProgressAxisRemoteModelCopyWith<$Res>(_self.strength!, (value) {
    return _then(_self.copyWith(strength: value));
  });
}
}


/// Adds pattern-matching-related methods to [CoachingProgressRemoteModel].
extension CoachingProgressRemoteModelPatterns on CoachingProgressRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CoachingProgressRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CoachingProgressRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CoachingProgressRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CoachingProgressRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CoachingProgressRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime generatedAt,  int sessionCount,  int analyzedCallCount,  int currentWindowSize,  int previousWindowSize,  bool hasComparison,  String rubricVersion,  List<CoachingProgressAxisRemoteModel> axes,  CoachingProgressMetricsRemoteModel observedMetrics,  List<CoachingProgressCallRemoteModel> recentCalls,  CoachingProgressAxisRemoteModel? focus,  CoachingProgressAxisRemoteModel? strength)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CoachingProgressRemoteModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime generatedAt,  int sessionCount,  int analyzedCallCount,  int currentWindowSize,  int previousWindowSize,  bool hasComparison,  String rubricVersion,  List<CoachingProgressAxisRemoteModel> axes,  CoachingProgressMetricsRemoteModel observedMetrics,  List<CoachingProgressCallRemoteModel> recentCalls,  CoachingProgressAxisRemoteModel? focus,  CoachingProgressAxisRemoteModel? strength)  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressRemoteModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime generatedAt,  int sessionCount,  int analyzedCallCount,  int currentWindowSize,  int previousWindowSize,  bool hasComparison,  String rubricVersion,  List<CoachingProgressAxisRemoteModel> axes,  CoachingProgressMetricsRemoteModel observedMetrics,  List<CoachingProgressCallRemoteModel> recentCalls,  CoachingProgressAxisRemoteModel? focus,  CoachingProgressAxisRemoteModel? strength)?  $default,) {final _that = this;
switch (_that) {
case _CoachingProgressRemoteModel() when $default != null:
return $default(_that.generatedAt,_that.sessionCount,_that.analyzedCallCount,_that.currentWindowSize,_that.previousWindowSize,_that.hasComparison,_that.rubricVersion,_that.axes,_that.observedMetrics,_that.recentCalls,_that.focus,_that.strength);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _CoachingProgressRemoteModel implements CoachingProgressRemoteModel {
  const _CoachingProgressRemoteModel({required this.generatedAt, required this.sessionCount, required this.analyzedCallCount, required this.currentWindowSize, required this.previousWindowSize, required this.hasComparison, required this.rubricVersion, required final  List<CoachingProgressAxisRemoteModel> axes, required this.observedMetrics, required final  List<CoachingProgressCallRemoteModel> recentCalls, this.focus, this.strength}): _axes = axes,_recentCalls = recentCalls;
  factory _CoachingProgressRemoteModel.fromJson(Map<String, dynamic> json) => _$CoachingProgressRemoteModelFromJson(json);

@override final  DateTime generatedAt;
@override final  int sessionCount;
@override final  int analyzedCallCount;
@override final  int currentWindowSize;
@override final  int previousWindowSize;
@override final  bool hasComparison;
@override final  String rubricVersion;
 final  List<CoachingProgressAxisRemoteModel> _axes;
@override List<CoachingProgressAxisRemoteModel> get axes {
  if (_axes is EqualUnmodifiableListView) return _axes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_axes);
}

@override final  CoachingProgressMetricsRemoteModel observedMetrics;
 final  List<CoachingProgressCallRemoteModel> _recentCalls;
@override List<CoachingProgressCallRemoteModel> get recentCalls {
  if (_recentCalls is EqualUnmodifiableListView) return _recentCalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentCalls);
}

@override final  CoachingProgressAxisRemoteModel? focus;
@override final  CoachingProgressAxisRemoteModel? strength;

/// Create a copy of CoachingProgressRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CoachingProgressRemoteModelCopyWith<_CoachingProgressRemoteModel> get copyWith => __$CoachingProgressRemoteModelCopyWithImpl<_CoachingProgressRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CoachingProgressRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CoachingProgressRemoteModel&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.sessionCount, sessionCount) || other.sessionCount == sessionCount)&&(identical(other.analyzedCallCount, analyzedCallCount) || other.analyzedCallCount == analyzedCallCount)&&(identical(other.currentWindowSize, currentWindowSize) || other.currentWindowSize == currentWindowSize)&&(identical(other.previousWindowSize, previousWindowSize) || other.previousWindowSize == previousWindowSize)&&(identical(other.hasComparison, hasComparison) || other.hasComparison == hasComparison)&&(identical(other.rubricVersion, rubricVersion) || other.rubricVersion == rubricVersion)&&const DeepCollectionEquality().equals(other._axes, _axes)&&(identical(other.observedMetrics, observedMetrics) || other.observedMetrics == observedMetrics)&&const DeepCollectionEquality().equals(other._recentCalls, _recentCalls)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.strength, strength) || other.strength == strength));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatedAt,sessionCount,analyzedCallCount,currentWindowSize,previousWindowSize,hasComparison,rubricVersion,const DeepCollectionEquality().hash(_axes),observedMetrics,const DeepCollectionEquality().hash(_recentCalls),focus,strength);

@override
String toString() {
  return 'CoachingProgressRemoteModel(generatedAt: $generatedAt, sessionCount: $sessionCount, analyzedCallCount: $analyzedCallCount, currentWindowSize: $currentWindowSize, previousWindowSize: $previousWindowSize, hasComparison: $hasComparison, rubricVersion: $rubricVersion, axes: $axes, observedMetrics: $observedMetrics, recentCalls: $recentCalls, focus: $focus, strength: $strength)';
}


}

/// @nodoc
abstract mixin class _$CoachingProgressRemoteModelCopyWith<$Res> implements $CoachingProgressRemoteModelCopyWith<$Res> {
  factory _$CoachingProgressRemoteModelCopyWith(_CoachingProgressRemoteModel value, $Res Function(_CoachingProgressRemoteModel) _then) = __$CoachingProgressRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 DateTime generatedAt, int sessionCount, int analyzedCallCount, int currentWindowSize, int previousWindowSize, bool hasComparison, String rubricVersion, List<CoachingProgressAxisRemoteModel> axes, CoachingProgressMetricsRemoteModel observedMetrics, List<CoachingProgressCallRemoteModel> recentCalls, CoachingProgressAxisRemoteModel? focus, CoachingProgressAxisRemoteModel? strength
});


@override $CoachingProgressMetricsRemoteModelCopyWith<$Res> get observedMetrics;@override $CoachingProgressAxisRemoteModelCopyWith<$Res>? get focus;@override $CoachingProgressAxisRemoteModelCopyWith<$Res>? get strength;

}
/// @nodoc
class __$CoachingProgressRemoteModelCopyWithImpl<$Res>
    implements _$CoachingProgressRemoteModelCopyWith<$Res> {
  __$CoachingProgressRemoteModelCopyWithImpl(this._self, this._then);

  final _CoachingProgressRemoteModel _self;
  final $Res Function(_CoachingProgressRemoteModel) _then;

/// Create a copy of CoachingProgressRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatedAt = null,Object? sessionCount = null,Object? analyzedCallCount = null,Object? currentWindowSize = null,Object? previousWindowSize = null,Object? hasComparison = null,Object? rubricVersion = null,Object? axes = null,Object? observedMetrics = null,Object? recentCalls = null,Object? focus = freezed,Object? strength = freezed,}) {
  return _then(_CoachingProgressRemoteModel(
generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,sessionCount: null == sessionCount ? _self.sessionCount : sessionCount // ignore: cast_nullable_to_non_nullable
as int,analyzedCallCount: null == analyzedCallCount ? _self.analyzedCallCount : analyzedCallCount // ignore: cast_nullable_to_non_nullable
as int,currentWindowSize: null == currentWindowSize ? _self.currentWindowSize : currentWindowSize // ignore: cast_nullable_to_non_nullable
as int,previousWindowSize: null == previousWindowSize ? _self.previousWindowSize : previousWindowSize // ignore: cast_nullable_to_non_nullable
as int,hasComparison: null == hasComparison ? _self.hasComparison : hasComparison // ignore: cast_nullable_to_non_nullable
as bool,rubricVersion: null == rubricVersion ? _self.rubricVersion : rubricVersion // ignore: cast_nullable_to_non_nullable
as String,axes: null == axes ? _self._axes : axes // ignore: cast_nullable_to_non_nullable
as List<CoachingProgressAxisRemoteModel>,observedMetrics: null == observedMetrics ? _self.observedMetrics : observedMetrics // ignore: cast_nullable_to_non_nullable
as CoachingProgressMetricsRemoteModel,recentCalls: null == recentCalls ? _self._recentCalls : recentCalls // ignore: cast_nullable_to_non_nullable
as List<CoachingProgressCallRemoteModel>,focus: freezed == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as CoachingProgressAxisRemoteModel?,strength: freezed == strength ? _self.strength : strength // ignore: cast_nullable_to_non_nullable
as CoachingProgressAxisRemoteModel?,
  ));
}

/// Create a copy of CoachingProgressRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressMetricsRemoteModelCopyWith<$Res> get observedMetrics {

  return $CoachingProgressMetricsRemoteModelCopyWith<$Res>(_self.observedMetrics, (value) {
    return _then(_self.copyWith(observedMetrics: value));
  });
}/// Create a copy of CoachingProgressRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressAxisRemoteModelCopyWith<$Res>? get focus {
    if (_self.focus == null) {
    return null;
  }

  return $CoachingProgressAxisRemoteModelCopyWith<$Res>(_self.focus!, (value) {
    return _then(_self.copyWith(focus: value));
  });
}/// Create a copy of CoachingProgressRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CoachingProgressAxisRemoteModelCopyWith<$Res>? get strength {
    if (_self.strength == null) {
    return null;
  }

  return $CoachingProgressAxisRemoteModelCopyWith<$Res>(_self.strength!, (value) {
    return _then(_self.copyWith(strength: value));
  });
}
}

// dart format on
