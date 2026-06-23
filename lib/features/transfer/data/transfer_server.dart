import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../../../core/constants/app_constants.dart';
import 'socket/socket_transfer_server.dart';

final _log = Logger(printer: SimplePrinter());

/// Callback for file receive progress updates.
typedef OnReceiveProgress = void Function(
  String fileName,
  int bytesReceived,
  int totalBytes,
);

/// Callback when a file transfer offer is received from a sender.
/// Return true to accept, false to reject.
typedef OnTransferOffer = Future<bool> Function(
  String peerName,
  String fileName,
  int fileSize,
);

/// Callback when a file has been fully received.
typedef OnFileReceived = void Function(
  String fileName,
  String savePath,
  String checksum,
  String peerName,
);

/// Callback when a peer successfully pairs via POST /pair.
typedef OnPeerPaired = void Function(
  String peerName,
  String peerPlatform,
  String sessionToken,
);

/// HTTP server that runs on the receiver device to accept incoming files.
///
/// Protocol:
///   POST /pair          — exchange device info, get session token
///   GET  /info          — device info (name, platform, port)
///   POST /offer         — sender offers a file (name, size, hash)
///   POST /upload        — chunked file upload with resume support
///   GET  /resume-offset — check how many bytes already received for a file
class TransferServer {
  HttpServer? _server;
  final SocketTransferServer _socketServer = SocketTransferServer();

  final Map<String, _Session> _sessions = {};
  final Map<String, _PartialFile> _partialFiles = {};

  String _deviceName = 'MX Video Device';
  String _platform = 'unknown';

  OnReceiveProgress? onReceiveProgress;
  OnTransferOffer? onTransferOffer;
  OnFileReceived? onFileReceived;
  OnPeerPaired? onPeerPaired;

  int get port => _server?.port ?? 0;
  bool get isRunning => _server != null;

  /// The raw TCP socket server for chunk-based transfers.
  SocketTransferServer get socketServer => _socketServer;

  /// Port of the socket transfer server (0 if not started).
  int get socketPort => _socketServer.port;

  void configure({required String deviceName, required String platform}) {
    _deviceName = deviceName;
    _platform = platform;
  }

  Future<void> start() async {
    if (isRunning) return;

    final router = Router()
      ..post('/pair', _handlePair)
      ..get('/info', _handleInfo)
      ..post('/offer', _handleOffer)
      ..post('/upload', _handleUpload)
      ..get('/resume-offset', _handleResumeOffset)
      ..post('/negotiate', _handleNegotiate);

    final handler = Pipeline()
        .addMiddleware(_corsMiddleware())
        .addHandler(router.call);

    // Bind to IPv6 wildcard which also accepts IPv4 connections (dual-stack).
    // Falls back to IPv4-only if the platform does not support dual-stack.
    try {
      _server = await shelf_io.serve(
        handler,
        InternetAddress.anyIPv6,
        AppConstants.transferServerPort,
      );
    } on SocketException {
      _server = await shelf_io.serve(
        handler,
        InternetAddress.anyIPv4,
        AppConstants.transferServerPort,
      );
    }
    _server!.autoCompress = false; // videos are already compressed

    _log.i('Transfer server started on port ${_server!.port}');
  }

  Future<void> stop() async {
    await _socketServer.stop();
    await _server?.close(force: true);
    _server = null;
    _sessions.clear();
    _partialFiles.clear();
    _log.i('Transfer server stopped');
  }

  // ── Handlers ─────────────────────────────────────────────────────────────

