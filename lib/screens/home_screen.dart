import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/notification_service.dart';
import '../services/priority_predictor.dart';
import '../services/storage_service.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'analytics_screen.dart';
import 'settings_screen.dart';
import 'task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService();
  final _notify = NotificationService.instance;
  List<TaskModel> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _notify.onReminder = _showReminderDialog;
    _load();
  }

  @override
  void dispose() {
    _notify.onReminder = null;
    super.dispose();
  }

  Future<void> _load() async {
    final t = await _storage.loadTasks();
    for (final x in t) {
      PriorityPredictor.apply(x);
      _notify.schedule(x);
    }
    if (!mounted) return;
    setState(() {
      _tasks = PriorityPredictor.sorted(t);
      _loading = false;
    });
  }

  Future<void> _save() async {
    await _storage.saveTasks(_tasks);
    if (!mounted) return;
    setState(() => _tasks = PriorityPredictor.sorted(_tasks));
  }

  Future<void> _add() async {
    final t = await Navigator.push<TaskModel>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (t != null) {
      _tasks.add(PriorityPredictor.apply(t));
      await _notify.schedule(t);
      await _save();
    }
  }

  Future<void> _open(TaskModel t) async {
    final res = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailsScreen(task: t)),
    );
    if (res == 'delete') {
      _tasks.removeWhere((x) => x.id == t.id);
      await _notify.cancel(t.id);
    }
    await _save();
  }

  void _showReminderDialog(TaskModel t) {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.alarm, size: 40),
        title: const Text('Task reminder'),
        content: Text(t.title, style: Theme.of(context).textTheme.titleMedium),
        actions: [
          TextButton(
            onPressed: () {
              _notify.stopAlarm();
              Navigator.pop(context);
            },
            child: const Text('Stop'),
          ),
          FilledButton(
            onPressed: () {
              _notify.stopAlarm();
              t.completed = true;
              _notify.cancel(t.id);
              _save();
              Navigator.pop(context);
            },
            child: const Text('Mark done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final done = _tasks.where((t) => t.completed).length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Task Priority'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AnalyticsScreen(tasks: _tasks)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
              _load();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('No tasks yet. Tap + to add one.'))
              : ListView(
                  children: [
                    ProgressCard(
                      title: 'Overall progress',
                      done: done,
                      total: _tasks.length,
                    ),
                    for (final t in _tasks)
                      TaskCard(
                        task: t,
                        onTap: () => _open(t),
                        onToggle: (v) {
                          t.completed = v ?? false;
                          _notify.schedule(t);
                          _save();
                        },
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text('Add task'),
      ),
    );
  }
}
