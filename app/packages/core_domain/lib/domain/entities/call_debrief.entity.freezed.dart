// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_debrief.entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$GroundedCallTextEntity {

 String get text; List<String> get evidenceSegmentIds;
/// Create a copy of GroundedCallTextEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GroundedCallTextEntityCopyWith<GroundedCallTextEntity> get copyWith => _$GroundedCallTextEntityCopyWithImpl<GroundedCallTextEntity>(this as GroundedCallTextEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GroundedCallTextEntity&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds));
}


@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(evidenceSegmentIds));

@override
String toString() {
  return 'GroundedCallTextEntity(text: $text, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class $GroundedCallTextEntityCopyWith<$Res>  {
  factory $GroundedCallTextEntityCopyWith(GroundedCallTextEntity value, $Res Function(GroundedCallTextEntity) _then) = _$GroundedCallTextEntityCopyWithImpl;
@useResult
$Res call({
 String text, List<String> evidenceSegmentIds
});




}
/// @nodoc
class _$GroundedCallTextEntityCopyWithImpl<$Res>
    implements $GroundedCallTextEntityCopyWith<$Res> {
  _$GroundedCallTextEntityCopyWithImpl(this._self, this._then);

  final GroundedCallTextEntity _self;
  final $Res Function(GroundedCallTextEntity) _then;

/// Create a copy of GroundedCallTextEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? evidenceSegmentIds = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [GroundedCallTextEntity].
extension GroundedCallTextEntityPatterns on GroundedCallTextEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GroundedCallTextEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GroundedCallTextEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GroundedCallTextEntity value)  $default,){
final _that = this;
switch (_that) {
case _GroundedCallTextEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GroundedCallTextEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GroundedCallTextEntity() when $default != null:
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
case _GroundedCallTextEntity() when $default != null:
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
case _GroundedCallTextEntity():
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
case _GroundedCallTextEntity() when $default != null:
return $default(_that.text,_that.evidenceSegmentIds);case _:
  return null;

}
}

}

/// @nodoc


class _GroundedCallTextEntity implements GroundedCallTextEntity {
  const _GroundedCallTextEntity({required this.text, required final  List<String> evidenceSegmentIds}): _evidenceSegmentIds = evidenceSegmentIds;
  

@override final  String text;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}


/// Create a copy of GroundedCallTextEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GroundedCallTextEntityCopyWith<_GroundedCallTextEntity> get copyWith => __$GroundedCallTextEntityCopyWithImpl<_GroundedCallTextEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GroundedCallTextEntity&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds));
}


@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_evidenceSegmentIds));

