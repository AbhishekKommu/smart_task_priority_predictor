import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final int done;
  final int total;
  const ProgressCard({
    super.key,
    required this.title,
    required this.done,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final v = total == 0 ? 0.0 : done / total;
    return Card(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.75),
      elevation: 0,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: v,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 8),
            Text('$done of $total completed (${(v * 100).toStringAsFixed(0)}%)'),
          ],
        ),
      ),
    );
  }
}
