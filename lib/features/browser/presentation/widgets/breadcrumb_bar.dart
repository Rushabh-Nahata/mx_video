import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../../../../core/theme/app_colors.dart';

/// Horizontal scrollable breadcrumb showing the current path stack.
class BreadcrumbBar extends StatelessWidget {
  const BreadcrumbBar({
    super.key,
    required this.pathStack,
    required this.onSegmentTap,
  });

  final List<String> pathStack;
  final void Function(String path) onSegmentTap;

  @override
  Widget build(BuildContext context) {
    if (pathStack.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: pathStack.length,
        separatorBuilder: (_, _) => const Icon(
          Icons.chevron_right,
          size: 16,
          color: AppColors.textSecondary,
        ),
        itemBuilder: (context, i) {
          final isLast = i == pathStack.length - 1;
          final label = i == 0 ? 'Storage' : p.basename(pathStack[i]);

          return GestureDetector(
            onTap: isLast ? null : () => onSegmentTap(pathStack[i]),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isLast
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight:
                      isLast ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
