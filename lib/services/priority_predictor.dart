import '../models/task_model.dart';

/// Lightweight weighted priority predictor (runs fully on-device).
class PriorityPredictor {
  /// Returns a score between 0 and 100.
  static double score({
    required DateTime deadline,
    required int importance,
    required int effortHours,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final hoursLeft = deadline.difference(current).inHours;

    double urgency;
    if (hoursLeft <= 0) {
      urgency = 1.0;
    } else if (hoursLeft <= 24) {
      urgency = 0.9;
    } else if (hoursLeft <= 72) {
      urgency = 0.7;
    } else if (hoursLeft <= 168) {
      urgency = 0.45;
    } else if (hoursLeft <= 336) {
      urgency = 0.25;
    } else {
      urgency = 0.1;
    }

    final imp = importance.clamp(1, 5) / 5.0;

    final effort = effortHours.clamp(1, 40);
    final double pressure =
        hoursLeft > 0 ? (effort / (hoursLeft / 8 + 1)).clamp(0.0, 1.0) : 1.0;

    final s = (urgency * 0.5 + imp * 0.35 + pressure * 0.15) * 100;
    return double.parse(s.clamp(0, 100).toStringAsFixed(1));
  }

  static String level(double score) {
    if (score >= 65) return 'High';
    if (score >= 40) return 'Medium';
    return 'Low';
  }

  static TaskModel apply(TaskModel t, {DateTime? now}) {
    t.score = score(
      deadline: t.deadline,
      importance: t.importance,
      effortHours: t.effortHours,
      now: now,
    );
    t.priority = level(t.score);
    return t;
  }

  static List<TaskModel> sorted(List<TaskModel> tasks) {
    final list = [...tasks];
    list.sort((a, b) {
      if (a.completed != b.completed) return a.completed ? 1 : -1;
      return b.score.compareTo(a.score);
    });
    return list;
  }
}
