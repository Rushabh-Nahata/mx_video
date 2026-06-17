import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../../../../core/constants/app_constants.dart';

/// Bit-level tracking of which chunks have been received.
///
/// Each bit in the internal byte array represents one chunk:
///   bit = 1 → received, bit = 0 → missing.
class ChunkBitmap {
  ChunkBitmap(this.totalChunks)
      : _bitmap = Uint8List((_totalChunks(totalChunks)));

  ChunkBitmap.fromBytes(Uint8List bytes, this.totalChunks)
      : _bitmap = Uint8List.fromList(bytes);

  final int totalChunks;
  final Uint8List _bitmap;

  static int _totalChunks(int total) => (total + 7) ~/ 8;

  bool isReceived(int chunkIndex) {
    final byteIndex = chunkIndex ~/ 8;
    final bitIndex = 7 - (chunkIndex % 8);
    return (_bitmap[byteIndex] >> bitIndex) & 1 == 1;
  }

  void markReceived(int chunkIndex) {
    final byteIndex = chunkIndex ~/ 8;
    final bitIndex = 7 - (chunkIndex % 8);
    _bitmap[byteIndex] |= (1 << bitIndex);
  }

  int get receivedCount {
    int count = 0;
    for (int i = 0; i < totalChunks; i++) {
      if (isReceived(i)) count++;
    }
    return count;
  }

  int get missingCount => totalChunks - receivedCount;

  bool get isComplete => receivedCount == totalChunks;

  double get progress => totalChunks > 0 ? receivedCount / totalChunks : 0.0;

  Uint8List toBytes() => Uint8List.fromList(_bitmap);

  /// Ordered list of chunk indices that are still missing.
  List<int> get missingChunks {
    final missing = <int>[];
    for (int i = 0; i < totalChunks; i++) {
      if (!isReceived(i)) missing.add(i);
    }
    return missing;
  }
}

/// Handles reading/writing file chunks and persisting the bitmap to disk.
class ChunkManager {
  ChunkManager({
    required this.filePath,
    required this.fileSize,
    this.chunkSize = AppConstants.transferChunkBytes,
  });

  final String filePath;
  final int fileSize;
  final int chunkSize;

  int get totalChunks => (fileSize + chunkSize - 1) ~/ chunkSize;

  /// Read chunk [chunkIndex] from the source file.
  Future<Uint8List> readChunk(int chunkIndex) async {
    final file = File(filePath);
    final raf = await file.open(mode: FileMode.read);
    try {
      final offset = chunkIndex * chunkSize;
      final end = (offset + chunkSize).clamp(0, fileSize);
      final length = end - offset;
      await raf.setPosition(offset);
      final bytes = await raf.read(length);
      return bytes;
    } finally {
      await raf.close();
    }
  }

  /// Write chunk [chunkIndex] to the .part file at the correct offset.
  Future<void> writeChunk(
      String partialFilePath, int chunkIndex, Uint8List data) async {
    final file = File(partialFilePath);
    final raf = await file.open(mode: FileMode.writeOnlyAppend);
    try {
      final offset = chunkIndex * chunkSize;
      await raf.setPosition(offset);
      await raf.writeFrom(data);
    } finally {
      await raf.close();
    }
  }

  /// Load an existing bitmap from disk, or create a new one.
  Future<ChunkBitmap> loadOrCreateBitmap(String partialFilePath) async {
    final bitmapFile = File('$partialFilePath.bitmap');
    if (await bitmapFile.exists()) {
      final bytes = await bitmapFile.readAsBytes();
      return ChunkBitmap.fromBytes(bytes, totalChunks);
    }

    // If .part file exists but no bitmap, infer from contiguous bytes.
    final partFile = File(partialFilePath);
    if (await partFile.exists()) {
      final partSize = await partFile.length();
      final bitmap = ChunkBitmap(totalChunks);
      final completeChunks = partSize ~/ chunkSize;
      for (int i = 0; i < completeChunks; i++) {
        bitmap.markReceived(i);
      }
      return bitmap;
    }

    return ChunkBitmap(totalChunks);
  }

  /// Persist the bitmap alongside the .part file.
  Future<void> saveBitmap(String partialFilePath, ChunkBitmap bitmap) async {
    final bitmapFile = File('$partialFilePath.bitmap');
    await bitmapFile.writeAsBytes(bitmap.toBytes(), flush: true);
  }

  /// Delete bitmap file after transfer is complete.
  Future<void> deleteBitmap(String partialFilePath) async {
    final bitmapFile = File('$partialFilePath.bitmap');
    if (await bitmapFile.exists()) {
      await bitmapFile.delete();
    }
  }

  /// Compute SHA-256 checksum of the file.
  Future<String> computeChecksum(String path) async {
    final file = File(path);
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }
}
