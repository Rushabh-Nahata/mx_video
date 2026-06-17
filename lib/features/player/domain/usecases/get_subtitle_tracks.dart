import '../entities/playback_state.dart';

/// Extracts available subtitle tracks from the player's current media.
class GetSubtitleTracks {
  const GetSubtitleTracks();

  // TODO: inject MediaController abstraction and return real tracks.
  List<TrackInfo> call() => const [];
}
