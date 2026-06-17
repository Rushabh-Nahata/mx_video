import '../entities/peer_device.dart';
import '../entities/transfer_job.dart';

abstract interface class TransferRepository {
  // ── Discovery ──────────────────────────────────────────────────────────
  /// Combined stream of peers from all discovery sources (mDNS, BLE, QR).
  Stream<List<PeerDevice>> discoverPeers();

  /// Start advertising this device on the local network.
  Future<void> startAdvertising();

  /// Stop advertising.
  Future<void> stopAdvertising();

  // ── Server ─────────────────────────────────────────────────────────────
  Future<void> startServer();
  Future<void> stopServer();

  /// The port the transfer server is listening on.
  int get serverPort;

  // ── Transfer ───────────────────────────────────────────────────────────
  /// Send a file to a peer. Returns the created job entity.
  /// Streams progress updates to the orchestrator.
  Future<TransferJobEntity> sendFile(PeerDevice peer, String filePath);

  /// Send multiple files to a peer. Returns job entities for each file.
  Future<List<TransferJobEntity>> sendFiles(
      PeerDevice peer, List<String> filePaths);

  /// Pause an active transfer.
  Future<void> pauseJob(int jobId);

  /// Resume a paused or failed transfer.
  Future<void> resumeJob(int jobId);

  /// Cancel a transfer.
  Future<void> cancelJob(int jobId);

  /// Retry a failed or cancelled transfer.
  Future<void> retryJob(int jobId);

  // ── Pairing ────────────────────────────────────────────────────────────
  /// Generate pairing info for QR code display.
  Future<Map<String, dynamic>> generatePairingInfo();

  /// Connect to a peer using QR pairing data.
  Future<PeerDevice> connectFromQr(Map<String, dynamic> pairingData);

  // ── History ────────────────────────────────────────────────────────────
  Stream<List<TransferJobEntity>> watchJobs();
  Future<void> pruneHistory();
}