  /// POST /pair — exchange device info and create a session.
  /// Body: { "deviceName": "...", "platform": "android" }
  /// Response: { "token": "...", "deviceName": "...", "platform": "..." }
  Future<Response> _handlePair(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final peerName = data['deviceName'] as String? ?? 'Unknown';
      final peerPlatform = data['platform'] as String? ?? 'unknown';

      final token = _generateToken();
      _sessions[token] = _Session(
        peerName: peerName,
        peerPlatform: peerPlatform,
        createdAt: DateTime.now(),
      );

      // Clean up expired sessions.
      _cleanExpiredSessions();

      // Notify the display screen that a peer has paired.
      onPeerPaired?.call(peerName, peerPlatform, token);

      return _jsonResponse({
        'token': token,
        'deviceName': _deviceName,
        'platform': _platform,
      });
    } catch (e) {
      return Response.internalServerError(body: '{"error":"$e"}');
    }
  }

  /// GET /info — returns device info.
  Response _handleInfo(Request request) {
    return _jsonResponse({
      'deviceName': _deviceName,
      'platform': _platform,
      'port': port,
    });
  }

  /// POST /offer — sender offers a file for transfer.
  /// Headers: X-Token
  /// Body: { "fileName": "...", "fileSize": 123456, "checksum": "sha256..." }
  /// Response: { "accepted": true, "resumeOffset": 0 }
  Future<Response> _handleOffer(Request request) async {
    final token = request.headers['x-token'];
    final session = _validateSession(token);
    if (session == null) return _unauthorized();

    try {
      final body = await request.readAsString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      final fileName = data['fileName'] as String;
      final fileSize = data['fileSize'] as int;
      final checksum = data['checksum'] as String?;

      // Check if we should accept (auto-accept or ask user).
      final accepted = onTransferOffer != null
          ? await onTransferOffer!(session.peerName, fileName, fileSize)
          : true;

      if (!accepted) {
        return _jsonResponse({'accepted': false, 'resumeOffset': 0});
      }

      // Check for existing partial file to determine resume offset.
      final saveDir = await _resolveDownloadDir();
      final partialPath = p.join(saveDir, '$fileName.part');
      int resumeOffset = 0;

      final partialFile = File(partialPath);
      if (await partialFile.exists()) {
        resumeOffset = await partialFile.length();
      }

      // Register partial file tracking.
      final fileKey = '${token}_$fileName';
      _partialFiles[fileKey] = _PartialFile(
        fileName: fileName,
        totalSize: fileSize,
        bytesReceived: resumeOffset,
        savePath: p.join(saveDir, fileName),
        partialPath: partialPath,
        expectedChecksum: checksum,
        peerName: session.peerName,
      );

      return _jsonResponse({'accepted': true, 'resumeOffset': resumeOffset});
    } catch (e) {
      return Response.internalServerError(body: '{"error":"$e"}');
    }
  }

  /// POST /upload — receive chunked file data.
  /// Headers: X-Token, X-File-Name, X-Offset (starting byte offset)
  /// Body: raw binary file stream
  /// Response: { "status": "ok", "bytesReceived": ..., "checksum": "..." }
  Future<Response> _handleUpload(Request request) async {
    final token = request.headers['x-token'];
    final session = _validateSession(token);
    if (session == null) return _unauthorized();

    final fileName = request.headers['x-file-name'];
    if (fileName == null) {
      return Response.badRequest(body: '{"error":"Missing X-File-Name"}');
    }

    final offset = int.tryParse(request.headers['x-offset'] ?? '0') ?? 0;
    final fileKey = '${token}_$fileName';
    final partial = _partialFiles[fileKey];

    if (partial == null) {
      return Response.badRequest(
        body: '{"error":"No offer found. Send POST /offer first."}',
      );
    }

    try {
      final file = File(partial.partialPath);
      final sink = file.openWrite(
        mode: offset > 0 ? FileMode.append : FileMode.write,
      );

      final digestSink = AccumulatorSink<Digest>();
      final hashSink = sha256.startChunkedConversion(digestSink);

      int bytesReceived = offset;
      var lastProgress = DateTime.now();

      await for (final chunk in request.read()) {
        sink.add(chunk);
        hashSink.add(chunk);
        bytesReceived += chunk.length;

        // Throttle progress callbacks.
        final now = DateTime.now();
        if (now.difference(lastProgress).inMilliseconds >=
            AppConstants.transferProgressIntervalMs) {
          onReceiveProgress?.call(fileName, bytesReceived, partial.totalSize);
          lastProgress = now;
        }
      }

      await sink.flush();
      await sink.close();
      hashSink.close();

      final checksum = digestSink.events.first.toString();

      // Final progress callback.
      onReceiveProgress?.call(fileName, bytesReceived, partial.totalSize);

      // If transfer is complete, rename from .part to final name.
      if (bytesReceived >= partial.totalSize) {
        final finalFile = File(partial.savePath);
        if (await finalFile.exists()) {
          // Avoid overwrite — add suffix.
          final base = p.basenameWithoutExtension(partial.savePath);
          final ext = p.extension(partial.savePath);
          final dir = p.dirname(partial.savePath);
          final ts = DateTime.now().millisecondsSinceEpoch;
          final newPath = p.join(dir, '${base}_$ts$ext');
          await File(partial.partialPath).rename(newPath);
          partial.savePath = newPath;
        } else {
          await File(partial.partialPath).rename(partial.savePath);
        }

        _partialFiles.remove(fileKey);

        onFileReceived?.call(
            fileName, partial.savePath, checksum, session.peerName);
      }

      return _jsonResponse({
        'status': 'ok',
        'bytesReceived': bytesReceived,
        'checksum': checksum,
        'complete': bytesReceived >= partial.totalSize,
      });
    } catch (e) {
      _log.e('Upload error: $e');
      return Response.internalServerError(body: '{"error":"$e"}');
    }
  }

  /// GET /resume-offset?token=...&fileName=...
  /// Returns how many bytes have been received for a partial file.
  Future<Response> _handleResumeOffset(Request request) async {
    final token = request.url.queryParameters['token'];
    final fileName = request.url.queryParameters['fileName'];

    if (token == null || fileName == null) {
      return Response.badRequest(body: '{"error":"Missing token or fileName"}');
    }

    final session = _validateSession(token);
    if (session == null) return _unauthorized();

    final saveDir = await _resolveDownloadDir();
    final partialPath = p.join(saveDir, '$fileName.part');
    final partialFile = File(partialPath);

    int offset = 0;
    if (await partialFile.exists()) {
      offset = await partialFile.length();
    }

    return _jsonResponse({'resumeOffset': offset});
  }

  /// POST /negotiate — negotiate a raw TCP socket port for chunk-based transfer.
  /// Headers: X-Token
  /// Response: { "socketPort": ..., "protocolVersion": 2, "encryptionSupported": true }
  Future<Response> _handleNegotiate(Request request) async {
    final token = request.headers['x-token'];
    final session = _validateSession(token);
    if (session == null) return _unauthorized();

    // Ensure socket server is running.
    final socketPort = await _socketServer.start();
    _socketServer.allowToken(token!);

    return _jsonResponse({
      'socketPort': socketPort,
      'protocolVersion': 2,
      'encryptionSupported': true,
    });
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  _Session? _validateSession(String? token) {
    if (token == null) return null;
    final session = _sessions[token];
    if (session == null) return null;
    if (DateTime.now().difference(session.createdAt) >
        AppConstants.transferTokenTtl) {
      _sessions.remove(token);
      return null;
    }
    return session;
  }

  void _cleanExpiredSessions() {
    _sessions.removeWhere((_, s) =>
        DateTime.now().difference(s.createdAt) > AppConstants.transferTokenTtl);
  }

  Future<String> _resolveDownloadDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'MX Video Downloads'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.path;
  }

  String _generateToken() {
    final now = DateTime.now();
    return '${now.millisecondsSinceEpoch.toRadixString(36)}'
        '-${now.microsecond.toRadixString(36)}'
        '-${(now.hashCode ^ identityHashCode(this)).toRadixString(36)}';
  }

  Response _jsonResponse(Map<String, dynamic> data) => Response.ok(
        jsonEncode(data),
        headers: {'content-type': 'application/json'},
      );

  Response _unauthorized() =>
      Response.forbidden('{"error":"Invalid or expired token"}');

  Middleware _corsMiddleware() => (Handler inner) {
        return (Request request) async {
          final response = await inner(request);
          return response.change(headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Headers': '*',
          });
        };
      };
}

// ── Internal models ──────────────────────────────────────────────────────

class _Session {
  final String peerName;
  final String peerPlatform;
  final DateTime createdAt;

  _Session({
    required this.peerName,
    required this.peerPlatform,
    required this.createdAt,
  });
}

class _PartialFile {
  final String fileName;
  final int totalSize;
  int bytesReceived;
  String savePath;
  final String partialPath;
  final String? expectedChecksum;
  final String peerName;

  _PartialFile({
    required this.fileName,
    required this.totalSize,
    required this.bytesReceived,
    required this.savePath,
    required this.partialPath,
    this.expectedChecksum,
    required this.peerName,
  });
}
