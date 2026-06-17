import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_item.freezed.dart';

enum StatusType { image, video }

@freezed
abstract class StatusItem with _$StatusItem {
  const factory StatusItem({
    required String path,
    required String name,
    required StatusType type,
    required DateTime dateModified,
    required int sizeBytes,
    @Default(false) bool isSaved,
  }) = _StatusItem;

  const StatusItem._();

  bool get isVideo => type == StatusType.video;
  bool get isImage => type == StatusType.image;
}
