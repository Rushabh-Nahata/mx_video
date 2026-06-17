import 'package:drift/drift.dart' hide Column;
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/di/providers.dart';
import '../../../../models/sort_order.dart';
import '../../../../services/thumbnail_queue.dart';
import '../../data/repositories/library_repository_impl.dart';
import '../../domain/entities/media_file.dart';
import '../../domain/entities/media_folder.dart';
import '../../domain/repositories/library_repository.dart';
import '../../domain/usecases/get_folders.dart';
import '../../domain/usecases/get_recents.dart';

part 'library_provider.g.dart';

// ── Repository ─────────────────────────────────────────────────────────────

@riverpod
LibraryRepository libraryRepository(Ref ref) {
  final dao = ref.watch(mediaDaoProvider);
  final db = ref.watch(appDatabaseProvider);
  return LibraryRepositoryImpl(dao: dao, db: db);
}

// ── Sort order state ───────────────────────────────────────────────────────

@riverpod
class FolderSortOrder extends _$FolderSortOrder {
  @override
  SortOrder build() => SortOrder.dateDesc;

  void set(SortOrder order) => state = order;
}

// ── Search query state ─────────────────────────────────────────────────────

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void set(String query) => state = query;
  void clear() => state = '';
}

// ── Reactive data streams ──────────────────────────────────────────────────

@riverpod
Stream<List<MediaFolderEntity>> folders(Ref ref) =>
    GetFolders(ref.watch(libraryRepositoryProvider)).call();

@riverpod
Stream<List<MediaFileEntity>> filesInFolder(Ref ref, int folderId) =>
    ref.watch(libraryRepositoryProvider).watchFilesInFolder(folderId);

@riverpod
Stream<List<MediaFileEntity>> recents(Ref ref) =>
    GetRecents(ref.watch(libraryRepositoryProvider)).call();

@riverpod
Stream<List<MediaFileEntity>> favourites(Ref ref) =>
    ref.watch(libraryRepositoryProvider).watchFavourites();

@riverpod
Stream<List<MediaFileEntity>> allFiles(Ref ref) =>
    ref.watch(libraryRepositoryProvider).watchAllFiles();

// ── Sorted files for folder detail ─────────────────────────────────────────

@riverpod
class SortedFilesInFolder extends _$SortedFilesInFolder {
  @override
  AsyncValue<List<MediaFileEntity>> build(int folderId) {
    final filesAsync = ref.watch(filesInFolderProvider(folderId));
    final sortOrder = ref.watch(folderSortOrderProvider);
    return filesAsync.whenData((files) => _sortFiles(files, sortOrder));
  }
}

List<MediaFileEntity> _sortFiles(List<MediaFileEntity> files, SortOrder order) {
  final sorted = [...files];
  switch (order) {
    case SortOrder.name:
      sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    case SortOrder.nameDesc:
      sorted.sort((a, b) => b.name.toLowerCase().compareTo(a.name.toLowerCase()));
    case SortOrder.date:
      sorted.sort((a, b) => a.scannedAt.compareTo(b.scannedAt));
    case SortOrder.dateDesc:
      sorted.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
    case SortOrder.size:
      sorted.sort((a, b) => a.sizeBytes.compareTo(b.sizeBytes));
    case SortOrder.sizeDesc:
      sorted.sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));
    case SortOrder.duration:
      sorted.sort((a, b) => (a.durationMs ?? 0).compareTo(b.durationMs ?? 0));
  }
  return sorted;
}

// ── Search results ─────────────────────────────────────────────────────────

@riverpod
Stream<List<MediaFileEntity>> searchResults(Ref ref) {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.isEmpty) return Stream.value([]);
  return ref.watch(libraryRepositoryProvider).searchFiles(query);
}

// ── Thumbnail pre-loader ──────────────────────────────────────────────────
// Watches folders and pre-generates thumbnails for folders missing covers,
// sorted by video count (biggest folders first). Also pre-generates
// thumbnails for files in the largest folders so they're ready when the
// user taps in.

@riverpod
Future<void> thumbnailPreloader(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final dao = db.mediaDao;

  // Wait for folders to be available.
  final folders = await dao.select(dao.mediaFolders).get();
  if (folders.isEmpty) return;

  // Sort by video count descending.
  folders.sort((a, b) => b.videoCount.compareTo(a.videoCount));

  // Phase 1: Generate missing folder cover thumbnails.
  for (final folder in folders) {
    if (folder.thumbnailPath != null) continue;

    final files = await (dao.select(dao.mediaFiles)
          ..where((t) => t.folderId.equals(folder.id))
          ..limit(1))
        .get();

    if (files.isEmpty) continue;

    final thumbPath = await ThumbnailQueue.instance.requestPriority(
      files.first.absolutePath,
    );
    if (thumbPath != null) {
      await (dao.update(dao.mediaFiles)
            ..where((t) => t.id.equals(files.first.id)))
          .write(MediaFilesCompanion(thumbnailPath: Value(thumbPath)));
      await (dao.update(dao.mediaFolders)
            ..where((t) => t.id.equals(folder.id)))
          .write(MediaFoldersCompanion(thumbnailPath: Value(thumbPath)));
    }
  }

  // Phase 2: Pre-generate thumbnails for files in top folders.
  for (final folder in folders.take(10)) {
    final files = await (dao.select(dao.mediaFiles)
          ..where((t) => t.folderId.equals(folder.id))
          ..where((t) => t.thumbnailPath.isNull())
          ..limit(20))
        .get();

    for (final file in files) {
      final thumbPath = await ThumbnailQueue.instance.request(file.absolutePath);
      if (thumbPath != null) {
        await (dao.update(dao.mediaFiles)
              ..where((t) => t.id.equals(file.id)))
            .write(MediaFilesCompanion(thumbnailPath: Value(thumbPath)));
      }
    }
  }

  debugPrint('ThumbnailPreloader: done pre-loading');
}

// ── Grid column count (zoom level) ────────────────────────────────────────

@riverpod
class FolderGridColumns extends _$FolderGridColumns {
  @override
  int build() => 2;

  void set(int count) => state = count.clamp(2, 5);
}

@riverpod
class MediaViewColumns extends _$MediaViewColumns {
  @override
  int build() => 1; // 1 = list view, 2+ = grid

  void set(int count) => state = count.clamp(1, 4);
}

// ── Selection state ────────────────────────────────────────────────────────

@riverpod
class SelectionNotifier extends _$SelectionNotifier {
  @override
  Set<int> build() => {};

  bool get isActive => state.isNotEmpty;
  int get count => state.length;

  void toggle(int id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  void selectAll(List<int> ids) => state = ids.toSet();
  void addAll(List<int> ids) => state = {...state, ...ids};
  void clear() => state = {};
}
