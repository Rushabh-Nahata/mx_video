import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../core/constants/app_constants.dart';
import 'chunk_manager.dart';
import 'encryption_handler.dart';
import 'transfer_protocol.dart';

final _log = Logger(printer: SimplePrinter());

/// Callback when a chunk is received (for progress tracking).
typedef OnChunkReceived = void Function(
  String sessionId,
  int fileIndex,
  int chunkIndex,
  int chunkSize,
  int totalChunks,
);

/// Callback when all chunks of a file are received.
typedef OnSocketFileReceived = void Function(
  String sessionId,
  int fileIndex,
  String fileName,
  String savePath,
  String checksum,
);

/// Callback when a transfer offer arrives.
typedef OnSocketTransferOffer = Future<bool> Function(
  String peerToken,
  List<FileManifestEntry> files,
);

/// Raw TCP server for receiving file transfers via the binary protocol.
///
/// Lifecycle:
///   1. [start] binds to a random port
///   2. Sender connects and sends HANDSHAKE_REQ with file manifest
///   3. Server loads/creates chunk bitmaps, replies with HANDSHAKE_ACK
///   4. Sender streams CHUNK_DATA messages
///   5. Server writes chunks to .part files, sends CHUNK_ACK
///   6. On FILE_COMPLETE, server verifies checksum and renames to final name
class SocketTransferServer {
  ServerSocket? _serverSocket;
  final _activeReceives = <String, _ActiveSession>{};

  OnChunkReceived? onChunkReceived;
  OnSocketFileReceived? onFileReceived;
  OnSocketTransferOffer? onTransferOffer;

  /// Allowed session tokens (from HTTP /pair).
  final _validTokens = <String>{};

  int get port => _serverSocket?.port ?? 0;
  bool get isRunning => _serverSocket != null;

  /// Register a session token as valid (called after HTTP /pair).
  void allowToken(String token) => _validTokens.add(token);

  /// Start the socket server. Returns the bound port.
  Future<int> start() async {
    if (isRunning) return port;
    // Bind to IPv6 wildcard which also accepts IPv4 (dual-stack).
    // Falls back to IPv4-only if the platform does not support dual-stack.
    try {
      _serverSocket = await ServerSocket.bind(
        InternetAddress.anyIPv6,
        0, // OS picks a free port
      );
    } on SocketException {
      _serverSocket = await ServerSocket.bind(
        InternetAddress.anyIPv4,
        0, // OS picks a free port
      );
    }
    _serverSocket!.listen(
      _handleConnection,
      onError: (e) => _log.e('Socket server error: $e'),
    );
    _log.i('Socket transfer server started on port $port');
    return port;
  }

  Future<void> stop() async {
    await _serverSocket?.close();
    _serverSocket = null;
    for (final session in _activeReceives.values) {
      await session.dispose();
    }
    _activeReceives.clear();
    _validTokens.clear();
    _log.i('Socket transfer server stopped');
  }

  // ── Connection handler ──────────────────────────────────────────────────

