import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../domain/entities/status_item.dart';

class StatusRepository {
  // WhatsApp status directories — Android 11+ paths first, then legacy
  static const _whatsappPaths = [
    '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses',
    '/storage/emulated/0/WhatsApp/Media/.Statuses',
  ];

  static const _whatsappBusinessPaths = [
    '/storage/emulated/0/Android/media/com.whatsapp.w4b/WhatsApp Business/Media/.Statuses',
    '/storage/emulated/0/WhatsApp Business/Media/.Statuses',
  ];

  static const _saveDir = '/storage/emulated/0/DCIM/MX Video Status';

  static const _imageExts = {'.jpg', '.jpeg', '.png', '.gif', '.webp'};
  static const _videoExts = {'.mp4', '.mkv', '.avi', '.3gp', '.webm'};

  /// Find all accessible WhatsApp status directories.
  Future<List<String>> _findStatusDirs() async {
    final dirs = <String>[];
    for (final path in [..._whatsappPaths, ..._whatsappBusinessPaths]) {
      final dir = Directory(path);
      try {
        final exists = await dir.exists();
        debugPrint('StatusRepository: $path exists=$exists');
        if (exists) {
          // Verify we can actually list the directory
          await dir.list().first.timeout(
            const Duration(seconds: 2),
            onTimeout: () => throw const FileSystemException('timeout'),
          );
          dirs.add(path);
          debugPrint('StatusRepository: $path is accessible');
        }
      } catch (e) {
        debugPrint('StatusRepository: $path check failed: $e');
        // Still add if the directory exists but might be empty
        if (await dir.exists()) {
          dirs.add(path);
        }
      }
    }
    return dirs;
  }

  /// Whether WhatsApp is installed and status directory exists.
  Future<bool> get isAvailable async {
    final dirs = await _findStatusDirs();
    return dirs.isNotEmpty;
  }

  /// List recent (unsaved) WhatsApp statuses.
  Future<List<StatusItem>> getRecentStatuses() async {
    final dirs = await _findStatusDirs();
    debugPrint('StatusRepository: found ${dirs.length} status dirs: $dirs');
    if (dirs.isEmpty) return [];

    final savedNames = await _getSavedFileNames();
    final items = <StatusItem>[];

    for (final dirPath in dirs) {
      final dir = Directory(dirPath);
      try {
        await for (final entity in dir.list()) {
          if (entity is! File) continue;
          final name = p.basename(entity.path);
          // Skip .nomedia and hidden files
          if (name.startsWith('.')) continue;

          final ext = p.extension(name).toLowerCase();
          final type = _typeForExt(ext);
          if (type == null) continue;

          final stat = await entity.stat();
          items.add(StatusItem(
            path: entity.path,
            name: name,
            type: type,
            dateModified: stat.modified,
            sizeBytes: stat.size,
            isSaved: savedNames.contains(name),
          ));
        }
      } catch (e) {
        debugPrint('StatusRepository: error listing $dirPath: $e');
      }
    }

    debugPrint('StatusRepository: found ${items.length} recent statuses');

    // Sort newest first
    items.sort((a, b) => b.dateModified.compareTo(a.dateModified));
    return items;
  }

  /// List saved statuses from our local save directory.
  Future<List<StatusItem>> getSavedStatuses() async {
    final dir = Directory(_saveDir);
    if (!await dir.exists()) return [];

    final items = <StatusItem>[];
    try {
      await for (final entity in dir.list()) {
        if (entity is! File) continue;
        final name = p.basename(entity.path);
        if (name.startsWith('.')) continue;

        final ext = p.extension(name).toLowerCase();
        final type = _typeForExt(ext);
        if (type == null) continue;

        final stat = await entity.stat();
        items.add(StatusItem(
          path: entity.path,
          name: name,
          type: type,
          dateModified: stat.modified,
          sizeBytes: stat.size,
          isSaved: true,
        ));
      }
    } catch (_) {}

    items.sort((a, b) => b.dateModified.compareTo(a.dateModified));
    return items;
  }

  /// Save a status file to local storage.
  Future<String> saveStatus(String sourcePath) async {
    final dir = Directory(_saveDir);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final name = p.basename(sourcePath);
    final destPath = p.join(_saveDir, name);
    final destFile = File(destPath);

    // Don't overwrite if already saved
    if (await destFile.exists()) return destPath;

    await File(sourcePath).copy(destPath);
    return destPath;
  }

  /// Delete a saved status.
  Future<void> deleteSavedStatus(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Get all file names in the save directory.
  Future<Set<String>> _getSavedFileNames() async {
    final dir = Directory(_saveDir);
    if (!await dir.exists()) return {};

    final names = <String>{};
    try {
      await for (final entity in dir.list()) {
        if (entity is File) {
          names.add(p.basename(entity.path));
        }
      }
    } catch (_) {}
    return names;
  }

  StatusType? _typeForExt(String ext) {
    if (_imageExts.contains(ext)) return StatusType.image;
    if (_videoExts.contains(ext)) return StatusType.video;
    return null;
  }
}
