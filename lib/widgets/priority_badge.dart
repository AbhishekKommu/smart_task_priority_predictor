import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class PriorityBadge extends StatelessWidget {
  final String level;
  final double? score;
  const PriorityBadge({super.key, required this.level, this.score});

  @override
  Widget build(BuildContext context) {
    final c = AppTheme.priorityColor(level);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c),
      ),
      child: Text(
        score == null ? level : '$level • ${score!.toStringAsFixed(0)}',
        style: TextStyle(color: c, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
