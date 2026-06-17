import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_state.freezed.dart';

enum ScanPhase {
  idle,
  queryingPlatform,   // calling native MediaStore / PHPhotoLibrary
  processingFiles,    // isolate: dedup, folder grouping, DB prep
  savingToDatabase,   // batch upserting to Drift
  generatingThumbnails, // background thumbnail queue
  complete,
  error,
}

@freezed
abstract class ScanState with _$ScanState {
  const factory ScanState({
    @Default(ScanPhase.idle) ScanPhase phase,
    @Default(0) int scanned,
    @Default(0) int total,
    @Default(0) int foldersFound,
    @Default(0) int thumbnailsGenerated,
    String? currentFile,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _ScanState;

  const ScanState._();

  static const idle = ScanState();

  bool get isRunning => phase != ScanPhase.idle &&
      phase != ScanPhase.complete &&
      phase != ScanPhase.error;

  double get progress => total > 0 ? scanned / total : 0.0;

  /// Human-readable status string for the UI.
  String get statusLabel => switch (phase) {
        ScanPhase.idle => 'Ready',
        ScanPhase.queryingPlatform => 'Querying device media...',
        ScanPhase.processingFiles => 'Processing $total files...',
        ScanPhase.savingToDatabase => 'Saving $scanned / $total...',
        ScanPhase.generatingThumbnails =>
          'Thumbnails $thumbnailsGenerated / $total',
        ScanPhase.complete =>
          'Done — $scanned files in $foldersFound folders',
        ScanPhase.error => errorMessage ?? 'Scan failed',
      };

  Duration? get elapsed =>
      startedAt == null ? null : (completedAt ?? DateTime.now()).difference(startedAt!);
}