@override
String toString() {
  return 'GroundedCallTextEntity(text: $text, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class _$GroundedCallTextEntityCopyWith<$Res> implements $GroundedCallTextEntityCopyWith<$Res> {
  factory _$GroundedCallTextEntityCopyWith(_GroundedCallTextEntity value, $Res Function(_GroundedCallTextEntity) _then) = __$GroundedCallTextEntityCopyWithImpl;
@override @useResult
$Res call({
 String text, List<String> evidenceSegmentIds
});




}
/// @nodoc
class __$GroundedCallTextEntityCopyWithImpl<$Res>
    implements _$GroundedCallTextEntityCopyWith<$Res> {
  __$GroundedCallTextEntityCopyWithImpl(this._self, this._then);

  final _GroundedCallTextEntity _self;
  final $Res Function(_GroundedCallTextEntity) _then;

/// Create a copy of GroundedCallTextEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? evidenceSegmentIds = null,}) {
  return _then(_GroundedCallTextEntity(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$CallCommitmentEntity {

 CallCommitmentOwner get owner; String get text; List<String> get evidenceSegmentIds; DateTime? get dueAt;
/// Create a copy of CallCommitmentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallCommitmentEntityCopyWith<CallCommitmentEntity> get copyWith => _$CallCommitmentEntityCopyWithImpl<CallCommitmentEntity>(this as CallCommitmentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallCommitmentEntity&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}


@override
int get hashCode => Object.hash(runtimeType,owner,text,const DeepCollectionEquality().hash(evidenceSegmentIds),dueAt);

@override
String toString() {
  return 'CallCommitmentEntity(owner: $owner, text: $text, evidenceSegmentIds: $evidenceSegmentIds, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class $CallCommitmentEntityCopyWith<$Res>  {
  factory $CallCommitmentEntityCopyWith(CallCommitmentEntity value, $Res Function(CallCommitmentEntity) _then) = _$CallCommitmentEntityCopyWithImpl;
@useResult
$Res call({
 CallCommitmentOwner owner, String text, List<String> evidenceSegmentIds, DateTime? dueAt
});




}
/// @nodoc
class _$CallCommitmentEntityCopyWithImpl<$Res>
    implements $CallCommitmentEntityCopyWith<$Res> {
  _$CallCommitmentEntityCopyWithImpl(this._self, this._then);

  final CallCommitmentEntity _self;
  final $Res Function(CallCommitmentEntity) _then;

/// Create a copy of CallCommitmentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? owner = null,Object? text = null,Object? evidenceSegmentIds = null,Object? dueAt = freezed,}) {
  return _then(_self.copyWith(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as CallCommitmentOwner,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallCommitmentEntity].
extension CallCommitmentEntityPatterns on CallCommitmentEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallCommitmentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallCommitmentEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallCommitmentEntity value)  $default,){
final _that = this;
switch (_that) {
case _CallCommitmentEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallCommitmentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CallCommitmentEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CallCommitmentOwner owner,  String text,  List<String> evidenceSegmentIds,  DateTime? dueAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallCommitmentEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CallCommitmentOwner owner,  String text,  List<String> evidenceSegmentIds,  DateTime? dueAt)  $default,) {final _that = this;
switch (_that) {
case _CallCommitmentEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CallCommitmentOwner owner,  String text,  List<String> evidenceSegmentIds,  DateTime? dueAt)?  $default,) {final _that = this;
switch (_that) {
case _CallCommitmentEntity() when $default != null:
return $default(_that.owner,_that.text,_that.evidenceSegmentIds,_that.dueAt);case _:
  return null;

}
}

}

/// @nodoc


class _CallCommitmentEntity implements CallCommitmentEntity {
  const _CallCommitmentEntity({required this.owner, required this.text, required final  List<String> evidenceSegmentIds, this.dueAt}): _evidenceSegmentIds = evidenceSegmentIds;
  

@override final  CallCommitmentOwner owner;
@override final  String text;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}

@override final  DateTime? dueAt;

/// Create a copy of CallCommitmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallCommitmentEntityCopyWith<_CallCommitmentEntity> get copyWith => __$CallCommitmentEntityCopyWithImpl<_CallCommitmentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallCommitmentEntity&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}


@override
int get hashCode => Object.hash(runtimeType,owner,text,const DeepCollectionEquality().hash(_evidenceSegmentIds),dueAt);

@override
String toString() {
  return 'CallCommitmentEntity(owner: $owner, text: $text, evidenceSegmentIds: $evidenceSegmentIds, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class _$CallCommitmentEntityCopyWith<$Res> implements $CallCommitmentEntityCopyWith<$Res> {
  factory _$CallCommitmentEntityCopyWith(_CallCommitmentEntity value, $Res Function(_CallCommitmentEntity) _then) = __$CallCommitmentEntityCopyWithImpl;
@override @useResult
$Res call({
 CallCommitmentOwner owner, String text, List<String> evidenceSegmentIds, DateTime? dueAt
});




}
/// @nodoc
class __$CallCommitmentEntityCopyWithImpl<$Res>
    implements _$CallCommitmentEntityCopyWith<$Res> {
  __$CallCommitmentEntityCopyWithImpl(this._self, this._then);

  final _CallCommitmentEntity _self;
  final $Res Function(_CallCommitmentEntity) _then;

/// Create a copy of CallCommitmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? owner = null,Object? text = null,Object? evidenceSegmentIds = null,Object? dueAt = freezed,}) {
  return _then(_CallCommitmentEntity(
owner: null == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as CallCommitmentOwner,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,dueAt: freezed == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$CallFollowUpEntity {

 String get subject; String get body; List<String> get evidenceSegmentIds; String? get nextAction; DateTime? get dueAt;
/// Create a copy of CallFollowUpEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallFollowUpEntityCopyWith<CallFollowUpEntity> get copyWith => _$CallFollowUpEntityCopyWithImpl<CallFollowUpEntity>(this as CallFollowUpEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallFollowUpEntity&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds)&&(identical(other.nextAction, nextAction) || other.nextAction == nextAction)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}


@override
int get hashCode => Object.hash(runtimeType,subject,body,const DeepCollectionEquality().hash(evidenceSegmentIds),nextAction,dueAt);

@override
String toString() {
  return 'CallFollowUpEntity(subject: $subject, body: $body, evidenceSegmentIds: $evidenceSegmentIds, nextAction: $nextAction, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class $CallFollowUpEntityCopyWith<$Res>  {
  factory $CallFollowUpEntityCopyWith(CallFollowUpEntity value, $Res Function(CallFollowUpEntity) _then) = _$CallFollowUpEntityCopyWithImpl;
@useResult
$Res call({
 String subject, String body, List<String> evidenceSegmentIds, String? nextAction, DateTime? dueAt
});




}
/// @nodoc
class _$CallFollowUpEntityCopyWithImpl<$Res>
    implements $CallFollowUpEntityCopyWith<$Res> {
  _$CallFollowUpEntityCopyWithImpl(this._self, this._then);

  final CallFollowUpEntity _self;
  final $Res Function(CallFollowUpEntity) _then;

/// Create a copy of CallFollowUpEntity
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


/// Adds pattern-matching-related methods to [CallFollowUpEntity].
extension CallFollowUpEntityPatterns on CallFollowUpEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallFollowUpEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallFollowUpEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallFollowUpEntity value)  $default,){
final _that = this;
switch (_that) {
case _CallFollowUpEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallFollowUpEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CallFollowUpEntity() when $default != null:
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
case _CallFollowUpEntity() when $default != null:
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
case _CallFollowUpEntity():
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
case _CallFollowUpEntity() when $default != null:
return $default(_that.subject,_that.body,_that.evidenceSegmentIds,_that.nextAction,_that.dueAt);case _:
  return null;

}
}

}

/// @nodoc


class _CallFollowUpEntity implements CallFollowUpEntity {
  const _CallFollowUpEntity({required this.subject, required this.body, required final  List<String> evidenceSegmentIds, this.nextAction, this.dueAt}): _evidenceSegmentIds = evidenceSegmentIds;
  

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

/// Create a copy of CallFollowUpEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallFollowUpEntityCopyWith<_CallFollowUpEntity> get copyWith => __$CallFollowUpEntityCopyWithImpl<_CallFollowUpEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallFollowUpEntity&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds)&&(identical(other.nextAction, nextAction) || other.nextAction == nextAction)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt));
}


@override
int get hashCode => Object.hash(runtimeType,subject,body,const DeepCollectionEquality().hash(_evidenceSegmentIds),nextAction,dueAt);

@override
String toString() {
  return 'CallFollowUpEntity(subject: $subject, body: $body, evidenceSegmentIds: $evidenceSegmentIds, nextAction: $nextAction, dueAt: $dueAt)';
}


}

/// @nodoc
abstract mixin class _$CallFollowUpEntityCopyWith<$Res> implements $CallFollowUpEntityCopyWith<$Res> {
  factory _$CallFollowUpEntityCopyWith(_CallFollowUpEntity value, $Res Function(_CallFollowUpEntity) _then) = __$CallFollowUpEntityCopyWithImpl;
@override @useResult
$Res call({
 String subject, String body, List<String> evidenceSegmentIds, String? nextAction, DateTime? dueAt
});




}
/// @nodoc
class __$CallFollowUpEntityCopyWithImpl<$Res>
    implements _$CallFollowUpEntityCopyWith<$Res> {
  __$CallFollowUpEntityCopyWithImpl(this._self, this._then);

  final _CallFollowUpEntity _self;
  final $Res Function(_CallFollowUpEntity) _then;

/// Create a copy of CallFollowUpEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subject = null,Object? body = null,Object? evidenceSegmentIds = null,Object? nextAction = freezed,Object? dueAt = freezed,}) {
  return _then(_CallFollowUpEntity(
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
mixin _$CallImprovementEntity {

 String get recommendationId; String get text; String get rationale; List<String> get evidenceSegmentIds; List<CoachingSourceEntity> get sources; double get confidence;
/// Create a copy of CallImprovementEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallImprovementEntityCopyWith<CallImprovementEntity> get copyWith => _$CallImprovementEntityCopyWithImpl<CallImprovementEntity>(this as CallImprovementEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallImprovementEntity&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId)&&(identical(other.text, text) || other.text == text)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode => Object.hash(runtimeType,recommendationId,text,rationale,const DeepCollectionEquality().hash(evidenceSegmentIds),const DeepCollectionEquality().hash(sources),confidence);

@override
String toString() {
  return 'CallImprovementEntity(recommendationId: $recommendationId, text: $text, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $CallImprovementEntityCopyWith<$Res>  {
  factory $CallImprovementEntityCopyWith(CallImprovementEntity value, $Res Function(CallImprovementEntity) _then) = _$CallImprovementEntityCopyWithImpl;
@useResult
$Res call({
 String recommendationId, String text, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceEntity> sources, double confidence
});




}
/// @nodoc
class _$CallImprovementEntityCopyWithImpl<$Res>
    implements $CallImprovementEntityCopyWith<$Res> {
  _$CallImprovementEntityCopyWithImpl(this._self, this._then);

  final CallImprovementEntity _self;
  final $Res Function(CallImprovementEntity) _then;

/// Create a copy of CallImprovementEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recommendationId = null,Object? text = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
recommendationId: null == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceEntity>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CallImprovementEntity].
extension CallImprovementEntityPatterns on CallImprovementEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallImprovementEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallImprovementEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallImprovementEntity value)  $default,){
final _that = this;
switch (_that) {
case _CallImprovementEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallImprovementEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CallImprovementEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String recommendationId,  String text,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceEntity> sources,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallImprovementEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String recommendationId,  String text,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceEntity> sources,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _CallImprovementEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String recommendationId,  String text,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceEntity> sources,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _CallImprovementEntity() when $default != null:
return $default(_that.recommendationId,_that.text,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc


class _CallImprovementEntity implements CallImprovementEntity {
  const _CallImprovementEntity({required this.recommendationId, required this.text, required this.rationale, required final  List<String> evidenceSegmentIds, required final  List<CoachingSourceEntity> sources, required this.confidence}): _evidenceSegmentIds = evidenceSegmentIds,_sources = sources;
  

@override final  String recommendationId;
@override final  String text;
@override final  String rationale;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}

 final  List<CoachingSourceEntity> _sources;
@override List<CoachingSourceEntity> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override final  double confidence;

/// Create a copy of CallImprovementEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallImprovementEntityCopyWith<_CallImprovementEntity> get copyWith => __$CallImprovementEntityCopyWithImpl<_CallImprovementEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallImprovementEntity&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId)&&(identical(other.text, text) || other.text == text)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}


@override
int get hashCode => Object.hash(runtimeType,recommendationId,text,rationale,const DeepCollectionEquality().hash(_evidenceSegmentIds),const DeepCollectionEquality().hash(_sources),confidence);

@override
String toString() {
  return 'CallImprovementEntity(recommendationId: $recommendationId, text: $text, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$CallImprovementEntityCopyWith<$Res> implements $CallImprovementEntityCopyWith<$Res> {
  factory _$CallImprovementEntityCopyWith(_CallImprovementEntity value, $Res Function(_CallImprovementEntity) _then) = __$CallImprovementEntityCopyWithImpl;
@override @useResult
$Res call({
 String recommendationId, String text, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceEntity> sources, double confidence
});




}
/// @nodoc
class __$CallImprovementEntityCopyWithImpl<$Res>
    implements _$CallImprovementEntityCopyWith<$Res> {
  __$CallImprovementEntityCopyWithImpl(this._self, this._then);

  final _CallImprovementEntity _self;
  final $Res Function(_CallImprovementEntity) _then;

/// Create a copy of CallImprovementEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recommendationId = null,Object? text = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,}) {
  return _then(_CallImprovementEntity(
recommendationId: null == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceEntity>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$CallPerformanceAxisEntity {

 CallPerformanceAxis get axis; int get score; CallPerformanceSignal get signal; String get observation; List<String> get evidenceSegmentIds;
/// Create a copy of CallPerformanceAxisEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallPerformanceAxisEntityCopyWith<CallPerformanceAxisEntity> get copyWith => _$CallPerformanceAxisEntityCopyWithImpl<CallPerformanceAxisEntity>(this as CallPerformanceAxisEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallPerformanceAxisEntity&&(identical(other.axis, axis) || other.axis == axis)&&(identical(other.score, score) || other.score == score)&&(identical(other.signal, signal) || other.signal == signal)&&(identical(other.observation, observation) || other.observation == observation)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds));
}


@override
int get hashCode => Object.hash(runtimeType,axis,score,signal,observation,const DeepCollectionEquality().hash(evidenceSegmentIds));

@override
String toString() {
  return 'CallPerformanceAxisEntity(axis: $axis, score: $score, signal: $signal, observation: $observation, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class $CallPerformanceAxisEntityCopyWith<$Res>  {
  factory $CallPerformanceAxisEntityCopyWith(CallPerformanceAxisEntity value, $Res Function(CallPerformanceAxisEntity) _then) = _$CallPerformanceAxisEntityCopyWithImpl;
@useResult
$Res call({
 CallPerformanceAxis axis, int score, CallPerformanceSignal signal, String observation, List<String> evidenceSegmentIds
});




}
/// @nodoc
class _$CallPerformanceAxisEntityCopyWithImpl<$Res>
    implements $CallPerformanceAxisEntityCopyWith<$Res> {
  _$CallPerformanceAxisEntityCopyWithImpl(this._self, this._then);

  final CallPerformanceAxisEntity _self;
  final $Res Function(CallPerformanceAxisEntity) _then;

/// Create a copy of CallPerformanceAxisEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? axis = null,Object? score = null,Object? signal = null,Object? observation = null,Object? evidenceSegmentIds = null,}) {
  return _then(_self.copyWith(
axis: null == axis ? _self.axis : axis // ignore: cast_nullable_to_non_nullable
as CallPerformanceAxis,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as CallPerformanceSignal,observation: null == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CallPerformanceAxisEntity].
extension CallPerformanceAxisEntityPatterns on CallPerformanceAxisEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallPerformanceAxisEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallPerformanceAxisEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallPerformanceAxisEntity value)  $default,){
final _that = this;
switch (_that) {
case _CallPerformanceAxisEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallPerformanceAxisEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CallPerformanceAxisEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CallPerformanceAxis axis,  int score,  CallPerformanceSignal signal,  String observation,  List<String> evidenceSegmentIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallPerformanceAxisEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CallPerformanceAxis axis,  int score,  CallPerformanceSignal signal,  String observation,  List<String> evidenceSegmentIds)  $default,) {final _that = this;
switch (_that) {
case _CallPerformanceAxisEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CallPerformanceAxis axis,  int score,  CallPerformanceSignal signal,  String observation,  List<String> evidenceSegmentIds)?  $default,) {final _that = this;
switch (_that) {
case _CallPerformanceAxisEntity() when $default != null:
return $default(_that.axis,_that.score,_that.signal,_that.observation,_that.evidenceSegmentIds);case _:
  return null;

}
}

}

/// @nodoc


class _CallPerformanceAxisEntity implements CallPerformanceAxisEntity {
  const _CallPerformanceAxisEntity({required this.axis, required this.score, required this.signal, required this.observation, required final  List<String> evidenceSegmentIds}): _evidenceSegmentIds = evidenceSegmentIds;
  

@override final  CallPerformanceAxis axis;
@override final  int score;
@override final  CallPerformanceSignal signal;
@override final  String observation;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}


/// Create a copy of CallPerformanceAxisEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallPerformanceAxisEntityCopyWith<_CallPerformanceAxisEntity> get copyWith => __$CallPerformanceAxisEntityCopyWithImpl<_CallPerformanceAxisEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallPerformanceAxisEntity&&(identical(other.axis, axis) || other.axis == axis)&&(identical(other.score, score) || other.score == score)&&(identical(other.signal, signal) || other.signal == signal)&&(identical(other.observation, observation) || other.observation == observation)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds));
}


@override
int get hashCode => Object.hash(runtimeType,axis,score,signal,observation,const DeepCollectionEquality().hash(_evidenceSegmentIds));

@override
String toString() {
  return 'CallPerformanceAxisEntity(axis: $axis, score: $score, signal: $signal, observation: $observation, evidenceSegmentIds: $evidenceSegmentIds)';
}


}

/// @nodoc
abstract mixin class _$CallPerformanceAxisEntityCopyWith<$Res> implements $CallPerformanceAxisEntityCopyWith<$Res> {
  factory _$CallPerformanceAxisEntityCopyWith(_CallPerformanceAxisEntity value, $Res Function(_CallPerformanceAxisEntity) _then) = __$CallPerformanceAxisEntityCopyWithImpl;
@override @useResult
$Res call({
 CallPerformanceAxis axis, int score, CallPerformanceSignal signal, String observation, List<String> evidenceSegmentIds
});




}
/// @nodoc
class __$CallPerformanceAxisEntityCopyWithImpl<$Res>
    implements _$CallPerformanceAxisEntityCopyWith<$Res> {
  __$CallPerformanceAxisEntityCopyWithImpl(this._self, this._then);

  final _CallPerformanceAxisEntity _self;
  final $Res Function(_CallPerformanceAxisEntity) _then;

/// Create a copy of CallPerformanceAxisEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? axis = null,Object? score = null,Object? signal = null,Object? observation = null,Object? evidenceSegmentIds = null,}) {
  return _then(_CallPerformanceAxisEntity(
axis: null == axis ? _self.axis : axis // ignore: cast_nullable_to_non_nullable
as CallPerformanceAxis,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as CallPerformanceSignal,observation: null == observation ? _self.observation : observation // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$PhraseCoachingEntity {

 PhraseCoachingFocus get focus; String get originalText; String get improvedText; String get rationale; List<String> get evidenceSegmentIds; List<CoachingSourceEntity> get sources; double get confidence; String? get recommendationId;
/// Create a copy of PhraseCoachingEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhraseCoachingEntityCopyWith<PhraseCoachingEntity> get copyWith => _$PhraseCoachingEntityCopyWithImpl<PhraseCoachingEntity>(this as PhraseCoachingEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhraseCoachingEntity&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.improvedText, improvedText) || other.improvedText == improvedText)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId));
}


@override
int get hashCode => Object.hash(runtimeType,focus,originalText,improvedText,rationale,const DeepCollectionEquality().hash(evidenceSegmentIds),const DeepCollectionEquality().hash(sources),confidence,recommendationId);

@override
String toString() {
  return 'PhraseCoachingEntity(focus: $focus, originalText: $originalText, improvedText: $improvedText, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence, recommendationId: $recommendationId)';
}


}

/// @nodoc
abstract mixin class $PhraseCoachingEntityCopyWith<$Res>  {
  factory $PhraseCoachingEntityCopyWith(PhraseCoachingEntity value, $Res Function(PhraseCoachingEntity) _then) = _$PhraseCoachingEntityCopyWithImpl;
@useResult
$Res call({
 PhraseCoachingFocus focus, String originalText, String improvedText, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceEntity> sources, double confidence, String? recommendationId
});




}
/// @nodoc
class _$PhraseCoachingEntityCopyWithImpl<$Res>
    implements $PhraseCoachingEntityCopyWith<$Res> {
  _$PhraseCoachingEntityCopyWithImpl(this._self, this._then);

  final PhraseCoachingEntity _self;
  final $Res Function(PhraseCoachingEntity) _then;

/// Create a copy of PhraseCoachingEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? focus = null,Object? originalText = null,Object? improvedText = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,Object? recommendationId = freezed,}) {
  return _then(_self.copyWith(
focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as PhraseCoachingFocus,originalText: null == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String,improvedText: null == improvedText ? _self.improvedText : improvedText // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceEntity>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,recommendationId: freezed == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhraseCoachingEntity].
extension PhraseCoachingEntityPatterns on PhraseCoachingEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhraseCoachingEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhraseCoachingEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhraseCoachingEntity value)  $default,){
final _that = this;
switch (_that) {
case _PhraseCoachingEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhraseCoachingEntity value)?  $default,){
final _that = this;
switch (_that) {
case _PhraseCoachingEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PhraseCoachingFocus focus,  String originalText,  String improvedText,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceEntity> sources,  double confidence,  String? recommendationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhraseCoachingEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PhraseCoachingFocus focus,  String originalText,  String improvedText,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceEntity> sources,  double confidence,  String? recommendationId)  $default,) {final _that = this;
switch (_that) {
case _PhraseCoachingEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PhraseCoachingFocus focus,  String originalText,  String improvedText,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceEntity> sources,  double confidence,  String? recommendationId)?  $default,) {final _that = this;
switch (_that) {
case _PhraseCoachingEntity() when $default != null:
return $default(_that.focus,_that.originalText,_that.improvedText,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence,_that.recommendationId);case _:
  return null;

}
}

}

/// @nodoc


class _PhraseCoachingEntity implements PhraseCoachingEntity {
  const _PhraseCoachingEntity({required this.focus, required this.originalText, required this.improvedText, required this.rationale, required final  List<String> evidenceSegmentIds, required final  List<CoachingSourceEntity> sources, required this.confidence, this.recommendationId}): _evidenceSegmentIds = evidenceSegmentIds,_sources = sources;
  

@override final  PhraseCoachingFocus focus;
@override final  String originalText;
@override final  String improvedText;
@override final  String rationale;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}

 final  List<CoachingSourceEntity> _sources;
@override List<CoachingSourceEntity> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override final  double confidence;
@override final  String? recommendationId;

/// Create a copy of PhraseCoachingEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhraseCoachingEntityCopyWith<_PhraseCoachingEntity> get copyWith => __$PhraseCoachingEntityCopyWithImpl<_PhraseCoachingEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhraseCoachingEntity&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.originalText, originalText) || other.originalText == originalText)&&(identical(other.improvedText, improvedText) || other.improvedText == improvedText)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId));
}


@override
int get hashCode => Object.hash(runtimeType,focus,originalText,improvedText,rationale,const DeepCollectionEquality().hash(_evidenceSegmentIds),const DeepCollectionEquality().hash(_sources),confidence,recommendationId);

@override
String toString() {
  return 'PhraseCoachingEntity(focus: $focus, originalText: $originalText, improvedText: $improvedText, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence, recommendationId: $recommendationId)';
}


}

/// @nodoc
abstract mixin class _$PhraseCoachingEntityCopyWith<$Res> implements $PhraseCoachingEntityCopyWith<$Res> {
  factory _$PhraseCoachingEntityCopyWith(_PhraseCoachingEntity value, $Res Function(_PhraseCoachingEntity) _then) = __$PhraseCoachingEntityCopyWithImpl;
@override @useResult
$Res call({
 PhraseCoachingFocus focus, String originalText, String improvedText, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceEntity> sources, double confidence, String? recommendationId
});




}
/// @nodoc
class __$PhraseCoachingEntityCopyWithImpl<$Res>
    implements _$PhraseCoachingEntityCopyWith<$Res> {
  __$PhraseCoachingEntityCopyWithImpl(this._self, this._then);

  final _PhraseCoachingEntity _self;
  final $Res Function(_PhraseCoachingEntity) _then;

/// Create a copy of PhraseCoachingEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? focus = null,Object? originalText = null,Object? improvedText = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,Object? recommendationId = freezed,}) {
  return _then(_PhraseCoachingEntity(
focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as PhraseCoachingFocus,originalText: null == originalText ? _self.originalText : originalText // ignore: cast_nullable_to_non_nullable
as String,improvedText: null == improvedText ? _self.improvedText : improvedText // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceEntity>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,recommendationId: freezed == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$StrategicCallAdviceEntity {

 StrategicAdviceCategory get category; AdvicePriority get priority; String get title; String get advice; String get rationale; List<String> get evidenceSegmentIds; List<CoachingSourceEntity> get sources; double get confidence; String? get recommendationId;
/// Create a copy of StrategicCallAdviceEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StrategicCallAdviceEntityCopyWith<StrategicCallAdviceEntity> get copyWith => _$StrategicCallAdviceEntityCopyWithImpl<StrategicCallAdviceEntity>(this as StrategicCallAdviceEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StrategicCallAdviceEntity&&(identical(other.category, category) || other.category == category)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.title, title) || other.title == title)&&(identical(other.advice, advice) || other.advice == advice)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other.evidenceSegmentIds, evidenceSegmentIds)&&const DeepCollectionEquality().equals(other.sources, sources)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId));
}


@override
int get hashCode => Object.hash(runtimeType,category,priority,title,advice,rationale,const DeepCollectionEquality().hash(evidenceSegmentIds),const DeepCollectionEquality().hash(sources),confidence,recommendationId);

@override
String toString() {
  return 'StrategicCallAdviceEntity(category: $category, priority: $priority, title: $title, advice: $advice, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence, recommendationId: $recommendationId)';
}


}

/// @nodoc
abstract mixin class $StrategicCallAdviceEntityCopyWith<$Res>  {
  factory $StrategicCallAdviceEntityCopyWith(StrategicCallAdviceEntity value, $Res Function(StrategicCallAdviceEntity) _then) = _$StrategicCallAdviceEntityCopyWithImpl;
@useResult
$Res call({
 StrategicAdviceCategory category, AdvicePriority priority, String title, String advice, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceEntity> sources, double confidence, String? recommendationId
});




}
/// @nodoc
class _$StrategicCallAdviceEntityCopyWithImpl<$Res>
    implements $StrategicCallAdviceEntityCopyWith<$Res> {
  _$StrategicCallAdviceEntityCopyWithImpl(this._self, this._then);

  final StrategicCallAdviceEntity _self;
  final $Res Function(StrategicCallAdviceEntity) _then;

/// Create a copy of StrategicCallAdviceEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? priority = null,Object? title = null,Object? advice = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,Object? recommendationId = freezed,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as StrategicAdviceCategory,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as AdvicePriority,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,advice: null == advice ? _self.advice : advice // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self.evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceEntity>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,recommendationId: freezed == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StrategicCallAdviceEntity].
extension StrategicCallAdviceEntityPatterns on StrategicCallAdviceEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StrategicCallAdviceEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StrategicCallAdviceEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StrategicCallAdviceEntity value)  $default,){
final _that = this;
switch (_that) {
case _StrategicCallAdviceEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StrategicCallAdviceEntity value)?  $default,){
final _that = this;
switch (_that) {
case _StrategicCallAdviceEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StrategicAdviceCategory category,  AdvicePriority priority,  String title,  String advice,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceEntity> sources,  double confidence,  String? recommendationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StrategicCallAdviceEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StrategicAdviceCategory category,  AdvicePriority priority,  String title,  String advice,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceEntity> sources,  double confidence,  String? recommendationId)  $default,) {final _that = this;
switch (_that) {
case _StrategicCallAdviceEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StrategicAdviceCategory category,  AdvicePriority priority,  String title,  String advice,  String rationale,  List<String> evidenceSegmentIds,  List<CoachingSourceEntity> sources,  double confidence,  String? recommendationId)?  $default,) {final _that = this;
switch (_that) {
case _StrategicCallAdviceEntity() when $default != null:
return $default(_that.category,_that.priority,_that.title,_that.advice,_that.rationale,_that.evidenceSegmentIds,_that.sources,_that.confidence,_that.recommendationId);case _:
  return null;

}
}

}

/// @nodoc


class _StrategicCallAdviceEntity implements StrategicCallAdviceEntity {
  const _StrategicCallAdviceEntity({required this.category, required this.priority, required this.title, required this.advice, required this.rationale, required final  List<String> evidenceSegmentIds, required final  List<CoachingSourceEntity> sources, required this.confidence, this.recommendationId}): _evidenceSegmentIds = evidenceSegmentIds,_sources = sources;
  

@override final  StrategicAdviceCategory category;
@override final  AdvicePriority priority;
@override final  String title;
@override final  String advice;
@override final  String rationale;
 final  List<String> _evidenceSegmentIds;
@override List<String> get evidenceSegmentIds {
  if (_evidenceSegmentIds is EqualUnmodifiableListView) return _evidenceSegmentIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceSegmentIds);
}

 final  List<CoachingSourceEntity> _sources;
@override List<CoachingSourceEntity> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}

@override final  double confidence;
@override final  String? recommendationId;

/// Create a copy of StrategicCallAdviceEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StrategicCallAdviceEntityCopyWith<_StrategicCallAdviceEntity> get copyWith => __$StrategicCallAdviceEntityCopyWithImpl<_StrategicCallAdviceEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StrategicCallAdviceEntity&&(identical(other.category, category) || other.category == category)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.title, title) || other.title == title)&&(identical(other.advice, advice) || other.advice == advice)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&const DeepCollectionEquality().equals(other._evidenceSegmentIds, _evidenceSegmentIds)&&const DeepCollectionEquality().equals(other._sources, _sources)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.recommendationId, recommendationId) || other.recommendationId == recommendationId));
}


@override
int get hashCode => Object.hash(runtimeType,category,priority,title,advice,rationale,const DeepCollectionEquality().hash(_evidenceSegmentIds),const DeepCollectionEquality().hash(_sources),confidence,recommendationId);

@override
String toString() {
  return 'StrategicCallAdviceEntity(category: $category, priority: $priority, title: $title, advice: $advice, rationale: $rationale, evidenceSegmentIds: $evidenceSegmentIds, sources: $sources, confidence: $confidence, recommendationId: $recommendationId)';
}


}

/// @nodoc
abstract mixin class _$StrategicCallAdviceEntityCopyWith<$Res> implements $StrategicCallAdviceEntityCopyWith<$Res> {
  factory _$StrategicCallAdviceEntityCopyWith(_StrategicCallAdviceEntity value, $Res Function(_StrategicCallAdviceEntity) _then) = __$StrategicCallAdviceEntityCopyWithImpl;
@override @useResult
$Res call({
 StrategicAdviceCategory category, AdvicePriority priority, String title, String advice, String rationale, List<String> evidenceSegmentIds, List<CoachingSourceEntity> sources, double confidence, String? recommendationId
});




}
/// @nodoc
class __$StrategicCallAdviceEntityCopyWithImpl<$Res>
    implements _$StrategicCallAdviceEntityCopyWith<$Res> {
  __$StrategicCallAdviceEntityCopyWithImpl(this._self, this._then);

  final _StrategicCallAdviceEntity _self;
  final $Res Function(_StrategicCallAdviceEntity) _then;

/// Create a copy of StrategicCallAdviceEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? priority = null,Object? title = null,Object? advice = null,Object? rationale = null,Object? evidenceSegmentIds = null,Object? sources = null,Object? confidence = null,Object? recommendationId = freezed,}) {
  return _then(_StrategicCallAdviceEntity(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as StrategicAdviceCategory,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as AdvicePriority,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,advice: null == advice ? _self.advice : advice // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,evidenceSegmentIds: null == evidenceSegmentIds ? _self._evidenceSegmentIds : evidenceSegmentIds // ignore: cast_nullable_to_non_nullable
as List<String>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<CoachingSourceEntity>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,recommendationId: freezed == recommendationId ? _self.recommendationId : recommendationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CallDebriefEntity {

 String get sessionId; GroundedCallTextEntity get summary; List<GroundedCallTextEntity> get keyPoints; List<CallCommitmentEntity> get commitments; CallFollowUpEntity get followUp; DateTime get generatedAt; String get provider; String get model; List<GroundedCallTextEntity> get strengths; List<CallPerformanceAxisEntity> get performanceAxes; List<PhraseCoachingEntity> get phraseCoaching; List<StrategicCallAdviceEntity> get strategicAdvice; CallImprovementEntity? get improvement;
/// Create a copy of CallDebriefEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallDebriefEntityCopyWith<CallDebriefEntity> get copyWith => _$CallDebriefEntityCopyWithImpl<CallDebriefEntity>(this as CallDebriefEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallDebriefEntity&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.keyPoints, keyPoints)&&const DeepCollectionEquality().equals(other.commitments, commitments)&&(identical(other.followUp, followUp) || other.followUp == followUp)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.strengths, strengths)&&const DeepCollectionEquality().equals(other.performanceAxes, performanceAxes)&&const DeepCollectionEquality().equals(other.phraseCoaching, phraseCoaching)&&const DeepCollectionEquality().equals(other.strategicAdvice, strategicAdvice)&&(identical(other.improvement, improvement) || other.improvement == improvement));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,summary,const DeepCollectionEquality().hash(keyPoints),const DeepCollectionEquality().hash(commitments),followUp,generatedAt,provider,model,const DeepCollectionEquality().hash(strengths),const DeepCollectionEquality().hash(performanceAxes),const DeepCollectionEquality().hash(phraseCoaching),const DeepCollectionEquality().hash(strategicAdvice),improvement);

@override
String toString() {
  return 'CallDebriefEntity(sessionId: $sessionId, summary: $summary, keyPoints: $keyPoints, commitments: $commitments, followUp: $followUp, generatedAt: $generatedAt, provider: $provider, model: $model, strengths: $strengths, performanceAxes: $performanceAxes, phraseCoaching: $phraseCoaching, strategicAdvice: $strategicAdvice, improvement: $improvement)';
}


}

/// @nodoc
abstract mixin class $CallDebriefEntityCopyWith<$Res>  {
  factory $CallDebriefEntityCopyWith(CallDebriefEntity value, $Res Function(CallDebriefEntity) _then) = _$CallDebriefEntityCopyWithImpl;
@useResult
$Res call({
 String sessionId, GroundedCallTextEntity summary, List<GroundedCallTextEntity> keyPoints, List<CallCommitmentEntity> commitments, CallFollowUpEntity followUp, DateTime generatedAt, String provider, String model, List<GroundedCallTextEntity> strengths, List<CallPerformanceAxisEntity> performanceAxes, List<PhraseCoachingEntity> phraseCoaching, List<StrategicCallAdviceEntity> strategicAdvice, CallImprovementEntity? improvement
});


$GroundedCallTextEntityCopyWith<$Res> get summary;$CallFollowUpEntityCopyWith<$Res> get followUp;$CallImprovementEntityCopyWith<$Res>? get improvement;

}
/// @nodoc
class _$CallDebriefEntityCopyWithImpl<$Res>
    implements $CallDebriefEntityCopyWith<$Res> {
  _$CallDebriefEntityCopyWithImpl(this._self, this._then);

  final CallDebriefEntity _self;
  final $Res Function(CallDebriefEntity) _then;

/// Create a copy of CallDebriefEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? summary = null,Object? keyPoints = null,Object? commitments = null,Object? followUp = null,Object? generatedAt = null,Object? provider = null,Object? model = null,Object? strengths = null,Object? performanceAxes = null,Object? phraseCoaching = null,Object? strategicAdvice = null,Object? improvement = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as GroundedCallTextEntity,keyPoints: null == keyPoints ? _self.keyPoints : keyPoints // ignore: cast_nullable_to_non_nullable
as List<GroundedCallTextEntity>,commitments: null == commitments ? _self.commitments : commitments // ignore: cast_nullable_to_non_nullable
as List<CallCommitmentEntity>,followUp: null == followUp ? _self.followUp : followUp // ignore: cast_nullable_to_non_nullable
as CallFollowUpEntity,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,strengths: null == strengths ? _self.strengths : strengths // ignore: cast_nullable_to_non_nullable
as List<GroundedCallTextEntity>,performanceAxes: null == performanceAxes ? _self.performanceAxes : performanceAxes // ignore: cast_nullable_to_non_nullable
as List<CallPerformanceAxisEntity>,phraseCoaching: null == phraseCoaching ? _self.phraseCoaching : phraseCoaching // ignore: cast_nullable_to_non_nullable
as List<PhraseCoachingEntity>,strategicAdvice: null == strategicAdvice ? _self.strategicAdvice : strategicAdvice // ignore: cast_nullable_to_non_nullable
as List<StrategicCallAdviceEntity>,improvement: freezed == improvement ? _self.improvement : improvement // ignore: cast_nullable_to_non_nullable
as CallImprovementEntity?,
  ));
}
/// Create a copy of CallDebriefEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroundedCallTextEntityCopyWith<$Res> get summary {
  
  return $GroundedCallTextEntityCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of CallDebriefEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallFollowUpEntityCopyWith<$Res> get followUp {
  
  return $CallFollowUpEntityCopyWith<$Res>(_self.followUp, (value) {
    return _then(_self.copyWith(followUp: value));
  });
}/// Create a copy of CallDebriefEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallImprovementEntityCopyWith<$Res>? get improvement {
    if (_self.improvement == null) {
    return null;
  }

  return $CallImprovementEntityCopyWith<$Res>(_self.improvement!, (value) {
    return _then(_self.copyWith(improvement: value));
  });
}
}


/// Adds pattern-matching-related methods to [CallDebriefEntity].
extension CallDebriefEntityPatterns on CallDebriefEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallDebriefEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallDebriefEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallDebriefEntity value)  $default,){
final _that = this;
switch (_that) {
case _CallDebriefEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallDebriefEntity value)?  $default,){
final _that = this;
switch (_that) {
case _CallDebriefEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  GroundedCallTextEntity summary,  List<GroundedCallTextEntity> keyPoints,  List<CallCommitmentEntity> commitments,  CallFollowUpEntity followUp,  DateTime generatedAt,  String provider,  String model,  List<GroundedCallTextEntity> strengths,  List<CallPerformanceAxisEntity> performanceAxes,  List<PhraseCoachingEntity> phraseCoaching,  List<StrategicCallAdviceEntity> strategicAdvice,  CallImprovementEntity? improvement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallDebriefEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  GroundedCallTextEntity summary,  List<GroundedCallTextEntity> keyPoints,  List<CallCommitmentEntity> commitments,  CallFollowUpEntity followUp,  DateTime generatedAt,  String provider,  String model,  List<GroundedCallTextEntity> strengths,  List<CallPerformanceAxisEntity> performanceAxes,  List<PhraseCoachingEntity> phraseCoaching,  List<StrategicCallAdviceEntity> strategicAdvice,  CallImprovementEntity? improvement)  $default,) {final _that = this;
switch (_that) {
case _CallDebriefEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  GroundedCallTextEntity summary,  List<GroundedCallTextEntity> keyPoints,  List<CallCommitmentEntity> commitments,  CallFollowUpEntity followUp,  DateTime generatedAt,  String provider,  String model,  List<GroundedCallTextEntity> strengths,  List<CallPerformanceAxisEntity> performanceAxes,  List<PhraseCoachingEntity> phraseCoaching,  List<StrategicCallAdviceEntity> strategicAdvice,  CallImprovementEntity? improvement)?  $default,) {final _that = this;
switch (_that) {
case _CallDebriefEntity() when $default != null:
return $default(_that.sessionId,_that.summary,_that.keyPoints,_that.commitments,_that.followUp,_that.generatedAt,_that.provider,_that.model,_that.strengths,_that.performanceAxes,_that.phraseCoaching,_that.strategicAdvice,_that.improvement);case _:
  return null;

}
}

}

