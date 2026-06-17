import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../features/transfer/domain/entities/transfer_job.dart';

/// Coordinates multiple concurrent transfer jobs.
/// Exposes a combined progress stream consumed by the transfer UI.
///
/// Tracks in-flight jobs with real-time speed and ETA calculations.
class TransferOrchestrator {
  TransferOrchestrator._();
  static final TransferOrchestrator instance = TransferOrchestrator._();

  final _activeJobs = BehaviorSubject<List<TransferJobEntity>>.seeded([]);

  Stream<List<TransferJobEntity>> get jobsStream => _activeJobs.stream;
  List<TransferJobEntity> get currentJobs => _activeJobs.value;

  /// Number of currently active transfers.
  int get activeCount =>
      _activeJobs.value.where((j) => j.isActive).length;

  /// Total bytes transferred across all active jobs.
  int get totalBytesTransferred =>
      _activeJobs.value.fold(0, (sum, j) => sum + j.bytesTransferred);

  /// Total bytes to transfer across all active jobs.
  int get totalBytes =>
      _activeJobs.value.fold(0, (sum, j) => sum + j.fileSize);

  /// Overall progress (0.0 to 1.0) across all active jobs.
  double get overallProgress =>
      totalBytes > 0 ? totalBytesTransferred / totalBytes : 0.0;

  /// Aggregate speed across all active jobs (bytes/sec).
  int get aggregateSpeed =>
      _activeJobs.value.fold(0, (sum, j) => sum + j.speedBytesPerSec);

  void addJob(TransferJobEntity job) {
    _activeJobs.add([..._activeJobs.value, job]);
  }

  void updateJob(TransferJobEntity updated) {
    final jobs = _activeJobs.value
        .map((j) => j.id == updated.id ? updated : j)
        .toList();
    _activeJobs.add(jobs);
  }

  void removeJob(int jobId) {
    _activeJobs.add(
      _activeJobs.value.where((j) => j.id != jobId).toList(),
    );
  }

  void clear() {
    _activeJobs.add([]);
  }

  void dispose() => _activeJobs.close();
}
