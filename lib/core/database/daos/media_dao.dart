import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/media_table.dart';

part 'media_dao.g.dart';

@DriftAccessor(tables: [MediaFiles, MediaFolders])
class MediaDao extends DatabaseAccessor<AppDatabase> with _$MediaDaoMixin {
  MediaDao(super.db);

  // ── Files ──────────────────────────────────────────────────────────────────

  Future<int> upsertFile(MediaFilesCompanion entry) =>
      into(mediaFiles).insertOnConflictUpdate(entry);

  Future<void> upsertFiles(List<MediaFilesCompanion> entries) => batch((b) {
        for (final entry in entries) {
          b.insert(
            mediaFiles,
            entry,
            onConflict: DoUpdate(
              (_) => entry,
              target: [mediaFiles.absolutePath],
            ),
          );
        }
      });

  Stream<List<MediaFile>> watchByFolder(int folderId) =>
      (select(mediaFiles)..where((t) => t.folderId.equals(folderId))).watch();

  Stream<List<MediaFile>> watchRecents({int limit = 50}) =>
      (select(mediaFiles)
            ..where((t) => t.lastPlayedAt.isNotNull())
            ..orderBy([(t) => OrderingTerm.desc(t.lastPlayedAt)])
            ..limit(limit))
          .watch();

  Stream<List<MediaFile>> watchFavourites() =>
      (select(mediaFiles)..where((t) => t.isFavourite.equals(true))).watch();

  Stream<List<MediaFile>> watchAllFiles() => select(mediaFiles).watch();

  Future<List<MediaFile>> getAllFiles() => select(mediaFiles).get();

  Future<List<MediaFile>> getFilesByIds(List<int> ids) =>
      (select(mediaFiles)..where((t) => t.id.isIn(ids))).get();

  Future<void> deleteFiles(List<int> ids) =>
      (delete(mediaFiles)..where((t) => t.id.isIn(ids))).go();

  Future<MediaFile?> findByPath(String path) =>
      (select(mediaFiles)..where((t) => t.absolutePath.equals(path)))
          .getSingleOrNull();

  Future<void> updatePlaybackPosition(int id, int positionMs) =>
      (update(mediaFiles)..where((t) => t.id.equals(id))).write(
        MediaFilesCompanion(
          playPositionMs: Value(positionMs),
          lastPlayedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  Future<void> incrementPlayCount(int id) async {
    final file = await (select(mediaFiles)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (file == null) return;
    await (update(mediaFiles)..where((t) => t.id.equals(id))).write(
      MediaFilesCompanion(playCount: Value(file.playCount + 1)),
    );
  }

  Future<void> toggleFavourite(int id, {required bool value}) =>
      (update(mediaFiles)..where((t) => t.id.equals(id))).write(
        MediaFilesCompanion(isFavourite: Value(value)),
      );

  Future<int> deleteFile(int id) =>
      (delete(mediaFiles)..where((t) => t.id.equals(id))).go();

  /// Clears all media files and folders for a full rescan.
  Future<void> clearAll() async {
    await delete(mediaFiles).go();
    await delete(mediaFolders).go();
  }

  // ── Folders ────────────────────────────────────────────────────────────────

  Future<int> upsertFolder(MediaFoldersCompanion entry) =>
      into(mediaFolders).insertOnConflictUpdate(entry);

  Future<void> upsertFolders(List<MediaFoldersCompanion> entries) => batch((b) {
        for (final entry in entries) {
          b.insert(
            mediaFolders,
            entry,
            onConflict: DoUpdate(
              (_) => entry,
              target: [mediaFolders.absolutePath],
            ),
          );
        }
      });

  Stream<List<MediaFolder>> watchAllFolders() =>
      (select(mediaFolders)
            ..orderBy([(t) => OrderingTerm.desc(t.videoCount)]))
          .watch();

  Future<MediaFolder?> findFolderByPath(String path) =>
      (select(mediaFolders)..where((t) => t.absolutePath.equals(path)))
          .getSingleOrNull();

  /// Returns a map of absolutePath → id for the given folder paths.
  Future<Map<String, int>> getFolderIdsByPaths(List<String> paths) async {
    final rows = await (select(mediaFolders)
          ..where((t) => t.absolutePath.isIn(paths)))
        .get();
    return {for (final r in rows) r.absolutePath: r.id};
  }

  /// Search files by name using SQL LIKE for efficient DB-level filtering.
  Stream<List<MediaFile>> searchFiles(String query) {
    return (select(mediaFiles)
          ..where((t) => t.name.like('%$query%'))
          ..limit(200))
        .watch();
  }
}
