import 'package:flutter/material.dart';

import '../../domain/entities/playback_state.dart';

/// Bottom sheet for selecting audio or subtitle tracks.
class TrackSelectorSheet extends StatelessWidget {
  const TrackSelectorSheet({
    super.key,
    required this.title,
    required this.tracks,
    required this.selectedIndex,
    required this.onSelect,
  });

  final String title;
  final List<TrackInfo> tracks;
  final int? selectedIndex;
  final void Function(int index) onSelect;

  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<TrackInfo> tracks,
    required int? selectedIndex,
    required void Function(int index) onSelect,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => TrackSelectorSheet(
        title: title,
        tracks: tracks,
        selectedIndex: selectedIndex,
        onSelect: onSelect,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tracks.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(tracks[i].label),
                trailing: selectedIndex == tracks[i].index
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  onSelect(tracks[i].index);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
