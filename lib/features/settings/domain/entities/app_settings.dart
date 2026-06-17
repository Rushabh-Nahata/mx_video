import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Persisted user preferences for MX Video.
@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default('light') String themeMode,
    @Default(1.0) double defaultPlaybackSpeed,
    @Default(true) bool resumeFromLastPosition,
    @Default(true) bool useGestureControls,
    @Default(true) bool showSubtitlesByDefault,
    @Default(false) bool keepScreenOn,
    @Default([]) List<String> scanRootPaths,
    @Default('name') String defaultSortOrder,
    @Default('grid') String libraryViewMode,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  static const AppSettings defaults = AppSettings();
}
