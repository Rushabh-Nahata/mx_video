// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScanState {

 ScanPhase get phase; int get scanned; int get total; int get foldersFound; int get thumbnailsGenerated; String? get currentFile; String? get errorMessage; DateTime? get startedAt; DateTime? get completedAt;
/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanStateCopyWith<ScanState> get copyWith => _$ScanStateCopyWithImpl<ScanState>(this as ScanState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.scanned, scanned) || other.scanned == scanned)&&(identical(other.total, total) || other.total == total)&&(identical(other.foldersFound, foldersFound) || other.foldersFound == foldersFound)&&(identical(other.thumbnailsGenerated, thumbnailsGenerated) || other.thumbnailsGenerated == thumbnailsGenerated)&&(identical(other.currentFile, currentFile) || other.currentFile == currentFile)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,phase,scanned,total,foldersFound,thumbnailsGenerated,currentFile,errorMessage,startedAt,completedAt);

@override
String toString() {
  return 'ScanState(phase: $phase, scanned: $scanned, total: $total, foldersFound: $foldersFound, thumbnailsGenerated: $thumbnailsGenerated, currentFile: $currentFile, errorMessage: $errorMessage, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $ScanStateCopyWith<$Res>  {
  factory $ScanStateCopyWith(ScanState value, $Res Function(ScanState) _then) = _$ScanStateCopyWithImpl;
@useResult
$Res call({
 ScanPhase phase, int scanned, int total, int foldersFound, int thumbnailsGenerated, String? currentFile, String? errorMessage, DateTime? startedAt, DateTime? completedAt
});




}
/// @nodoc
class _$ScanStateCopyWithImpl<$Res>
    implements $ScanStateCopyWith<$Res> {
  _$ScanStateCopyWithImpl(this._self, this._then);

  final ScanState _self;
  final $Res Function(ScanState) _then;

/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? scanned = null,Object? total = null,Object? foldersFound = null,Object? thumbnailsGenerated = null,Object? currentFile = freezed,Object? errorMessage = freezed,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ScanPhase,scanned: null == scanned ? _self.scanned : scanned // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,foldersFound: null == foldersFound ? _self.foldersFound : foldersFound // ignore: cast_nullable_to_non_nullable
as int,thumbnailsGenerated: null == thumbnailsGenerated ? _self.thumbnailsGenerated : thumbnailsGenerated // ignore: cast_nullable_to_non_nullable
as int,currentFile: freezed == currentFile ? _self.currentFile : currentFile // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanState].
extension ScanStatePatterns on ScanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanState value)  $default,){
final _that = this;
switch (_that) {
case _ScanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanState value)?  $default,){
final _that = this;
switch (_that) {
case _ScanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ScanPhase phase,  int scanned,  int total,  int foldersFound,  int thumbnailsGenerated,  String? currentFile,  String? errorMessage,  DateTime? startedAt,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanState() when $default != null:
return $default(_that.phase,_that.scanned,_that.total,_that.foldersFound,_that.thumbnailsGenerated,_that.currentFile,_that.errorMessage,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ScanPhase phase,  int scanned,  int total,  int foldersFound,  int thumbnailsGenerated,  String? currentFile,  String? errorMessage,  DateTime? startedAt,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _ScanState():
return $default(_that.phase,_that.scanned,_that.total,_that.foldersFound,_that.thumbnailsGenerated,_that.currentFile,_that.errorMessage,_that.startedAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ScanPhase phase,  int scanned,  int total,  int foldersFound,  int thumbnailsGenerated,  String? currentFile,  String? errorMessage,  DateTime? startedAt,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _ScanState() when $default != null:
return $default(_that.phase,_that.scanned,_that.total,_that.foldersFound,_that.thumbnailsGenerated,_that.currentFile,_that.errorMessage,_that.startedAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ScanState extends ScanState {
  const _ScanState({this.phase = ScanPhase.idle, this.scanned = 0, this.total = 0, this.foldersFound = 0, this.thumbnailsGenerated = 0, this.currentFile, this.errorMessage, this.startedAt, this.completedAt}): super._();
  

@override@JsonKey() final  ScanPhase phase;
@override@JsonKey() final  int scanned;
@override@JsonKey() final  int total;
@override@JsonKey() final  int foldersFound;
@override@JsonKey() final  int thumbnailsGenerated;
@override final  String? currentFile;
@override final  String? errorMessage;
@override final  DateTime? startedAt;
@override final  DateTime? completedAt;

/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanStateCopyWith<_ScanState> get copyWith => __$ScanStateCopyWithImpl<_ScanState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.scanned, scanned) || other.scanned == scanned)&&(identical(other.total, total) || other.total == total)&&(identical(other.foldersFound, foldersFound) || other.foldersFound == foldersFound)&&(identical(other.thumbnailsGenerated, thumbnailsGenerated) || other.thumbnailsGenerated == thumbnailsGenerated)&&(identical(other.currentFile, currentFile) || other.currentFile == currentFile)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,phase,scanned,total,foldersFound,thumbnailsGenerated,currentFile,errorMessage,startedAt,completedAt);

@override
String toString() {
  return 'ScanState(phase: $phase, scanned: $scanned, total: $total, foldersFound: $foldersFound, thumbnailsGenerated: $thumbnailsGenerated, currentFile: $currentFile, errorMessage: $errorMessage, startedAt: $startedAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$ScanStateCopyWith<$Res> implements $ScanStateCopyWith<$Res> {
  factory _$ScanStateCopyWith(_ScanState value, $Res Function(_ScanState) _then) = __$ScanStateCopyWithImpl;
@override @useResult
$Res call({
 ScanPhase phase, int scanned, int total, int foldersFound, int thumbnailsGenerated, String? currentFile, String? errorMessage, DateTime? startedAt, DateTime? completedAt
});




}
/// @nodoc
class __$ScanStateCopyWithImpl<$Res>
    implements _$ScanStateCopyWith<$Res> {
  __$ScanStateCopyWithImpl(this._self, this._then);

  final _ScanState _self;
  final $Res Function(_ScanState) _then;

/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? scanned = null,Object? total = null,Object? foldersFound = null,Object? thumbnailsGenerated = null,Object? currentFile = freezed,Object? errorMessage = freezed,Object? startedAt = freezed,Object? completedAt = freezed,}) {
  return _then(_ScanState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as ScanPhase,scanned: null == scanned ? _self.scanned : scanned // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,foldersFound: null == foldersFound ? _self.foldersFound : foldersFound // ignore: cast_nullable_to_non_nullable
as int,thumbnailsGenerated: null == thumbnailsGenerated ? _self.thumbnailsGenerated : thumbnailsGenerated // ignore: cast_nullable_to_non_nullable
as int,currentFile: freezed == currentFile ? _self.currentFile : currentFile // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
