import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.freezed.dart';

/// Represents the media item currently loaded in the player.
@freezed
abstract class MediaItem with _$MediaItem {
  const factory MediaItem({
    required String path,
    required String title,
    String? thumbnailPath,
    int? durationMs,
    int? resumePositionMs,
  }) = _MediaItem;
}
