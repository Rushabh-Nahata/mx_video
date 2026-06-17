import '../entities/media_file.dart';
import '../entities/media_folder.dart';
import '../entities/scan_state.dart';

/// Abstract contract for the library data layer.
abstract interface class LibraryRepository {
  // ── Reactive queries ───────────────────────────────────────────────────────
  Stream<List<MediaFolderEntity>> watchFolders();
  Stream<List<MediaFileEntity>> watchFilesInFolder(int folderId);
  Stream<List<MediaFileEntity>> watchRecents({int limit = 50});
  Stream<List<MediaFileEntity>> watchFavourites();
  Stream<List<MediaFileEntity>> watchAllFiles();
  Stream<List<MediaFileEntity>> searchFiles(String query);

  // ── Scanning ───────────────────────────────────────────────────────────────

  /// Starts a full scan and returns a stream of progress states.
  /// The stream completes after [ScanPhase.complete] or [ScanPhase.error].
  Stream<ScanState> scan({List<String>? rootPaths});

  // ── Playback tracking ──────────────────────────────────────────────────────
  Future<void> updatePlaybackPosition(int fileId, int positionMs);
  Future<void> toggleFavourite(int fileId, {required bool value});
}
