import 'dart:io';

import 'package:flutter/material.dart';

import '../../services/thumbnail_queue.dart';

/// Displays a video/audio thumbnail from a local file path.
///
/// Behaviour:
///   - If [path] is a pre-generated thumbnail path (ends in .jpg/.png) it is
///     shown directly via [Image.file].
///   - If [videoPath] is supplied (the original video file), the widget
///     triggers lazy thumbnail generation via [ThumbnailQueue] and rebuilds
///     once the thumbnail is ready.
///   - While loading or if generation fails, shows a themed placeholder icon.
class ThumbnailWidget extends StatefulWidget {
  const ThumbnailWidget({
    super.key,
    this.path,
    this.videoPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.priority = false,
  }) : assert(
          path != null || videoPath != null || (path == null && videoPath == null),
          'Provide either path (pre-generated) or videoPath (lazy generate), or neither for a placeholder.',
        );

  /// Path to an already-generated thumbnail image file.
  final String? path;

  /// Path to the original video. If provided and [path] is null, the thumbnail
  /// is generated lazily via [ThumbnailQueue].
  final String? videoPath;

  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  /// When true, this thumbnail is bumped to the front of the generation queue.
  /// Set to true when the user taps a cell that is about to fill the screen.
  final bool priority;

  @override
  State<ThumbnailWidget> createState() => _ThumbnailWidgetState();
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> {
  String? _resolvedPath;
  bool _loading = false;
  bool _fileExists = false;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  @override
  void didUpdateWidget(ThumbnailWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path || oldWidget.videoPath != widget.videoPath) {
      _resolve();
    }
  }

  Future<void> _resolve() async {
    // Fast path: pre-generated thumbnail path supplied directly.
    if (widget.path != null) {
      final exists = await File(widget.path!).exists();
      if (mounted) {
        setState(() {
          _resolvedPath = widget.path;
          _fileExists = exists;
        });
      }
      return;
    }

    // Lazy path: trigger ThumbnailQueue.
    if (widget.videoPath != null) {
      setState(() => _loading = true);
      final result = widget.priority
          ? await ThumbnailQueue.instance.requestPriority(widget.videoPath!)
          : await ThumbnailQueue.instance.request(widget.videoPath!);
      if (mounted) {
        setState(() {
          _resolvedPath = result;
          _fileExists = result != null;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_loading) {
      child = _AnimatedPlaceholder(width: widget.width, height: widget.height);
    } else if (_resolvedPath != null && _fileExists) {
      child = Image.file(
        File(_resolvedPath!),
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        cacheWidth: widget.width != null && widget.width!.isFinite
            ? (widget.width! * 2).toInt()
            : null,
        cacheHeight: widget.height != null && widget.height!.isFinite
            ? (widget.height! * 2).toInt()
            : null,
        errorBuilder: (_, _, _) =>
            _Placeholder(width: widget.width, height: widget.height),
      );
    } else {
      child = _Placeholder(width: widget.width, height: widget.height);
    }

    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: child);
    }
    return child;
  }
}

// ── Placeholder widgets ──────────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  const _Placeholder({this.width, this.height});
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ColoredBox(
      color: cs.surfaceContainerHighest,
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Icon(
            Icons.play_circle_outline,
            color: cs.onSurface.withAlpha(100),
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _AnimatedPlaceholder extends StatefulWidget {
  const _AnimatedPlaceholder({this.width, this.height});
  final double? width;
  final double? height;

  @override
  State<_AnimatedPlaceholder> createState() => _AnimatedPlaceholderState();
}

class _AnimatedPlaceholderState extends State<_AnimatedPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.5, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FadeTransition(
      opacity: _anim,
      child: ColoredBox(
        color: cs.surfaceContainerHighest,
        child: SizedBox(width: widget.width, height: widget.height),
      ),
    );
  }
}
