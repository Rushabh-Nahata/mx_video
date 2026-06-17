import 'dart:async';

import 'package:media_kit/media_kit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/sources/media_session_source.dart';
import '../../domain/entities/playback_state.dart';

part 'player_provider.g.dart';

@riverpod
class PlayerController extends _$PlayerController {
  late MediaSessionSource _source;
  final List<StreamSubscription<dynamic>> _subs = [];
  Timer? _hideTimer;

  // Raw media_kit track objects – needed for selection calls.
  List<AudioTrack> _audioTracks = [];
  List<SubtitleTrack> _subtitleTracks = [];

  String? _currentPath;

  // Cached for use in onDispose (cannot read state inside life-cycles).
  int _lastPositionMs = 0;
  int _lastDurationMs = 0;

  // Playlist support for auto-play next.
  List<String> _playlist = [];
  int _playlistIndex = 0;

  /// Called when the current video ends and the next one starts loading.
  /// The screen listens to this to update the title.
  final _nextVideoController = StreamController<String>.broadcast();
  Stream<String> get onNextVideo => _nextVideoController.stream;

  @override
  PlaybackState build() {
    _source = MediaSessionSource();
    ref.onDispose(() {
      _hideTimer?.cancel();
      for (final s in _subs) {
        s.cancel();
      }
      _persistResumePosition();
      _source.dispose();
      _nextVideoController.close();
    });
    return const PlaybackState();
  }

  // ── Media loading ──────────────────────────────────────────────────────

  /// Loads a single video. If [playlist] is provided, auto-plays the next
  /// video when the current one finishes.
  Future<void> loadMedia(
    String path, {
    int? resumePositionMs,
    List<String>? playlist,
    int startIndex = 0,
  }) async {
    _currentPath = path;
    if (playlist != null) {
      _playlist = playlist;
      _playlistIndex = startIndex;
    }
    state = state.copyWith(status: PlaybackStatus.loading);

    // Load saved resume position unless caller overrides.
    if (resumePositionMs == null) {
      final prefs = await SharedPreferences.getInstance();
      resumePositionMs = prefs.getInt(_resumeKey(path));
    }

    // Cancel old subscriptions before adding new ones (for playlist transitions).
    for (final s in _subs) {
      s.cancel();
    }
    _subs.clear();

    _subs.addAll([
      _source.positionStream.listen((d) {
        _lastPositionMs = d.inMilliseconds;
        state = state.copyWith(positionMs: d.inMilliseconds);
      }),
      _source.durationStream.listen((d) {
        _lastDurationMs = d.inMilliseconds;
        state = state.copyWith(durationMs: d.inMilliseconds);
      }),
      _source.playingStream.listen((playing) {
        state = state.copyWith(
          status: playing ? PlaybackStatus.playing : PlaybackStatus.paused,
        );
      }),
      _source.bufferingStream.listen((buffering) {
        if (buffering && state.status != PlaybackStatus.playing) {
          state = state.copyWith(status: PlaybackStatus.loading);
        }
      }),
      _source.completedStream.listen((completed) {
        if (completed) _onVideoCompleted();
      }),
      _source.audioTracksStream.listen((tracks) {
        _audioTracks = tracks;
        state = state.copyWith(
          audioTracks: tracks.asMap().entries.map((e) => TrackInfo(
            index: e.key,
            label: _trackLabel(e.value.title, e.value.language, 'Audio', e.key),
            language: e.value.language,
          )).toList(),
        );
      }),
      _source.subtitleTracksStream.listen((tracks) {
        _subtitleTracks = tracks;
        state = state.copyWith(
          subtitleTracks: tracks.asMap().entries.map((e) => TrackInfo(
            index: e.key,
            label: _trackLabel(e.value.title, e.value.language, 'Subtitle', e.key),
            language: e.value.language,
          )).toList(),
        );
      }),
    ]);

    await _source.open(path, startPositionMs: resumePositionMs);
    state = state.copyWith(status: PlaybackStatus.playing);
  }

  /// Called when the current video finishes. Loads the next video in the
  /// playlist, or marks playback as ended if this was the last one.
  void _onVideoCompleted() {
    _persistResumePosition();
    if (_playlist.isNotEmpty && _playlistIndex < _playlist.length - 1) {
      _playlistIndex++;
      final nextPath = _playlist[_playlistIndex];
      _nextVideoController.add(nextPath);
      loadMedia(nextPath, playlist: _playlist, startIndex: _playlistIndex);
    } else {
      state = state.copyWith(status: PlaybackStatus.ended);
    }
  }

