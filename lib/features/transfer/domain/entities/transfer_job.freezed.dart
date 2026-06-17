// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransferJobEntity {

 int get id; String get peerName; String get peerIp; String get fileName; int get fileSize; int get bytesTransferred; TransferDirection get direction; TransferStatus get status; String? get checksum; int? get startedAt; int? get finishedAt; String? get savePath; String? get errorMessage;/// Current transfer speed in bytes per second.
 int get speedBytesPerSec;
/// Create a copy of TransferJobEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferJobEntityCopyWith<TransferJobEntity> get copyWith => _$TransferJobEntityCopyWithImpl<TransferJobEntity>(this as TransferJobEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferJobEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.peerName, peerName) || other.peerName == peerName)&&(identical(other.peerIp, peerIp) || other.peerIp == peerIp)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.bytesTransferred, bytesTransferred) || other.bytesTransferred == bytesTransferred)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.checksum, checksum) || other.checksum == checksum)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.savePath, savePath) || other.savePath == savePath)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.speedBytesPerSec, speedBytesPerSec) || other.speedBytesPerSec == speedBytesPerSec));
}


@override
int get hashCode => Object.hash(runtimeType,id,peerName,peerIp,fileName,fileSize,bytesTransferred,direction,status,checksum,startedAt,finishedAt,savePath,errorMessage,speedBytesPerSec);

@override
String toString() {
  return 'TransferJobEntity(id: $id, peerName: $peerName, peerIp: $peerIp, fileName: $fileName, fileSize: $fileSize, bytesTransferred: $bytesTransferred, direction: $direction, status: $status, checksum: $checksum, startedAt: $startedAt, finishedAt: $finishedAt, savePath: $savePath, errorMessage: $errorMessage, speedBytesPerSec: $speedBytesPerSec)';
}


}

/// @nodoc
abstract mixin class $TransferJobEntityCopyWith<$Res>  {
  factory $TransferJobEntityCopyWith(TransferJobEntity value, $Res Function(TransferJobEntity) _then) = _$TransferJobEntityCopyWithImpl;
@useResult
$Res call({
 int id, String peerName, String peerIp, String fileName, int fileSize, int bytesTransferred, TransferDirection direction, TransferStatus status, String? checksum, int? startedAt, int? finishedAt, String? savePath, String? errorMessage, int speedBytesPerSec
});




}
/// @nodoc
class _$TransferJobEntityCopyWithImpl<$Res>
    implements $TransferJobEntityCopyWith<$Res> {
  _$TransferJobEntityCopyWithImpl(this._self, this._then);

  final TransferJobEntity _self;
  final $Res Function(TransferJobEntity) _then;

/// Create a copy of TransferJobEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? peerName = null,Object? peerIp = null,Object? fileName = null,Object? fileSize = null,Object? bytesTransferred = null,Object? direction = null,Object? status = null,Object? checksum = freezed,Object? startedAt = freezed,Object? finishedAt = freezed,Object? savePath = freezed,Object? errorMessage = freezed,Object? speedBytesPerSec = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,peerName: null == peerName ? _self.peerName : peerName // ignore: cast_nullable_to_non_nullable
as String,peerIp: null == peerIp ? _self.peerIp : peerIp // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,bytesTransferred: null == bytesTransferred ? _self.bytesTransferred : bytesTransferred // ignore: cast_nullable_to_non_nullable
as int,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransferDirection,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,checksum: freezed == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as int?,savePath: freezed == savePath ? _self.savePath : savePath // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,speedBytesPerSec: null == speedBytesPerSec ? _self.speedBytesPerSec : speedBytesPerSec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferJobEntity].
extension TransferJobEntityPatterns on TransferJobEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferJobEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferJobEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferJobEntity value)  $default,){
final _that = this;
switch (_that) {
case _TransferJobEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferJobEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TransferJobEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String peerName,  String peerIp,  String fileName,  int fileSize,  int bytesTransferred,  TransferDirection direction,  TransferStatus status,  String? checksum,  int? startedAt,  int? finishedAt,  String? savePath,  String? errorMessage,  int speedBytesPerSec)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferJobEntity() when $default != null:
return $default(_that.id,_that.peerName,_that.peerIp,_that.fileName,_that.fileSize,_that.bytesTransferred,_that.direction,_that.status,_that.checksum,_that.startedAt,_that.finishedAt,_that.savePath,_that.errorMessage,_that.speedBytesPerSec);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String peerName,  String peerIp,  String fileName,  int fileSize,  int bytesTransferred,  TransferDirection direction,  TransferStatus status,  String? checksum,  int? startedAt,  int? finishedAt,  String? savePath,  String? errorMessage,  int speedBytesPerSec)  $default,) {final _that = this;
switch (_that) {
case _TransferJobEntity():
return $default(_that.id,_that.peerName,_that.peerIp,_that.fileName,_that.fileSize,_that.bytesTransferred,_that.direction,_that.status,_that.checksum,_that.startedAt,_that.finishedAt,_that.savePath,_that.errorMessage,_that.speedBytesPerSec);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String peerName,  String peerIp,  String fileName,  int fileSize,  int bytesTransferred,  TransferDirection direction,  TransferStatus status,  String? checksum,  int? startedAt,  int? finishedAt,  String? savePath,  String? errorMessage,  int speedBytesPerSec)?  $default,) {final _that = this;
switch (_that) {
case _TransferJobEntity() when $default != null:
return $default(_that.id,_that.peerName,_that.peerIp,_that.fileName,_that.fileSize,_that.bytesTransferred,_that.direction,_that.status,_that.checksum,_that.startedAt,_that.finishedAt,_that.savePath,_that.errorMessage,_that.speedBytesPerSec);case _:
  return null;

}
}

}

