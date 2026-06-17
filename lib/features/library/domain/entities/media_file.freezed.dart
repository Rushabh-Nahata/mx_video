// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaFileEntity {

 int get id; String get absolutePath; String get name; String get extension; int get sizeBytes; int? get durationMs; int? get width; int? get height; String? get thumbnailPath; int? get folderId; int? get lastPlayedAt; int get playPositionMs; int get playCount; bool get isFavourite; int get scannedAt;
/// Create a copy of MediaFileEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaFileEntityCopyWith<MediaFileEntity> get copyWith => _$MediaFileEntityCopyWithImpl<MediaFileEntity>(this as MediaFileEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaFileEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.absolutePath, absolutePath) || other.absolutePath == absolutePath)&&(identical(other.name, name) || other.name == name)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.lastPlayedAt, lastPlayedAt) || other.lastPlayedAt == lastPlayedAt)&&(identical(other.playPositionMs, playPositionMs) || other.playPositionMs == playPositionMs)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.isFavourite, isFavourite) || other.isFavourite == isFavourite)&&(identical(other.scannedAt, scannedAt) || other.scannedAt == scannedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,absolutePath,name,extension,sizeBytes,durationMs,width,height,thumbnailPath,folderId,lastPlayedAt,playPositionMs,playCount,isFavourite,scannedAt);

@override
String toString() {
  return 'MediaFileEntity(id: $id, absolutePath: $absolutePath, name: $name, extension: $extension, sizeBytes: $sizeBytes, durationMs: $durationMs, width: $width, height: $height, thumbnailPath: $thumbnailPath, folderId: $folderId, lastPlayedAt: $lastPlayedAt, playPositionMs: $playPositionMs, playCount: $playCount, isFavourite: $isFavourite, scannedAt: $scannedAt)';
}


}

