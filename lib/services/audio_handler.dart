import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';

/// [AudioHandler] implementation that bridges audio_service with media_kit.
/// Handles lock-screen controls, headset buttons, and notification player.
class MxAudioHandler extends BaseAudioHandler with SeekHandler {
  MxAudioHandler() : _player = Player();

  final Player _player;

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToNext() async {
    // TODO: implement playlist next
  }

  @override
  Future<void> skipToPrevious() async {
    // TODO: implement playlist previous
  }

  Future<void> loadTrack(String path, {MediaItem? item}) async {
    if (item != null) mediaItem.add(item);
    await _player.open(Media(path));
    await play();
  }

  /// Initialise this handler with audio_service. Call once in main().
  static Future<MxAudioHandler> init() async {
    return AudioService.init(
      builder: MxAudioHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.mxvideo.audio',
        androidNotificationChannelName: 'MX Video Audio',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
  }
}
