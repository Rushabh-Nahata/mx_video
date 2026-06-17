import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_file.freezed.dart';

/// Domain entity representing a single indexed media file.
/// Derived from [MediaFile] (Drift table row) but decoupled from the DB layer.
@freezed
abstract class MediaFileEntity with _$MediaFileEntity {
  const factory MediaFileEntity({
    required int id,
    required String absolutePath,
    required String name,
    required String extension,
    required int sizeBytes,
    int? durationMs,
    int? width,
    int? height,
    String? thumbnailPath,
    int? folderId,
    int? lastPlayedAt,
    @Default(0) int playPositionMs,
    @Default(0) int playCount,
    @Default(false) bool isFavourite,
    required int scannedAt,
  }) = _MediaFileEntity;

  const MediaFileEntity._();

  bool get isVideo => const [
        'mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv',
        'webm', 'm4v', 'mpeg', 'mpg', '3gp', 'ts',
      ].contains(extension.toLowerCase());

  bool get isAudio => const [
        'mp3', 'aac', 'flac', 'ogg', 'wav', 'm4a', 'wma', 'opus',
      ].contains(extension.toLowerCase());

  bool get hasBeenPlayed => lastPlayedAt != null;
}