/// @nodoc
abstract mixin class $MediaFileEntityCopyWith<$Res>  {
  factory $MediaFileEntityCopyWith(MediaFileEntity value, $Res Function(MediaFileEntity) _then) = _$MediaFileEntityCopyWithImpl;
@useResult
$Res call({
 int id, String absolutePath, String name, String extension, int sizeBytes, int? durationMs, int? width, int? height, String? thumbnailPath, int? folderId, int? lastPlayedAt, int playPositionMs, int playCount, bool isFavourite, int scannedAt
});




}
/// @nodoc
class _$MediaFileEntityCopyWithImpl<$Res>
    implements $MediaFileEntityCopyWith<$Res> {
  _$MediaFileEntityCopyWithImpl(this._self, this._then);

  final MediaFileEntity _self;
  final $Res Function(MediaFileEntity) _then;

/// Create a copy of MediaFileEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? absolutePath = null,Object? name = null,Object? extension = null,Object? sizeBytes = null,Object? durationMs = freezed,Object? width = freezed,Object? height = freezed,Object? thumbnailPath = freezed,Object? folderId = freezed,Object? lastPlayedAt = freezed,Object? playPositionMs = null,Object? playCount = null,Object? isFavourite = null,Object? scannedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,absolutePath: null == absolutePath ? _self.absolutePath : absolutePath // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as int?,lastPlayedAt: freezed == lastPlayedAt ? _self.lastPlayedAt : lastPlayedAt // ignore: cast_nullable_to_non_nullable
as int?,playPositionMs: null == playPositionMs ? _self.playPositionMs : playPositionMs // ignore: cast_nullable_to_non_nullable
as int,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,isFavourite: null == isFavourite ? _self.isFavourite : isFavourite // ignore: cast_nullable_to_non_nullable
as bool,scannedAt: null == scannedAt ? _self.scannedAt : scannedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaFileEntity].
extension MediaFileEntityPatterns on MediaFileEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaFileEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaFileEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaFileEntity value)  $default,){
final _that = this;
switch (_that) {
case _MediaFileEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaFileEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MediaFileEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String absolutePath,  String name,  String extension,  int sizeBytes,  int? durationMs,  int? width,  int? height,  String? thumbnailPath,  int? folderId,  int? lastPlayedAt,  int playPositionMs,  int playCount,  bool isFavourite,  int scannedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaFileEntity() when $default != null:
return $default(_that.id,_that.absolutePath,_that.name,_that.extension,_that.sizeBytes,_that.durationMs,_that.width,_that.height,_that.thumbnailPath,_that.folderId,_that.lastPlayedAt,_that.playPositionMs,_that.playCount,_that.isFavourite,_that.scannedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String absolutePath,  String name,  String extension,  int sizeBytes,  int? durationMs,  int? width,  int? height,  String? thumbnailPath,  int? folderId,  int? lastPlayedAt,  int playPositionMs,  int playCount,  bool isFavourite,  int scannedAt)  $default,) {final _that = this;
switch (_that) {
case _MediaFileEntity():
return $default(_that.id,_that.absolutePath,_that.name,_that.extension,_that.sizeBytes,_that.durationMs,_that.width,_that.height,_that.thumbnailPath,_that.folderId,_that.lastPlayedAt,_that.playPositionMs,_that.playCount,_that.isFavourite,_that.scannedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String absolutePath,  String name,  String extension,  int sizeBytes,  int? durationMs,  int? width,  int? height,  String? thumbnailPath,  int? folderId,  int? lastPlayedAt,  int playPositionMs,  int playCount,  bool isFavourite,  int scannedAt)?  $default,) {final _that = this;
switch (_that) {
case _MediaFileEntity() when $default != null:
return $default(_that.id,_that.absolutePath,_that.name,_that.extension,_that.sizeBytes,_that.durationMs,_that.width,_that.height,_that.thumbnailPath,_that.folderId,_that.lastPlayedAt,_that.playPositionMs,_that.playCount,_that.isFavourite,_that.scannedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MediaFileEntity extends MediaFileEntity {
  const _MediaFileEntity({required this.id, required this.absolutePath, required this.name, required this.extension, required this.sizeBytes, this.durationMs, this.width, this.height, this.thumbnailPath, this.folderId, this.lastPlayedAt, this.playPositionMs = 0, this.playCount = 0, this.isFavourite = false, required this.scannedAt}): super._();
  

@override final  int id;
@override final  String absolutePath;
@override final  String name;
@override final  String extension;
@override final  int sizeBytes;
@override final  int? durationMs;
@override final  int? width;
@override final  int? height;
@override final  String? thumbnailPath;
@override final  int? folderId;
@override final  int? lastPlayedAt;
@override@JsonKey() final  int playPositionMs;
@override@JsonKey() final  int playCount;
@override@JsonKey() final  bool isFavourite;
@override final  int scannedAt;

/// Create a copy of MediaFileEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaFileEntityCopyWith<_MediaFileEntity> get copyWith => __$MediaFileEntityCopyWithImpl<_MediaFileEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaFileEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.absolutePath, absolutePath) || other.absolutePath == absolutePath)&&(identical(other.name, name) || other.name == name)&&(identical(other.extension, extension) || other.extension == extension)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.thumbnailPath, thumbnailPath) || other.thumbnailPath == thumbnailPath)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.lastPlayedAt, lastPlayedAt) || other.lastPlayedAt == lastPlayedAt)&&(identical(other.playPositionMs, playPositionMs) || other.playPositionMs == playPositionMs)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.isFavourite, isFavourite) || other.isFavourite == isFavourite)&&(identical(other.scannedAt, scannedAt) || other.scannedAt == scannedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,absolutePath,name,extension,sizeBytes,durationMs,width,height,thumbnailPath,folderId,lastPlayedAt,playPositionMs,playCount,isFavourite,scannedAt);

@override
String toString() {
  return 'MediaFileEntity(id: $id, absolutePath: $absolutePath, name: $name, extension: $extension, sizeBytes: $sizeBytes, durationMs: $durationMs, width: $width, height: $height, thumbnailPath: $thumbnailPath, folderId: $folderId, lastPlayedAt: $lastPlayedAt, playPositionMs: $playPositionMs, playCount: $playCount, isFavourite: $isFavourite, scannedAt: $scannedAt)';
}


}

/// @nodoc
abstract mixin class _$MediaFileEntityCopyWith<$Res> implements $MediaFileEntityCopyWith<$Res> {
  factory _$MediaFileEntityCopyWith(_MediaFileEntity value, $Res Function(_MediaFileEntity) _then) = __$MediaFileEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String absolutePath, String name, String extension, int sizeBytes, int? durationMs, int? width, int? height, String? thumbnailPath, int? folderId, int? lastPlayedAt, int playPositionMs, int playCount, bool isFavourite, int scannedAt
});




}
/// @nodoc
class __$MediaFileEntityCopyWithImpl<$Res>
    implements _$MediaFileEntityCopyWith<$Res> {
  __$MediaFileEntityCopyWithImpl(this._self, this._then);

  final _MediaFileEntity _self;
  final $Res Function(_MediaFileEntity) _then;

/// Create a copy of MediaFileEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? absolutePath = null,Object? name = null,Object? extension = null,Object? sizeBytes = null,Object? durationMs = freezed,Object? width = freezed,Object? height = freezed,Object? thumbnailPath = freezed,Object? folderId = freezed,Object? lastPlayedAt = freezed,Object? playPositionMs = null,Object? playCount = null,Object? isFavourite = null,Object? scannedAt = null,}) {
  return _then(_MediaFileEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,absolutePath: null == absolutePath ? _self.absolutePath : absolutePath // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,extension: null == extension ? _self.extension : extension // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,durationMs: freezed == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,thumbnailPath: freezed == thumbnailPath ? _self.thumbnailPath : thumbnailPath // ignore: cast_nullable_to_non_nullable
as String?,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as int?,lastPlayedAt: freezed == lastPlayedAt ? _self.lastPlayedAt : lastPlayedAt // ignore: cast_nullable_to_non_nullable
as int?,playPositionMs: null == playPositionMs ? _self.playPositionMs : playPositionMs // ignore: cast_nullable_to_non_nullable
as int,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,isFavourite: null == isFavourite ? _self.isFavourite : isFavourite // ignore: cast_nullable_to_non_nullable
as bool,scannedAt: null == scannedAt ? _self.scannedAt : scannedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
