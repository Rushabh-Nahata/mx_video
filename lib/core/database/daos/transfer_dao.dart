import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/transfer_table.dart';

part 'transfer_dao.g.dart';

@DriftAccessor(tables: [TransferJobs])
class TransferDao extends DatabaseAccessor<AppDatabase>
    with _$TransferDaoMixin {
  TransferDao(super.db);

  Future<int> insertJob(TransferJobsCompanion entry) =>
      into(transferJobs).insert(entry);

  Stream<List<TransferJob>> watchAll() =>
      (select(transferJobs)
            ..orderBy([(t) => OrderingTerm.desc(t.id)]))
          .watch();

  Stream<List<TransferJob>> watchActive() =>
      (select(transferJobs)
            ..where((t) => t.status.isIn(['queued', 'active', 'paused'])))
          .watch();

  Future<TransferJob?> getJob(int id) =>
      (select(transferJobs)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> updateStatus(int id, String status) =>
      (update(transferJobs)..where((t) => t.id.equals(id))).write(
        TransferJobsCompanion(status: Value(status)),
      );

  Future<void> updateProgress(int id, int bytesTransferred) =>
      (update(transferJobs)..where((t) => t.id.equals(id))).write(
        TransferJobsCompanion(bytesTransferred: Value(bytesTransferred)),
      );

  /// Update chunk-level progress for socket transfers.
  Future<void> updateChunkProgress(
      int id, int bytesTransferred, int chunksTransferred) =>
      (update(transferJobs)..where((t) => t.id.equals(id))).write(
        TransferJobsCompanion(
          bytesTransferred: Value(bytesTransferred),
          chunksTransferred: Value(chunksTransferred),
        ),
      );

  Future<void> markCompleted(int id, String checksum) =>
      (update(transferJobs)..where((t) => t.id.equals(id))).write(
        TransferJobsCompanion(
          status: const Value('completed'),
          checksum: Value(checksum),
          finishedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  Future<void> markCompletedWithPath(
          int id, String checksum, String savePath) =>
      (update(transferJobs)..where((t) => t.id.equals(id))).write(
        TransferJobsCompanion(
          status: const Value('completed'),
          checksum: Value(checksum),
          savePath: Value(savePath),
          finishedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  Future<void> markFailed(int id, String errorMessage) =>
      (update(transferJobs)..where((t) => t.id.equals(id))).write(
        TransferJobsCompanion(
          status: const Value('failed'),
          errorMessage: Value(errorMessage),
          finishedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );

  /// Get all jobs for a session (multi-file transfer).
  Future<List<TransferJob>> getJobsBySession(String sessionId) =>
      (select(transferJobs)
            ..where((t) => t.sessionId.equals(sessionId)))
          .get();

  /// Deletes transfer records older than [days] days.
  Future<int> pruneOlderThan(int days) {
    final cutoff = DateTime.now()
        .subtract(Duration(days: days))
        .millisecondsSinceEpoch;
    return (delete(transferJobs)
          ..where(
            (t) =>
                t.finishedAt.isSmallerThanValue(cutoff) &
                t.status.isIn(['completed', 'failed', 'cancelled']),
          ))
        .go();
  }
}
