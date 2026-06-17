import 'package:flutter/material.dart';

import '../../../../models/sort_order.dart';

/// Bottom sheet for selecting video sort order.
class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({
    super.key,
    required this.current,
    required this.onSelected,
  });

  final SortOrder current;
  final ValueChanged<SortOrder> onSelected;

  static Future<SortOrder?> show(BuildContext context, SortOrder current) {
    return showModalBottomSheet<SortOrder>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SortBottomSheet(
        current: current,
        onSelected: (order) => Navigator.pop(context, order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Sort by', style: theme.textTheme.titleMedium),
            ),
            const Divider(height: 1),
            ...SortOrder.values.map((order) => ListTile(
                  leading: Icon(
                    order == current
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: order == current
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface.withAlpha(153),
                    size: 22,
                  ),
                  title: Text(order.label),
                  dense: true,
                  onTap: () => onSelected(order),
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
