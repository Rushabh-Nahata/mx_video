import '../entities/playback_state.dart';

/// Extracts available audio tracks from the player's current media.
/// Delegates to the platform via media_kit's track info API.
class GetAudioTracks {
  const GetAudioTracks();

  // TODO: inject MediaController abstraction and return real tracks.
  List<TrackInfo> call() => const [];
}
