import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../shared/widgets/thumbnail_widget.dart';
import '../../../../core/utils/file_size_formatter.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../../domain/entities/media_file.dart';
import '../providers/library_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: const InputDecoration(
            hintText: 'Search videos...',
            border: InputBorder.none,
          ),
          style: theme.textTheme.titleMedium,
          onChanged: (v) => ref.read(searchQueryProvider.notifier).set(v),
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                ref.read(searchQueryProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: results.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (files) {
          if (query.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, size: 64,
                      color: theme.colorScheme.onSurface.withAlpha(80)),
                  const SizedBox(height: 12),
                  Text('Type to search your videos',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(120),
                      )),
                ],
              ),
            );
          }
          if (files.isEmpty) {
            return Center(
              child: Text('No results for "$query"',
                  style: theme.textTheme.bodyMedium),
            );
          }
          return ListView.builder(
            itemCount: files.length,
            itemBuilder: (context, i) => _SearchResultTile(
              file: files[i],
              query: query,
              onTap: () {
                final route = files[i].isVideo
                    ? RouteNames.videoPlayer
                    : RouteNames.audioPlayer;
                context.push(
                  '$route?path=${Uri.encodeComponent(files[i].absolutePath)}',
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.file,
    required this.query,
    required this.onTap,
  });

  final MediaFileEntity file;
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: ThumbnailWidget(
          path: file.thumbnailPath,
          videoPath: file.isVideo && file.thumbnailPath == null
              ? file.absolutePath
              : null,
          width: 56,
          height: 40,
          fit: BoxFit.cover,
        ),
      ),
      title: _HighlightedText(text: file.name, highlight: query),
      subtitle: Text(
        _subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: cs.onSurface.withAlpha(153),
        ),
      ),
      trailing: Icon(
        file.isVideo ? Icons.play_circle_outline : Icons.music_note_outlined,
        size: 20,
        color: cs.onSurface.withAlpha(100),
      ),
      onTap: onTap,
    );
  }

  String get _subtitle {
    final parts = <String>[FileSizeFormatter.format(file.sizeBytes)];
    if (file.durationMs != null) {
      parts.add(DurationFormatter.format(file.durationMs!));
    }
    return parts.join(' · ');
  }
}

class _HighlightedText extends StatelessWidget {
  const _HighlightedText({required this.text, required this.highlight});

  final String text;
  final String highlight;

  @override
  Widget build(BuildContext context) {
    if (highlight.isEmpty) return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);

    final lowerText = text.toLowerCase();
    final lowerHighlight = highlight.toLowerCase();
    final idx = lowerText.indexOf(lowerHighlight);

    if (idx < 0) return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis);

    final theme = Theme.of(context);
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: theme.textTheme.titleSmall,
        children: [
          if (idx > 0) TextSpan(text: text.substring(0, idx)),
          TextSpan(
            text: text.substring(idx, idx + highlight.length),
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (idx + highlight.length < text.length)
            TextSpan(text: text.substring(idx + highlight.length)),
        ],
      ),
    );
  }
}
