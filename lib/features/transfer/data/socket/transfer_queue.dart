import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/peer_device.dart';
import '../../domain/entities/transfer_job.dart';
import 'encryption_handler.dart';
import 'socket_transfer_client.dart';
import 'transfer_protocol.dart';

final _log = Logger(printer: SimplePrinter());

/// Queued transfer item.
class QueuedTransfer {
  QueuedTransfer({
    required this.jobId,
    required this.peer,
    required this.filePaths,
    required this.direction,
    this.encrypted = false,
    this.socketPort,
    this.sessionToken,
  });

  final int jobId;
  final PeerDevice peer;
  final List<String> filePaths;
  final TransferDirection direction;
  final bool encrypted;
  final int? socketPort;
  final String? sessionToken;

  TransferStatus status = TransferStatus.queued;
  int bytesTransferred = 0;
  int speedBytesPerSec = 0;
}

/// Manages a queue of file transfers with concurrency limits.
///
/// Up to [maxConcurrent] transfers execute simultaneously.
/// When one completes, the next queued item starts automatically.
class TransferQueue {
  TransferQueue({
    this.maxConcurrent = AppConstants.maxConcurrentTransfers,
  });

  final int maxConcurrent;
  final _queue = Queue<QueuedTransfer>();
  final _active = <int, _ActiveTransfer>{};
  final _controller =
      StreamController<List<TransferJobEntity>>.broadcast();

  /// Callback invoked when a job completes (success or failure).
  void Function(int jobId, bool success, String? error)? onJobCompleted;

  /// Callback invoked for progress updates.
  void Function(int jobId, int bytesTransferred, int totalBytes,
      int speedBytesPerSec)? onProgress;

  Stream<List<TransferJobEntity>> get stateStream => _controller.stream;

  /// Add a transfer to the queue. Starts processing if under the limit.
  void enqueue(QueuedTransfer transfer) {
    _queue.add(transfer);
    _processNext();
  }

  /// Pause a specific job.
  Future<void> pause(int jobId) async {
    final active = _active[jobId];
    if (active != null) {
      active.client.pause();
      active.transfer.status = TransferStatus.paused;
    }
  }

  /// Resume a paused job.
  Future<void> resume(int jobId) async {
    final active = _active[jobId];
    if (active != null) {
      active.client.resume();
      active.transfer.status = TransferStatus.active;
    }
  }

  /// Cancel a specific job.
  Future<void> cancel(int jobId) async {
    // Remove from queue if still waiting.
    _queue.removeWhere((t) => t.jobId == jobId);

    // Cancel if active.
    final active = _active[jobId];
    if (active != null) {
      await active.client.cancel();
      await active.client.dispose();
      _active.remove(jobId);
      active.transfer.status = TransferStatus.cancelled;
      onJobCompleted?.call(jobId, false, 'Cancelled');
      _processNext();
    }
  }

  /// Cancel all jobs for a peer.
  Future<void> cancelAllForPeer(String peerId) async {
    _queue.removeWhere((t) => t.peer.id == peerId);
    for (final entry in _active.entries.toList()) {
      if (entry.value.transfer.peer.id == peerId) {
        await cancel(entry.key);
      }
    }
  }

  int get activeCount => _active.length;
  int get queuedCount => _queue.length;

  void _processNext() {
    while (_active.length < maxConcurrent && _queue.isNotEmpty) {
      final transfer = _queue.removeFirst();
      transfer.status = TransferStatus.active;
      _executeTransfer(transfer);
    }
  }

  Future<void> _executeTransfer(QueuedTransfer transfer) async {
    final client = SocketTransferClient();
    _active[transfer.jobId] = _ActiveTransfer(
      transfer: transfer,
      client: client,
    );

    try {
      // Connect to receiver's socket port with retry.
      final socketPort = transfer.socketPort ?? transfer.peer.port;
      const maxRetries = 3;
      for (int attempt = 1; attempt <= maxRetries; attempt++) {
        try {
          await client.connect(transfer.peer.ipAddress, socketPort);
          break;
        } catch (e) {
          if (attempt == maxRetries) rethrow;
          _log.w('Connect attempt $attempt failed, retrying in 2s: $e');
          await Future.delayed(const Duration(seconds: 2));
        }
      }

      // Build file manifest — skip files that are no longer accessible.
      // Checksum is deferred until after transfer to avoid blocking.
      final manifest = <FileManifestEntry>[];
      final validPaths = <String>[];
      for (final path in transfer.filePaths) {
        final file = File(path);
        if (!await file.exists()) {
          _log.w('File not accessible during transfer, skipping: $path');
          continue;
        }
        final fileSize = await file.length();
        manifest.add(FileManifestEntry(
          fileName: p.basename(path),
          fileSize: fileSize,
          checksum: '',
        ));
        validPaths.add(path);
      }

      if (manifest.isEmpty) {
        throw Exception('No accessible files to transfer');
      }

      // Handshake — get chunk bitmaps for resume.
      final bitmaps = await client.handshake(
        token: transfer.sessionToken ?? transfer.peer.sessionToken ?? '',
        files: manifest,
        encrypted: transfer.encrypted,
      );

      // Set up encryption if enabled.
      EncryptionHandler? encryption;
      if (transfer.encrypted) {
        encryption = EncryptionHandler.generate();
        await client.setupEncryption(
          encryption,
          transfer.sessionToken ?? transfer.peer.sessionToken ?? '',
        );
      }

      // Send all files.
      final result = await client.sendFiles(
        filePaths: validPaths,
        manifest: manifest,
        bitmaps: bitmaps,
        encryption: encryption,
        onProgress: (fileIndex, progress) {
          transfer.bytesTransferred = progress.bytesTransferred;
          transfer.speedBytesPerSec = progress.speedBytesPerSec;
          onProgress?.call(
            transfer.jobId,
            progress.bytesTransferred,
            progress.totalBytes,
            progress.speedBytesPerSec,
          );
        },
      );

      await client.dispose();
      _active.remove(transfer.jobId);

      if (result.success) {
        transfer.status = TransferStatus.completed;
        onJobCompleted?.call(transfer.jobId, true, null);
      } else {
        transfer.status = TransferStatus.failed;
        onJobCompleted?.call(
            transfer.jobId, false, result.error ?? 'Transfer failed');
      }
    } catch (e) {
      _log.e('Transfer error for job ${transfer.jobId}: $e');
      await client.dispose();
      _active.remove(transfer.jobId);
      transfer.status = TransferStatus.failed;
      onJobCompleted?.call(transfer.jobId, false, e.toString());
    }

    _processNext();
  }

  Future<void> dispose() async {
    for (final active in _active.values) {
      await active.client.dispose();
    }
    _active.clear();
    _queue.clear();
    if (!_controller.isClosed) _controller.close();
  }
}

class _ActiveTransfer {
  _ActiveTransfer({required this.transfer, required this.client});
  final QueuedTransfer transfer;
  final SocketTransferClient client;
}
