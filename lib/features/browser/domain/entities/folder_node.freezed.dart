// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'folder_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FolderNode {

 String get path; String get name; DateTime get modifiedAt; int get childCount;
/// Create a copy of FolderNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FolderNodeCopyWith<FolderNode> get copyWith => _$FolderNodeCopyWithImpl<FolderNode>(this as FolderNode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FolderNode&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt)&&(identical(other.childCount, childCount) || other.childCount == childCount));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,modifiedAt,childCount);

@override
String toString() {
  return 'FolderNode(path: $path, name: $name, modifiedAt: $modifiedAt, childCount: $childCount)';
}


}

/// @nodoc
abstract mixin class $FolderNodeCopyWith<$Res>  {
  factory $FolderNodeCopyWith(FolderNode value, $Res Function(FolderNode) _then) = _$FolderNodeCopyWithImpl;
@useResult
$Res call({
 String path, String name, DateTime modifiedAt, int childCount
});




}
/// @nodoc
class _$FolderNodeCopyWithImpl<$Res>
    implements $FolderNodeCopyWith<$Res> {
  _$FolderNodeCopyWithImpl(this._self, this._then);

  final FolderNode _self;
  final $Res Function(FolderNode) _then;

/// Create a copy of FolderNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? name = null,Object? modifiedAt = null,Object? childCount = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,childCount: null == childCount ? _self.childCount : childCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FolderNode].
extension FolderNodePatterns on FolderNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FolderNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FolderNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FolderNode value)  $default,){
final _that = this;
switch (_that) {
case _FolderNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FolderNode value)?  $default,){
final _that = this;
switch (_that) {
case _FolderNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String name,  DateTime modifiedAt,  int childCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FolderNode() when $default != null:
return $default(_that.path,_that.name,_that.modifiedAt,_that.childCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String name,  DateTime modifiedAt,  int childCount)  $default,) {final _that = this;
switch (_that) {
case _FolderNode():
return $default(_that.path,_that.name,_that.modifiedAt,_that.childCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String name,  DateTime modifiedAt,  int childCount)?  $default,) {final _that = this;
switch (_that) {
case _FolderNode() when $default != null:
return $default(_that.path,_that.name,_that.modifiedAt,_that.childCount);case _:
  return null;

}
}

}

/// @nodoc


class _FolderNode implements FolderNode {
  const _FolderNode({required this.path, required this.name, required this.modifiedAt, this.childCount = 0});
  

@override final  String path;
@override final  String name;
@override final  DateTime modifiedAt;
@override@JsonKey() final  int childCount;

/// Create a copy of FolderNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FolderNodeCopyWith<_FolderNode> get copyWith => __$FolderNodeCopyWithImpl<_FolderNode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FolderNode&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt)&&(identical(other.childCount, childCount) || other.childCount == childCount));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,modifiedAt,childCount);

@override
String toString() {
  return 'FolderNode(path: $path, name: $name, modifiedAt: $modifiedAt, childCount: $childCount)';
}


}

/// @nodoc
abstract mixin class _$FolderNodeCopyWith<$Res> implements $FolderNodeCopyWith<$Res> {
  factory _$FolderNodeCopyWith(_FolderNode value, $Res Function(_FolderNode) _then) = __$FolderNodeCopyWithImpl;
@override @useResult
$Res call({
 String path, String name, DateTime modifiedAt, int childCount
});




}
/// @nodoc
class __$FolderNodeCopyWithImpl<$Res>
    implements _$FolderNodeCopyWith<$Res> {
  __$FolderNodeCopyWithImpl(this._self, this._then);

  final _FolderNode _self;
  final $Res Function(_FolderNode) _then;

/// Create a copy of FolderNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,Object? modifiedAt = null,Object? childCount = null,}) {
  return _then(_FolderNode(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,childCount: null == childCount ? _self.childCount : childCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
