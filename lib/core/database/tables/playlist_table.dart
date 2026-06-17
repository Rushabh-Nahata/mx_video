import 'package:drift/drift.dart';

import 'media_table.dart';

/// User-created playlists.
class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get createdAt => integer()();
}

/// Ordered entries within a playlist.
class PlaylistEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get playlistId => integer().references(Playlists, #id)();
  IntColumn get mediaId => integer().references(MediaFiles, #id)();
  IntColumn get sortOrder => integer()();
}
