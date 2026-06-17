extension StringFileUtils on String {
  /// Returns the file extension without the dot, lower-cased.
  /// e.g. "/path/to/Video.MKV" → "mkv"
  String get fileExtension {
    final dot = lastIndexOf('.');
    if (dot == -1 || dot == length - 1) return '';
    return substring(dot + 1).toLowerCase();
  }

  /// Returns the file name (with extension) from a full path.
  String get fileName {
    final sep = lastIndexOf('/');
    return sep == -1 ? this : substring(sep + 1);
  }

  /// Returns the file name without extension.
  String get fileBaseName {
    final name = fileName;
    final dot = name.lastIndexOf('.');
    return dot == -1 ? name : name.substring(0, dot);
  }

  /// Returns the parent directory path.
  String get parentPath {
    final sep = lastIndexOf('/');
    return sep <= 0 ? '/' : substring(0, sep);
  }

  /// Capitalises the first character.
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
