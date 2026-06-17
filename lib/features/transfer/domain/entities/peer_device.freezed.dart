// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'peer_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PeerDevice {

 String get id; String get name; String get ipAddress; int get port; PeerPlatform get platform; ConnectionMethod get connectionMethod;/// Session token for authenticated transfers (set after pairing).
 String? get sessionToken;
/// Create a copy of PeerDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PeerDeviceCopyWith<PeerDevice> get copyWith => _$PeerDeviceCopyWithImpl<PeerDevice>(this as PeerDevice, _$identity);

  /// Serializes this PeerDevice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PeerDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.port, port) || other.port == port)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.connectionMethod, connectionMethod) || other.connectionMethod == connectionMethod)&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,ipAddress,port,platform,connectionMethod,sessionToken);

@override
String toString() {
  return 'PeerDevice(id: $id, name: $name, ipAddress: $ipAddress, port: $port, platform: $platform, connectionMethod: $connectionMethod, sessionToken: $sessionToken)';
}


}

/// @nodoc
abstract mixin class $PeerDeviceCopyWith<$Res>  {
  factory $PeerDeviceCopyWith(PeerDevice value, $Res Function(PeerDevice) _then) = _$PeerDeviceCopyWithImpl;
@useResult
$Res call({
 String id, String name, String ipAddress, int port, PeerPlatform platform, ConnectionMethod connectionMethod, String? sessionToken
});




}
/// @nodoc
class _$PeerDeviceCopyWithImpl<$Res>
    implements $PeerDeviceCopyWith<$Res> {
  _$PeerDeviceCopyWithImpl(this._self, this._then);

  final PeerDevice _self;
  final $Res Function(PeerDevice) _then;

/// Create a copy of PeerDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? ipAddress = null,Object? port = null,Object? platform = null,Object? connectionMethod = null,Object? sessionToken = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ipAddress: null == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as PeerPlatform,connectionMethod: null == connectionMethod ? _self.connectionMethod : connectionMethod // ignore: cast_nullable_to_non_nullable
as ConnectionMethod,sessionToken: freezed == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PeerDevice].
extension PeerDevicePatterns on PeerDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PeerDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PeerDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PeerDevice value)  $default,){
final _that = this;
switch (_that) {
case _PeerDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PeerDevice value)?  $default,){
final _that = this;
switch (_that) {
case _PeerDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String ipAddress,  int port,  PeerPlatform platform,  ConnectionMethod connectionMethod,  String? sessionToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PeerDevice() when $default != null:
return $default(_that.id,_that.name,_that.ipAddress,_that.port,_that.platform,_that.connectionMethod,_that.sessionToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String ipAddress,  int port,  PeerPlatform platform,  ConnectionMethod connectionMethod,  String? sessionToken)  $default,) {final _that = this;
switch (_that) {
case _PeerDevice():
return $default(_that.id,_that.name,_that.ipAddress,_that.port,_that.platform,_that.connectionMethod,_that.sessionToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String ipAddress,  int port,  PeerPlatform platform,  ConnectionMethod connectionMethod,  String? sessionToken)?  $default,) {final _that = this;
switch (_that) {
case _PeerDevice() when $default != null:
return $default(_that.id,_that.name,_that.ipAddress,_that.port,_that.platform,_that.connectionMethod,_that.sessionToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PeerDevice implements PeerDevice {
  const _PeerDevice({required this.id, required this.name, required this.ipAddress, required this.port, this.platform = PeerPlatform.unknown, this.connectionMethod = ConnectionMethod.wifi, this.sessionToken});
  factory _PeerDevice.fromJson(Map<String, dynamic> json) => _$PeerDeviceFromJson(json);

@override final  String id;
@override final  String name;
@override final  String ipAddress;
@override final  int port;
@override@JsonKey() final  PeerPlatform platform;
@override@JsonKey() final  ConnectionMethod connectionMethod;
/// Session token for authenticated transfers (set after pairing).
@override final  String? sessionToken;

/// Create a copy of PeerDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PeerDeviceCopyWith<_PeerDevice> get copyWith => __$PeerDeviceCopyWithImpl<_PeerDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PeerDeviceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PeerDevice&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.port, port) || other.port == port)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.connectionMethod, connectionMethod) || other.connectionMethod == connectionMethod)&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,ipAddress,port,platform,connectionMethod,sessionToken);

@override
String toString() {
  return 'PeerDevice(id: $id, name: $name, ipAddress: $ipAddress, port: $port, platform: $platform, connectionMethod: $connectionMethod, sessionToken: $sessionToken)';
}


}

/// @nodoc
abstract mixin class _$PeerDeviceCopyWith<$Res> implements $PeerDeviceCopyWith<$Res> {
  factory _$PeerDeviceCopyWith(_PeerDevice value, $Res Function(_PeerDevice) _then) = __$PeerDeviceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String ipAddress, int port, PeerPlatform platform, ConnectionMethod connectionMethod, String? sessionToken
});




}
/// @nodoc
class __$PeerDeviceCopyWithImpl<$Res>
    implements _$PeerDeviceCopyWith<$Res> {
  __$PeerDeviceCopyWithImpl(this._self, this._then);

  final _PeerDevice _self;
  final $Res Function(_PeerDevice) _then;

/// Create a copy of PeerDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? ipAddress = null,Object? port = null,Object? platform = null,Object? connectionMethod = null,Object? sessionToken = freezed,}) {
  return _then(_PeerDevice(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ipAddress: null == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as PeerPlatform,connectionMethod: null == connectionMethod ? _self.connectionMethod : connectionMethod // ignore: cast_nullable_to_non_nullable
as ConnectionMethod,sessionToken: freezed == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
