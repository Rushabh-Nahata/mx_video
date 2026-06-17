/// App-wide constants that do not belong to any single feature.
class AppConstants {
  AppConstants._();

  // App identity
  static const String appName = 'MX Video';
  static const String appVersion = '1.0.0';

  // ── Transfer ────────────────────────────────────────────────────────────
  static const String mdnsServiceType = '_mxvideo._tcp';
  static const int transferServerPort = 0; // 0 = OS picks a free port
  static const int transferHistoryRetentionDays = 30;

  /// Chunk size for file I/O during transfer (1 MB for high-speed LAN).
  static const int transferChunkBytes = 1024 * 1024;

  /// Read buffer size for streaming file uploads (256 KB).
  static const int transferBufferBytes = 256 * 1024;

  /// Maximum concurrent file transfers.
  static const int maxConcurrentTransfers = 3;

  /// Timeout for handshake / offer requests.
  static const Duration transferHandshakeTimeout = Duration(seconds: 10);

  /// Timeout for the entire file transfer (per GB).
  static const Duration transferTimeoutPerGb = Duration(minutes: 10);

  /// How often to report progress updates to the UI (ms).
  static const int transferProgressIntervalMs = 200;

  /// Session token validity.
  static const Duration transferTokenTtl = Duration(minutes: 30);

  // ── BLE Discovery ───────────────────────────────────────────────────────
  /// Custom BLE service UUID for MX Video peer discovery.
  /// Generated as a v4 UUID specific to this app.
  static const String bleServiceUuid = 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d';

  /// Magic bytes in BLE manufacturer data to identify MX Video devices.
  static const int bleManufacturerId = 0x4D58; // "MX" in ASCII

  /// BLE scan duration before refreshing results.
  static const Duration bleScanDuration = Duration(seconds: 8);

  // ── Socket Transfer ─────────────────────────────────────────────────────
  /// Port for the raw TCP socket transfer server (0 = OS picks).
  static const int socketTransferPort = 0;

  /// How often to persist the chunk bitmap during receive (every N chunks).
  static const int bitmapPersistInterval = 50;

  /// Window size for pipelined chunk sends (chunks in flight before ACK).
  static const int socketPipelineWindow = 4;

  // ── QR Pairing ──────────────────────────────────────────────────────────
  /// Prefix for QR code data to identify MX Video pairing codes.
  static const String qrPrefix = 'mxvideo://pair?';

  // Media scanning
  static const List<String> videoExtensions = [
    'mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'webm',
    'm4v', 'mpeg', 'mpg', '3gp', 'ts', 'm2ts',
  ];
  static const List<String> audioExtensions = [
    'mp3', 'aac', 'flac', 'ogg', 'wav', 'm4a',
    'wma', 'opus', 'aiff', 'alac',
  ];

  // Thumbnail
  static const String thumbnailCacheDirName = 'mx_thumbnails';
  static const int thumbnailWidth = 320;
  static const int thumbnailQuality = 75;

  // Playback
  static const Duration resumeThreshold = Duration(seconds: 5);
  static const List<double> playbackSpeeds = [
    0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0,
  ];
}
