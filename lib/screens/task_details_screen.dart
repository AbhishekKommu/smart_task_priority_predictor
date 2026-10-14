import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../widgets/priority_badge.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskModel task;
  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final d = task.deadline;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => Navigator.pop(context, 'delete'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: PriorityBadge(level: task.priority, score: task.score),
          ),
          const SizedBox(height: 16),
          if (task.description.isNotEmpty) Text(task.description),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Deadline'),
            subtitle: Text('${d.day}/${d.month}/${d.year}'),
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Importance'),
            subtitle: Text('${task.importance} / 5'),
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Estimated effort'),
            subtitle: Text('${task.effortHours} hours'),
          ),
          ListTile(
            leading: const Icon(Icons.insights),
            title: const Text('Priority score'),
            subtitle: Text('${task.score} / 100'),
          ),
        ],
      ),
    );
  }
}
