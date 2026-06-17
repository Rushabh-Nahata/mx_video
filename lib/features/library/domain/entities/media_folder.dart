import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_folder.freezed.dart';

/// Domain entity representing a scanned media folder.
@freezed
abstract class MediaFolderEntity with _$MediaFolderEntity {
  const factory MediaFolderEntity({
    required int id,
    required String absolutePath,
    required String name,
    int? parentId,
    String? thumbnailPath,
    @Default(0) int videoCount,
    @Default(0) int audioCount,
    @Default(false) bool isWatched,
  }) = _MediaFolderEntity;

  const MediaFolderEntity._();

  int get totalCount => videoCount + audioCount;
  bool get isEmpty => totalCount == 0;
}
