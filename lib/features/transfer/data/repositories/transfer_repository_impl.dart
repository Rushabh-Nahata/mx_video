import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/transfer_dao.dart';
import '../../../../services/transfer_orchestrator.dart';
import '../../domain/entities/peer_device.dart';
import '../../domain/entities/transfer_job.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../sources/ble_discovery_source.dart';
import '../sources/mdns_source.dart';
import '../sources/qr_pairing_source.dart';
import '../socket/socket_transfer_client.dart';
import '../socket/encryption_handler.dart';
import '../socket/transfer_protocol.dart';
import '../socket/transfer_queue.dart';
import '../transfer_client.dart';
import '../transfer_server.dart';

final _log = Logger(printer: SimplePrinter());

class TransferRepositoryImpl implements TransferRepository {
  TransferRepositoryImpl({
    required this.dao,
    required this.mdns,
    required this.ble,
    required this.qr,
    required this.server,
    required this.client,
    required this.deviceName,
    required this.platform,
  });

  final TransferDao dao;
  final MdnsSource mdns;
  final BleDiscoverySource ble;
  final QrPairingSource qr;
  final TransferServer server;
  final TransferClient client;
  final String deviceName;
  final String platform;

  late final TransferQueue _queue = TransferQueue()
    ..onJobCompleted = _onJobCompleted
    ..onProgress = _onProgress;

  String? _sessionToken;

  // ── Discovery ──────────────────────────────────────────────────────────

  @override
  Stream<List<PeerDevice>> discoverPeers() {
    final mdnsStream = mdns.discoverPeers().handleError(
      (e) => _log.w('mDNS discovery error: $e'),
    );

    final bleStream = ble.discoverPeers().handleError(
      (e) => _log.w('BLE discovery error: $e'),
    );

    return Rx.combineLatest2<List<PeerDevice>, List<PeerDevice>,
        List<PeerDevice>>(
      mdnsStream.startWith([]),
      bleStream.startWith([]),
      (mdnsPeers, blePeers) {
        final merged = <String, PeerDevice>{};
        for (final peer in mdnsPeers) {
          merged[peer.ipAddress.isNotEmpty ? peer.ipAddress : peer.id] = peer;
        }
        for (final peer in blePeers) {
          final key = peer.ipAddress.isNotEmpty ? peer.ipAddress : peer.id;
          if (!merged.containsKey(key)) {
            merged[key] = peer;
          }
        }
        return merged.values.toList();
      },
    );
  }

  @override
  Future<void> startAdvertising() async {
    await mdns.startAdvertising(
      deviceName: deviceName,
      port: server.port,
      platform: platform,
    );
  }

  @override
  Future<void> stopAdvertising() async {
    await mdns.stopAdvertising();
  }

  // ── Server ─────────────────────────────────────────────────────────────

  @override
  Future<void> startServer() async {
    server.configure(deviceName: deviceName, platform: platform);

    // Wire up HTTP server callbacks for legacy transfers.
    server.onTransferOffer = (peerName, fileName, fileSize) async {
      final jobId = await dao.insertJob(TransferJobsCompanion(
        peerName: Value(peerName),
        peerIp: const Value(''),
        fileName: Value(fileName),
        fileSize: Value(fileSize),
        direction: const Value('receive'),
        status: const Value('active'),
        startedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ));
      _log.i(
          'Receiving "$fileName" ($fileSize bytes) from $peerName [job=$jobId]');
      return true;
    };

    server.onReceiveProgress = (fileName, bytesReceived, totalBytes) {
      _updateReceiveJobProgress(fileName, bytesReceived);
    };

    server.onFileReceived = (fileName, savePath, checksum, peerName) {
      _completeReceiveJob(fileName, savePath, checksum);
      _log.i('Received "$fileName" → $savePath');
    };

    // Wire up socket server callbacks.
    server.socketServer.onTransferOffer = (token, files) async {
      for (final entry in files) {
        await dao.insertJob(TransferJobsCompanion(
          peerName: const Value('Peer'),
          peerIp: const Value(''),
          fileName: Value(entry.fileName),
          fileSize: Value(entry.fileSize),
          direction: const Value('receive'),
          status: const Value('active'),
          startedAt: Value(DateTime.now().millisecondsSinceEpoch),
          totalChunks: Value(
              (entry.fileSize + AppConstants.transferChunkBytes - 1) ~/
                  AppConstants.transferChunkBytes),
          sessionId: Value(token),
        ));
      }
      return true;
    };

    server.socketServer.onChunkReceived =
        (sessionId, fileIndex, chunkIndex, chunkSize, totalChunks) {
      _updateReceiveChunkProgress(sessionId, fileIndex, chunkSize, totalChunks);
    };

    server.socketServer.onFileReceived =
        (sessionId, fileIndex, fileName, savePath, checksum) {
      _completeReceiveJob(fileName, savePath, checksum);
      _log.i('Socket received "$fileName" → $savePath');
    };

    await server.start();
  }