/// @nodoc


class _CallDebriefEntity implements CallDebriefEntity {
  const _CallDebriefEntity({required this.sessionId, required this.summary, required final  List<GroundedCallTextEntity> keyPoints, required final  List<CallCommitmentEntity> commitments, required this.followUp, required this.generatedAt, required this.provider, required this.model, final  List<GroundedCallTextEntity> strengths = const <GroundedCallTextEntity>[], final  List<CallPerformanceAxisEntity> performanceAxes = const <CallPerformanceAxisEntity>[], final  List<PhraseCoachingEntity> phraseCoaching = const <PhraseCoachingEntity>[], final  List<StrategicCallAdviceEntity> strategicAdvice = const <StrategicCallAdviceEntity>[], this.improvement}): _keyPoints = keyPoints,_commitments = commitments,_strengths = strengths,_performanceAxes = performanceAxes,_phraseCoaching = phraseCoaching,_strategicAdvice = strategicAdvice;
  

@override final  String sessionId;
@override final  GroundedCallTextEntity summary;
 final  List<GroundedCallTextEntity> _keyPoints;
@override List<GroundedCallTextEntity> get keyPoints {
  if (_keyPoints is EqualUnmodifiableListView) return _keyPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keyPoints);
}

 final  List<CallCommitmentEntity> _commitments;
