import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DeleteDialog extends StatelessWidget {
  final Widget? icon;
  final String? title;
  final String? message;
  final List<Widget>? actions;
  final VoidCallback? onPressed;

  const DeleteDialog({
    super.key,
    this.icon,
    this.title,
    this.message,
    this.actions,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: icon ?? Icon(Icons.delete, size: 50, color: color.error),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Delete', style: textStyle.titleMedium),
            const Gap(8),
            Text(
              message ?? 'Are you sure to delete this?',
              style: textStyle.bodySmall,
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: ((actions ?? []).isNotEmpty)
          ? actions
          : [
              SizedBox(
                width: screenWidth / 3,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(color.error),
                    foregroundColor: WidgetStatePropertyAll(color.onError),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Yes'),
                ),
              ),
              SizedBox(
                width: screenWidth / 3,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
              ),
            ],
    );
  }
}
