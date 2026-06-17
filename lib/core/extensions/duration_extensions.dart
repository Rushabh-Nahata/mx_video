extension DurationFormatting on Duration {
  /// Returns "H:MM:SS" or "M:SS" depending on length.
  String toHhMmSs() {
    final h = inHours;
    final m = inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  /// Returns a human-readable string like "1h 23m" or "45m 10s".
  String toReadable() {
    if (inHours > 0) {
      final m = inMinutes.remainder(60);
      return '${inHours}h ${m}m';
    }
    if (inMinutes > 0) {
      final s = inSeconds.remainder(60);
      return '${inMinutes}m ${s}s';
    }
    return '${inSeconds}s';
  }
}