@override List<CallCommitmentEntity> get commitments {
  if (_commitments is EqualUnmodifiableListView) return _commitments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_commitments);
}

@override final  CallFollowUpEntity followUp;
@override final  DateTime generatedAt;
@override final  String provider;
@override final  String model;
 final  List<GroundedCallTextEntity> _strengths;
@override@JsonKey() List<GroundedCallTextEntity> get strengths {
  if (_strengths is EqualUnmodifiableListView) return _strengths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strengths);
}

 final  List<CallPerformanceAxisEntity> _performanceAxes;
@override@JsonKey() List<CallPerformanceAxisEntity> get performanceAxes {
  if (_performanceAxes is EqualUnmodifiableListView) return _performanceAxes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_performanceAxes);
}

 final  List<PhraseCoachingEntity> _phraseCoaching;
@override@JsonKey() List<PhraseCoachingEntity> get phraseCoaching {
  if (_phraseCoaching is EqualUnmodifiableListView) return _phraseCoaching;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_phraseCoaching);
}

 final  List<StrategicCallAdviceEntity> _strategicAdvice;
@override@JsonKey() List<StrategicCallAdviceEntity> get strategicAdvice {
  if (_strategicAdvice is EqualUnmodifiableListView) return _strategicAdvice;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_strategicAdvice);
}

