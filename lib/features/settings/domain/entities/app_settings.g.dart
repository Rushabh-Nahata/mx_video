// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  themeMode: json['themeMode'] as String? ?? 'light',
  defaultPlaybackSpeed:
      (json['defaultPlaybackSpeed'] as num?)?.toDouble() ?? 1.0,
  resumeFromLastPosition: json['resumeFromLastPosition'] as bool? ?? true,
  useGestureControls: json['useGestureControls'] as bool? ?? true,
  showSubtitlesByDefault: json['showSubtitlesByDefault'] as bool? ?? true,
  keepScreenOn: json['keepScreenOn'] as bool? ?? false,
  scanRootPaths:
      (json['scanRootPaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  defaultSortOrder: json['defaultSortOrder'] as String? ?? 'name',
  libraryViewMode: json['libraryViewMode'] as String? ?? 'grid',
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'defaultPlaybackSpeed': instance.defaultPlaybackSpeed,
      'resumeFromLastPosition': instance.resumeFromLastPosition,
      'useGestureControls': instance.useGestureControls,
      'showSubtitlesByDefault': instance.showSubtitlesByDefault,
      'keepScreenOn': instance.keepScreenOn,
      'scanRootPaths': instance.scanRootPaths,
      'defaultSortOrder': instance.defaultSortOrder,
      'libraryViewMode': instance.libraryViewMode,
    };
