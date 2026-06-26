import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:logger/logger.dart';

import '../../../../core/constants/app_constants.dart';
import 'chunk_manager.dart';
import 'encryption_handler.dart';
import 'progress_tracker.dart';
import 'transfer_protocol.dart';

final _log = Logger(printer: SimplePrinter());

/// Result of a socket-based file transfer.
class SocketTransferResult {
  const SocketTransferResult({
    required this.success,
    required this.filesTransferred,
    required this.totalBytesTransferred,
    this.error,
  });

  final bool success;
  final int filesTransferred;
  final int totalBytesTransferred;
  final String? error;
}

/// Raw TCP client for sending files via the binary protocol.
///
/// Usage:
///   1. [connect] to the receiver's socket port
///   2. [handshake] sends file manifest, receives chunk bitmaps
///   3. [sendFiles] streams chunks for all files with resume support
///   4. Connection is closed when all files are transferred
class SocketTransferClient {
  Socket? _socket;
  FrameReader? _frameReader;
  bool _isPaused = false;
  bool _isCancelled = false;

  bool get isConnected => _socket != null;
  bool get isPaused => _isPaused;

  /// Connect to the receiver's socket transfer server.
  Future<void> connect(String host, int port) async {
    _socket = await Socket.connect(
      host,
      port,
      timeout: AppConstants.transferHandshakeTimeout,
    );
    _frameReader = FrameReader(_socket!);
    _frameReader!.start();
    _log.i('Connected to socket transfer server at $host:$port');
  }

  /// Perform the handshake: send file manifest, receive chunk bitmaps.
  /// Returns a list of ChunkBitmaps (one per file) indicating which
  /// chunks the receiver already has.
  Future<List<ChunkBitmap>> handshake({
    required String token,
    required List<FileManifestEntry> files,
    required bool encrypted,
  }) async {
    final req = TransferProtocol.encodeHandshakeReq(
      token: token,
      files: files,
      encrypted: encrypted,
    );
    _socket!.add(TransferProtocol.encodeFrame(
        TransferProtocol.handshakeReq, req));
    await _socket!.flush();

    // Wait for HANDSHAKE_ACK.
    final ack = await _frameReader!.frames
        .where((f) => f.type == TransferProtocol.handshakeAck)
        .first
        .timeout(AppConstants.transferHandshakeTimeout);

    final decoded = TransferProtocol.decodeHandshakeAck(ack.payload);
    if (!decoded.accepted) {
      throw Exception('Transfer rejected by receiver');
    }

    // Convert bitmap bytes to ChunkBitmap objects.
    return List.generate(files.length, (i) {
      final totalChunks =
          (files[i].fileSize + AppConstants.transferChunkBytes - 1) ~/
              AppConstants.transferChunkBytes;
      if (i < decoded.bitmaps.length) {
        return ChunkBitmap.fromBytes(decoded.bitmaps[i], totalChunks);
      }
      return ChunkBitmap(totalChunks);
    });
  }

  /// Set up encryption for this transfer session.
  Future<void> setupEncryption(
      EncryptionHandler handler, String sessionToken) async {
    final sharedSecret = Uint8List.fromList(sessionToken.codeUnits);
    final encryptedKey = handler.exportKey(sharedSecret);
    _socket!.add(TransferProtocol.encodeFrame(
        TransferProtocol.encryptionSetup, encryptedKey));
    await _socket!.flush();
  }

  /// Send all files to the receiver, skipping already-received chunks.
  ///
  /// Returns a result indicating success/failure and bytes transferred.
  Future<SocketTransferResult> sendFiles({
    required List<String> filePaths,
    required List<FileManifestEntry> manifest,
    required List<ChunkBitmap> bitmaps,
    EncryptionHandler? encryption,
    void Function(int fileIndex, TransferProgress progress)? onProgress,
  }) async {
    int totalBytesTransferred = 0;
    int filesCompleted = 0;

    try {
      for (int fileIndex = 0; fileIndex < filePaths.length; fileIndex++) {
        if (_isCancelled) break;

        final result = await _sendSingleFile(
          fileIndex: fileIndex,
          filePath: filePaths[fileIndex],
          manifest: manifest[fileIndex],
          bitmap: bitmaps[fileIndex],
          encryption: encryption,
          onProgress: (progress) => onProgress?.call(fileIndex, progress),
        );

        if (result) {
          filesCompleted++;
          totalBytesTransferred += manifest[fileIndex].fileSize;
        }
      }

      return SocketTransferResult(
        success: !_isCancelled && filesCompleted == filePaths.length,
        filesTransferred: filesCompleted,
        totalBytesTransferred: totalBytesTransferred,
      );
    } catch (e) {
      return SocketTransferResult(
        success: false,
        filesTransferred: filesCompleted,
        totalBytesTransferred: totalBytesTransferred,
        error: e.toString(),
      );
    }
  }

