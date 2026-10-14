import 'dart:convert';

class TaskModel {
  final String id;
  String title;
  String description;
  DateTime deadline;
  DateTime? reminder; // sound alert time
  int importance; // 1-5
  int effortHours;
  bool completed;
  double score;
  String priority;

  TaskModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.deadline,
    this.reminder,
    required this.importance,
    required this.effortHours,
    this.completed = false,
    this.score = 0,
    this.priority = 'Low',
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'deadline': deadline.toIso8601String(),
        'reminder': reminder?.toIso8601String(),
        'importance': importance,
        'effortHours': effortHours,
        'completed': completed,
        'score': score,
        'priority': priority,
      };

  factory TaskModel.fromMap(Map<String, dynamic> m) => TaskModel(
        id: m['id'] as String,
        title: m['title'] as String,
        description: (m['description'] ?? '') as String,
        deadline: DateTime.parse(m['deadline'] as String),
        reminder: m['reminder'] == null
            ? null
            : DateTime.parse(m['reminder'] as String),
        importance: m['importance'] as int,
        effortHours: m['effortHours'] as int,
        completed: (m['completed'] ?? false) as bool,
        score: (m['score'] ?? 0).toDouble(),
        priority: (m['priority'] ?? 'Low') as String,
      );

  String toJson() => json.encode(toMap());
  factory TaskModel.fromJson(String s) =>
      TaskModel.fromMap(json.decode(s) as Map<String, dynamic>);
}
