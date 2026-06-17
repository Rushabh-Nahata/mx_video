import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/file_node.dart';
import '../../domain/entities/folder_node.dart';

/// Low-level file system operations.
/// Runs directory listing via [compute] in the repository layer for large dirs.
class FileSystemSource {
  Future<String> getStorageRoot() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0';
    }
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<List<FolderNode>> listDirectories(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) return [];

    final entries = await dir.list().toList();
    final dirs = entries.whereType<Directory>();

    return Future.wait(dirs.map((d) async {
      final stat = await d.stat();
      int childCount = 0;
      try {
        childCount = (await d.list().length);
      } catch (_) {}
      return FolderNode(
        path: d.path,
        name: p.basename(d.path),
        modifiedAt: stat.modified,
        childCount: childCount,
      );
    }));
  }

  Future<List<FileNode>> listFiles(String path) async {
    final dir = Directory(path);
    if (!await dir.exists()) return [];

    final entries = await dir.list().toList();
    final files = entries.whereType<File>();

    return Future.wait(files.map((f) async {
      final ext = p.extension(f.path).replaceFirst('.', '').toLowerCase();
      final stat = await f.stat();
      return FileNode(
        path: f.path,
        name: p.basename(f.path),
        extension: ext,
        sizeBytes: stat.size,
        modifiedAt: stat.modified,
      );
    }));
  }

  Future<List<FileNode>> search(String query, String rootPath) async {
    final results = <FileNode>[];
    await _searchRecursive(Directory(rootPath), query.toLowerCase(), results);
    return results;
  }

  Future<void> _searchRecursive(
    Directory dir,
    String query,
    List<FileNode> results,
  ) async {
    if (!await dir.exists()) return;
    try {
      await for (final entity in dir.list(recursive: false)) {
        if (entity is File) {
          final name = p.basename(entity.path).toLowerCase();
          final ext = p.extension(entity.path).replaceFirst('.', '').toLowerCase();
          final isMedia = AppConstants.videoExtensions.contains(ext) ||
              AppConstants.audioExtensions.contains(ext);
          if (isMedia && name.contains(query)) {
            final stat = await entity.stat();
            results.add(FileNode(
              path: entity.path,
              name: p.basename(entity.path),
              extension: ext,
              sizeBytes: stat.size,
              modifiedAt: stat.modified,
            ));
          }
        } else if (entity is Directory) {
          await _searchRecursive(entity, query, results);
        }
      }
    } catch (_) {
      // Permission denied on some system directories — skip silently.
    }
  }
}
