import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// Binary protocol for socket-based file transfer.
///
/// Frame layout (big-endian):
///   [1 byte]  messageType
///   [4 bytes] payloadLength
///   [N bytes] payload
class TransferProtocol {
  TransferProtocol._();

  // ── Message types ─────────────────────────────────────────────────────────

  static const int handshakeReq = 0x01;
  static const int handshakeAck = 0x02;
  static const int chunkData = 0x03;
  static const int chunkAck = 0x04;
  static const int fileComplete = 0x05;
  static const int fileVerified = 0x06;
  static const int cancel = 0x07;
  static const int pause = 0x08;
  static const int resume = 0x09;
  static const int encryptionSetup = 0x0B;

  /// Header size: 1 (type) + 4 (length).
  static const int headerSize = 5;

  // ── Frame encoding ────────────────────────────────────────────────────────

  static Uint8List encodeFrame(int type, Uint8List payload) {
    final frame = Uint8List(headerSize + payload.length);
    frame[0] = type;
    final bd = ByteData.sublistView(frame);
    bd.setUint32(1, payload.length, Endian.big);
    frame.setRange(headerSize, frame.length, payload);
    return frame;
  }

  // ── Payload helpers ───────────────────────────────────────────────────────

  /// Encode a handshake request: session token + file manifest.
  static Uint8List encodeHandshakeReq({
    required String token,
    required List<FileManifestEntry> files,
    required bool encrypted,
  }) {
    final map = {
      'token': token,
      'encrypted': encrypted,
      'files': files.map((f) => f.toMap()).toList(),
    };
    return Uint8List.fromList(utf8.encode(jsonEncode(map)));
  }

