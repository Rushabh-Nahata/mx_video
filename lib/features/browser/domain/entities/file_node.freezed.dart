// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'file_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FileNode {

 String get path; String get name; String get extension; int get sizeBytes; DateTime get modifiedAt; bool get isSelected;
/// Create a copy of FileNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FileNodeCopyWith<FileNode> get copyWith => _$FileNodeCopyWithImpl<FileNode>(this as FileNode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FileNode&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,extension,sizeBytes,modifiedAt,isSelected);

@override
String toString() {
  return 'FileNode(path: $path, name: $name, extension: $extension, sizeBytes: $sizeBytes, modifiedAt: $modifiedAt, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class $FileNodeCopyWith<$Res>  {
  factory $FileNodeCopyWith(FileNode value, $Res Function(FileNode) _then) = _$FileNodeCopyWithImpl;
@useResult
$Res call({
 String path, String name, String extension, int sizeBytes, DateTime modifiedAt, bool isSelected
});




}
/// @nodoc
class _$FileNodeCopyWithImpl<$Res>
    implements $FileNodeCopyWith<$Res> {
  _$FileNodeCopyWithImpl(this._self, this._then);

  final FileNode _self;
  final $Res Function(FileNode) _then;

/// Create a copy of FileNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? name = null,Object? extension = null,Object? sizeBytes = null,Object? modifiedAt = null,Object? isSelected = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FileNode].
extension FileNodePatterns on FileNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FileNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FileNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FileNode value)  $default,){
final _that = this;
switch (_that) {
case _FileNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FileNode value)?  $default,){
final _that = this;
switch (_that) {
case _FileNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  String name,  String extension,  int sizeBytes,  DateTime modifiedAt,  bool isSelected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FileNode() when $default != null:
return $default(_that.path,_that.name,_that.extension,_that.sizeBytes,_that.modifiedAt,_that.isSelected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  String name,  String extension,  int sizeBytes,  DateTime modifiedAt,  bool isSelected)  $default,) {final _that = this;
switch (_that) {
case _FileNode():
return $default(_that.path,_that.name,_that.extension,_that.sizeBytes,_that.modifiedAt,_that.isSelected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  String name,  String extension,  int sizeBytes,  DateTime modifiedAt,  bool isSelected)?  $default,) {final _that = this;
switch (_that) {
case _FileNode() when $default != null:
return $default(_that.path,_that.name,_that.extension,_that.sizeBytes,_that.modifiedAt,_that.isSelected);case _:
  return null;

}
}

}

/// @nodoc


class _FileNode extends FileNode {
  const _FileNode({required this.path, required this.name, required this.extension, required this.sizeBytes, required this.modifiedAt, this.isSelected = false}): super._();
  

@override final  String path;
@override final  String name;
@override final  String extension;
@override final  int sizeBytes;
@override final  DateTime modifiedAt;
@override@JsonKey() final  bool isSelected;

/// Create a copy of FileNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FileNodeCopyWith<_FileNode> get copyWith => __$FileNodeCopyWithImpl<_FileNode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FileNode&&(identical(other.path, path) || other.path == path)&&(identical(other.name, name) || other.name == name)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.modifiedAt, modifiedAt) || other.modifiedAt == modifiedAt)&&(identical(other.isSelected, isSelected) || other.isSelected == isSelected));
}


@override
int get hashCode => Object.hash(runtimeType,path,name,extension,sizeBytes,modifiedAt,isSelected);

@override
String toString() {
  return 'FileNode(path: $path, name: $name, extension: $extension, sizeBytes: $sizeBytes, modifiedAt: $modifiedAt, isSelected: $isSelected)';
}


}

/// @nodoc
abstract mixin class _$FileNodeCopyWith<$Res> implements $FileNodeCopyWith<$Res> {
  factory _$FileNodeCopyWith(_FileNode value, $Res Function(_FileNode) _then) = __$FileNodeCopyWithImpl;
@override @useResult
$Res call({
 String path, String name, String extension, int sizeBytes, DateTime modifiedAt, bool isSelected
});




}
/// @nodoc
class __$FileNodeCopyWithImpl<$Res>
    implements _$FileNodeCopyWith<$Res> {
  __$FileNodeCopyWithImpl(this._self, this._then);

  final _FileNode _self;
  final $Res Function(_FileNode) _then;

/// Create a copy of FileNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? name = null,Object? extension = null,Object? sizeBytes = null,Object? modifiedAt = null,Object? isSelected = null,}) {
  return _then(_FileNode(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,modifiedAt: null == modifiedAt ? _self.modifiedAt : modifiedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isSelected: null == isSelected ? _self.isSelected : isSelected // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
