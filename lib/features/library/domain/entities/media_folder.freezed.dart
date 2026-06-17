// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaFolderEntity {

 int get id; String get absolutePath; String get name; int? get parentId; String? get thumbnailPath; int get videoCount; int get audioCount; bool get isWatched;
/// Create a copy of MediaFolderEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaFolderEntityCopyWith<MediaFolderEntity> get copyWith => _$MediaFolderEntityCopyWithImpl<MediaFolderEntity>(this as MediaFolderEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaFolderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.absolutePath, absolutePath) || other.absolutePath == absolutePath)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.videoCount, videoCount) || other.videoCount == videoCount)&&(identical(other.audioCount, audioCount) || other.audioCount == audioCount)&&(identical(other.isWatched, isWatched) || other.isWatched == isWatched));
}


@override
int get hashCode => Object.hash(runtimeType,id,absolutePath,name,parentId,thumbnailPath,videoCount,audioCount,isWatched);

@override
String toString() {
  return 'MediaFolderEntity(id: $id, absolutePath: $absolutePath, name: $name, parentId: $parentId, thumbnailPath: $thumbnailPath, videoCount: $videoCount, audioCount: $audioCount, isWatched: $isWatched)';
}


}

/// @nodoc
abstract mixin class $MediaFolderEntityCopyWith<$Res>  {
  factory $MediaFolderEntityCopyWith(MediaFolderEntity value, $Res Function(MediaFolderEntity) _then) = _$MediaFolderEntityCopyWithImpl;
@useResult
$Res call({
 int id, String absolutePath, String name, int? parentId, String? thumbnailPath, int videoCount, int audioCount, bool isWatched
});




}
/// @nodoc
class _$MediaFolderEntityCopyWithImpl<$Res>
    implements $MediaFolderEntityCopyWith<$Res> {
  _$MediaFolderEntityCopyWithImpl(this._self, this._then);

  final MediaFolderEntity _self;
  final $Res Function(MediaFolderEntity) _then;

/// Create a copy of MediaFolderEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? absolutePath = null,Object? name = null,Object? parentId = freezed,Object? thumbnailPath = freezed,Object? videoCount = null,Object? audioCount = null,Object? isWatched = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,absolutePath: null == absolutePath ? _self.absolutePath : absolutePath // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,videoCount: null == videoCount ? _self.videoCount : videoCount // ignore: cast_nullable_to_non_nullable
as int,audioCount: null == audioCount ? _self.audioCount : audioCount // ignore: cast_nullable_to_non_nullable
as int,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaFolderEntity].
extension MediaFolderEntityPatterns on MediaFolderEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaFolderEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaFolderEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaFolderEntity value)  $default,){
final _that = this;
switch (_that) {
case _MediaFolderEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaFolderEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MediaFolderEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String absolutePath,  String name,  int? parentId,  String? thumbnailPath,  int videoCount,  int audioCount,  bool isWatched)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaFolderEntity() when $default != null:
return $default(_that.id,_that.absolutePath,_that.name,_that.parentId,_that.thumbnailPath,_that.videoCount,_that.audioCount,_that.isWatched);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String absolutePath,  String name,  int? parentId,  String? thumbnailPath,  int videoCount,  int audioCount,  bool isWatched)  $default,) {final _that = this;
switch (_that) {
case _MediaFolderEntity():
return $default(_that.id,_that.absolutePath,_that.name,_that.parentId,_that.thumbnailPath,_that.videoCount,_that.audioCount,_that.isWatched);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String absolutePath,  String name,  int? parentId,  String? thumbnailPath,  int videoCount,  int audioCount,  bool isWatched)?  $default,) {final _that = this;
switch (_that) {
case _MediaFolderEntity() when $default != null:
return $default(_that.id,_that.absolutePath,_that.name,_that.parentId,_that.thumbnailPath,_that.videoCount,_that.audioCount,_that.isWatched);case _:
  return null;

}
}

}

/// @nodoc


class _MediaFolderEntity extends MediaFolderEntity {
  const _MediaFolderEntity({required this.id, required this.absolutePath, required this.name, this.parentId, this.thumbnailPath, this.videoCount = 0, this.audioCount = 0, this.isWatched = false}): super._();
  

@override final  int id;
@override final  String absolutePath;
@override final  String name;
@override final  int? parentId;
@override final  String? thumbnailPath;
@override@JsonKey() final  int videoCount;
@override@JsonKey() final  int audioCount;
@override@JsonKey() final  bool isWatched;

/// Create a copy of MediaFolderEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaFolderEntityCopyWith<_MediaFolderEntity> get copyWith => __$MediaFolderEntityCopyWithImpl<_MediaFolderEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaFolderEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.absolutePath, absolutePath) || other.absolutePath == absolutePath)&&(identical(other.name, name) || other.name == name)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.videoCount, videoCount) || other.videoCount == videoCount)&&(identical(other.audioCount, audioCount) || other.audioCount == audioCount)&&(identical(other.isWatched, isWatched) || other.isWatched == isWatched));
}


@override
int get hashCode => Object.hash(runtimeType,id,absolutePath,name,parentId,thumbnailPath,videoCount,audioCount,isWatched);

@override
String toString() {
  return 'MediaFolderEntity(id: $id, absolutePath: $absolutePath, name: $name, parentId: $parentId, thumbnailPath: $thumbnailPath, videoCount: $videoCount, audioCount: $audioCount, isWatched: $isWatched)';
}


}

/// @nodoc
abstract mixin class _$MediaFolderEntityCopyWith<$Res> implements $MediaFolderEntityCopyWith<$Res> {
  factory _$MediaFolderEntityCopyWith(_MediaFolderEntity value, $Res Function(_MediaFolderEntity) _then) = __$MediaFolderEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String absolutePath, String name, int? parentId, String? thumbnailPath, int videoCount, int audioCount, bool isWatched
});




}
/// @nodoc
class __$MediaFolderEntityCopyWithImpl<$Res>
    implements _$MediaFolderEntityCopyWith<$Res> {
  __$MediaFolderEntityCopyWithImpl(this._self, this._then);

  final _MediaFolderEntity _self;
  final $Res Function(_MediaFolderEntity) _then;

/// Create a copy of MediaFolderEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? absolutePath = null,Object? name = null,Object? parentId = freezed,Object? thumbnailPath = freezed,Object? videoCount = null,Object? audioCount = null,Object? isWatched = null,}) {
  return _then(_MediaFolderEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,absolutePath: null == absolutePath ? _self.absolutePath : absolutePath // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as int?,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,videoCount: null == videoCount ? _self.videoCount : videoCount // ignore: cast_nullable_to_non_nullable
as int,audioCount: null == audioCount ? _self.audioCount : audioCount // ignore: cast_nullable_to_non_nullable
as int,isWatched: null == isWatched ? _self.isWatched : isWatched // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
