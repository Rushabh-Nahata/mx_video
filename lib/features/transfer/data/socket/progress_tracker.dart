import 'dart:async';
import 'dart:collection';

import '../../../../core/constants/app_constants.dart';

/// Tracks transfer progress for a single job with speed and ETA calculation.
class ProgressTracker {
  ProgressTracker({
    required this.jobId,
    required this.totalBytes,
    required this.totalChunks,
    int initialBytesTransferred = 0,
    int initialChunksTransferred = 0,
  })  : _bytesTransferred = initialBytesTransferred,
        _chunksTransferred = initialChunksTransferred;

  final int jobId;
  final int totalBytes;
  final int totalChunks;

  int _bytesTransferred;
  int _chunksTransferred;
  final _speedSamples = Queue<_SpeedSample>();

  final _controller = StreamController<TransferProgress>.broadcast();
  DateTime? _lastEmit;

  /// Update with a completed chunk.
  void onChunkCompleted(int chunkSizeBytes) {
    _bytesTransferred += chunkSizeBytes;
    _chunksTransferred++;

    _speedSamples.addLast(_SpeedSample(
      timestamp: DateTime.now(),
      bytes: chunkSizeBytes,
    ));

    // Keep only last 5 seconds of samples for moving average.
    final cutoff = DateTime.now().subtract(const Duration(seconds: 5));
    while (_speedSamples.isNotEmpty &&
        _speedSamples.first.timestamp.isBefore(cutoff)) {
      _speedSamples.removeFirst();
    }

    _maybeEmit();
  }

  /// Current progress 0.0 to 1.0.
  double get progress =>
      totalBytes > 0 ? _bytesTransferred / totalBytes : 0.0;

  /// Percentage 0-100.
  int get percentage => (progress * 100).round();

  int get bytesTransferred => _bytesTransferred;
  int get chunksTransferred => _chunksTransferred;

  /// Moving-average speed in bytes/sec (last 5 seconds).
  int get speedBytesPerSec {
    if (_speedSamples.isEmpty) return 0;
    final oldest = _speedSamples.first.timestamp;
    final elapsed =
        DateTime.now().difference(oldest).inMilliseconds;
    if (elapsed <= 0) return 0;
    final totalSampleBytes =
        _speedSamples.fold<int>(0, (sum, s) => sum + s.bytes);
    return (totalSampleBytes * 1000 / elapsed).round();
  }

  /// ETA based on moving-average speed.
  Duration? get eta {
    final speed = speedBytesPerSec;
    if (speed <= 0) return null;
    final remaining = totalBytes - _bytesTransferred;
    if (remaining <= 0) return Duration.zero;
    return Duration(seconds: remaining ~/ speed);
  }

  /// Throttled stream of progress updates.
  Stream<TransferProgress> get progressStream => _controller.stream;

  void _maybeEmit() {
    final now = DateTime.now();
    if (_lastEmit != null &&
        now.difference(_lastEmit!).inMilliseconds <
            AppConstants.transferProgressIntervalMs) {
      return;
    }
    _lastEmit = now;
    if (_controller.isClosed) return;
    _controller.add(TransferProgress(
      jobId: jobId,
      bytesTransferred: _bytesTransferred,
      totalBytes: totalBytes,
      chunksTransferred: _chunksTransferred,
      totalChunks: totalChunks,
      progress: progress,
      speedBytesPerSec: speedBytesPerSec,
      eta: eta,
    ));
  }

  /// Force-emit a final progress update.
  void emitFinal() {
    if (_controller.isClosed) return;
    _controller.add(TransferProgress(
      jobId: jobId,
      bytesTransferred: _bytesTransferred,
      totalBytes: totalBytes,
      chunksTransferred: _chunksTransferred,
      totalChunks: totalChunks,
      progress: progress,
      speedBytesPerSec: speedBytesPerSec,
      eta: eta,
    ));
  }

  void dispose() {
    if (!_controller.isClosed) _controller.close();
  }
}

class TransferProgress {
  const TransferProgress({
    required this.jobId,
    required this.bytesTransferred,
    required this.totalBytes,
    required this.chunksTransferred,
    required this.totalChunks,
    required this.progress,
    required this.speedBytesPerSec,
    this.eta,
  });

  final int jobId;
  final int bytesTransferred;
  final int totalBytes;
  final int chunksTransferred;
  final int totalChunks;
  final double progress;
  final int speedBytesPerSec;
  final Duration? eta;

  int get percentage => (progress * 100).round();
}

class _SpeedSample {
  const _SpeedSample({required this.timestamp, required this.bytes});
  final DateTime timestamp;
  final int bytes;
}
