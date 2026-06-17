/// Raw media item returned directly from the platform channel.
/// Contains only primitive types so it crosses the isolate boundary safely.
class RawMediaItem {
  const RawMediaItem({
    required this.path,
    required this.name,
    required this.extension,
    required this.sizeBytes,
    required this.folderPath,
    required this.folderName,
    required this.dateModifiedMs,
    required this.mimeType,
    this.durationMs,
    this.width,
    this.height,
  });

  final String path;
  final String name;
  final String extension;
  final int sizeBytes;
  final String folderPath;
  final String folderName;
  final int dateModifiedMs;
  final String mimeType;
  final int? durationMs;
  final int? width;
  final int? height;

  bool get isVideo => mimeType.startsWith('video/');
  bool get isAudio => mimeType.startsWith('audio/');

  /// Serialise to plain map so it can be passed to/from isolates.
  Map<String, dynamic> toMap() => {
        'path': path,
        'name': name,
        'extension': extension,
        'sizeBytes': sizeBytes,
        'folderPath': folderPath,
        'folderName': folderName,
        'dateModifiedMs': dateModifiedMs,
        'mimeType': mimeType,
        'durationMs': durationMs,
        'width': width,
        'height': height,
      };

  factory RawMediaItem.fromMap(Map<String, dynamic> m) => RawMediaItem(
        path: m['path'] as String,
        name: m['name'] as String,
        extension: m['extension'] as String? ??
            ((m['name'] as String).contains('.')
                ? (m['name'] as String).split('.').last.toLowerCase()
                : ''),
        sizeBytes: (m['size'] as num?)?.toInt() ?? (m['sizeBytes'] as num?)?.toInt() ?? 0,
        folderPath: m['folderPath'] as String,
        folderName: m['folderName'] as String,
        dateModifiedMs: (m['dateModified'] as num?)?.toInt() ??
            (m['dateModifiedMs'] as num?)?.toInt() ??
            0,
        mimeType: m['mimeType'] as String? ?? 'application/octet-stream',
        durationMs: (m['duration'] as num?)?.toInt(),
        width: (m['width'] as num?)?.toInt(),
        height: (m['height'] as num?)?.toInt(),
      );
}

/// Abstract contract that each platform implements via its native plugin.
abstract interface class MediaPlatformSource {
  /// Returns all video files the platform can index.
  /// Android: MediaStore.Video.Media query (instant, system-maintained).
  /// iOS: Documents directory walk + AVFoundation metadata.
  Future<List<RawMediaItem>> queryVideos();

  /// Returns all audio files the platform can index.
  Future<List<RawMediaItem>> queryAudios();

  /// Returns the root storage paths available on the device.
  Future<List<String>> getStorageRoots();
}
