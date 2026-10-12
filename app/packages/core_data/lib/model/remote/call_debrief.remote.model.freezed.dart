// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_debrief.remote.model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroundedCallTextRemoteModel {

 String get text; List<String> get evidenceSegmentIds;
/// Create a copy of GroundedCallTextRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroundedCallTextRemoteModelCopyWith<GroundedCallTextRemoteModel> get copyWith => _$GroundedCallTextRemoteModelCopyWithImpl<GroundedCallTextRemoteModel>(this as GroundedCallTextRemoteModel, _$identity);

  /// Serializes this GroundedCallTextRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroundedCallTextRemoteModel&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(evidenceSegmentIds));

@override
String toString() {
  return 'GroundedCallTextRemoteModel(text: $text, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class $GroundedCallTextRemoteModelCopyWith<$Res>  {
  factory $GroundedCallTextRemoteModelCopyWith(GroundedCallTextRemoteModel value, $Res Function(GroundedCallTextRemoteModel) _then) = _$GroundedCallTextRemoteModelCopyWithImpl;
@useResult
$Res call({
 String text, List<String> evidenceSegmentIds
});




}
/// @nodoc
class _$GroundedCallTextRemoteModelCopyWithImpl<$Res>
    implements $GroundedCallTextRemoteModelCopyWith<$Res> {
  _$GroundedCallTextRemoteModelCopyWithImpl(this._self, this._then);

  final GroundedCallTextRemoteModel _self;
  final $Res Function(GroundedCallTextRemoteModel) _then;

/// Create a copy of GroundedCallTextRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? evidenceSegmentIds = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [GroundedCallTextRemoteModel].
extension GroundedCallTextRemoteModelPatterns on GroundedCallTextRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroundedCallTextRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroundedCallTextRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroundedCallTextRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _GroundedCallTextRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroundedCallTextRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _GroundedCallTextRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  List<String> evidenceSegmentIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GroundedCallTextRemoteModel() when $default != null:
return $default(_that.text,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  List<String> evidenceSegmentIds)  $default,) {final _that = this;
switch (_that) {
case _GroundedCallTextRemoteModel():
return $default(_that.text,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  List<String> evidenceSegmentIds)?  $default,) {final _that = this;
switch (_that) {
case _GroundedCallTextRemoteModel() when $default != null:
return $default(_that.text,_that.evidenceSegmentIds);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _GroundedCallTextRemoteModel implements GroundedCallTextRemoteModel {
  const _GroundedCallTextRemoteModel({required this.text, required final  List<String> evidenceSegmentIds}): _evidenceSegmentIds = evidenceSegmentIds;
  factory _GroundedCallTextRemoteModel.fromJson(Map<String, dynamic> json) => _$GroundedCallTextRemoteModelFromJson(json);

@override final  String text;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}


/// Create a copy of GroundedCallTextRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroundedCallTextRemoteModelCopyWith<_GroundedCallTextRemoteModel> get copyWith => __$GroundedCallTextRemoteModelCopyWithImpl<_GroundedCallTextRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GroundedCallTextRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroundedCallTextRemoteModel&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_evidenceSegmentIds));

@override
String toString() {
  return 'GroundedCallTextRemoteModel(text: $text, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class _$GroundedCallTextRemoteModelCopyWith<$Res> implements $GroundedCallTextRemoteModelCopyWith<$Res> {
  factory _$GroundedCallTextRemoteModelCopyWith(_GroundedCallTextRemoteModel value, $Res Function(_GroundedCallTextRemoteModel) _then) = __$GroundedCallTextRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String text, List<String> evidenceSegmentIds
});




}
/// @nodoc
class __$GroundedCallTextRemoteModelCopyWithImpl<$Res>
    implements _$GroundedCallTextRemoteModelCopyWith<$Res> {
  __$GroundedCallTextRemoteModelCopyWithImpl(this._self, this._then);

  final _GroundedCallTextRemoteModel _self;
  final $Res Function(_GroundedCallTextRemoteModel) _then;

/// Create a copy of GroundedCallTextRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? evidenceSegmentIds = null,}) {
  return _then(_GroundedCallTextRemoteModel(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$CallCommitmentRemoteModel {

 String get owner; String get text; List<String> get evidenceSegmentIds; DateTime? get dueAt;
/// Create a copy of CallCommitmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallCommitmentRemoteModelCopyWith<CallCommitmentRemoteModel> get copyWith => _$CallCommitmentRemoteModelCopyWithImpl<CallCommitmentRemoteModel>(this as CallCommitmentRemoteModel, _$identity);

  /// Serializes this CallCommitmentRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallCommitmentRemoteModel&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,owner,text,const DeepCollectionEquality().hash(evidenceSegmentIds),dueAt);

@override
String toString() {
  return 'CallCommitmentRemoteModel(owner: $owner, text: $text, evidenceSegmentIds: $evidenceSegmentIds, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class $CallCommitmentRemoteModelCopyWith<$Res>  {
  factory $CallCommitmentRemoteModelCopyWith(CallCommitmentRemoteModel value, $Res Function(CallCommitmentRemoteModel) _then) = _$CallCommitmentRemoteModelCopyWithImpl;
@useResult
$Res call({
 String owner, String text, List<String> evidenceSegmentIds, DateTime? dueAt
});




}
/// @nodoc
class _$CallCommitmentRemoteModelCopyWithImpl<$Res>
    implements $CallCommitmentRemoteModelCopyWith<$Res> {
  _$CallCommitmentRemoteModelCopyWithImpl(this._self, this._then);

  final CallCommitmentRemoteModel _self;
  final $Res Function(CallCommitmentRemoteModel) _then;

/// Create a copy of CallCommitmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? owner = null,Object? text = null,Object? evidenceSegmentIds = null,Object? dueAt = freezed,}) {
  return _then(_self.copyWith(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallCommitmentRemoteModel].
extension CallCommitmentRemoteModelPatterns on CallCommitmentRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallCommitmentRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallCommitmentRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallCommitmentRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CallCommitmentRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallCommitmentRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CallCommitmentRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String owner,  String text,  List<String> evidenceSegmentIds,  DateTime? dueAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallCommitmentRemoteModel() when $default != null:
return $default(_that.owner,_that.text,_that.evidenceSegmentIds,_that.dueAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String owner,  String text,  List<String> evidenceSegmentIds,  DateTime? dueAt)  $default,) {final _that = this;
switch (_that) {
case _CallCommitmentRemoteModel():
return $default(_that.owner,_that.text,_that.evidenceSegmentIds,_that.dueAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String owner,  String text,  List<String> evidenceSegmentIds,  DateTime? dueAt)?  $default,) {final _that = this;
switch (_that) {
case _CallCommitmentRemoteModel() when $default != null:
return $default(_that.owner,_that.text,_that.evidenceSegmentIds,_that.dueAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CallCommitmentRemoteModel implements CallCommitmentRemoteModel {
  const _CallCommitmentRemoteModel({required this.owner, required this.text, required final  List<String> evidenceSegmentIds, this.dueAt}): _evidenceSegmentIds = evidenceSegmentIds;
  factory _CallCommitmentRemoteModel.fromJson(Map<String, dynamic> json) => _$CallCommitmentRemoteModelFromJson(json);

@override final  String owner;
@override final  String text;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}

@override final  DateTime? dueAt;

/// Create a copy of CallCommitmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallCommitmentRemoteModelCopyWith<_CallCommitmentRemoteModel> get copyWith => __$CallCommitmentRemoteModelCopyWithImpl<_CallCommitmentRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallCommitmentRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallCommitmentRemoteModel&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,owner,text,const DeepCollectionEquality().hash(_evidenceSegmentIds),dueAt);

@override
String toString() {
  return 'CallCommitmentRemoteModel(owner: $owner, text: $text, evidenceSegmentIds: $evidenceSegmentIds, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class _$CallCommitmentRemoteModelCopyWith<$Res> implements $CallCommitmentRemoteModelCopyWith<$Res> {
  factory _$CallCommitmentRemoteModelCopyWith(_CallCommitmentRemoteModel value, $Res Function(_CallCommitmentRemoteModel) _then) = __$CallCommitmentRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String owner, String text, List<String> evidenceSegmentIds, DateTime? dueAt
});




}
/// @nodoc
class __$CallCommitmentRemoteModelCopyWithImpl<$Res>
    implements _$CallCommitmentRemoteModelCopyWith<$Res> {
  __$CallCommitmentRemoteModelCopyWithImpl(this._self, this._then);

  final _CallCommitmentRemoteModel _self;
  final $Res Function(_CallCommitmentRemoteModel) _then;

/// Create a copy of CallCommitmentRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? owner = null,Object? text = null,Object? evidenceSegmentIds = null,Object? dueAt = freezed,}) {
  return _then(_CallCommitmentRemoteModel(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CallFollowUpRemoteModel {

 String get subject; String get body; List<String> get evidenceSegmentIds; String? get nextAction; DateTime? get dueAt;
/// Create a copy of CallFollowUpRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallFollowUpRemoteModelCopyWith<CallFollowUpRemoteModel> get copyWith => _$CallFollowUpRemoteModelCopyWithImpl<CallFollowUpRemoteModel>(this as CallFollowUpRemoteModel, _$identity);

  /// Serializes this CallFollowUpRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallFollowUpRemoteModel&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds)&&(identical(other.nextAction, nextAction) || other.nextAction == nextAction)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,body,const DeepCollectionEquality().hash(evidenceSegmentIds),nextAction,dueAt);

@override
String toString() {
  return 'CallFollowUpRemoteModel(subject: $subject, body: $body, evidenceSegmentIds: $evidenceSegmentIds, nextAction: $nextAction, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class $CallFollowUpRemoteModelCopyWith<$Res>  {
  factory $CallFollowUpRemoteModelCopyWith(CallFollowUpRemoteModel value, $Res Function(CallFollowUpRemoteModel) _then) = _$CallFollowUpRemoteModelCopyWithImpl;
@useResult
$Res call({
 String subject, String body, List<String> evidenceSegmentIds, String? nextAction, DateTime? dueAt
});




}
/// @nodoc
class _$CallFollowUpRemoteModelCopyWithImpl<$Res>
    implements $CallFollowUpRemoteModelCopyWith<$Res> {
  _$CallFollowUpRemoteModelCopyWithImpl(this._self, this._then);

  final CallFollowUpRemoteModel _self;
  final $Res Function(CallFollowUpRemoteModel) _then;

/// Create a copy of CallFollowUpRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subject = null,Object? body = null,Object? evidenceSegmentIds = null,Object? nextAction = freezed,Object? dueAt = freezed,}) {
  return _then(_self.copyWith(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,nextAction: freezed == nextAction ? _self.nextAction : nextAction // ignore: cast_nullable_to_non_nullable
as String?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallFollowUpRemoteModel].
extension CallFollowUpRemoteModelPatterns on CallFollowUpRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallFollowUpRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallFollowUpRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallFollowUpRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CallFollowUpRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallFollowUpRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CallFollowUpRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String subject,  String body,  List<String> evidenceSegmentIds,  String? nextAction,  DateTime? dueAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallFollowUpRemoteModel() when $default != null:
return $default(_that.subject,_that.body,_that.evidenceSegmentIds,_that.nextAction,_that.dueAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String subject,  String body,  List<String> evidenceSegmentIds,  String? nextAction,  DateTime? dueAt)  $default,) {final _that = this;
switch (_that) {
case _CallFollowUpRemoteModel():
return $default(_that.subject,_that.body,_that.evidenceSegmentIds,_that.nextAction,_that.dueAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String subject,  String body,  List<String> evidenceSegmentIds,  String? nextAction,  DateTime? dueAt)?  $default,) {final _that = this;
switch (_that) {
case _CallFollowUpRemoteModel() when $default != null:
return $default(_that.subject,_that.body,_that.evidenceSegmentIds,_that.nextAction,_that.dueAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CallFollowUpRemoteModel implements CallFollowUpRemoteModel {
  const _CallFollowUpRemoteModel({required this.subject, required this.body, required final  List<String> evidenceSegmentIds, this.nextAction, this.dueAt}): _evidenceSegmentIds = evidenceSegmentIds;
  factory _CallFollowUpRemoteModel.fromJson(Map<String, dynamic> json) => _$CallFollowUpRemoteModelFromJson(json);

@override final  String subject;
@override final  String body;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}

@override final  String? nextAction;
@override final  DateTime? dueAt;

/// Create a copy of CallFollowUpRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallFollowUpRemoteModelCopyWith<_CallFollowUpRemoteModel> get copyWith => __$CallFollowUpRemoteModelCopyWithImpl<_CallFollowUpRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallFollowUpRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallFollowUpRemoteModel&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds)&&(identical(other.nextAction, nextAction) || other.nextAction == nextAction)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subject,body,const DeepCollectionEquality().hash(_evidenceSegmentIds),nextAction,dueAt);

@override
String toString() {
  return 'CallFollowUpRemoteModel(subject: $subject, body: $body, evidenceSegmentIds: $evidenceSegmentIds, nextAction: $nextAction, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class _$CallFollowUpRemoteModelCopyWith<$Res> implements $CallFollowUpRemoteModelCopyWith<$Res> {
  factory _$CallFollowUpRemoteModelCopyWith(_CallFollowUpRemoteModel value, $Res Function(_CallFollowUpRemoteModel) _then) = __$CallFollowUpRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String subject, String body, List<String> evidenceSegmentIds, String? nextAction, DateTime? dueAt
});




}
/// @nodoc
class __$CallFollowUpRemoteModelCopyWithImpl<$Res>
    implements _$CallFollowUpRemoteModelCopyWith<$Res> {
  __$CallFollowUpRemoteModelCopyWithImpl(this._self, this._then);

  final _CallFollowUpRemoteModel _self;
  final $Res Function(_CallFollowUpRemoteModel) _then;

/// Create a copy of CallFollowUpRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subject = null,Object? body = null,Object? evidenceSegmentIds = null,Object? nextAction = freezed,Object? dueAt = freezed,}) {
  return _then(_CallFollowUpRemoteModel(
subject: null == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,nextAction: freezed == nextAction ? _self.nextAction : nextAction // ignore: cast_nullable_to_non_nullable
as String?,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CallImprovementRemoteModel {

 String get recommendationId; String get text; String get rationale; List<String> get evidenceSegmentIds; List<CoachingSourceRemoteModel> get sources; double get confidence;
/// Create a copy of CallImprovementRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallImprovementRemoteModelCopyWith<CallImprovementRemoteModel> get copyWith => _$CallImprovementRemoteModelCopyWithImpl<CallImprovementRemoteModel>(this as CallImprovementRemoteModel, _$identity);

  /// Serializes this CallImprovementRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallImprovementRemoteModel&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId)&&(identical(other.text, text) || other.text == text)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recommendationId,text,rationale,const DeepCollectionEquality().hash(evidenceSegmentIds),const DeepCollectionEquality().hash(sources),confidence);

@override
String toString() {
  return 'CallImprovementRemoteModel(recommendationId: $recommendationId, text: $text, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $CallImprovementRemoteModelCopyWith<$Res>  {
  factory $CallImprovementRemoteModelCopyWith(CallImprovementRemoteModel value, $Res Function(CallImprovementRemoteModel) _then) = _$CallImprovementRemoteModelCopyWithImpl;
@useResult
$Res call({
 String recommendationId, String text, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceRemoteModel> sources, double confidence
});




}
/// @nodoc
class _$CallImprovementRemoteModelCopyWithImpl<$Res>
    implements $CallImprovementRemoteModelCopyWith<$Res> {
  _$CallImprovementRemoteModelCopyWithImpl(this._self, this._then);

  final CallImprovementRemoteModel _self;
  final $Res Function(CallImprovementRemoteModel) _then;

/// Create a copy of CallImprovementRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recommendationId = null,Object? text = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
recommendationId: null == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceRemoteModel>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CallImprovementRemoteModel].
extension CallImprovementRemoteModelPatterns on CallImprovementRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallImprovementRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallImprovementRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallImprovementRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CallImprovementRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallImprovementRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CallImprovementRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String recommendationId,  String text,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceRemoteModel> sources,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallImprovementRemoteModel() when $default != null:
return $default(_that.recommendationId,_that.text,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String recommendationId,  String text,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceRemoteModel> sources,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _CallImprovementRemoteModel():
return $default(_that.recommendationId,_that.text,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String recommendationId,  String text,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceRemoteModel> sources,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _CallImprovementRemoteModel() when $default != null:
return $default(_that.recommendationId,_that.text,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _CallImprovementRemoteModel implements CallImprovementRemoteModel {
  const _CallImprovementRemoteModel({required this.recommendationId, required this.text, required this.rationale, required final  List<String> evidenceSegmentIds, required final  List<CoachingSourceRemoteModel> sources, required this.confidence}): _evidenceSegmentIds = evidenceSegmentIds,_sources = sources;
  factory _CallImprovementRemoteModel.fromJson(Map<String, dynamic> json) => _$CallImprovementRemoteModelFromJson(json);

@override final  String recommendationId;
@override final  String text;
@override final  String rationale;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}

 final  List<CoachingSourceRemoteModel> _sources;
@override List<CoachingSourceRemoteModel> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override final  double confidence;

/// Create a copy of CallImprovementRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallImprovementRemoteModelCopyWith<_CallImprovementRemoteModel> get copyWith => __$CallImprovementRemoteModelCopyWithImpl<_CallImprovementRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallImprovementRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallImprovementRemoteModel&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId)&&(identical(other.text, text) || other.text == text)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,recommendationId,text,rationale,const DeepCollectionEquality().hash(_evidenceSegmentIds),const DeepCollectionEquality().hash(_sources),confidence);

@override
String toString() {
  return 'CallImprovementRemoteModel(recommendationId: $recommendationId, text: $text, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$CallImprovementRemoteModelCopyWith<$Res> implements $CallImprovementRemoteModelCopyWith<$Res> {
  factory _$CallImprovementRemoteModelCopyWith(_CallImprovementRemoteModel value, $Res Function(_CallImprovementRemoteModel) _then) = __$CallImprovementRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String recommendationId, String text, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceRemoteModel> sources, double confidence
});




}
/// @nodoc
class __$CallImprovementRemoteModelCopyWithImpl<$Res>
    implements _$CallImprovementRemoteModelCopyWith<$Res> {
  __$CallImprovementRemoteModelCopyWithImpl(this._self, this._then);

  final _CallImprovementRemoteModel _self;
  final $Res Function(_CallImprovementRemoteModel) _then;

/// Create a copy of CallImprovementRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recommendationId = null,Object? text = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,}) {
  return _then(_CallImprovementRemoteModel(
recommendationId: null == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceRemoteModel>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$CallPerformanceAxisRemoteModel {

 String get axis; int get score; String get signal; String get observation; List<String> get evidenceSegmentIds;
/// Create a copy of CallPerformanceAxisRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallPerformanceAxisRemoteModelCopyWith<CallPerformanceAxisRemoteModel> get copyWith => _$CallPerformanceAxisRemoteModelCopyWithImpl<CallPerformanceAxisRemoteModel>(this as CallPerformanceAxisRemoteModel, _$identity);

  /// Serializes this CallPerformanceAxisRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallPerformanceAxisRemoteModel&&(identical(other.axis, axis) || other.axis == axis)&&(identical(other.score, score) || other.score == score)&&(identical(other.signal, signal) || other.signal == signal)&&(identical(other.observation, observation) || other.observation == observation)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,axis,score,signal,observation,const DeepCollectionEquality().hash(evidenceSegmentIds));

@override
String toString() {
  return 'CallPerformanceAxisRemoteModel(axis: $axis, score: $score, signal: $signal, observation: $observation, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class $CallPerformanceAxisRemoteModelCopyWith<$Res>  {
  factory $CallPerformanceAxisRemoteModelCopyWith(CallPerformanceAxisRemoteModel value, $Res Function(CallPerformanceAxisRemoteModel) _then) = _$CallPerformanceAxisRemoteModelCopyWithImpl;
@useResult
$Res call({
 String axis, int score, String signal, String observation, List<String> evidenceSegmentIds
});




}
/// @nodoc
class _$CallPerformanceAxisRemoteModelCopyWithImpl<$Res>
    implements $CallPerformanceAxisRemoteModelCopyWith<$Res> {
  _$CallPerformanceAxisRemoteModelCopyWithImpl(this._self, this._then);

  final CallPerformanceAxisRemoteModel _self;
  final $Res Function(CallPerformanceAxisRemoteModel) _then;

/// Create a copy of CallPerformanceAxisRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? axis = null,Object? score = null,Object? signal = null,Object? observation = null,Object? evidenceSegmentIds = null,}) {
  return _then(_self.copyWith(
axis: null == axis ? _self.axis : axis // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as String,observation: null == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CallPerformanceAxisRemoteModel].
extension CallPerformanceAxisRemoteModelPatterns on CallPerformanceAxisRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallPerformanceAxisRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallPerformanceAxisRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallPerformanceAxisRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CallPerformanceAxisRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallPerformanceAxisRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CallPerformanceAxisRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String axis,  int score,  String signal,  String observation,  List<String> evidenceSegmentIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallPerformanceAxisRemoteModel() when $default != null:
return $default(_that.axis,_that.score,_that.signal,_that.observation,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String axis,  int score,  String signal,  String observation,  List<String> evidenceSegmentIds)  $default,) {final _that = this;
switch (_that) {
case _CallPerformanceAxisRemoteModel():
return $default(_that.axis,_that.score,_that.signal,_that.observation,_that.evidenceSegmentIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String axis,  int score,  String signal,  String observation,  List<String> evidenceSegmentIds)?  $default,) {final _that = this;
switch (_that) {
case _CallPerformanceAxisRemoteModel() when $default != null:
return $default(_that.axis,_that.score,_that.signal,_that.observation,_that.evidenceSegmentIds);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _CallPerformanceAxisRemoteModel implements CallPerformanceAxisRemoteModel {
  const _CallPerformanceAxisRemoteModel({required this.axis, required this.score, required this.signal, required this.observation, required final  List<String> evidenceSegmentIds}): _evidenceSegmentIds = evidenceSegmentIds;
  factory _CallPerformanceAxisRemoteModel.fromJson(Map<String, dynamic> json) => _$CallPerformanceAxisRemoteModelFromJson(json);

@override final  String axis;
@override final  int score;
@override final  String signal;
@override final  String observation;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}


/// Create a copy of CallPerformanceAxisRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallPerformanceAxisRemoteModelCopyWith<_CallPerformanceAxisRemoteModel> get copyWith => __$CallPerformanceAxisRemoteModelCopyWithImpl<_CallPerformanceAxisRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallPerformanceAxisRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallPerformanceAxisRemoteModel&&(identical(other.axis, axis) || other.axis == axis)&&(identical(other.score, score) || other.score == score)&&(identical(other.signal, signal) || other.signal == signal)&&(identical(other.observation, observation) || other.observation == observation)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,axis,score,signal,observation,const DeepCollectionEquality().hash(_evidenceSegmentIds));

@override
String toString() {
  return 'CallPerformanceAxisRemoteModel(axis: $axis, score: $score, signal: $signal, observation: $observation, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class _$CallPerformanceAxisRemoteModelCopyWith<$Res> implements $CallPerformanceAxisRemoteModelCopyWith<$Res> {
  factory _$CallPerformanceAxisRemoteModelCopyWith(_CallPerformanceAxisRemoteModel value, $Res Function(_CallPerformanceAxisRemoteModel) _then) = __$CallPerformanceAxisRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String axis, int score, String signal, String observation, List<String> evidenceSegmentIds
});




}
/// @nodoc
class __$CallPerformanceAxisRemoteModelCopyWithImpl<$Res>
    implements _$CallPerformanceAxisRemoteModelCopyWith<$Res> {
  __$CallPerformanceAxisRemoteModelCopyWithImpl(this._self, this._then);

  final _CallPerformanceAxisRemoteModel _self;
  final $Res Function(_CallPerformanceAxisRemoteModel) _then;

/// Create a copy of CallPerformanceAxisRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? axis = null,Object? score = null,Object? signal = null,Object? observation = null,Object? evidenceSegmentIds = null,}) {
  return _then(_CallPerformanceAxisRemoteModel(
axis: null == axis ? _self.axis : axis // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as String,observation: null == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PhraseCoachingRemoteModel {

 String get focus; String get originalText; String get improvedText; String get rationale; List<String> get evidenceSegmentIds; List<CoachingSourceRemoteModel> get sources; double get confidence; String? get recommendationId;
/// Create a copy of PhraseCoachingRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhraseCoachingRemoteModelCopyWith<PhraseCoachingRemoteModel> get copyWith => _$PhraseCoachingRemoteModelCopyWithImpl<PhraseCoachingRemoteModel>(this as PhraseCoachingRemoteModel, _$identity);

  /// Serializes this PhraseCoachingRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhraseCoachingRemoteModel&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.improvedText, improvedText) || other.improvedText == improvedText)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,focus,originalText,improvedText,rationale,const DeepCollectionEquality().hash(evidenceSegmentIds),const DeepCollectionEquality().hash(sources),confidence,recommendationId);

@override
String toString() {
  return 'PhraseCoachingRemoteModel(focus: $focus, originalText: $originalText, improvedText: $improvedText, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence, recommendationId: $recommendationId)';
}


}

/// @nodoc
abstract mixin class $PhraseCoachingRemoteModelCopyWith<$Res>  {
  factory $PhraseCoachingRemoteModelCopyWith(PhraseCoachingRemoteModel value, $Res Function(PhraseCoachingRemoteModel) _then) = _$PhraseCoachingRemoteModelCopyWithImpl;
@useResult
$Res call({
 String focus, String originalText, String improvedText, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceRemoteModel> sources, double confidence, String? recommendationId
});




}
/// @nodoc
class _$PhraseCoachingRemoteModelCopyWithImpl<$Res>
    implements $PhraseCoachingRemoteModelCopyWith<$Res> {
  _$PhraseCoachingRemoteModelCopyWithImpl(this._self, this._then);

  final PhraseCoachingRemoteModel _self;
  final $Res Function(PhraseCoachingRemoteModel) _then;

/// Create a copy of PhraseCoachingRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? focus = null,Object? originalText = null,Object? improvedText = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,Object? recommendationId = freezed,}) {
  return _then(_self.copyWith(
focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,originalText: null == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String,improvedText: null == improvedText ? _self.improvedText : improvedText // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceRemoteModel>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,recommendationId: freezed == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhraseCoachingRemoteModel].
extension PhraseCoachingRemoteModelPatterns on PhraseCoachingRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhraseCoachingRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhraseCoachingRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhraseCoachingRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _PhraseCoachingRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhraseCoachingRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _PhraseCoachingRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String focus,  String originalText,  String improvedText,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceRemoteModel> sources,  double confidence,  String? recommendationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhraseCoachingRemoteModel() when $default != null:
return $default(_that.focus,_that.originalText,_that.improvedText,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence,_that.recommendationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String focus,  String originalText,  String improvedText,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceRemoteModel> sources,  double confidence,  String? recommendationId)  $default,) {final _that = this;
switch (_that) {
case _PhraseCoachingRemoteModel():
return $default(_that.focus,_that.originalText,_that.improvedText,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence,_that.recommendationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String focus,  String originalText,  String improvedText,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceRemoteModel> sources,  double confidence,  String? recommendationId)?  $default,) {final _that = this;
switch (_that) {
case _PhraseCoachingRemoteModel() when $default != null:
return $default(_that.focus,_that.originalText,_that.improvedText,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence,_that.recommendationId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _PhraseCoachingRemoteModel implements PhraseCoachingRemoteModel {
  const _PhraseCoachingRemoteModel({required this.focus, required this.originalText, required this.improvedText, required this.rationale, required final  List<String> evidenceSegmentIds, final  List<CoachingSourceRemoteModel> sources = const <CoachingSourceRemoteModel>[], this.confidence = 0, this.recommendationId}): _evidenceSegmentIds = evidenceSegmentIds,_sources = sources;
  factory _PhraseCoachingRemoteModel.fromJson(Map<String, dynamic> json) => _$PhraseCoachingRemoteModelFromJson(json);

@override final  String focus;
@override final  String originalText;
@override final  String improvedText;
@override final  String rationale;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}

 final  List<CoachingSourceRemoteModel> _sources;
@override@JsonKey() List<CoachingSourceRemoteModel> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override@JsonKey() final  double confidence;
@override final  String? recommendationId;

/// Create a copy of PhraseCoachingRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhraseCoachingRemoteModelCopyWith<_PhraseCoachingRemoteModel> get copyWith => __$PhraseCoachingRemoteModelCopyWithImpl<_PhraseCoachingRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhraseCoachingRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhraseCoachingRemoteModel&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.improvedText, improvedText) || other.improvedText == improvedText)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,focus,originalText,improvedText,rationale,const DeepCollectionEquality().hash(_evidenceSegmentIds),const DeepCollectionEquality().hash(_sources),confidence,recommendationId);

@override
String toString() {
  return 'PhraseCoachingRemoteModel(focus: $focus, originalText: $originalText, improvedText: $improvedText, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence, recommendationId: $recommendationId)';
}


}

/// @nodoc
abstract mixin class _$PhraseCoachingRemoteModelCopyWith<$Res> implements $PhraseCoachingRemoteModelCopyWith<$Res> {
  factory _$PhraseCoachingRemoteModelCopyWith(_PhraseCoachingRemoteModel value, $Res Function(_PhraseCoachingRemoteModel) _then) = __$PhraseCoachingRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String focus, String originalText, String improvedText, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceRemoteModel> sources, double confidence, String? recommendationId
});




}
/// @nodoc
class __$PhraseCoachingRemoteModelCopyWithImpl<$Res>
    implements _$PhraseCoachingRemoteModelCopyWith<$Res> {
  __$PhraseCoachingRemoteModelCopyWithImpl(this._self, this._then);

  final _PhraseCoachingRemoteModel _self;
  final $Res Function(_PhraseCoachingRemoteModel) _then;

/// Create a copy of PhraseCoachingRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? focus = null,Object? originalText = null,Object? improvedText = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,Object? recommendationId = freezed,}) {
  return _then(_PhraseCoachingRemoteModel(
focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,originalText: null == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String,improvedText: null == improvedText ? _self.improvedText : improvedText // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceRemoteModel>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,recommendationId: freezed == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$StrategicCallAdviceRemoteModel {

 String get category; String get priority; String get title; String get advice; String get rationale; List<String> get evidenceSegmentIds; List<CoachingSourceRemoteModel> get sources; double get confidence; String? get recommendationId;
/// Create a copy of StrategicCallAdviceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StrategicCallAdviceRemoteModelCopyWith<StrategicCallAdviceRemoteModel> get copyWith => _$StrategicCallAdviceRemoteModelCopyWithImpl<StrategicCallAdviceRemoteModel>(this as StrategicCallAdviceRemoteModel, _$identity);

  /// Serializes this StrategicCallAdviceRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StrategicCallAdviceRemoteModel&&(identical(other.category, category) || other.category == category)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.title, title) || other.title == title)&&(identical(other.advice, advice) || other.advice == advice)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,priority,title,advice,rationale,const DeepCollectionEquality().hash(evidenceSegmentIds),const DeepCollectionEquality().hash(sources),confidence,recommendationId);

@override
String toString() {
  return 'StrategicCallAdviceRemoteModel(category: $category, priority: $priority, title: $title, advice: $advice, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence, recommendationId: $recommendationId)';
}


}

/// @nodoc
abstract mixin class $StrategicCallAdviceRemoteModelCopyWith<$Res>  {
  factory $StrategicCallAdviceRemoteModelCopyWith(StrategicCallAdviceRemoteModel value, $Res Function(StrategicCallAdviceRemoteModel) _then) = _$StrategicCallAdviceRemoteModelCopyWithImpl;
@useResult
$Res call({
 String category, String priority, String title, String advice, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceRemoteModel> sources, double confidence, String? recommendationId
});




}
/// @nodoc
class _$StrategicCallAdviceRemoteModelCopyWithImpl<$Res>
    implements $StrategicCallAdviceRemoteModelCopyWith<$Res> {
  _$StrategicCallAdviceRemoteModelCopyWithImpl(this._self, this._then);

  final StrategicCallAdviceRemoteModel _self;
  final $Res Function(StrategicCallAdviceRemoteModel) _then;

/// Create a copy of StrategicCallAdviceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? priority = null,Object? title = null,Object? advice = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,Object? recommendationId = freezed,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,advice: null == advice ? _self.advice : advice // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceRemoteModel>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,recommendationId: freezed == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StrategicCallAdviceRemoteModel].
extension StrategicCallAdviceRemoteModelPatterns on StrategicCallAdviceRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StrategicCallAdviceRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StrategicCallAdviceRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StrategicCallAdviceRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _StrategicCallAdviceRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StrategicCallAdviceRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _StrategicCallAdviceRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String category,  String priority,  String title,  String advice,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceRemoteModel> sources,  double confidence,  String? recommendationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StrategicCallAdviceRemoteModel() when $default != null:
return $default(_that.category,_that.priority,_that.title,_that.advice,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence,_that.recommendationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String category,  String priority,  String title,  String advice,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceRemoteModel> sources,  double confidence,  String? recommendationId)  $default,) {final _that = this;
switch (_that) {
case _StrategicCallAdviceRemoteModel():
return $default(_that.category,_that.priority,_that.title,_that.advice,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence,_that.recommendationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String category,  String priority,  String title,  String advice,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceRemoteModel> sources,  double confidence,  String? recommendationId)?  $default,) {final _that = this;
switch (_that) {
case _StrategicCallAdviceRemoteModel() when $default != null:
return $default(_that.category,_that.priority,_that.title,_that.advice,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence,_that.recommendationId);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StrategicCallAdviceRemoteModel implements StrategicCallAdviceRemoteModel {
  const _StrategicCallAdviceRemoteModel({required this.category, required this.priority, required this.title, required this.advice, required this.rationale, required final  List<String> evidenceSegmentIds, final  List<CoachingSourceRemoteModel> sources = const <CoachingSourceRemoteModel>[], this.confidence = 0, this.recommendationId}): _evidenceSegmentIds = evidenceSegmentIds,_sources = sources;
  factory _StrategicCallAdviceRemoteModel.fromJson(Map<String, dynamic> json) => _$StrategicCallAdviceRemoteModelFromJson(json);

@override final  String category;
@override final  String priority;
@override final  String title;
@override final  String advice;
@override final  String rationale;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}

 final  List<CoachingSourceRemoteModel> _sources;
@override@JsonKey() List<CoachingSourceRemoteModel> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override@JsonKey() final  double confidence;
@override final  String? recommendationId;

/// Create a copy of StrategicCallAdviceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StrategicCallAdviceRemoteModelCopyWith<_StrategicCallAdviceRemoteModel> get copyWith => __$StrategicCallAdviceRemoteModelCopyWithImpl<_StrategicCallAdviceRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StrategicCallAdviceRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StrategicCallAdviceRemoteModel&&(identical(other.category, category) || other.category == category)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.title, title) || other.title == title)&&(identical(other.advice, advice) || other.advice == advice)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,priority,title,advice,rationale,const DeepCollectionEquality().hash(_evidenceSegmentIds),const DeepCollectionEquality().hash(_sources),confidence,recommendationId);

@override
String toString() {
  return 'StrategicCallAdviceRemoteModel(category: $category, priority: $priority, title: $title, advice: $advice, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence, recommendationId: $recommendationId)';
}


}

/// @nodoc
abstract mixin class _$StrategicCallAdviceRemoteModelCopyWith<$Res> implements $StrategicCallAdviceRemoteModelCopyWith<$Res> {
  factory _$StrategicCallAdviceRemoteModelCopyWith(_StrategicCallAdviceRemoteModel value, $Res Function(_StrategicCallAdviceRemoteModel) _then) = __$StrategicCallAdviceRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String category, String priority, String title, String advice, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceRemoteModel> sources, double confidence, String? recommendationId
});




}
/// @nodoc
class __$StrategicCallAdviceRemoteModelCopyWithImpl<$Res>
    implements _$StrategicCallAdviceRemoteModelCopyWith<$Res> {
  __$StrategicCallAdviceRemoteModelCopyWithImpl(this._self, this._then);

  final _StrategicCallAdviceRemoteModel _self;
  final $Res Function(_StrategicCallAdviceRemoteModel) _then;

/// Create a copy of StrategicCallAdviceRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? priority = null,Object? title = null,Object? advice = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,Object? recommendationId = freezed,}) {
  return _then(_StrategicCallAdviceRemoteModel(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,advice: null == advice ? _self.advice : advice // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceRemoteModel>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,recommendationId: freezed == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CallDebriefRemoteModel {

 String get sessionId; GroundedCallTextRemoteModel get summary; List<GroundedCallTextRemoteModel> get keyPoints; List<CallCommitmentRemoteModel> get commitments; CallFollowUpRemoteModel get followUp; DateTime get generatedAt; String get provider; String get model; List<GroundedCallTextRemoteModel> get strengths; List<CallPerformanceAxisRemoteModel> get performanceAxes; List<PhraseCoachingRemoteModel> get phraseCoaching; List<StrategicCallAdviceRemoteModel> get strategicAdvice; CallImprovementRemoteModel? get improvement;
/// Create a copy of CallDebriefRemoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallDebriefRemoteModelCopyWith<CallDebriefRemoteModel> get copyWith => _$CallDebriefRemoteModelCopyWithImpl<CallDebriefRemoteModel>(this as CallDebriefRemoteModel, _$identity);

  /// Serializes this CallDebriefRemoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallDebriefRemoteModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.keyPoints, keyPoints)&&const DeepCollectionEquality().equals(other.commitments, commitments)&&(identical(other.followUp, followUp) || other.followUp == followUp)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.strengths, strengths)&&const DeepCollectionEquality().equals(other.performanceAxes, performanceAxes)&&const DeepCollectionEquality().equals(other.phraseCoaching, phraseCoaching)&&const DeepCollectionEquality().equals(other.strategicAdvice, strategicAdvice)&&(identical(other.improvement, improvement) || other.improvement == improvement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,summary,const DeepCollectionEquality().hash(keyPoints),const DeepCollectionEquality().hash(commitments),followUp,generatedAt,provider,model,const DeepCollectionEquality().hash(strengths),const DeepCollectionEquality().hash(performanceAxes),const DeepCollectionEquality().hash(phraseCoaching),const DeepCollectionEquality().hash(strategicAdvice),improvement);

@override
String toString() {
  return 'CallDebriefRemoteModel(sessionId: $sessionId, summary: $summary, keyPoints: $keyPoints, commitments: $commitments, followUp: $followUp, generatedAt: $generatedAt, provider: $provider, model: $model, strengths: $strengths, performanceAxes: $performanceAxes, phraseCoaching: $phraseCoaching, strategicAdvice: $strategicAdvice, improvement: $improvement)';
}


}

/// @nodoc
abstract mixin class $CallDebriefRemoteModelCopyWith<$Res>  {
  factory $CallDebriefRemoteModelCopyWith(CallDebriefRemoteModel value, $Res Function(CallDebriefRemoteModel) _then) = _$CallDebriefRemoteModelCopyWithImpl;
@useResult
$Res call({
 String sessionId, GroundedCallTextRemoteModel summary, List<GroundedCallTextRemoteModel> keyPoints, List<CallCommitmentRemoteModel> commitments, CallFollowUpRemoteModel followUp, DateTime generatedAt, String provider, String model, List<GroundedCallTextRemoteModel> strengths, List<CallPerformanceAxisRemoteModel> performanceAxes, List<PhraseCoachingRemoteModel> phraseCoaching, List<StrategicCallAdviceRemoteModel> strategicAdvice, CallImprovementRemoteModel? improvement
});


$GroundedCallTextRemoteModelCopyWith<$Res> get summary;$CallFollowUpRemoteModelCopyWith<$Res> get followUp;$CallImprovementRemoteModelCopyWith<$Res>? get improvement;

}
/// @nodoc
class _$CallDebriefRemoteModelCopyWithImpl<$Res>
    implements $CallDebriefRemoteModelCopyWith<$Res> {
  _$CallDebriefRemoteModelCopyWithImpl(this._self, this._then);

  final CallDebriefRemoteModel _self;
  final $Res Function(CallDebriefRemoteModel) _then;

/// Create a copy of CallDebriefRemoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? summary = null,Object? keyPoints = null,Object? commitments = null,Object? followUp = null,Object? generatedAt = null,Object? provider = null,Object? model = null,Object? strengths = null,Object? performanceAxes = null,Object? phraseCoaching = null,Object? strategicAdvice = null,Object? improvement = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as GroundedCallTextRemoteModel,keyPoints: null == keyPoints ? _self.keyPoints : keyPoints // ignore: cast_nullable_to_non_nullable
as List<GroundedCallTextRemoteModel>,commitments: null == commitments ? _self.commitments : commitments // ignore: cast_nullable_to_non_nullable
as List<CallCommitmentRemoteModel>,followUp: null == followUp ? _self.followUp : followUp // ignore: cast_nullable_to_non_nullable
as CallFollowUpRemoteModel,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,strengths: null == strengths ? _self.strengths : strengths // ignore: cast_nullable_to_non_nullable
as List<GroundedCallTextRemoteModel>,performanceAxes: null == performanceAxes ? _self.performanceAxes : performanceAxes // ignore: cast_nullable_to_non_nullable
as List<CallPerformanceAxisRemoteModel>,phraseCoaching: null == phraseCoaching ? _self.phraseCoaching : phraseCoaching // ignore: cast_nullable_to_non_nullable
as List<PhraseCoachingRemoteModel>,strategicAdvice: null == strategicAdvice ? _self.strategicAdvice : strategicAdvice // ignore: cast_nullable_to_non_nullable
as List<StrategicCallAdviceRemoteModel>,improvement: freezed == improvement ? _self.improvement : improvement // ignore: cast_nullable_to_non_nullable
as CallImprovementRemoteModel?,
  ));
}
/// Create a copy of CallDebriefRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroundedCallTextRemoteModelCopyWith<$Res> get summary {
  
  return $GroundedCallTextRemoteModelCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of CallDebriefRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallFollowUpRemoteModelCopyWith<$Res> get followUp {
  
  return $CallFollowUpRemoteModelCopyWith<$Res>(_self.followUp, (value) {
    return _then(_self.copyWith(followUp: value));
  });
}/// Create a copy of CallDebriefRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallImprovementRemoteModelCopyWith<$Res>? get improvement {
    if (_self.improvement == null) {
    return null;
  }

  return $CallImprovementRemoteModelCopyWith<$Res>(_self.improvement!, (value) {
    return _then(_self.copyWith(improvement: value));
  });
}
}


/// Adds pattern-matching-related methods to [CallDebriefRemoteModel].
extension CallDebriefRemoteModelPatterns on CallDebriefRemoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallDebriefRemoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallDebriefRemoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallDebriefRemoteModel value)  $default,){
final _that = this;
switch (_that) {
case _CallDebriefRemoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallDebriefRemoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _CallDebriefRemoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  GroundedCallTextRemoteModel summary,  List<GroundedCallTextRemoteModel> keyPoints,  List<CallCommitmentRemoteModel> commitments,  CallFollowUpRemoteModel followUp,  DateTime generatedAt,  String provider,  String model,  List<GroundedCallTextRemoteModel> strengths,  List<CallPerformanceAxisRemoteModel> performanceAxes,  List<PhraseCoachingRemoteModel> phraseCoaching,  List<StrategicCallAdviceRemoteModel> strategicAdvice,  CallImprovementRemoteModel? improvement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallDebriefRemoteModel() when $default != null:
return $default(_that.sessionId,_that.summary,_that.keyPoints,_that.commitments,_that.followUp,_that.generatedAt,_that.provider,_that.model,_that.strengths,_that.performanceAxes,_that.phraseCoaching,_that.strategicAdvice,_that.improvement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  GroundedCallTextRemoteModel summary,  List<GroundedCallTextRemoteModel> keyPoints,  List<CallCommitmentRemoteModel> commitments,  CallFollowUpRemoteModel followUp,  DateTime generatedAt,  String provider,  String model,  List<GroundedCallTextRemoteModel> strengths,  List<CallPerformanceAxisRemoteModel> performanceAxes,  List<PhraseCoachingRemoteModel> phraseCoaching,  List<StrategicCallAdviceRemoteModel> strategicAdvice,  CallImprovementRemoteModel? improvement)  $default,) {final _that = this;
switch (_that) {
case _CallDebriefRemoteModel():
return $default(_that.sessionId,_that.summary,_that.keyPoints,_that.commitments,_that.followUp,_that.generatedAt,_that.provider,_that.model,_that.strengths,_that.performanceAxes,_that.phraseCoaching,_that.strategicAdvice,_that.improvement);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  GroundedCallTextRemoteModel summary,  List<GroundedCallTextRemoteModel> keyPoints,  List<CallCommitmentRemoteModel> commitments,  CallFollowUpRemoteModel followUp,  DateTime generatedAt,  String provider,  String model,  List<GroundedCallTextRemoteModel> strengths,  List<CallPerformanceAxisRemoteModel> performanceAxes,  List<PhraseCoachingRemoteModel> phraseCoaching,  List<StrategicCallAdviceRemoteModel> strategicAdvice,  CallImprovementRemoteModel? improvement)?  $default,) {final _that = this;
switch (_that) {
case _CallDebriefRemoteModel() when $default != null:
return $default(_that.sessionId,_that.summary,_that.keyPoints,_that.commitments,_that.followUp,_that.generatedAt,_that.provider,_that.model,_that.strengths,_that.performanceAxes,_that.phraseCoaching,_that.strategicAdvice,_that.improvement);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _CallDebriefRemoteModel implements CallDebriefRemoteModel {
  const _CallDebriefRemoteModel({required this.sessionId, required this.summary, required final  List<GroundedCallTextRemoteModel> keyPoints, required final  List<CallCommitmentRemoteModel> commitments, required this.followUp, required this.generatedAt, required this.provider, required this.model, final  List<GroundedCallTextRemoteModel> strengths = const <GroundedCallTextRemoteModel>[], final  List<CallPerformanceAxisRemoteModel> performanceAxes = const <CallPerformanceAxisRemoteModel>[], final  List<PhraseCoachingRemoteModel> phraseCoaching = const <PhraseCoachingRemoteModel>[], final  List<StrategicCallAdviceRemoteModel> strategicAdvice = const <StrategicCallAdviceRemoteModel>[], this.improvement}): _keyPoints = keyPoints,_commitments = commitments,_strengths = strengths,_performanceAxes = performanceAxes,_phraseCoaching = phraseCoaching,_strategicAdvice = strategicAdvice;
  factory _CallDebriefRemoteModel.fromJson(Map<String, dynamic> json) => _$CallDebriefRemoteModelFromJson(json);

@override final  String sessionId;
@override final  GroundedCallTextRemoteModel summary;
 final  List<GroundedCallTextRemoteModel> _keyPoints;
@override List<GroundedCallTextRemoteModel> get keyPoints {
  if (_keyPoints is EqualUnmodifiableListView) return _keyPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keyPoints);
}

 final  List<CallCommitmentRemoteModel> _commitments;
@override List<CallCommitmentRemoteModel> get commitments {
  if (_commitments is EqualUnmodifiableListView) return _commitments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_commitments);
}

@override final  CallFollowUpRemoteModel followUp;
@override final  DateTime generatedAt;
@override final  String provider;
@override final  String model;
 final  List<GroundedCallTextRemoteModel> _strengths;
@override@JsonKey() List<GroundedCallTextRemoteModel> get strengths {
  if (_strengths is EqualUnmodifiableListView) return _strengths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strengths);
}

 final  List<CallPerformanceAxisRemoteModel> _performanceAxes;
@override@JsonKey() List<CallPerformanceAxisRemoteModel> get performanceAxes {
  if (_performanceAxes is EqualUnmodifiableListView) return _performanceAxes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_performanceAxes);
}

 final  List<PhraseCoachingRemoteModel> _phraseCoaching;
@override@JsonKey() List<PhraseCoachingRemoteModel> get phraseCoaching {
  if (_phraseCoaching is EqualUnmodifiableListView) return _phraseCoaching;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_phraseCoaching);
}

 final  List<StrategicCallAdviceRemoteModel> _strategicAdvice;
@override@JsonKey() List<StrategicCallAdviceRemoteModel> get strategicAdvice {
  if (_strategicAdvice is EqualUnmodifiableListView) return _strategicAdvice;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strategicAdvice);
}

@override final  CallImprovementRemoteModel? improvement;

/// Create a copy of CallDebriefRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallDebriefRemoteModelCopyWith<_CallDebriefRemoteModel> get copyWith => __$CallDebriefRemoteModelCopyWithImpl<_CallDebriefRemoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallDebriefRemoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallDebriefRemoteModel&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._keyPoints, _keyPoints)&&const DeepCollectionEquality().equals(other._commitments, _commitments)&&(identical(other.followUp, followUp) || other.followUp == followUp)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other._strengths, _strengths)&&const DeepCollectionEquality().equals(other._performanceAxes, _performanceAxes)&&const DeepCollectionEquality().equals(other._phraseCoaching, _phraseCoaching)&&const DeepCollectionEquality().equals(other._strategicAdvice, _strategicAdvice)&&(identical(other.improvement, improvement) || other.improvement == improvement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionId,summary,const DeepCollectionEquality().hash(_keyPoints),const DeepCollectionEquality().hash(_commitments),followUp,generatedAt,provider,model,const DeepCollectionEquality().hash(_strengths),const DeepCollectionEquality().hash(_performanceAxes),const DeepCollectionEquality().hash(_phraseCoaching),const DeepCollectionEquality().hash(_strategicAdvice),improvement);

@override
String toString() {
  return 'CallDebriefRemoteModel(sessionId: $sessionId, summary: $summary, keyPoints: $keyPoints, commitments: $commitments, followUp: $followUp, generatedAt: $generatedAt, provider: $provider, model: $model, strengths: $strengths, performanceAxes: $performanceAxes, phraseCoaching: $phraseCoaching, strategicAdvice: $strategicAdvice, improvement: $improvement)';
}


}

/// @nodoc
abstract mixin class _$CallDebriefRemoteModelCopyWith<$Res> implements $CallDebriefRemoteModelCopyWith<$Res> {
  factory _$CallDebriefRemoteModelCopyWith(_CallDebriefRemoteModel value, $Res Function(_CallDebriefRemoteModel) _then) = __$CallDebriefRemoteModelCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, GroundedCallTextRemoteModel summary, List<GroundedCallTextRemoteModel> keyPoints, List<CallCommitmentRemoteModel> commitments, CallFollowUpRemoteModel followUp, DateTime generatedAt, String provider, String model, List<GroundedCallTextRemoteModel> strengths, List<CallPerformanceAxisRemoteModel> performanceAxes, List<PhraseCoachingRemoteModel> phraseCoaching, List<StrategicCallAdviceRemoteModel> strategicAdvice, CallImprovementRemoteModel? improvement
});


@override $GroundedCallTextRemoteModelCopyWith<$Res> get summary;@override $CallFollowUpRemoteModelCopyWith<$Res> get followUp;@override $CallImprovementRemoteModelCopyWith<$Res>? get improvement;

}
/// @nodoc
class __$CallDebriefRemoteModelCopyWithImpl<$Res>
    implements _$CallDebriefRemoteModelCopyWith<$Res> {
  __$CallDebriefRemoteModelCopyWithImpl(this._self, this._then);

  final _CallDebriefRemoteModel _self;
  final $Res Function(_CallDebriefRemoteModel) _then;

/// Create a copy of CallDebriefRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? summary = null,Object? keyPoints = null,Object? commitments = null,Object? followUp = null,Object? generatedAt = null,Object? provider = null,Object? model = null,Object? strengths = null,Object? performanceAxes = null,Object? phraseCoaching = null,Object? strategicAdvice = null,Object? improvement = freezed,}) {
  return _then(_CallDebriefRemoteModel(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as GroundedCallTextRemoteModel,keyPoints: null == keyPoints ? _self._keyPoints : keyPoints // ignore: cast_nullable_to_non_nullable
as List<GroundedCallTextRemoteModel>,commitments: null == commitments ? _self._commitments : commitments // ignore: cast_nullable_to_non_nullable
as List<CallCommitmentRemoteModel>,followUp: null == followUp ? _self.followUp : followUp // ignore: cast_nullable_to_non_nullable
as CallFollowUpRemoteModel,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,strengths: null == strengths ? _self._strengths : strengths // ignore: cast_nullable_to_non_nullable
as List<GroundedCallTextRemoteModel>,performanceAxes: null == performanceAxes ? _self._performanceAxes : performanceAxes // ignore: cast_nullable_to_non_nullable
as List<CallPerformanceAxisRemoteModel>,phraseCoaching: null == phraseCoaching ? _self._phraseCoaching : phraseCoaching // ignore: cast_nullable_to_non_nullable
as List<PhraseCoachingRemoteModel>,strategicAdvice: null == strategicAdvice ? _self._strategicAdvice : strategicAdvice // ignore: cast_nullable_to_non_nullable
as List<StrategicCallAdviceRemoteModel>,improvement: freezed == improvement ? _self.improvement : improvement // ignore: cast_nullable_to_non_nullable
as CallImprovementRemoteModel?,
  ));
}

/// Create a copy of CallDebriefRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroundedCallTextRemoteModelCopyWith<$Res> get summary {
  
  return $GroundedCallTextRemoteModelCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of CallDebriefRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallFollowUpRemoteModelCopyWith<$Res> get followUp {
  
  return $CallFollowUpRemoteModelCopyWith<$Res>(_self.followUp, (value) {
    return _then(_self.copyWith(followUp: value));
  });
}/// Create a copy of CallDebriefRemoteModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallImprovementRemoteModelCopyWith<$Res>? get improvement {
    if (_self.improvement == null) {
    return null;
  }

  return $CallImprovementRemoteModelCopyWith<$Res>(_self.improvement!, (value) {
    return _then(_self.copyWith(improvement: value));
  });
}
}

// dart format on
