// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'folder_dao.dart';

// ignore_for_file: type=lint
mixin _$FolderDaoMixin on DatabaseAccessor<AppDatabase> {
  $MediaFoldersTable get mediaFolders => attachedDatabase.mediaFolders;
  FolderDaoManager get managers => FolderDaoManager(this);
}

class FolderDaoManager {
  final _$FolderDaoMixin _db;
  FolderDaoManager(this._db);
  $$MediaFoldersTableTableManager get mediaFolders =>
      $$MediaFoldersTableTableManager(_db.attachedDatabase, _db.mediaFolders);
}
