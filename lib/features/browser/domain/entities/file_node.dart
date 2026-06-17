import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_node.freezed.dart';

/// A single file entry in the device storage browser.
@freezed
abstract class FileNode with _$FileNode {
  const factory FileNode({
    required String path,
    required String name,
    required String extension,
    required int sizeBytes,
    required DateTime modifiedAt,
    @Default(false) bool isSelected,
  }) = _FileNode;

  const FileNode._();

  bool get isVideo => const [
        'mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv', 'webm', 'm4v',
      ].contains(extension.toLowerCase());

  bool get isAudio => const [
        'mp3', 'aac', 'flac', 'ogg', 'wav', 'm4a', 'wma', 'opus',
      ].contains(extension.toLowerCase());

  bool get isMedia => isVideo || isAudio;
}
