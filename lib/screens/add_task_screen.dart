import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/priority_predictor.dart';
import '../widgets/priority_badge.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  DateTime _deadline = DateTime.now().add(const Duration(days: 2));
  DateTime? _reminder;
  int _importance = 3;
  int _effort = 2;

  double get _score => PriorityPredictor.score(
        deadline: _deadline,
        importance: _importance,
        effortHours: _effort,
      );

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (d != null) setState(() => _deadline = d);
  }

  Future<void> _pickReminder() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _reminder ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
    );
    if (d == null || !mounted) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _reminder ?? now.add(const Duration(minutes: 5)),
      ),
    );
    if (t == null) return;
    setState(() => _reminder = DateTime(d.year, d.month, d.day, t.hour, t.minute));
  }

  String _fmt(DateTime d) =>
      '${d.day}/${d.month}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final t = TaskModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      description: _desc.text.trim(),
      deadline: _deadline,
      reminder: _reminder,
      importance: _importance,
      effortHours: _effort,
    );
    Navigator.pop(context, PriorityPredictor.apply(t));
  }

  @override
  Widget build(BuildContext context) {
    final s = _score;
    final border = RoundedRectangleBorder(
      side: BorderSide(color: Theme.of(context).dividerColor),
      borderRadius: BorderRadius.circular(12),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a title' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _desc,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            ListTile(
              shape: border,
              title: const Text('Deadline'),
              subtitle:
                  Text('${_deadline.day}/${_deadline.month}/${_deadline.year}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),
            ListTile(
              shape: border,
              leading: const Icon(Icons.alarm),
              title: const Text('Sound reminder'),
              subtitle: Text(_reminder == null ? 'Not set' : _fmt(_reminder!)),
              trailing: _reminder == null
                  ? const Icon(Icons.add_alarm)
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _reminder = null),
                    ),
              onTap: _pickReminder,
            ),
            const SizedBox(height: 12),
            Text('Importance: $_importance / 5'),
            Slider(
              value: _importance.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: '$_importance',
              onChanged: (v) => setState(() => _importance = v.round()),
            ),
            Text('Estimated effort: $_effort hours'),
            Slider(
              value: _effort.toDouble(),
              min: 1,
              max: 40,
              divisions: 39,
              label: '$_effort h',
              onChanged: (v) => setState(() => _effort = v.round()),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Predicted priority: '),
                PriorityBadge(level: PriorityPredictor.level(s), score: s),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Save task'),
            ),
          ],
        ),
      ),
    );
  }
}