  @override
  Future<void> stopServer() => server.stop();

  @override
  int get serverPort => server.port;

  // ── Transfer (socket-based) ─────────────────────────────────────────────

  @override
  Future<TransferJobEntity> sendFile(PeerDevice peer, String filePath) async {
    return (await sendFiles(peer, [filePath])).first;
  }

  @override
  Future<List<TransferJobEntity>> sendFiles(
      PeerDevice peer, List<String> filePaths) async {
    final jobs = <TransferJobEntity>[];
    final sessionId =
        '${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}_${peer.id}';

    // Step 1: Pair with receiver (get session token).
    final token = peer.sessionToken ??
        await client.pair(
          peer: peer,
          deviceName: deviceName,
          platform: platform,
        );

    // Step 2: Negotiate socket port.
    int socketPort;
    try {
      final negotiation =
          await client.negotiate(peer: peer, token: token);
      socketPort = negotiation.socketPort;
    } catch (_) {
      // Fallback to HTTP-based transfer if /negotiate is not available.
      socketPort = peer.port;
    }

    for (final path in filePaths) {
      final file = File(path);
      if (!await file.exists()) continue;

      final fileName = p.basename(path);
      final fileSize = await file.length();
      final totalChunks =
          (fileSize + AppConstants.transferChunkBytes - 1) ~/
              AppConstants.transferChunkBytes;

      final jobId = await dao.insertJob(TransferJobsCompanion(
        peerName: Value(peer.name),
        peerIp: Value(peer.ipAddress),
        fileName: Value(fileName),
        fileSize: Value(fileSize),
        direction: const Value('send'),
        status: const Value('queued'),
        startedAt: Value(DateTime.now().millisecondsSinceEpoch),
        totalChunks: Value(totalChunks),
        filePath: Value(path),
        socketPort: Value(socketPort),
        sessionId: Value(sessionId),
        peerDeviceId: Value(peer.id),
      ));

      final job = TransferJobEntity(
        id: jobId,
        peerName: peer.name,
        peerIp: peer.ipAddress,
        fileName: fileName,
        fileSize: fileSize,
        direction: TransferDirection.send,
        status: TransferStatus.queued,
        startedAt: DateTime.now().millisecondsSinceEpoch,
      );

      TransferOrchestrator.instance.addJob(job);
      jobs.add(job);
    }

    // Enqueue all files as a single transfer batch.
    _queue.enqueue(QueuedTransfer(
      jobId: jobs.first.id,
      peer: peer,
      filePaths: filePaths,
      direction: TransferDirection.send,
      socketPort: socketPort,
      sessionToken: token,
    ));

    return jobs;
  }

  @override
  Future<void> pauseJob(int jobId) async {
    await _queue.pause(jobId);
    await dao.updateStatus(jobId, 'paused');
    TransferOrchestrator.instance.removeJob(jobId);
  }

  @override
  Future<void> resumeJob(int jobId) async {
    await _queue.resume(jobId);
    await dao.updateStatus(jobId, 'active');
  }

  @override
  Future<void> cancelJob(int jobId) async {
    await _queue.cancel(jobId);
    await dao.updateStatus(jobId, 'cancelled');
    TransferOrchestrator.instance.removeJob(jobId);
  }