/// @nodoc


class _TransferJobEntity extends TransferJobEntity {
  const _TransferJobEntity({required this.id, required this.peerName, required this.peerIp, required this.fileName, required this.fileSize, this.bytesTransferred = 0, required this.direction, this.status = TransferStatus.queued, this.checksum, this.startedAt, this.finishedAt, this.savePath, this.errorMessage, this.speedBytesPerSec = 0}): super._();
  

@override final  int id;
@override final  String peerName;
@override final  String peerIp;
@override final  String fileName;
@override final  int fileSize;
@override@JsonKey() final  int bytesTransferred;
@override final  TransferDirection direction;
@override@JsonKey() final  TransferStatus status;
@override final  String? checksum;
@override final  int? startedAt;
@override final  int? finishedAt;
@override final  String? savePath;
@override final  String? errorMessage;
/// Current transfer speed in bytes per second.
@override@JsonKey() final  int speedBytesPerSec;

/// Create a copy of TransferJobEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferJobEntityCopyWith<_TransferJobEntity> get copyWith => __$TransferJobEntityCopyWithImpl<_TransferJobEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferJobEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.peerName, peerName) || other.peerName == peerName)&&(identical(other.peerIp, peerIp) || other.peerIp == peerIp)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.bytesTransferred, bytesTransferred) || other.bytesTransferred == bytesTransferred)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.status, status) || other.status == status)&&(identical(other.checksum, checksum) || other.checksum == checksum)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.savePath, savePath) || other.savePath == savePath)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.speedBytesPerSec, speedBytesPerSec) || other.speedBytesPerSec == speedBytesPerSec));
}


@override
int get hashCode => Object.hash(runtimeType,id,peerName,peerIp,fileName,fileSize,bytesTransferred,direction,status,checksum,startedAt,finishedAt,savePath,errorMessage,speedBytesPerSec);

@override
String toString() {
  return 'TransferJobEntity(id: $id, peerName: $peerName, peerIp: $peerIp, fileName: $fileName, fileSize: $fileSize, bytesTransferred: $bytesTransferred, direction: $direction, status: $status, checksum: $checksum, startedAt: $startedAt, finishedAt: $finishedAt, savePath: $savePath, errorMessage: $errorMessage, speedBytesPerSec: $speedBytesPerSec)';
}


}

/// @nodoc
abstract mixin class _$TransferJobEntityCopyWith<$Res> implements $TransferJobEntityCopyWith<$Res> {
  factory _$TransferJobEntityCopyWith(_TransferJobEntity value, $Res Function(_TransferJobEntity) _then) = __$TransferJobEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String peerName, String peerIp, String fileName, int fileSize, int bytesTransferred, TransferDirection direction, TransferStatus status, String? checksum, int? startedAt, int? finishedAt, String? savePath, String? errorMessage, int speedBytesPerSec
});




}
/// @nodoc
class __$TransferJobEntityCopyWithImpl<$Res>
    implements _$TransferJobEntityCopyWith<$Res> {
  __$TransferJobEntityCopyWithImpl(this._self, this._then);

  final _TransferJobEntity _self;
  final $Res Function(_TransferJobEntity) _then;

/// Create a copy of TransferJobEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? peerName = null,Object? peerIp = null,Object? fileName = null,Object? fileSize = null,Object? bytesTransferred = null,Object? direction = null,Object? status = null,Object? checksum = freezed,Object? startedAt = freezed,Object? finishedAt = freezed,Object? savePath = freezed,Object? errorMessage = freezed,Object? speedBytesPerSec = null,}) {
  return _then(_TransferJobEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,peerName: null == peerName ? _self.peerName : peerName // ignore: cast_nullable_to_non_nullable
as String,peerIp: null == peerIp ? _self.peerIp : peerIp // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,bytesTransferred: null == bytesTransferred ? _self.bytesTransferred : bytesTransferred // ignore: cast_nullable_to_non_nullable
as int,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TransferDirection,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,checksum: freezed == checksum ? _self.checksum : checksum // ignore: cast_nullable_to_non_nullable
as String?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as int?,savePath: freezed == savePath ? _self.savePath : savePath // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,speedBytesPerSec: null == speedBytesPerSec ? _self.speedBytesPerSec : speedBytesPerSec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