  Future<bool> _sendSingleFile({
    required int fileIndex,
    required String filePath,
    required FileManifestEntry manifest,
    required ChunkBitmap bitmap,
    EncryptionHandler? encryption,
    void Function(TransferProgress progress)? onProgress,
  }) async {
    final chunkMgr = ChunkManager(
      filePath: filePath,
      fileSize: manifest.fileSize,
    );

    final tracker = ProgressTracker(
      jobId: fileIndex,
      totalBytes: manifest.fileSize,
      totalChunks: chunkMgr.totalChunks,
      initialBytesTransferred:
          bitmap.receivedCount * AppConstants.transferChunkBytes,
      initialChunksTransferred: bitmap.receivedCount,
    );

    final progressSub = tracker.progressStream.listen(onProgress);

    try {
      final missingChunks = bitmap.missingChunks;
      const pipelineWindow = AppConstants.socketPipelineWindow;

      // Subscribe to ACK stream ONCE before sending any chunks.
      // StreamIterator buffers events — no dropped ACKs on broadcast stream.
      final ackStream =
          _frameReader!.frames.where((f) => f.type == TransferProtocol.chunkAck);
      final ackIterator = StreamIterator(ackStream);

      int inFlight = 0;
      int chunkIdx = 0;

      while (chunkIdx < missingChunks.length || inFlight > 0) {
        if (_isCancelled) return false;

        while (_isPaused && !_isCancelled) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        if (_isCancelled) return false;

        // Send chunks up to pipeline window.
        while (inFlight < pipelineWindow && chunkIdx < missingChunks.length) {
          final chunkIndex = missingChunks[chunkIdx];
          var data = await chunkMgr.readChunk(chunkIndex);

          if (encryption != null) {
            data = encryption.encryptChunk(data, chunkIndex);
          }

          final payload =
              TransferProtocol.encodeChunkData(fileIndex, chunkIndex, data);
          _socket!.add(
              TransferProtocol.encodeFrame(TransferProtocol.chunkData, payload));
          inFlight++;
          chunkIdx++;
        }

        // Flush all queued chunks at once.
        await _socket!.flush();

        // Drain one ACK.
        final gotAck =
            await ackIterator.moveNext().timeout(const Duration(seconds: 60));
        if (!gotAck) {
          throw Exception('Connection closed while waiting for chunk ACK');
        }
        final ack = TransferProtocol.decodeChunkAck(ackIterator.current.payload);
        if (!ack.success) {
          _log.w('Chunk rejected for file $fileIndex');
        }
        inFlight--;
        tracker.onChunkCompleted(AppConstants.transferChunkBytes);
      }

      await ackIterator.cancel();

      // Send FILE_COMPLETE (empty checksum — skip blocking hash).
      final fcPayload =
          TransferProtocol.encodeFileComplete(fileIndex, '');
      _socket!.add(TransferProtocol.encodeFrame(
          TransferProtocol.fileComplete, fcPayload));
      await _socket!.flush();

      // Subscribe to verified stream BEFORE it can arrive.
      final verifiedStream = _frameReader!.frames
          .where((f) => f.type == TransferProtocol.fileVerified);
      final verifiedIterator = StreamIterator(verifiedStream);
      final gotVerified =
          await verifiedIterator.moveNext().timeout(const Duration(seconds: 60));
      if (!gotVerified) {
        throw Exception('Connection closed while waiting for file verification');
      }
      final verified =
          TransferProtocol.decodeFileVerified(verifiedIterator.current.payload);
      await verifiedIterator.cancel();
      tracker.emitFinal();

      return verified.match;
    } finally {
      await progressSub.cancel();
      tracker.dispose();
    }
  }

  /// Pause the current transfer.
  void pause() {
    _isPaused = true;
    if (_socket != null) {
      _socket!.add(TransferProtocol.encodeFrame(
          TransferProtocol.pause, Uint8List(0)));
    }
  }

  /// Resume a paused transfer.
  void resume() {
    _isPaused = false;
    if (_socket != null) {
      _socket!.add(TransferProtocol.encodeFrame(
          TransferProtocol.resume, Uint8List(0)));
    }
  }

  /// Cancel the current transfer.
  Future<void> cancel({int? fileIndex}) async {
    _isCancelled = true;
    if (_socket != null) {
      final payload = TransferProtocol.encodeCancel(fileIndex ?? 0xFFFF);
      _socket!.add(
          TransferProtocol.encodeFrame(TransferProtocol.cancel, payload));
      await _socket!.flush();
    }
  }

  Future<void> dispose() async {
    await _frameReader?.dispose();
    await _socket?.close();
    _socket = null;
    _frameReader = null;
  }
}
