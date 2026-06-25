import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

import '../../../core/constants/app_constants.dart';
import '../domain/entities/peer_device.dart';

/// Progress callback for file upload.
typedef TransferProgressCallback = void Function(
  int bytesSent,
  int totalBytes,
  int speedBytesPerSec,
);

/// Result of a file transfer.
class TransferResult {
  final bool success;
  final int bytesTransferred;
  final String? checksum;
  final String? error;

  const TransferResult({
    required this.success,
    required this.bytesTransferred,
    this.checksum,
    this.error,
  });
}

/// HTTP client for sending files to a peer's transfer server.
///
/// Protocol flow:
///   1. POST /pair     → get session token
///   2. POST /offer    → offer a file, get resume offset
///   3. POST /upload   → stream file data from offset
class TransferClient {
  late final Dio _dio;

  TransferClient() {
    _dio = Dio(BaseOptions(
      connectTimeout: AppConstants.transferHandshakeTimeout,
      receiveTimeout: const Duration(minutes: 5),
      sendTimeout: const Duration(minutes: 30),
    ));
  }

  /// Perform the pairing handshake with a peer's server.
  /// Returns the session token.
  Future<String> pair({
    required PeerDevice peer,
    required String deviceName,
    required String platform,
  }) async {
    final url = _baseUrl(peer);

    final response = await _dio.post(
      '$url/pair',
      data: jsonEncode({
        'deviceName': deviceName,
        'platform': platform,
      }),
      options: Options(contentType: 'application/json'),
    );

    final data = response.data is String
        ? jsonDecode(response.data as String) as Map<String, dynamic>
        : response.data as Map<String, dynamic>;

    return data['token'] as String;
  }

  /// Offer a file to the peer. Returns the resume offset (0 if starting fresh).
  Future<int> offerFile({
    required PeerDevice peer,
    required String token,
    required String fileName,
    required int fileSize,
    String? checksum,
  }) async {
    final url = _baseUrl(peer);

    final response = await _dio.post(
      '$url/offer',
      data: jsonEncode({
        'fileName': fileName,
        'fileSize': fileSize,
        'checksum': checksum,
      }),
      options: Options(
        headers: {'X-Token': token},
        contentType: 'application/json',
      ),
    );

    final data = response.data is String
        ? jsonDecode(response.data as String) as Map<String, dynamic>
        : response.data as Map<String, dynamic>;

    final accepted = data['accepted'] as bool? ?? false;
    if (!accepted) {
      throw Exception('Transfer rejected by receiver');
    }

    return data['resumeOffset'] as int? ?? 0;
  }

  /// Upload a file to the peer with progress tracking and resume support.
  ///
  /// [offset]: byte position to start from (for resume).
  /// [cancelToken]: to cancel the transfer mid-stream.
  Future<TransferResult> uploadFile({
    required PeerDevice peer,
    required String token,
    required String filePath,
    required String fileName,
    int offset = 0,
    TransferProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
    final url = _baseUrl(peer);
    final file = File(filePath);

    if (!await file.exists()) {
      return const TransferResult(
        success: false,
        bytesTransferred: 0,
        error: 'File not found',
      );
    }

    final fileSize = await file.length();
    final stream = _createFileStream(file, offset);

    // Track speed.
    var lastTime = DateTime.now();
    var lastBytes = offset;
    var speed = 0;

    try {
      final response = await _dio.post(
        '$url/upload',
        data: stream,
        options: Options(
          headers: {
            'X-Token': token,
            'X-File-Name': fileName,
            'X-Offset': offset.toString(),
            'Content-Type': 'application/octet-stream',
            'Content-Length': (fileSize - offset).toString(),
          },
        ),
        onSendProgress: (sent, total) {
          final actualSent = sent + offset;
          final now = DateTime.now();
          final elapsed = now.difference(lastTime).inMilliseconds;

          if (elapsed >= AppConstants.transferProgressIntervalMs) {
            speed = ((actualSent - lastBytes) * 1000 ~/ elapsed);
            lastTime = now;
            lastBytes = actualSent;
          }

          onProgress?.call(actualSent, fileSize, speed);
        },
        cancelToken: cancelToken,
      );

      final data = response.data is String
          ? jsonDecode(response.data as String) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      return TransferResult(
        success: data['status'] == 'ok',
        bytesTransferred: data['bytesReceived'] as int? ?? fileSize,
        checksum: data['checksum'] as String?,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        return TransferResult(
          success: false,
          bytesTransferred: lastBytes,
          error: 'Cancelled',
        );
      }
      return TransferResult(
        success: false,
        bytesTransferred: lastBytes,
        error: e.message ?? 'Transfer failed',
      );
    }
  }

  /// Negotiate a raw TCP socket port for chunk-based transfer.
  /// Returns the socket port to connect to.
  Future<({int socketPort, bool encryptionSupported})> negotiate({
    required PeerDevice peer,
    required String token,
  }) async {
    final url = _baseUrl(peer);

    final response = await _dio.post(
      '$url/negotiate',
      options: Options(
        headers: {'X-Token': token},
      ),
    );

    final data = response.data is String
        ? jsonDecode(response.data as String) as Map<String, dynamic>
        : response.data as Map<String, dynamic>;

    return (
      socketPort: data['socketPort'] as int,
      encryptionSupported: data['encryptionSupported'] as bool? ?? false,
    );
  }

  /// Compute SHA-256 checksum of a file.
  Future<String> computeChecksum(String filePath) async {
    final file = File(filePath);
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }

  /// Check the resume offset for a file at the peer.
  Future<int> getResumeOffset({
    required PeerDevice peer,
    required String token,
    required String fileName,
  }) async {
    final url = _baseUrl(peer);

    try {
      final response = await _dio.get(
        '$url/resume-offset',
        queryParameters: {'token': token, 'fileName': fileName},
      );

      final data = response.data is String
          ? jsonDecode(response.data as String) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      return data['resumeOffset'] as int? ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Create a file read stream starting from [offset].
  Stream<List<int>> _createFileStream(File file, int offset) {
    if (offset <= 0) return file.openRead();
    return file.openRead(offset);
  }

  String _baseUrl(PeerDevice peer) =>
      'http://${peer.ipAddress}:${peer.port}';

  void dispose() {
    _dio.close();
  }
}
