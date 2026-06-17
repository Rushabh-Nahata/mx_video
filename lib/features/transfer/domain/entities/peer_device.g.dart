// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'peer_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PeerDevice _$PeerDeviceFromJson(Map<String, dynamic> json) => _PeerDevice(
  id: json['id'] as String,
  name: json['name'] as String,
  ipAddress: json['ipAddress'] as String,
  port: (json['port'] as num).toInt(),
  platform:
      $enumDecodeNullable(_$PeerPlatformEnumMap, json['platform']) ??
      PeerPlatform.unknown,
  connectionMethod:
      $enumDecodeNullable(
        _$ConnectionMethodEnumMap,
        json['connectionMethod'],
      ) ??
      ConnectionMethod.wifi,
  sessionToken: json['sessionToken'] as String?,
);

Map<String, dynamic> _$PeerDeviceToJson(_PeerDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ipAddress': instance.ipAddress,
      'port': instance.port,
      'platform': _$PeerPlatformEnumMap[instance.platform]!,
      'connectionMethod': _$ConnectionMethodEnumMap[instance.connectionMethod]!,
      'sessionToken': instance.sessionToken,
    };

const _$PeerPlatformEnumMap = {
  PeerPlatform.android: 'android',
  PeerPlatform.ios: 'ios',
  PeerPlatform.windows: 'windows',
  PeerPlatform.macos: 'macos',
  PeerPlatform.linux: 'linux',
  PeerPlatform.unknown: 'unknown',
};

const _$ConnectionMethodEnumMap = {
  ConnectionMethod.wifi: 'wifi',
  ConnectionMethod.bluetooth: 'bluetooth',
  ConnectionMethod.qrCode: 'qrCode',
  ConnectionMethod.wifiDirect: 'wifiDirect',
  ConnectionMethod.hotspot: 'hotspot',
};
