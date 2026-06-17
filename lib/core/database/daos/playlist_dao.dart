import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/playlist_table.dart';

part 'playlist_dao.g.dart';

@DriftAccessor(tables: [Playlists, PlaylistEntries])
class PlaylistDao extends DatabaseAccessor<AppDatabase>
    with _$PlaylistDaoMixin {
  PlaylistDao(super.db);

  Stream<List<Playlist>> watchAll() =>
      (select(playlists)
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  Future<int> createPlaylist(String name) => into(playlists).insert(
        PlaylistsCompanion.insert(
          name: name,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );

  Future<void> addEntry(int playlistId, int mediaId, int sortOrder) =>
      into(playlistEntries).insert(
        PlaylistEntriesCompanion.insert(
          playlistId: playlistId,
          mediaId: mediaId,
          sortOrder: sortOrder,
        ),
      );

  Stream<List<PlaylistEntry>> watchEntries(int playlistId) =>
      (select(playlistEntries)
            ..where((t) => t.playlistId.equals(playlistId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<int> deletePlaylist(int id) =>
      (delete(playlists)..where((t) => t.id.equals(id))).go();
}
