import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/media_table.dart';

part 'folder_dao.g.dart';

@DriftAccessor(tables: [MediaFolders])
class FolderDao extends DatabaseAccessor<AppDatabase> with _$FolderDaoMixin {
  FolderDao(super.db);

  Stream<List<MediaFolder>> watchRootFolders() =>
      (select(mediaFolders)..where((t) => t.parentId.isNull())).watch();

  Stream<List<MediaFolder>> watchChildren(int parentId) =>
      (select(mediaFolders)
            ..where((t) => t.parentId.equals(parentId)))
          .watch();

  Future<MediaFolder?> getById(int id) =>
      (select(mediaFolders)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> updateCounts(int id, int videoCount, int audioCount) =>
      (update(mediaFolders)..where((t) => t.id.equals(id))).write(
        MediaFoldersCompanion(
          videoCount: Value(videoCount),
          audioCount: Value(audioCount),
        ),
      );

  Future<int> deleteFolder(int id) =>
      (delete(mediaFolders)..where((t) => t.id.equals(id))).go();
}