  Future<void> _handleConnection(Socket socket) async {
    final reader = FrameReader(socket);
    reader.start();

    String? sessionToken;
    EncryptionHandler? encryption;

    await for (final frame in reader.frames) {
      try {
        switch (frame.type) {
          case TransferProtocol.handshakeReq:
            final req = TransferProtocol.decodeHandshakeReq(frame.payload);
            sessionToken = req.token;

            // Validate token.
            if (!_validTokens.contains(sessionToken)) {
              // Auto-allow for direct connections without HTTP pairing.
              _validTokens.add(sessionToken);
            }

            // Ask whether to accept.
            final accepted = onTransferOffer != null
                ? await onTransferOffer!(req.token, req.files)
                : true;

            if (!accepted) {
              final ack = TransferProtocol.encodeHandshakeAck(
                  accepted: false, bitmaps: []);
              socket.add(TransferProtocol.encodeFrame(
                  TransferProtocol.handshakeAck, ack));
              await socket.flush();
              await socket.close();
              return;
            }

            // Use the sender's chunk size if provided (protocol negotiation).
            final negotiatedChunkSize = req.chunkSize;

            // Set up session.
            final saveDir = await _resolveDownloadDir();
            final session = _ActiveSession(token: req.token);

            for (final entry in req.files) {
              final partialPath = p.join(saveDir, '${entry.fileName}.part');
              final savePath = p.join(saveDir, entry.fileName);
              final mgr = ChunkManager(
                filePath: savePath,
                fileSize: entry.fileSize,
                chunkSize: negotiatedChunkSize,
              );
              final bitmap = await mgr.loadOrCreateBitmap(partialPath);

              // Ensure .part file exists.
              final partFile = File(partialPath);
              if (!await partFile.exists()) {
                await partFile.create(recursive: true);
              }

              session.files.add(_ReceiveFileState(
                entry: entry,
                partialPath: partialPath,
                savePath: savePath,
                chunkManager: mgr,
                bitmap: bitmap,
              ));
            }

            _activeReceives[req.token] = session;

            // Reply with bitmaps and negotiated parameters.
            final bitmaps =
                session.files.map((f) => f.bitmap.toBytes()).toList();
            final ack = TransferProtocol.encodeHandshakeAck(
              accepted: true,
              bitmaps: bitmaps,
              chunkSize: negotiatedChunkSize,
              protocolVersion: req.protocolVersion,
            );
            socket.add(TransferProtocol.encodeFrame(
                TransferProtocol.handshakeAck, ack));
            await socket.flush();

          case TransferProtocol.encryptionSetup:
            if (sessionToken == null) break;
            // Derive shared secret from session token.
            final sharedSecret =
                Uint8List.fromList(sessionToken.codeUnits);
            encryption = EncryptionHandler.fromEncryptedKey(
                frame.payload, sharedSecret);
            _log.i('Encryption enabled for session $sessionToken');

          case TransferProtocol.chunkData:
            if (sessionToken == null) break;
            final session = _activeReceives[sessionToken];
            if (session == null) break;

            final chunk = TransferProtocol.decodeChunkData(frame.payload);
            if (chunk.fileIndex >= session.files.length) break;

            final fileState = session.files[chunk.fileIndex];
            var data = chunk.data;

            // Decrypt if encryption is enabled.
            if (encryption != null) {
              data = encryption.decryptChunk(data, chunk.chunkIndex);
            }

            // Write chunk to .part file.
            await fileState.chunkManager.writeChunk(
              fileState.partialPath,
              chunk.chunkIndex,
              data,
            );
            fileState.bitmap.markReceived(chunk.chunkIndex);

            // Persist bitmap periodically (every 50 chunks).
            if (chunk.chunkIndex % 50 == 0) {
              await fileState.chunkManager
                  .saveBitmap(fileState.partialPath, fileState.bitmap);
            }

            // Send ACK.
            final ack = TransferProtocol.encodeChunkAck(
                chunk.fileIndex, chunk.chunkIndex, true);
            socket.add(
                TransferProtocol.encodeFrame(TransferProtocol.chunkAck, ack));
            await socket.flush();

            // Report progress.
            onChunkReceived?.call(
              sessionToken,
              chunk.fileIndex,
              chunk.chunkIndex,
              data.length,
              fileState.chunkManager.totalChunks,
            );

          case TransferProtocol.fileComplete:
            if (sessionToken == null) break;
            final session = _activeReceives[sessionToken];
            if (session == null) break;

            final fc = TransferProtocol.decodeFileComplete(frame.payload);
            if (fc.fileIndex >= session.files.length) break;

            final fileState = session.files[fc.fileIndex];

            // Save final bitmap.
            await fileState.chunkManager
                .saveBitmap(fileState.partialPath, fileState.bitmap);

            // Verify checksum.
            bool match = true;
            String computedChecksum = '';
            if (fc.checksum.isNotEmpty) {
              computedChecksum = await fileState.chunkManager
                  .computeChecksum(fileState.partialPath);
              match = computedChecksum == fc.checksum;
            }

            if (match) {
              // Rename .part to final.
              final finalFile = File(fileState.savePath);
              String finalPath = fileState.savePath;
              if (await finalFile.exists()) {
                final base = p.basenameWithoutExtension(fileState.savePath);
                final ext = p.extension(fileState.savePath);
                final dir = p.dirname(fileState.savePath);
                final ts = DateTime.now().millisecondsSinceEpoch;
                finalPath = p.join(dir, '${base}_$ts$ext');
              }
              await File(fileState.partialPath).rename(finalPath);
              await fileState.chunkManager
                  .deleteBitmap(fileState.partialPath);

              onFileReceived?.call(
                sessionToken,
                fc.fileIndex,
                fileState.entry.fileName,
                finalPath,
                computedChecksum,
              );
            }

            // Reply.
            final verified = TransferProtocol.encodeFileVerified(
                fc.fileIndex, match);
            socket.add(TransferProtocol.encodeFrame(
                TransferProtocol.fileVerified, verified));
            await socket.flush();

          case TransferProtocol.cancel:
            final fileIndex = TransferProtocol.decodeCancel(frame.payload);
            if (sessionToken != null) {
              if (fileIndex == 0xFFFF) {
                _activeReceives.remove(sessionToken);
              }
            }
            await reader.dispose();
            await socket.close();
            return;

          case TransferProtocol.pause:
            // Save current state so resume can pick up.
            if (sessionToken != null) {
              final session = _activeReceives[sessionToken];
              if (session != null) {
                for (final f in session.files) {
                  await f.chunkManager.saveBitmap(f.partialPath, f.bitmap);
                }
              }
            }

          default:
            _log.w('Unknown frame type: ${frame.type}');
        }
      } catch (e, st) {
        _log.e('Error handling frame type ${frame.type}: $e\n$st');
      }
    }

    // Connection closed — save bitmaps.
    if (sessionToken != null) {
      final session = _activeReceives[sessionToken];
      if (session != null) {
        for (final f in session.files) {
          await f.chunkManager.saveBitmap(f.partialPath, f.bitmap);
        }
      }
    }
    await reader.dispose();
  }

  Future<String> _resolveDownloadDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'MX Video Downloads'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.path;
  }
}

// ── Internal models ─────────────────────────────────────────────────────────

class _ActiveSession {
  _ActiveSession({required this.token});
  final String token;
  final files = <_ReceiveFileState>[];

  Future<void> dispose() async {
    for (final f in files) {
      await f.chunkManager.saveBitmap(f.partialPath, f.bitmap);
    }
  }
}

class _ReceiveFileState {
  _ReceiveFileState({
    required this.entry,
    required this.partialPath,
    required this.savePath,
    required this.chunkManager,
    required this.bitmap,
  });

  final FileManifestEntry entry;
  final String partialPath;
  final String savePath;
  final ChunkManager chunkManager;
  final ChunkBitmap bitmap;
}