@override final  CallImprovementEntity? improvement;

/// Create a copy of CallDebriefEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallDebriefEntityCopyWith<_CallDebriefEntity> get copyWith => __$CallDebriefEntityCopyWithImpl<_CallDebriefEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallDebriefEntity&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other._keyPoints, _keyPoints)&&const DeepCollectionEquality().equals(other._commitments, _commitments)&&(identical(other.followUp, followUp) || other.followUp == followUp)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other._strengths, _strengths)&&const DeepCollectionEquality().equals(other._performanceAxes, _performanceAxes)&&const DeepCollectionEquality().equals(other._phraseCoaching, _phraseCoaching)&&const DeepCollectionEquality().equals(other._strategicAdvice, _strategicAdvice)&&(identical(other.improvement, improvement) || other.improvement == improvement));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,summary,const DeepCollectionEquality().hash(_keyPoints),const DeepCollectionEquality().hash(_commitments),followUp,generatedAt,provider,model,const DeepCollectionEquality().hash(_strengths),const DeepCollectionEquality().hash(_performanceAxes),const DeepCollectionEquality().hash(_phraseCoaching),const DeepCollectionEquality().hash(_strategicAdvice),improvement);

@override
String toString() {
  return 'CallDebriefEntity(sessionId: $sessionId, summary: $summary, keyPoints: $keyPoints, commitments: $commitments, followUp: $followUp, generatedAt: $generatedAt, provider: $provider, model: $model, strengths: $strengths, performanceAxes: $performanceAxes, phraseCoaching: $phraseCoaching, strategicAdvice: $strategicAdvice, improvement: $improvement)';
}


}

