import 'package:drift/drift.dart';

/// Persisted record of every file transfer (sent and received).
/// Append-only — old records are pruned at startup after 30 days.
class TransferJobs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get peerName => text()();
  TextColumn get peerIp => text()();
  TextColumn get fileName => text()();
  IntColumn get fileSize => integer()();
  IntColumn get bytesTransferred => integer().withDefault(const Constant(0))();

  /// 'send' or 'receive'
  TextColumn get direction => text()();

  /// 'queued' | 'active' | 'paused' | 'completed' | 'failed' | 'cancelled'
  TextColumn get status => text().withDefault(const Constant('queued'))();

  TextColumn get checksum => text().nullable()();
  IntColumn get startedAt => integer().nullable()();
  IntColumn get finishedAt => integer().nullable()();
  TextColumn get savePath => text().nullable()();
  TextColumn get errorMessage => text().nullable()();

  // ── Socket transfer fields (schema v2) ──────────────────────────────────

  /// Total number of chunks for this file.
  IntColumn get totalChunks => integer().withDefault(const Constant(0))();

  /// Number of chunks already transferred.
  IntColumn get chunksTransferred => integer().withDefault(const Constant(0))();

  /// Whether this transfer was encrypted.
  BoolColumn get encrypted => boolean().withDefault(const Constant(false))();

  /// Source file path (for resume on sender side).
  TextColumn get filePath => text().nullable()();

  /// Peer's socket port (for reconnection/resume).
  IntColumn get socketPort => integer().nullable()();

  /// Groups multi-file transfers under one session.
  TextColumn get sessionId => text().nullable()();

  /// Peer device ID for identification.
  TextColumn get peerDeviceId => text().withDefault(const Constant(''))();
}
