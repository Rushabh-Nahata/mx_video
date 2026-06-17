import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_state.freezed.dart';

enum PlaybackStatus { idle, loading, playing, paused, ended, error }

@freezed
abstract class TrackInfo with _$TrackInfo {
  const factory TrackInfo({
    required int index,
    required String label,
    String? language,
  }) = _TrackInfo;
}

@freezed
abstract class PlaybackState with _$PlaybackState {
  const factory PlaybackState({
    @Default(PlaybackStatus.idle) PlaybackStatus status,
    @Default(0) int positionMs,
    @Default(0) int durationMs,
    @Default(1.0) double speed,
    @Default(1.0) double volume,
    @Default(false) bool isMuted,
    @Default(false) bool isFullscreen,
    @Default(false) bool showControls,
    @Default([]) List<TrackInfo> audioTracks,
    @Default([]) List<TrackInfo> subtitleTracks,
    int? selectedAudioTrack,
    int? selectedSubtitleTrack,
    String? errorMessage,
  }) = _PlaybackState;

  const PlaybackState._();

  bool get isPlaying => status == PlaybackStatus.playing;
  bool get isLoading => status == PlaybackStatus.loading;
  bool get hasError => status == PlaybackStatus.error;

  double get progress =>
      durationMs > 0 ? positionMs / durationMs : 0.0;
}
