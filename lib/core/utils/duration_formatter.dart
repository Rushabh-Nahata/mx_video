/// Formats raw millisecond values for display in the player UI.
class DurationFormatter {
  DurationFormatter._();

  static String format(int ms) {
    final d = Duration(milliseconds: ms);
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  /// Returns remaining time as a negative string, e.g. "-3:45".
  static String remaining(int positionMs, int durationMs) {
    final left = durationMs - positionMs;
    return '-${format(left.clamp(0, durationMs))}';
  }
}
