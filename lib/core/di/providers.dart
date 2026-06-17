import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/daos/folder_dao.dart';
import '../database/daos/media_dao.dart';
import '../database/daos/playlist_dao.dart';
import '../database/daos/transfer_dao.dart';

/// The single [AppDatabase] instance.
/// Overridden in [main.dart] via [ProviderScope.overrides] so the DB
/// is opened before the widget tree is built.
final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('Override appDatabaseProvider in main()'),
);

/// DAO providers — derived from the single database instance.
final mediaDaoProvider = Provider<MediaDao>(
  (ref) => ref.watch(appDatabaseProvider).mediaDao,
);

final folderDaoProvider = Provider<FolderDao>(
  (ref) => ref.watch(appDatabaseProvider).folderDao,
);

final playlistDaoProvider = Provider<PlaylistDao>(
  (ref) => ref.watch(appDatabaseProvider).playlistDao,
);

final transferDaoProvider = Provider<TransferDao>(
  (ref) => ref.watch(appDatabaseProvider).transferDao,
);