  @override
  Future<void> retryJob(int jobId) async {
    await dao.updateStatus(jobId, 'queued');
  }

  // ── Pairing ────────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> generatePairingInfo() async {
    if (!server.isRunning) await startServer();

    _sessionToken ??= DateTime.now().millisecondsSinceEpoch.toRadixString(36);

    return qr.generatePairingData(
      port: server.port,
      deviceName: deviceName,
      platform: platform,
      sessionToken: _sessionToken!,
    );
  }

  @override
  Future<PeerDevice> connectFromQr(Map<String, dynamic> pairingData) async {
    final peer = qr.peerFromPairingData(pairingData);
    if (peer == null) {
      throw Exception('Invalid QR pairing data');
    }
    return peer;
  }

  // ── History ────────────────────────────────────────────────────────────

  @override
  Stream<List<TransferJobEntity>> watchJobs() =>
      dao.watchAll().map((rows) => rows.map(_mapJob).toList());

  @override
  Future<void> pruneHistory() =>
      dao.pruneOlderThan(AppConstants.transferHistoryRetentionDays);

  // ── Queue callbacks ────────────────────────────────────────────────────

  void _onJobCompleted(int jobId, bool success, String? error) {
    if (success) {
      dao.markCompleted(jobId, '');
      _log.i('Transfer job $jobId completed successfully');
    } else {
      dao.markFailed(jobId, error ?? 'Transfer failed');
      _log.e('Transfer job $jobId failed: $error');
    }
    TransferOrchestrator.instance.removeJob(jobId);
  }

  void _onProgress(
      int jobId, int bytesTransferred, int totalBytes, int speed) {
    dao.updateProgress(jobId, bytesTransferred);
    TransferOrchestrator.instance.updateJob(
      TransferJobEntity(
        id: jobId,
        peerName: '',
        peerIp: '',
        fileName: '',
        fileSize: totalBytes,
        bytesTransferred: bytesTransferred,
        direction: TransferDirection.send,
        status: TransferStatus.active,
        speedBytesPerSec: speed,
      ),
    );
  }

  // ── Internal helpers ───────────────────────────────────────────────────

  Future<void> _updateReceiveJobProgress(
      String fileName, int bytesReceived) async {
    final jobs = await dao.watchActive().first;
    for (final job in jobs) {
      if (job.fileName == fileName &&
          job.direction == 'receive' &&
          job.status == 'active') {
        await dao.updateProgress(job.id, bytesReceived);
        break;
      }
    }
  }

  Future<void> _updateReceiveChunkProgress(
      String sessionId, int fileIndex, int chunkSize, int totalChunks) async {
    final jobs = await dao.getJobsBySession(sessionId);
    if (fileIndex < jobs.length) {
      final job = jobs[fileIndex];
      await dao.updateChunkProgress(
        job.id,
        job.bytesTransferred + chunkSize,
        job.chunksTransferred + 1,
      );
    }
  }

  Future<void> _completeReceiveJob(
      String fileName, String savePath, String checksum) async {
    final jobs = await dao.watchActive().first;
    for (final job in jobs) {
      if (job.fileName == fileName &&
          job.direction == 'receive' &&
          job.status == 'active') {
        await dao.markCompleted(job.id, checksum);
        break;
      }
    }
  }

  TransferJobEntity _mapJob(TransferJob row) => TransferJobEntity(
        id: row.id,
        peerName: row.peerName,
        peerIp: row.peerIp,
        fileName: row.fileName,
        fileSize: row.fileSize,
        bytesTransferred: row.bytesTransferred,
        direction: row.direction == 'send'
            ? TransferDirection.send
            : TransferDirection.receive,
        status: TransferStatus.values.firstWhere(
          (s) => s.name == row.status,
          orElse: () => TransferStatus.queued,
        ),
        checksum: row.checksum,
        startedAt: row.startedAt,
        finishedAt: row.finishedAt,
        savePath: row.savePath,
        errorMessage: row.errorMessage,
      );
}
