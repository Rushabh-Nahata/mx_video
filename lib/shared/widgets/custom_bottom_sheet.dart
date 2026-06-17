import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Reusable bottom sheet template with a drag handle, title, and scrollable body.
class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.maxHeightFactor = 0.7,
  });

  final String? title;
  final Widget child;
  final double maxHeightFactor;

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    double maxHeightFactor = 0.7,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomBottomSheet(
        title: title,
        maxHeightFactor: maxHeightFactor,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * maxHeightFactor;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkDivider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
          ],

          Flexible(child: child),
        ],
      ),
    );
  }
}
