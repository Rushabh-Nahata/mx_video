import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/app_settings.dart';

part 'settings_provider.g.dart';

const _kSettingsKey = 'app_settings';

@riverpod
class Settings extends _$Settings {
  @override
  Future<AppSettings> build() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kSettingsKey);
    if (raw == null) return AppSettings.defaults;
    try {
      return AppSettings.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (_) {
      return AppSettings.defaults;
    }
  }

  Future<void> save(AppSettings settings) async {
    state = AsyncData(settings);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSettingsKey, json.encode(settings.toJson()));
  }

  Future<void> addScanPath(String path) async {
    final current = state.asData?.value ?? AppSettings.defaults;
    if (current.scanRootPaths.contains(path)) return;
    await save(current.copyWith(
      scanRootPaths: [...current.scanRootPaths, path],
    ));
  }

  Future<void> removeScanPath(String path) async {
    final current = state.asData?.value ?? AppSettings.defaults;
    await save(current.copyWith(
      scanRootPaths: current.scanRootPaths.where((String p) => p != path).toList(),
    ));
  }
}
