import 'package:freezed_annotation/freezed_annotation.dart';

part 'folder_node.freezed.dart';

/// A directory entry in the device storage browser.
@freezed
abstract class FolderNode with _$FolderNode {
  const factory FolderNode({
    required String path,
    required String name,
    required DateTime modifiedAt,
    @Default(0) int childCount,
  }) = _FolderNode;
}
