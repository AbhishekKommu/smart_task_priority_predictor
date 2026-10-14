import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/app_theme.dart';
import '../widgets/progress_card.dart';

class AnalyticsScreen extends StatelessWidget {
  final List<TaskModel> tasks;
  const AnalyticsScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    int count(String p) => tasks.where((t) => t.priority == p).length;
    final done = tasks.where((t) => t.completed).length;
    const levels = ['High', 'Medium', 'Low'];
    final total = tasks.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        children: [
          ProgressCard(title: 'Completion', done: done, total: total),
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tasks by priority',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  for (final l in levels)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          SizedBox(width: 70, child: Text(l)),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: total == 0 ? 0 : count(l) / total,
                              minHeight: 12,
                              color: AppTheme.priorityColor(l),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${count(l)}'),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
