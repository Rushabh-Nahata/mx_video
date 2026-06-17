// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoveryState {

 List<PeerDevice> get devices; bool get isScanning; DateTime? get lastRefreshed; String? get error;
/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryStateCopyWith<DiscoveryState> get copyWith => _$DiscoveryStateCopyWithImpl<DiscoveryState>(this as DiscoveryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryState&&const DeepCollectionEquality().equals(other.devices, devices)&&(identical(other.isScanning, isScanning) || other.isScanning == isScanning)&&(identical(other.lastRefreshed, lastRefreshed) || other.lastRefreshed == lastRefreshed)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(devices),isScanning,lastRefreshed,error);

@override
String toString() {
  return 'DiscoveryState(devices: $devices, isScanning: $isScanning, lastRefreshed: $lastRefreshed, error: $error)';
}


}

/// @nodoc
abstract mixin class $DiscoveryStateCopyWith<$Res>  {
  factory $DiscoveryStateCopyWith(DiscoveryState value, $Res Function(DiscoveryState) _then) = _$DiscoveryStateCopyWithImpl;
@useResult
$Res call({
 List<PeerDevice> devices, bool isScanning, DateTime? lastRefreshed, String? error
});




}
/// @nodoc
class _$DiscoveryStateCopyWithImpl<$Res>
    implements $DiscoveryStateCopyWith<$Res> {
  _$DiscoveryStateCopyWithImpl(this._self, this._then);

  final DiscoveryState _self;
  final $Res Function(DiscoveryState) _then;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? devices = null,Object? isScanning = null,Object? lastRefreshed = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<PeerDevice>,isScanning: null == isScanning ? _self.isScanning : isScanning // ignore: cast_nullable_to_non_nullable
as bool,lastRefreshed: freezed == lastRefreshed ? _self.lastRefreshed : lastRefreshed // ignore: cast_nullable_to_non_nullable
as DateTime?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoveryState].
extension DiscoveryStatePatterns on DiscoveryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoveryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoveryState value)  $default,){
final _that = this;
switch (_that) {
case _DiscoveryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoveryState value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PeerDevice> devices,  bool isScanning,  DateTime? lastRefreshed,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
return $default(_that.devices,_that.isScanning,_that.lastRefreshed,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PeerDevice> devices,  bool isScanning,  DateTime? lastRefreshed,  String? error)  $default,) {final _that = this;
switch (_that) {
case _DiscoveryState():
return $default(_that.devices,_that.isScanning,_that.lastRefreshed,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PeerDevice> devices,  bool isScanning,  DateTime? lastRefreshed,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
return $default(_that.devices,_that.isScanning,_that.lastRefreshed,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoveryState extends DiscoveryState {
  const _DiscoveryState({final  List<PeerDevice> devices = const [], this.isScanning = false, this.lastRefreshed, this.error}): _devices = devices,super._();
  

 final  List<PeerDevice> _devices;
@override@JsonKey() List<PeerDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}

@override@JsonKey() final  bool isScanning;
@override final  DateTime? lastRefreshed;
@override final  String? error;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoveryStateCopyWith<_DiscoveryState> get copyWith => __$DiscoveryStateCopyWithImpl<_DiscoveryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoveryState&&const DeepCollectionEquality().equals(other._devices, _devices)&&(identical(other.isScanning, isScanning) || other.isScanning == isScanning)&&(identical(other.lastRefreshed, lastRefreshed) || other.lastRefreshed == lastRefreshed)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_devices),isScanning,lastRefreshed,error);

@override
String toString() {
  return 'DiscoveryState(devices: $devices, isScanning: $isScanning, lastRefreshed: $lastRefreshed, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DiscoveryStateCopyWith<$Res> implements $DiscoveryStateCopyWith<$Res> {
  factory _$DiscoveryStateCopyWith(_DiscoveryState value, $Res Function(_DiscoveryState) _then) = __$DiscoveryStateCopyWithImpl;
@override @useResult
$Res call({
 List<PeerDevice> devices, bool isScanning, DateTime? lastRefreshed, String? error
});




}
/// @nodoc
class __$DiscoveryStateCopyWithImpl<$Res>
    implements _$DiscoveryStateCopyWith<$Res> {
  __$DiscoveryStateCopyWithImpl(this._self, this._then);

  final _DiscoveryState _self;
  final $Res Function(_DiscoveryState) _then;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? devices = null,Object? isScanning = null,Object? lastRefreshed = freezed,Object? error = freezed,}) {
  return _then(_DiscoveryState(
devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<PeerDevice>,isScanning: null == isScanning ? _self.isScanning : isScanning // ignore: cast_nullable_to_non_nullable
as bool,lastRefreshed: freezed == lastRefreshed ? _self.lastRefreshed : lastRefreshed // ignore: cast_nullable_to_non_nullable
as DateTime?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