  static ({String token, List<FileManifestEntry> files, bool encrypted})
      decodeHandshakeReq(Uint8List payload) {
    final map = jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
    return (
      token: map['token'] as String,
      encrypted: map['encrypted'] as bool? ?? false,
      files: (map['files'] as List)
          .map((e) => FileManifestEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Encode a handshake ACK: accepted + chunk bitmaps per file.
  static Uint8List encodeHandshakeAck({
    required bool accepted,
    required List<Uint8List> bitmaps,
  }) {
    final map = {
      'accepted': accepted,
      'bitmaps': bitmaps.map((b) => base64Encode(b)).toList(),
    };
    return Uint8List.fromList(utf8.encode(jsonEncode(map)));
  }

  static ({bool accepted, List<Uint8List> bitmaps}) decodeHandshakeAck(
      Uint8List payload) {
    final map = jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
    return (
      accepted: map['accepted'] as bool,
      bitmaps: (map['bitmaps'] as List)
          .map((b) => base64Decode(b as String))
          .toList(),
    );
  }

  /// Encode chunk data: fileIndex(2) + chunkIndex(4) + data.
  static Uint8List encodeChunkData(
      int fileIndex, int chunkIndex, Uint8List data) {
    final payload = Uint8List(6 + data.length);
    final bd = ByteData.sublistView(payload);
    bd.setUint16(0, fileIndex, Endian.big);
    bd.setUint32(2, chunkIndex, Endian.big);
    payload.setRange(6, payload.length, data);
    return payload;
  }

  static ({int fileIndex, int chunkIndex, Uint8List data}) decodeChunkData(
      Uint8List payload) {
    final bd = ByteData.sublistView(payload);
    return (
      fileIndex: bd.getUint16(0, Endian.big),
      chunkIndex: bd.getUint32(2, Endian.big),
      data: Uint8List.sublistView(payload, 6),
    );
  }

  /// Encode chunk ACK: fileIndex(2) + chunkIndex(4) + success(1).
  static Uint8List encodeChunkAck(
      int fileIndex, int chunkIndex, bool success) {
    final payload = Uint8List(7);
    final bd = ByteData.sublistView(payload);
    bd.setUint16(0, fileIndex, Endian.big);
    bd.setUint32(2, chunkIndex, Endian.big);
    payload[6] = success ? 1 : 0;
    return payload;
  }

  static ({int fileIndex, int chunkIndex, bool success}) decodeChunkAck(
      Uint8List payload) {
    final bd = ByteData.sublistView(payload);
    return (
      fileIndex: bd.getUint16(0, Endian.big),
      chunkIndex: bd.getUint32(2, Endian.big),
      success: payload[6] == 1,
    );
  }

  /// Encode file complete: fileIndex(2) + SHA-256 checksum string.
  static Uint8List encodeFileComplete(int fileIndex, String checksum) {
    final checksumBytes = utf8.encode(checksum);
    final payload = Uint8List(2 + checksumBytes.length);
    final bd = ByteData.sublistView(payload);
    bd.setUint16(0, fileIndex, Endian.big);
    payload.setRange(2, payload.length, checksumBytes);
    return payload;
  }

  static ({int fileIndex, String checksum}) decodeFileComplete(
      Uint8List payload) {
    final bd = ByteData.sublistView(payload);
    return (
      fileIndex: bd.getUint16(0, Endian.big),
      checksum: utf8.decode(Uint8List.sublistView(payload, 2)),
    );
  }

  /// Encode file verified: fileIndex(2) + match(1).
  static Uint8List encodeFileVerified(int fileIndex, bool match) {
    final payload = Uint8List(3);
    final bd = ByteData.sublistView(payload);
    bd.setUint16(0, fileIndex, Endian.big);
    payload[2] = match ? 1 : 0;
    return payload;
  }

  static ({int fileIndex, bool match}) decodeFileVerified(Uint8List payload) {
    final bd = ByteData.sublistView(payload);
    return (
      fileIndex: bd.getUint16(0, Endian.big),
      match: payload[2] == 1,
    );
  }

  /// Encode cancel: fileIndex(2). 0xFFFF = cancel all.
  static Uint8List encodeCancel(int fileIndex) {
    final payload = Uint8List(2);
    final bd = ByteData.sublistView(payload);
    bd.setUint16(0, fileIndex, Endian.big);
    return payload;
  }

  static int decodeCancel(Uint8List payload) {
    return ByteData.sublistView(payload).getUint16(0, Endian.big);
  }

  /// Encode encryption setup: encrypted AES key bytes.
  static Uint8List encodeEncryptionSetup(Uint8List encryptedKey) =>
      encryptedKey;

  static Uint8List decodeEncryptionSetup(Uint8List payload) => payload;
}

/// Reads complete frames from a TCP socket stream, handling fragmentation.
class FrameReader {
  FrameReader(this._socket);

  final Socket _socket;
  final _buffer = BytesBuilder(copy: false);
  final _controller = StreamController<({int type, Uint8List payload})>();
  StreamSubscription<Uint8List>? _sub;

  Stream<({int type, Uint8List payload})> get frames => _controller.stream;

  void start() {
    _sub = _socket.listen(
      (data) {
        _buffer.add(data);
        _processBuffer();
      },
      onError: (e) => _controller.addError(e),
      onDone: () => _controller.close(),
    );
  }

  void _processBuffer() {
    while (true) {
      final bytes = _buffer.takeBytes();
      if (bytes.length < TransferProtocol.headerSize) {
        _buffer.add(bytes);
        break;
      }

      final bd = ByteData.sublistView(bytes);
      final type = bytes[0];
      final length = bd.getUint32(1, Endian.big);
      final totalFrameSize = TransferProtocol.headerSize + length;

      if (bytes.length < totalFrameSize) {
        _buffer.add(bytes);
        break;
      }

      final payload = Uint8List.sublistView(
          bytes, TransferProtocol.headerSize, totalFrameSize);
      _controller.add((type: type, payload: Uint8List.fromList(payload)));

      // Put remaining bytes back.
      if (bytes.length > totalFrameSize) {
        _buffer.add(Uint8List.sublistView(bytes, totalFrameSize));
      }
    }
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    if (!_controller.isClosed) await _controller.close();
  }
}

/// Describes a file to be transferred.
class FileManifestEntry {
  const FileManifestEntry({
    required this.fileName,
    required this.fileSize,
    required this.checksum,
  });

  final String fileName;
  final int fileSize;
  final String checksum;

  Map<String, dynamic> toMap() => {
        'fileName': fileName,
        'fileSize': fileSize,
        'checksum': checksum,
      };

  factory FileManifestEntry.fromMap(Map<String, dynamic> map) =>
      FileManifestEntry(
        fileName: map['fileName'] as String,
        fileSize: map['fileSize'] as int,
        checksum: map['checksum'] as String? ?? '',
      );
}
