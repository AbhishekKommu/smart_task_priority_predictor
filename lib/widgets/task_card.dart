import 'package:flutter/material.dart';
import '../models/task_model.dart';
import 'priority_badge.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onTap;
  final ValueChanged<bool?> onToggle;
  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final d = task.deadline;
    final r = task.reminder;
    final reminderText = r == null
        ? ''
        : ' • ⏰ ${r.hour.toString().padLeft(2, '0')}:${r.minute.toString().padLeft(2, '0')}';
    return Card(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.75),
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Checkbox(value: task.completed, onChanged: onToggle),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Due ${d.day}/${d.month}/${d.year} • ${task.effortHours}h • Imp ${task.importance}/5$reminderText',
        ),
        trailing: PriorityBadge(level: task.priority, score: task.score),
      ),
    );
  }
}
