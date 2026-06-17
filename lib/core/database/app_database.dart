import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/folder_dao.dart';
import 'daos/media_dao.dart';
import 'daos/playlist_dao.dart';
import 'daos/transfer_dao.dart';
import 'tables/media_table.dart';
import 'tables/playlist_table.dart';
import 'tables/transfer_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    MediaFiles,
    MediaFolders,
    Playlists,
    PlaylistEntries,
    TransferJobs,
  ],
  daos: [
    MediaDao,
    FolderDao,
    PlaylistDao,
    TransferDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _createIndexes();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(transferJobs, transferJobs.totalChunks);
            await m.addColumn(transferJobs, transferJobs.chunksTransferred);
            await m.addColumn(transferJobs, transferJobs.encrypted);
            await m.addColumn(transferJobs, transferJobs.filePath);
            await m.addColumn(transferJobs, transferJobs.socketPort);
            await m.addColumn(transferJobs, transferJobs.sessionId);
            await m.addColumn(transferJobs, transferJobs.peerDeviceId);
          }
          if (from < 3) {
            await _createIndexes();
          }
        },
        beforeOpen: (details) async {
          // Integrity & journaling.
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('PRAGMA journal_mode = WAL');

          // Performance tuning.
          await customStatement('PRAGMA busy_timeout = 3000');
          await customStatement('PRAGMA synchronous = NORMAL');
          await customStatement('PRAGMA cache_size = -8000'); // 8 MB
          await customStatement('PRAGMA mmap_size = 268435456'); // 256 MB
          await customStatement('PRAGMA temp_store = MEMORY');
        },
      );

  /// One-time index creation for query-heavy columns.
  Future<void> _createIndexes() async {
    // FK lookup — watchByFolder, _assignFolderThumbnails
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_files_folder_id '
      'ON media_files(folder_id)',
    );
    // Recents sort — watchRecents ORDER BY last_played_at DESC
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_files_last_played '
      'ON media_files(last_played_at DESC)',
    );
    // Favourites filter — sparse partial index (only true rows)
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_files_favourite '
      'ON media_files(is_favourite) WHERE is_favourite = 1',
    );
    // Date sort — folder detail default sort
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_files_scanned_at '
      'ON media_files(scanned_at DESC)',
    );
    // Name sort / search — case-insensitive
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_files_name '
      'ON media_files(name COLLATE NOCASE)',
    );
    // Size sort
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_files_size '
      'ON media_files(size_bytes DESC)',
    );
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'mx_video');
}