  /// Whether there's a next video in the playlist.
  bool get hasNext => _playlist.isNotEmpty && _playlistIndex < _playlist.length - 1;

  /// Whether there's a previous video in the playlist.
  bool get hasPrevious => _playlist.isNotEmpty && _playlistIndex > 0;

  /// Skip to the next video.
  void skipNext() {
    if (!hasNext) return;
    _persistResumePosition();
    _playlistIndex++;
    final nextPath = _playlist[_playlistIndex];
    _nextVideoController.add(nextPath);
    loadMedia(nextPath, playlist: _playlist, startIndex: _playlistIndex);
  }

  /// Skip to the previous video.
  void skipPrevious() {
    if (!hasPrevious) return;
    _persistResumePosition();
    _playlistIndex--;
    final prevPath = _playlist[_playlistIndex];
    _nextVideoController.add(prevPath);
    loadMedia(prevPath, playlist: _playlist, startIndex: _playlistIndex);
  }

  // ── Playback controls ─────────────────────────────────────────────────

  Future<void> play() => _source.play();
  Future<void> pause() => _source.pause();

  Future<void> playPause() async {
    if (state.isPlaying) {
      await _source.pause();
    } else {
      await _source.play();
    }
  }

  Future<void> seekTo(int positionMs) =>
      _source.seekTo(Duration(milliseconds: positionMs));

  Future<void> seekBy(int deltaMs) =>
      seekTo((state.positionMs + deltaMs).clamp(0, state.durationMs));

  Future<void> setSpeed(double speed) async {
    await _source.setSpeed(speed);
    state = state.copyWith(speed: speed);
  }

  Future<void> setVolume(double volume) async {
    await _source.setVolume(volume);
    state = state.copyWith(volume: volume);
  }

  // ── Track selection ──────────────────────────────────────────────────

  Future<void> setAudioTrack(int listIndex) async {
    if (listIndex < 0 || listIndex >= _audioTracks.length) return;
    await _source.setAudioTrack(_audioTracks[listIndex]);
    state = state.copyWith(selectedAudioTrack: listIndex);
  }

  Future<void> setSubtitleTrack(int listIndex) async {
    if (listIndex == -1) {
      await _source.disableSubtitles();
      state = state.copyWith(selectedSubtitleTrack: -1);
      return;
    }
    if (listIndex < 0 || listIndex >= _subtitleTracks.length) return;
    await _source.setSubtitleTrack(_subtitleTracks[listIndex]);
    state = state.copyWith(selectedSubtitleTrack: listIndex);
  }

  // ── UI state ─────────────────────────────────────────────────────────

  void toggleFullscreen() =>
      state = state.copyWith(isFullscreen: !state.isFullscreen);

  void showControlsTemporarily() {
    _hideTimer?.cancel();
    // Toggle: if already showing, hide immediately.
    if (state.showControls) {
      state = state.copyWith(showControls: false);
      return;
    }
    state = state.copyWith(showControls: true);
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (state.isPlaying) state = state.copyWith(showControls: false);
    });
  }

  /// Show controls briefly on initial load (1 second), then hide.
  void showControlsBriefly() {
    _hideTimer?.cancel();
    state = state.copyWith(showControls: true);
    _hideTimer = Timer(const Duration(seconds: 1), () {
      state = state.copyWith(showControls: false);
    });
  }

  void hideControls() {
    _hideTimer?.cancel();
    state = state.copyWith(showControls: false);
  }

  // ── Internals ─────────────────────────────────────────────────────────

  void _persistResumePosition() async {
    if (_currentPath == null || _lastDurationMs == 0) return;
    // Don't save if near the end (>95%) – treat as finished.
    if (_lastPositionMs > _lastDurationMs * 0.95) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_resumeKey(_currentPath!));
      return;
    }
    if (_lastPositionMs > 5000) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_resumeKey(_currentPath!), _lastPositionMs);
    }
  }

  String _resumeKey(String path) => 'resume_${path.hashCode}';

  String _trackLabel(
      String? title, String? language, String prefix, int index) {
    if (title != null && title.isNotEmpty) return title;
    if (language != null && language.isNotEmpty) return language;
    return '$prefix ${index + 1}';
  }

  MediaSessionSource get rawSource => _source;
}
