// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_dao.dart';

// ignore_for_file: type=lint
mixin _$MediaDaoMixin on DatabaseAccessor<AppDatabase> {
  $MediaFoldersTable get mediaFolders => attachedDatabase.mediaFolders;
  $MediaFilesTable get mediaFiles => attachedDatabase.mediaFiles;
  MediaDaoManager get managers => MediaDaoManager(this);
}

class MediaDaoManager {
  final _$MediaDaoMixin _db;
  MediaDaoManager(this._db);
  $$MediaFoldersTableTableManager get mediaFolders =>
      $$MediaFoldersTableTableManager(_db.attachedDatabase, _db.mediaFolders);
  $$MediaFilesTableTableManager get mediaFiles =>
      $$MediaFilesTableTableManager(_db.attachedDatabase, _db.mediaFiles);
}
