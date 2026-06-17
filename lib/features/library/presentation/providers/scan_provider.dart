import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/utils/permission_helper.dart';
import '../../../../services/media_scanner_service.dart';
import '../../domain/entities/scan_state.dart';

part 'scan_provider.g.dart';

/// Exposes [ScanState] to the UI and drives [MediaScannerService.scan].
///
/// The notifier owns the scan lifecycle:
///   - [startScan] kicks off a new scan (cancels any in-progress scan).
///   - State flows through all [ScanPhase] values and settles on
///     [ScanPhase.complete] or [ScanPhase.error].
///   - The UI can cancel via [cancel] (stops consuming the stream; the
///     current DB chunk finishes, then no more chunks are written).
@riverpod
class ScanNotifier extends _$ScanNotifier {
  StreamSubscription<ScanState>? _subscription;
  bool _hasScannedOnce = false;

  @override
  ScanState build() {
    ref.onDispose(() => _subscription?.cancel());

    // Auto-trigger scan only if DB is empty (first launch).
    if (!_hasScannedOnce) {
      _hasScannedOnce = true;
      Future.microtask(() => _scanIfEmpty());
    }

    return ScanState.idle;
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  Future<void> startScan({List<String>? rootPaths}) async {
    // Cancel any in-progress scan first.
    await _subscription?.cancel();
    _subscription = null;

    // Request storage/media permissions before scanning.
    final granted = await PermissionHelper.requestStoragePermission();
    if (!granted) {
      state = ScanState(
        phase: ScanPhase.error,
        errorMessage:
            'Storage permission denied. Please grant access in Settings.',
        completedAt: DateTime.now(),
      );
      return;
    }

    state = ScanState(
      phase: ScanPhase.queryingPlatform,
      startedAt: DateTime.now(),
    );

    final db = ref.read(appDatabaseProvider);
    final service = MediaScannerService(db: db);

    _subscription = service
        .scan(rootPaths: rootPaths)
        .listen(
          (s) => state = s,
          onError: (Object e) => state = ScanState(
            phase: ScanPhase.error,
            errorMessage: e.toString(),
            completedAt: DateTime.now(),
          ),
          cancelOnError: true,
        );
  }

  static const _kDateFixApplied = 'date_fix_v1_applied';

  /// Scan if DB is empty (first launch) OR if the date-sort fix hasn't been
  /// applied yet (one-time rescan to overwrite stale scannedAt values).
  Future<void> _scanIfEmpty() async {
    final db = ref.read(appDatabaseProvider);
    final folders = await db.mediaDao.select(db.mediaDao.mediaFolders).get();
    if (folders.isEmpty) {
      await startScan();
      return;
    }
    // One-time rescan to fix scannedAt dates for existing records.
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_kDateFixApplied)) {
      await startScan();
      await prefs.setBool(_kDateFixApplied, true);
    }
  }

  Future<void> cancel() async {
    await _subscription?.cancel();
    _subscription = null;
    state = ScanState.idle;
  }

  // ── Convenience getters ────────────────────────────────────────────────────

  bool get isScanning => state.isRunning;
  double get progress => state.progress;
}
