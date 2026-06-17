// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_dao.dart';

// ignore_for_file: type=lint
mixin _$PlaylistDaoMixin on DatabaseAccessor<AppDatabase> {
  $PlaylistsTable get playlists => attachedDatabase.playlists;
  $MediaFoldersTable get mediaFolders => attachedDatabase.mediaFolders;
  $MediaFilesTable get mediaFiles => attachedDatabase.mediaFiles;
  $PlaylistEntriesTable get playlistEntries => attachedDatabase.playlistEntries;
  PlaylistDaoManager get managers => PlaylistDaoManager(this);
}

class PlaylistDaoManager {
  final _$PlaylistDaoMixin _db;
  PlaylistDaoManager(this._db);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db.attachedDatabase, _db.playlists);
  $$MediaFoldersTableTableManager get mediaFolders =>
      $$MediaFoldersTableTableManager(_db.attachedDatabase, _db.mediaFolders);
  $$MediaFilesTableTableManager get mediaFiles =>
      $$MediaFilesTableTableManager(_db.attachedDatabase, _db.mediaFiles);
  $$PlaylistEntriesTableTableManager get playlistEntries =>
      $$PlaylistEntriesTableTableManager(
        _db.attachedDatabase,
        _db.playlistEntries,
      );
}
