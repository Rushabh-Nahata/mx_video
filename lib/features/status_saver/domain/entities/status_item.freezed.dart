// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StatusItem {

 String get path; String get name; StatusType get type; DateTime get dateModified; int get sizeBytes; bool get isSaved;
/// Create a copy of StatusItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusItemCopyWith<StatusItem> get copyWith => _$StatusItemCopyWithImpl<StatusItem>(this as StatusItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusItem&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.dateModified, dateModified) || other.dateModified == dateModified)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,type,dateModified,sizeBytes,isSaved);

@override
String toString() {
  return 'StatusItem(path: $path, name: $name, type: $type, dateModified: $dateModified, sizeBytes: $sizeBytes, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class $StatusItemCopyWith<$Res>  {
  factory $StatusItemCopyWith(StatusItem value, $Res Function(StatusItem) _then) = _$StatusItemCopyWithImpl;
@useResult
$Res call({
 String path, String name, StatusType type, DateTime dateModified, int sizeBytes, bool isSaved
});




}
/// @nodoc
class _$StatusItemCopyWithImpl<$Res>
    implements $StatusItemCopyWith<$Res> {
  _$StatusItemCopyWithImpl(this._self, this._then);

  final StatusItem _self;
  final $Res Function(StatusItem) _then;

/// Create a copy of StatusItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? name = null,Object? type = null,Object? dateModified = null,Object? sizeBytes = null,Object? isSaved = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as StatusType,dateModified: null == dateModified ? _self.dateModified : dateModified // ignore: cast_nullable_to_non_nullable
as DateTime,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StatusItem].
extension StatusItemPatterns on StatusItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatusItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatusItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatusItem value)  $default,){
final _that = this;
switch (_that) {
case _StatusItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatusItem value)?  $default,){
final _that = this;
switch (_that) {
case _StatusItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String name,  StatusType type,  DateTime dateModified,  int sizeBytes,  bool isSaved)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatusItem() when $default != null:
return $default(_that.path,_that.name,_that.type,_that.dateModified,_that.sizeBytes,_that.isSaved);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String name,  StatusType type,  DateTime dateModified,  int sizeBytes,  bool isSaved)  $default,) {final _that = this;
switch (_that) {
case _StatusItem():
return $default(_that.path,_that.name,_that.type,_that.dateModified,_that.sizeBytes,_that.isSaved);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String name,  StatusType type,  DateTime dateModified,  int sizeBytes,  bool isSaved)?  $default,) {final _that = this;
switch (_that) {
case _StatusItem() when $default != null:
return $default(_that.path,_that.name,_that.type,_that.dateModified,_that.sizeBytes,_that.isSaved);case _:
  return null;

}
}

}

/// @nodoc


class _StatusItem extends StatusItem {
  const _StatusItem({required this.path, required this.name, required this.type, required this.dateModified, required this.sizeBytes, this.isSaved = false}): super._();
  

@override final  String path;
@override final  String name;
@override final  StatusType type;
@override final  DateTime dateModified;
@override final  int sizeBytes;
@override@JsonKey() final  bool isSaved;

/// Create a copy of StatusItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatusItemCopyWith<_StatusItem> get copyWith => __$StatusItemCopyWithImpl<_StatusItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatusItem&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.dateModified, dateModified) || other.dateModified == dateModified)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.isSaved, isSaved) || other.isSaved == isSaved));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,type,dateModified,sizeBytes,isSaved);

@override
String toString() {
  return 'StatusItem(path: $path, name: $name, type: $type, dateModified: $dateModified, sizeBytes: $sizeBytes, isSaved: $isSaved)';
}


}

/// @nodoc
abstract mixin class _$StatusItemCopyWith<$Res> implements $StatusItemCopyWith<$Res> {
  factory _$StatusItemCopyWith(_StatusItem value, $Res Function(_StatusItem) _then) = __$StatusItemCopyWithImpl;
@override @useResult
$Res call({
 String path, String name, StatusType type, DateTime dateModified, int sizeBytes, bool isSaved
});




}
/// @nodoc
class __$StatusItemCopyWithImpl<$Res>
    implements _$StatusItemCopyWith<$Res> {
  __$StatusItemCopyWithImpl(this._self, this._then);

  final _StatusItem _self;
  final $Res Function(_StatusItem) _then;

/// Create a copy of StatusItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,Object? type = null,Object? dateModified = null,Object? sizeBytes = null,Object? isSaved = null,}) {
  return _then(_StatusItem(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as StatusType,dateModified: null == dateModified ? _self.dateModified : dateModified // ignore: cast_nullable_to_non_nullable
as DateTime,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,isSaved: null == isSaved ? _self.isSaved : isSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
