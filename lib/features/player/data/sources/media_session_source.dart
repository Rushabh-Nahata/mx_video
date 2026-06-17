import 'package:media_kit/media_kit.dart';

/// Wraps the media_kit [Player] lifecycle.
/// One instance is created per player screen and disposed with the screen.
class MediaSessionSource {
  MediaSessionSource() : _player = Player();

  final Player _player;
  Player get player => _player;

  Future<void> open(String path, {int? startPositionMs}) async {
    final media = Media(path);
    await _player.open(media);
    if (startPositionMs != null && startPositionMs > 5000) {
      await _player.seek(Duration(milliseconds: startPositionMs));
    }
  }

  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> seekTo(Duration position) => _player.seek(position);
  Future<void> setSpeed(double speed) => _player.setRate(speed);

  // Media-kit volume is 0–100; we normalise to 0.0–1.0 on the outside.
  Future<void> setVolume(double volume) => _player.setVolume(volume * 100);

  // ── Track selection ─────────────────────────────────────────────────────
  Future<void> setAudioTrack(AudioTrack track) =>
      _player.setAudioTrack(track);

  Future<void> setSubtitleTrack(SubtitleTrack track) =>
      _player.setSubtitleTrack(track);

  Future<void> disableSubtitles() =>
      _player.setSubtitleTrack(SubtitleTrack.no());

  // ── Streams ─────────────────────────────────────────────────────────────
  Stream<Duration> get positionStream => _player.stream.position;
  Stream<Duration> get durationStream => _player.stream.duration;
  Stream<bool> get playingStream => _player.stream.playing;
  Stream<bool> get bufferingStream => _player.stream.buffering;
  Stream<bool> get completedStream => _player.stream.completed;
  Stream<List<AudioTrack>> get audioTracksStream =>
      _player.stream.tracks.map((t) =>
          t.audio.where((a) => a.id != 'no' && a.id != 'auto').toList());
  Stream<List<SubtitleTrack>> get subtitleTracksStream =>
      _player.stream.tracks.map((t) =>
          t.subtitle.where((s) => s.id != 'no' && s.id != 'auto').toList());

  void dispose() => _player.dispose();
}