/// @nodoc
abstract mixin class _$CallDebriefEntityCopyWith<$Res> implements $CallDebriefEntityCopyWith<$Res> {
  factory _$CallDebriefEntityCopyWith(_CallDebriefEntity value, $Res Function(_CallDebriefEntity) _then) = __$CallDebriefEntityCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, GroundedCallTextEntity summary, List<GroundedCallTextEntity> keyPoints, List<CallCommitmentEntity> commitments, CallFollowUpEntity followUp, DateTime generatedAt, String provider, String model, List<GroundedCallTextEntity> strengths, List<CallPerformanceAxisEntity> performanceAxes, List<PhraseCoachingEntity> phraseCoaching, List<StrategicCallAdviceEntity> strategicAdvice, CallImprovementEntity? improvement
});


@override $GroundedCallTextEntityCopyWith<$Res> get summary;@override $CallFollowUpEntityCopyWith<$Res> get followUp;@override $CallImprovementEntityCopyWith<$Res>? get improvement;

}
/// @nodoc
class __$CallDebriefEntityCopyWithImpl<$Res>
    implements _$CallDebriefEntityCopyWith<$Res> {
  __$CallDebriefEntityCopyWithImpl(this._self, this._then);

  final _CallDebriefEntity _self;
  final $Res Function(_CallDebriefEntity) _then;

/// Create a copy of CallDebriefEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? summary = null,Object? keyPoints = null,Object? commitments = null,Object? followUp = null,Object? generatedAt = null,Object? provider = null,Object? model = null,Object? strengths = null,Object? performanceAxes = null,Object? phraseCoaching = null,Object? strategicAdvice = null,Object? improvement = freezed,}) {
  return _then(_CallDebriefEntity(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as GroundedCallTextEntity,keyPoints: null == keyPoints ? _self._keyPoints : keyPoints // ignore: cast_nullable_to_non_nullable
as List<GroundedCallTextEntity>,commitments: null == commitments ? _self._commitments : commitments // ignore: cast_nullable_to_non_nullable
as List<CallCommitmentEntity>,followUp: null == followUp ? _self.followUp : followUp // ignore: cast_nullable_to_non_nullable
as CallFollowUpEntity,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,strengths: null == strengths ? _self._strengths : strengths // ignore: cast_nullable_to_non_nullable
as List<GroundedCallTextEntity>,performanceAxes: null == performanceAxes ? _self._performanceAxes : performanceAxes // ignore: cast_nullable_to_non_nullable
as List<CallPerformanceAxisEntity>,phraseCoaching: null == phraseCoaching ? _self._phraseCoaching : phraseCoaching // ignore: cast_nullable_to_non_nullable
as List<PhraseCoachingEntity>,strategicAdvice: null == strategicAdvice ? _self._strategicAdvice : strategicAdvice // ignore: cast_nullable_to_non_nullable
as List<StrategicCallAdviceEntity>,improvement: freezed == improvement ? _self.improvement : improvement // ignore: cast_nullable_to_non_nullable
as CallImprovementEntity?,
  ));
}

/// Create a copy of CallDebriefEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroundedCallTextEntityCopyWith<$Res> get summary {
  
  return $GroundedCallTextEntityCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}/// Create a copy of CallDebriefEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallFollowUpEntityCopyWith<$Res> get followUp {
  
  return $CallFollowUpEntityCopyWith<$Res>(_self.followUp, (value) {
    return _then(_self.copyWith(followUp: value));
  });
}/// Create a copy of CallDebriefEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallImprovementEntityCopyWith<$Res>? get improvement {
    if (_self.improvement == null) {
    return null;
  }

  return $CallImprovementEntityCopyWith<$Res>(_self.improvement!, (value) {
    return _then(_self.copyWith(improvement: value));
  });
}
}

// dart format on
